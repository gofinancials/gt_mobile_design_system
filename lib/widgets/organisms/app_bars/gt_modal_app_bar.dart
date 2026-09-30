import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// An app bar tailored for modal bottom sheets and overlays, featuring a centered title and an integrated cancel button.
///
/// @category Organisms
class GtModalAppBar extends GtStatelessWidget implements PreferredSizeWidget {
  /// The centred title, drawn in uppercase. Null leaves the title column empty.
  final String? _title;

  /// An optional widget drawn before the [_title], such as an icon or avatar.
  final Widget? _titleLeading;

  /// An optional widget rendered at the leading edge, opposite the cancel
  /// button (e.g. a refresh action).
  ///
  /// The layout already reserves this column, so supplying a leading widget
  /// does not shift the centered title.
  final Widget? leading;

  /// Creates a standard [GtModalAppBar] with an optional [title].
  const GtModalAppBar({String? title, this.leading, super.key})
    : _title = title,
      _titleLeading = null;

  /// Creates a [GtModalAppBar] featuring both a [title] and a leading widget
  /// specifically for the title (e.g., an icon or avatar).
  const GtModalAppBar.withLeadingTitleimage({
    required String title,
    required Widget titleLeading,
    this.leading,
    super.key,
  }) : _titleLeading = titleLeading,
       _title = title;

  /// Creates an extended [GtModalAppBar] that includes a back button,
  /// a centered title, and an optional trailing [action] widget.
  ///
  /// The title is drawn in uppercase in [style], which falls back to
  /// [GtTextStyles.button] when null.
  const factory GtModalAppBar.extended({
    required String title,
    required Widget? action,
    TextStyle? style,
    Key? key,
  }) = _GtExtendedModalAppBar;

  /// A [GtModalAppBar] that displays a title as a header, with an optional trailing action button. The title text is automatically expanded to fill available space and truncated with an ellipsis if necessary.
  const factory GtModalAppBar.title({
    required String title,
    required Widget? action,
    TextStyle? style,
    GtTextCase? titleCase,
    Key? key,
    double? horizontalSpacing,
  }) = _GtTitleModalAppBar;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: .transparency,
      child: Container(
        padding: (context.insets.defaultHorizontalInsets).add(
          context.insets.onlyDp(top: 24.px),
        ),
        color: Colors.transparent,
        child: Table(
          defaultVerticalAlignment: .middle,
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(10),
            2: FlexColumnWidth(2),
          },
          children: [
            TableRow(
              children: [
                leading ?? const Offstage(),
                Row(
                  mainAxisAlignment: .center,
                  spacing: context.spacingSm,
                  children: [
                    ?_titleLeading,
                    Flexible(
                      child: GtText(
                        _title?.upper,
                        style: context.textStyles.h6(),
                        textAlign: .center,
                        maxLines: 1,
                        // Level 1 within the modal's own route scope.
                        headingLevel: 1,
                        overflow: .ellipsis,
                      ),
                    ),
                  ],
                ),
                GtCancelButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize {
    return Size.fromHeight(kToolbarHeight);
  }
}

/// A private [GtModalAppBar] with a back button, a centred title and an
/// optional trailing action, built by [GtModalAppBar.extended].
class _GtExtendedModalAppBar extends GtModalAppBar {
  /// The centred title, drawn in uppercase.
  final String title;

  /// An optional widget aligned to the trailing edge.
  final Widget? action;

  /// Overrides the [title]'s style. Null preserves [GtTextStyles.button].
  final TextStyle? style;

  /// Creates a [_GtExtendedModalAppBar].
  const _GtExtendedModalAppBar({
    super.key,
    required this.title,
    this.action,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: .transparency,
      child: Padding(
        padding: context.insets.fromLTRBDp(16.px, 24.px, 16.px, 0),
        child: Table(
          defaultVerticalAlignment: .middle,
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(10),
            2: FlexColumnWidth(2),
          },
          children: [
            TableRow(
              children: [
                GtBackButton(size: .small),
                GtText(
                  title.upper,
                  textAlign: .center,
                  maxLines: 1,
                  style: style ?? context.textStyles.button(),
                  overflow: .ellipsis,
                  headingLevel: 1,
                ),
                Align(alignment: .centerRight, child: action),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// A private [GtModalAppBar] with a leading, expanded title and an optional
/// trailing action, built by [GtModalAppBar.title].
class _GtTitleModalAppBar extends GtModalAppBar {
  /// The title, cased by [titleCase].
  final String title;

  /// Overrides the [title]'s style. Null preserves [GtTextStyles.button].
  final TextStyle? style;

  /// How the [title] is cased. Null preserves [GtTextCase.upper].
  final GtTextCase? titleCase;

  /// An optional widget drawn after the title.
  final Widget? action;

  /// The gap between the title and the [action], in logical pixels. Null
  /// preserves [BuildContext.spacingMd].
  final double? horizontalSpacing;

  /// Creates a [_GtTitleModalAppBar].
  const _GtTitleModalAppBar({
    super.key,
    required this.title,
    this.action,
    this.style,
    this.titleCase,
    this.horizontalSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final casing = titleCase ?? GtTextCase.upper;

    final casedTitle = switch (casing) {
      .lower => title.lower,
      .upper => title.upper,
      .sentence => title.capitalise(true),
      .title => title.capitalise(),
      .none => title,
    };

    return Material(
      type: .transparency,
      child: Padding(
        padding: context.insets.fromLTRBDp(16.px, 24.px, 16.px, 0),
        child: Row(
          spacing: horizontalSpacing ?? context.spacingMd,
          children: [
            Expanded(
              child: GtText(
                casedTitle,
                maxLines: 1,
                style: style ?? context.textStyles.button(),
                overflow: .ellipsis,
                headingLevel: 1,
              ),
            ),
            ?action,
          ],
        ),
      ),
    );
  }
}
