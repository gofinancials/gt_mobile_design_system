import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A header widget typically used to introduce a section of content.
///
/// It displays a primary [title] on the left and an optional [trailing] widget
/// (such as a "See All" button or an icon) on the right.
class GtSectionHeader extends GtStatelessWidget {
  /// An optional widget displayed at the trailing edge of the header.
  ///
  /// Often used for actions related to the section, like a text button or an icon.
  final Widget? trailing;

  /// The main title text of the header.
  ///
  /// This text is automatically converted to uppercase.
  final String title;

  /// Creates a [GtSectionHeader].
  const GtSectionHeader(this.title, {this.trailing, super.key});

  @override
  Widget build(BuildContext context) {
    Widget child = GtText(title.upper, style: context.textStyles.buttonS());

    if (trailing != null) {
      child = Row(
        crossAxisAlignment: .center,
        spacing: context.spacingMd,
        children: [
          Expanded(child: child),
          ?trailing,
        ],
      );
    }
    return child;
  }
}

/// Standardized **header for a group of transactions**, such as the date
/// bucket ("TODAY", "12 MAR 2026") that precedes a run of transaction tiles in
/// a statement or activity list.
///
/// It lays out the uppercased [title] on the leading edge and, on the trailing
/// edge, either:
/// - an aggregate amount, rendered in the same style as the title — see
///   [GtTransactionGroupHeader.new]; or
/// - an arbitrary widget, such as a chip or a text button — see
///   [GtTransactionGroupHeader.withTrailing].
///
/// Typography follows [GtTextStyles.subHeadXs] and reacts to [highlighted]; the
/// title takes the remaining width, so a long title wraps rather than pushing
/// the trailing content off-screen. The header renders no padding of its own —
/// wrap it or rely on the padding of the surrounding list.
class GtTransactionGroupHeader extends GtStatelessWidget {
  /// The widget shown at the trailing edge, supplied by
  /// [GtTransactionGroupHeader.withTrailing].
  ///
  /// `null` for the default constructor, which renders the aggregate amount
  /// instead. The two are mutually exclusive, and [style] does not apply here —
  /// the widget is rendered as given.
  final Widget? _trailing;

  /// The group's heading text (shown in **uppercase**).
  ///
  /// Typically the date or label the transactions are grouped by.
  final String title;

  /// The aggregate amount for the group, pre-formatted for display
  /// (e.g. `'-₦24,500.00'`), supplied by [GtTransactionGroupHeader.new].
  ///
  /// Rendered at the trailing edge, end-aligned, in the same style as [title].
  /// `null` when the header was built with
  /// [GtTransactionGroupHeader.withTrailing].
  final String? _sum;

  /// Whether the header is emphasized against the rest of the list.
  ///
  /// When `false` (the default) the text uses [GtPalette.text.sub]. When `true`
  /// it is bumped to weight `w600` in the stronger [GtPalette.text.darkerSub].
  /// Ignored when [style] is supplied.
  final bool highlighted;

  /// Overrides the computed text style for **both** the title and the amount.
  ///
  /// When `null`, the style is derived from [highlighted]. Has no effect on a
  /// widget passed to [GtTransactionGroupHeader.withTrailing].
  final TextStyle? style;

  /// Creates a [GtTransactionGroupHeader] that shows the group's aggregate
  /// [sum] at the trailing edge.
  const GtTransactionGroupHeader(
    this.title, {
    required String sum,
    this.highlighted = false,
    this.style,
    super.key,
  }) : _sum = sum,
       _trailing = null;

  /// Creates a [GtTransactionGroupHeader] that shows a custom [trailing] widget
  /// instead of an aggregate amount.
  const GtTransactionGroupHeader.withTrailing(
    this.title, {
    required Widget trailing,
    this.highlighted = false,
    this.style,
    super.key,
  }) : _sum = null,
       _trailing = trailing;

  @override
  Widget build(BuildContext context) {
    final defaultStyle = switch (highlighted) {
      true => context.textStyles.subHeadXs(
        weight: .w600,
        color: context.palette.text.darkerSub,
      ),
      false => context.textStyles.subHeadXs(color: context.palette.text.sub),
    };
    Widget? trailing = _trailing;

    if (_sum != null) {
      trailing = GtText(_sum, style: style ?? defaultStyle, textAlign: .end);
    }

    return Row(
      crossAxisAlignment: .center,
      spacing: context.spacingMd,
      children: [
        Expanded(
          child: GtText(title.capitalise(), style: style ?? defaultStyle),
        ),
        ?trailing,
      ],
    );
  }
}
