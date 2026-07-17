import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtToastOverlay', type: GtToastOverlay)
Widget gtToastOverlayUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: "Toast Overlay",
    description: "Displays a brief toast notification over the screen.",
    code: '''
GtToastOverlay(
  'Item added to favorites',
  type: .success,
  icon: Icons.check_circle,
)
''',
    child: Column(
      children: [
        GalleryPageSectionHeader(title: "GtToastOverlay"),
        GtToastOverlay(
          context.knobs.string(
            label: 'Toast Message',
            initialValue: 'Item added to favorites',
          ),
          type: context.knobs.object.dropdown<GtPillVariant>(
            label: 'Variant',
            options: GtPillVariant.values,
            initialOption: .success,
          ),
          icon: Icons.check_circle,
        ),
      ],
    ),
  );
}
