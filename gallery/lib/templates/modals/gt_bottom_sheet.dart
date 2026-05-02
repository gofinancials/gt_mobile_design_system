import 'package:flutter/material.dart';
import 'package:gallery/widgets/gallery_page_header.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Widgetbook playground for [GtLoaderBottomSheet].
@widgetbook.UseCase(name: 'GtBottomSheet', type: GtBottomSheet)
Widget buildGtBottomSheetUsecase(BuildContext context) {
  return const _BottomSheetPreview();
}

class _BottomSheetPreview extends StatefulWidget {
  const _BottomSheetPreview();

  @override
  State<_BottomSheetPreview> createState() => _BottomSheetPreviewState();
}

const List<(IconData, String)> items = [
  (GtIcons.editDoc, "Edit"),
  (GtIcons.calendarEmpty, "Schedule"),
  (GtIcons.copy, "Duplicate"),
  (GtIcons.shareIos, "Export"),
  (GtIcons.trash, "Delete"),
  (GtIcons.message, "Retry SMS and email"),
  (GtIcons.whatsapp, "Verify with a Selfie"),
];

class _BottomSheetPreviewState extends State<_BottomSheetPreview>
    with GtBottomSheetMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: context.insets.defaultHorizontalInsets,
        child: Column(
          mainAxisAlignment: .start,
          crossAxisAlignment: .stretch,
          spacing: context.spacingLg,
          children: [
            GalleryPageHeader(
              title: 'Bottom Sheet',
              rider: 'Bottom shet playground draggable and static',
            ),
            GtRaisedButton(
              text: 'Show Simple Bottom Sheet',
              onPressed: () {
                showSheet(
                  context,
                  maxHeightFraction: .5,
                  child: GtStatusState.success(
                    messageTitle: "successful !",
                    subtitle:
                        "Your BVN was added successfully. You can now initiate transactions.",
                    actionLabel: "SUCCESS",
                    onActionPressed: () => Navigator.of(context).pop(),
                  ),
                );
              },
            ),
            GtRaisedButton(
              text: 'Show Draggable Bottom Sheet',
              variant: .highlighted,
              onPressed: () {
                showDraggableSheet(
                  context,
                  minChildSize: .2,
                  initialChildSize: .3,
                  maxHeightFraction: .7,
                  builder: (value) {
                    return SingleChildScrollView(
                      controller: value,
                      padding: context.insets.defaultAllInsets,
                      child: SafeArea(
                        top: false,
                        child: Column(
                          spacing: context.spacingSm,
                          children: [
                            GtModalAppBar(title: "Manage PAYROLL"),
                            for (final item in items)
                              GtIconListTile.alt(item.$2, icon: item.$1),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
