import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// An app bar tailored for modal bottom sheets and overlays, featuring a centered title and an integrated cancel button.
///
/// {@category Organisms}
class GtModalAppBar extends GtStatelessWidget implements PreferredSizeWidget {
  final String? _title;
  final Widget? _titleLeading;

  /// Creates a standard [GtModalAppBar] with an optional [title].
  const GtModalAppBar({String? title, super.key})
    : _title = title,
      _titleLeading = null;

  /// Creates a [GtModalAppBar] featuring both a [title] and a leading widget
  /// specifically for the title (e.g., an icon or avatar).
  const GtModalAppBar.withLeadingTitleimage({
    required String title,
    required Widget titleLeading,
    super.key,
  }) : _titleLeading = titleLeading,
       _title = title;

  /// Creates an extended [GtModalAppBar] that includes a back button,
  /// a centered title, and an optional trailing [action] widget.
  const factory GtModalAppBar.extended({
    required String title,
    Widget? action,
    Key? key,
  }) = _GtExtendedModalAppBar;

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
                const Offstage(),
                Row(
                  mainAxisAlignment: .center,
                  spacing: context.spacingSm,
                  children: [
                    ?_titleLeading,
                    GtText(
                      _title?.upper,
                      style: context.textStyles.h6(),
                      textAlign: .center,
                      maxLines: 1,
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
        child: Row(
          children: [
            GtSquareConstrainedBox(
              24,
              child: FittedBox(fit: .scaleDown, child: GtBackButton()),
            ),
            Expanded(
              child: FractionalTranslation(
                // Slight horizontal offset to balance the visual center of the title
                // against the leading back button.
                translation: Offset(.08, 0),
                child: GtText(
                  title,
                  textAlign: .center,
                  maxLines: 1,
                  style: context.textStyles.button(),
                ),
              ),
            ),
            ?action,
          ],
        ),
      ),
    );
  }
}
