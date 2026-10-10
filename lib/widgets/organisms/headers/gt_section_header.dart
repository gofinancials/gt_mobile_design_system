import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A header widget typically used to introduce a section of content.
///
/// It displays a primary [title] on the left and an optional [trailing] widget
/// (such as a "See All" button or an icon) on the right.
class GtSectionHeader extends GtStatelessWidget {
  /// Overrides style. Null preserves the current default.
  final TextStyle? style;

  /// Overrides text color. Null preserves the current default.
  final Color? textColor;

  /// An optional widget displayed at the trailing edge of the header.
  ///
  /// Often used for actions related to the section, like a text button or an icon.
  final Widget? trailing;

  /// The main title text of the header, cased by [titleCase].
  final String title;

  /// How the [title] is cased before it is drawn.
  ///
  /// Defaults to [GtTextCase.upper]. A header drawn in sentence case passes
  /// [GtTextCase.none] to keep the title as written.
  final GtTextCase titleCase;

  /// Creates a [GtSectionHeader].
  const GtSectionHeader(
    this.title, {
    this.titleCase = .upper,
    this.style,
    this.textColor,
    this.trailing,
    super.key,
  });

  /// Creates a skeleton of a section header, standing in for one whose
  /// title is still loading.
  const factory GtSectionHeader.skeleton({Key? key}) = _GtSectionHeaderSkeleton;

  @override
  Widget build(BuildContext context) {
    final casedTitle = switch (titleCase) {
      .upper => title.upper,
      .lower => title.lower,
      .sentence => title.capitalise(true),
      .title => title.capitalise(),
      .none => title,
    };

    Widget child = GtText(
      casedTitle,
      style: GtTextStyleOverrides.resolve(
        style,
        context.textStyles.buttonS(),
        textColor,
      ),
    );

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
/// Typography follows [GtTextStyles.bodyXs] and reacts to [highlighted]; the
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

  /// Creates a skeleton of a group header with an aggregate amount,
  /// standing in for one whose group is still loading.
  const factory GtTransactionGroupHeader.skeleton({Key? key}) =
      _GtTransactionGroupHeaderSkeleton;

  @override
  Widget build(BuildContext context) {
    final defaultStyle = switch (highlighted) {
      true => context.textStyles.bodyXs(
        weight: .w600,
        color: context.palette.text.darkerSub,
      ),
      false => context.textStyles.bodyXs(
        color: context.palette.text.sub,
        weight: .w500,
      ),
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

/// A private skeleton of [GtSectionHeader], laid out with placeholder data under its
/// own [GtSkeleton].
class _GtSectionHeaderSkeleton extends GtSectionHeader {
  /// Creates a [_GtSectionHeaderSkeleton].
  const _GtSectionHeaderSkeleton({super.key}) : super('Section title');

  @override
  Widget build(BuildContext context) {
    return GtSkeleton(
      child: Builder(builder: (context) => super.build(context)),
    );
  }
}

/// A private skeleton of [GtTransactionGroupHeader], laid out with placeholder data under its
/// own [GtSkeleton].
class _GtTransactionGroupHeaderSkeleton extends GtTransactionGroupHeader {
  /// Creates a [_GtTransactionGroupHeaderSkeleton].
  const _GtTransactionGroupHeaderSkeleton({super.key})
    : super('12 Mar 2026', sum: '-₦24,500.00');

  @override
  Widget build(BuildContext context) {
    return GtSkeleton(
      child: Builder(builder: (context) => super.build(context)),
    );
  }
}
