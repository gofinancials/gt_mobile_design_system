import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A horizontal strip of [GtActionButton]s — the quick-action row of "Send",
/// "Top up" or "Pay bills" affordances that sits under a balance card or at the
/// head of an account screen.
///
/// The bar measures itself with a [LayoutBuilder] and picks one of two layouts
/// by estimating how much room the tiles need. It multiplies the first button's
/// [GtActionButton.size] (or 44 when that is null) by the number of [buttons]
/// and compares the result against 80% of the width it has been given:
/// - **Within that budget** the bar is a plain [Row] that fills its box,
///   spreading the tiles edge to edge with [MainAxisAlignment.spaceBetween].
/// - **Over it** the row becomes a horizontally scrolling strip anchored to the
///   leading edge, gapped by [BuildContext.spacingMd], so extra actions stay
///   reachable instead of overflowing.
///
/// Either way [padding] is applied around the row. The bar takes its width from
/// its parent, so give it a bounded box; it adds no background of its own.
///
/// *Note: the estimate sizes every tile from the first button alone and counts
/// neither the inter-tile spacing nor [padding], so it errs in both directions:
/// the 80% margin sends rows that would have fitted to the scrolling layout,
/// while a [padding] wider than that margin can overflow the fitted one.*
class GtActionButtonBar extends GtStatelessWidget {
  /// Creates a [GtActionButtonBar].
  ///
  /// [buttons] must not be empty — the layout estimate reads `buttons.first`.
  /// This is asserted, so an empty list is a debug-time error and, for a `const`
  /// invocation, a compile-time one.
  const GtActionButtonBar({
    super.key,
    required this.buttons,
    this.padding = .zero,
  }) : assert(buttons.length >= 1, "provide at least one button");

  /// The actions rendered in the bar, in display order.
  ///
  /// Deliberately typed to [GtActionButton] rather than [Widget] so every entry
  /// shares the same tile size, caption treatment and tap target — the layout
  /// estimate assumes as much, sizing the whole row from the first entry.
  ///
  /// Must not be empty; see the constructor. In release builds, where the
  /// assert is stripped, an empty list renders nothing instead of throwing.
  final List<GtActionButton> buttons;

  /// Padding applied around the row of [buttons], in both layouts.
  ///
  /// Defaults to [EdgeInsets.zero].
  ///
  /// *Note: this is not subtracted from the width the layout estimate works
  /// with, so a horizontal inset wider than the estimate's 80% margin can
  /// overflow the fitted row.*
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    if (buttons.isEmpty) return SizedBox.shrink();

    return LayoutBuilder(
      builder: (_, constraints) {
        final width = constraints.maxWidth;
        final actionWidth = (buttons.first.size ?? 44) + context.spacingMd;
        final shouldScroll = (actionWidth * buttons.length) > width;

        final child = Row(
          spacing: !shouldScroll ? 0 : context.spacingMd,
          mainAxisAlignment: shouldScroll ? .start : .spaceBetween,
          children: buttons,
        );

        if (!shouldScroll) return Padding(padding: padding, child: child);

        return IntrinsicHeight(
          child: SingleChildScrollView(
            scrollDirection: .horizontal,
            padding: padding,
            child: child,
          ),
        );
      },
    );
  }
}
