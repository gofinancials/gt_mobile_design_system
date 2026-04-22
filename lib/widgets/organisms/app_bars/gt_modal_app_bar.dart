import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// An app bar tailored for modal bottom sheets and overlays, featuring a centered title and an integrated cancel button.
class GtModalAppBar extends GtStatelessWidget implements PreferredSizeWidget {
  final String? _title;
  final Widget? _titleLeading;

  /// Creates a standard [GtModalAppBar] with an optional [title].
  const GtModalAppBar({String? title, super.key})
    : _title = title,
      _titleLeading = null;

  /// Creates a [GtModalAppBar] featuring both a [title] and a leading widget specifically for the title.
  const GtModalAppBar.withLeadingTitleimage({
    required String title,
    required Widget titleLeading,
    super.key,
  }) : _titleLeading = titleLeading,
       _title = title;

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
