import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// An app bar tailored for modal bottom sheets and overlays, featuring a centered title and an integrated cancel button.
///
/// @category Organisms
class GtModalAppBar extends GtStatelessWidget implements PreferredSizeWidget {
  final String? _title;
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
  const factory GtModalAppBar.extended({
    required String title,
    required Widget? action,
    Key? key,
  }) = _GtExtendedModalAppBar;

  /// A [GtModalAppBar] that displays a title as a header, with an optional trailing action button. The title text is automatically expanded to fill available space and truncated with an ellipsis if necessary.
  const factory GtModalAppBar.title({
    required String title,
    required Widget? action,
    TextStyle? style,
    GtTextCase? titleCase,
    Key? key,
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

/// Internal implementation for the extended modal app bar.
class _GtExtendedModalAppBar extends GtModalAppBar {
  final String title;
  final Widget? action;

  const _GtExtendedModalAppBar({super.key, required this.title, this.action});

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
                  style: context.textStyles.button(),
                  overflow: .ellipsis,
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

/// Internal implementation for the extended modal app bar.
class _GtTitleModalAppBar extends GtModalAppBar {
  final String title;
  final TextStyle? style;
  final GtTextCase? titleCase;
  final Widget? action;

  const _GtTitleModalAppBar({
    super.key,
    required this.title,
    this.action,
    this.style,
    this.titleCase,
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
          spacing: context.spacingMd,
          children: [
            Expanded(
              child: GtText(
                casedTitle,
                maxLines: 1,
                style: style ?? context.textStyles.button(),
                overflow: .ellipsis,
              ),
            ),
            ?action,
          ],
        ),
      ),
    );
  }
}
