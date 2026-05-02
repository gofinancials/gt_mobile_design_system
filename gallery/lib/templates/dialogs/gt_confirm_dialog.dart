import 'package:flutter/material.dart';
import 'package:gallery/widgets/gallery_page_header.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Widgetbook playground for [GtLoaderConfirmDialog].
@widgetbook.UseCase(name: 'GtConfirmDialog', type: GtConfirmDialog)
Widget buildGtConfirmDialogUsecase(BuildContext context) {
  return const _ConfirmDialogPreview();
}

class _ConfirmDialogPreview extends StatefulWidget {
  const _ConfirmDialogPreview();

  @override
  State<_ConfirmDialogPreview> createState() => _ConfirmDialogPreviewState();
}

class _ConfirmDialogPreviewState extends State<_ConfirmDialogPreview>
    with GtConfirmDialogMixin {
  @override
  Widget build(BuildContext context) {
    final title = context.knobs.string(
      label: "Confirm Title",
      initialValue: "Confirm Action",
    );
    final description = context.knobs.stringOrNull(
      label: "Confirm Description",
    );
    final allowText = context.knobs.stringOrNull(label: "Confirm Allow Text");
    final denyText = context.knobs.stringOrNull(label: "Confirm Deny text");
    final isDissmissable = context.knobs.boolean(
      label: "Dismissable",
      initialValue: true,
    );

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
              text: "Confirm Action",
              onPressed: () {
                confirmAction(
                  context,
                  title: title,
                  denyText: denyText,
                  allowText: allowText,
                  description: description,
                  isDismissable: isDissmissable,
                  onContinue: () {
                    context.showToast(
                      "You confirmed the action and executed same",
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
