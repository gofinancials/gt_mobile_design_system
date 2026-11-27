import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A horizontal strip of [GtActionButton]s — the quick-action row of "Send",
/// "Top up" or "Pay bills" affordances that sits under a balance card or at the
/// head of an account screen.
///
/// The bar measures itself with a [LayoutBuilder] and shares the width it has
/// been given, less [padding], out as one equal slot per button. It then picks
/// one of two layouts:
/// - **Every button fits its slot** — its tile is no wider than the slot, and
///   its caption wraps into the slot within two lines, at the ambient text
///   scale, without breaking a word. Each button is centred in its own slot,
///   so the spacing follows from the row's width and the number of buttons:
///   four sit as the Home quick actions do, four equal items edge to edge;
///   two or three spread evenly about the centre; one sits in the middle.
///   Each slot keeps a [BuildContext.spacingXs] inset either side, so the
///   captions of neighbouring buttons never touch, and a caption wraps within
///   its slot rather than pushing the row wider.
/// - **Any button does not** — the row becomes a horizontally scrolling strip
///   anchored to the leading edge, gapped by [BuildContext.spacingLg], so every
///   action stays whole and reachable instead of overflowing.
///
/// The fitted layout spaces the buttons itself, so [padding] is for the bar's
/// own margins, not for spreading the buttons out.
///
/// Either way [padding] is applied around the row, tiles are top-aligned so a
/// wrapped caption never pushes its tile out of line, and the row is capped at
/// 450 wide, centred in any wider box. The bar takes its width from its parent,
/// so give it a bounded box; it adds no background of its own.
class GtActionButtonBar extends GtStatelessWidget {
  /// The widest the row may grow, in logical pixels; a wider box centres it.
  static const double _maxRowWidth = 450;

  /// The most lines a caption may wrap onto in the fitted layout before the
  /// bar scrolls instead.
  ///
  /// Mirrors the `maxLines` [GtActionButton] gives its caption.
  static const int _maxCaptionLines = 2;

  /// Creates a [GtActionButtonBar].
  ///
  /// [buttons] must not be empty — the bar shares its width out among them.
  /// This is asserted, so an empty list is a debug-time error and, for a `const`
  /// invocation, a compile-time one.
  const GtActionButtonBar({
    super.key,
    required this.buttons,
    this.padding = .zero,
  }) : assert(buttons.length >= 1, "provide at least one button");

  /// The actions rendered in the bar, in display order.
  ///
  /// Deliberately typed to [GtActionButton] rather than [Widget] so the bar can
  /// read each entry's [GtActionButton.size], [GtActionButton.label] and
  /// [GtActionButton.labelStyle] when deciding whether the row fits.
  ///
  /// Must not be empty; see the constructor. In release builds, where the
  /// assert is stripped, an empty list renders nothing instead of throwing.
  final List<GtActionButton> buttons;

  /// Padding applied around the row of [buttons], in both layouts.
  ///
  /// Defaults to [EdgeInsets.zero]. Its horizontal inset comes out of the width
  /// the bar shares among [buttons]. The buttons are already spaced evenly
  /// across what is left, so there is no need to pad them apart.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    if (buttons.isEmpty) return SizedBox.shrink();

    return LayoutBuilder(
      builder: (_, constraints) {
        final width = constraints.maxWidth;
        final shouldScroll = _shouldScroll(context, width);

        Widget child;
        if (shouldScroll) {
          child = IntrinsicHeight(
            child: SingleChildScrollView(
              scrollDirection: .horizontal,
              padding: padding,
              child: Row(
                spacing: context.spacingLg,
                crossAxisAlignment: .start,
                children: buttons,
              ),
            ),
          );
        } else {
          // One equal slot per button, each centred in it, so the gaps follow
          // from the row's width however many buttons there are. The slots
          // share at most [_maxRowWidth], or a wide box would spread them out.
          child = ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxRowWidth),
            child: Padding(
              padding: padding,
              child: Row(
                crossAxisAlignment: .start,
                children: [
                  for (final button in buttons)
                    Expanded(
                      child: Padding(
                        padding: .symmetric(horizontal: context.spacingXs),
                        child: Align(alignment: .topCenter, child: button),
                      ),
                    ),
                ],
              ),
            ),
          );
        }

        if (width <= _maxRowWidth) return child;

        return Center(child: child);
      },
    );
  }

  /// Whether [buttons] need the scrolling layout to fit a box [width] wide.
  ///
  /// Caps [width] at [_maxRowWidth], takes off [padding], and shares what is
  /// left equally among [buttons], less each slot's inset, as the fitted
  /// layout does. The row scrolls when any button does not fit its share; see
  /// [_fitsSlot].
  bool _shouldScroll(BuildContext context, double width) {
    final room = math.min(width, _maxRowWidth) - padding.horizontal;
    final slot = room / buttons.length - context.spacingXs * 2;

    return buttons.any((button) => !_fitsSlot(context, button, slot));
  }

  /// Whether [button] fits a slot [slot] wide in the fitted layout.
  ///
  /// Its tile — [GtActionButton.size], or [GtActionButton.minTapTargetSize]
  /// when that is null — must be no wider than the slot. Its caption, set in
  /// [GtActionButton.labelStyle] or else [GtTextStyles.bodyXs] at weight 500,
  /// and measured by [GtTextFit.of] as the caption's [Text] would draw it,
  /// must wrap into the slot within [_maxCaptionLines] lines without breaking
  /// its longest word.
  ///
  /// *Note: the caption fallbacks mirror [GtActionButton]'s own, so keep the
  /// two in step. A mismatch only misjudges which layout to pick: the fitted
  /// layout still bounds each button to its slot, so it cannot overflow.*
  bool _fitsSlot(BuildContext context, GtActionButton button, double slot) {
    final tile = button.size ?? GtActionButton.minTapTargetSize;
    if (tile > slot) return false;

    if (button.label case String label) {
      final fit = GtTextFit.of(
        context,
        style: button.labelStyle ?? context.textStyles.bodyXs(weight: .w500),
        maxLines: _maxCaptionLines,
      );
      final fits = fit.fits(label, slot, wholeWords: true);
      fit.dispose();
      return fits;
    }

    return true;
  }
}
