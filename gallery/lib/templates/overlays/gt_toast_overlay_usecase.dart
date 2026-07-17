import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtToastOverlay', type: GtToastOverlay)
Widget playgroundGtToastOverlayUseCase(BuildContext context) {
  final message = context.knobs.string(label: 'Toast Message', initialValue: 'Item added to favorites');
  final variant = context.knobs.object.dropdown<GtPillVariant>(
    label: 'Variant',
    options: GtPillVariant.values,
    initialOption: GtPillVariant.success,
    labelBuilder: (v) => v.name,
  );

  return GtWidgetDocPage(
    title: 'GtToastOverlay',
    description: 'A transient floating toast message banner. Present it via the BuildContext extension method.',
    code: '''
// Display toast overlay via BuildContext extension
context.showToast(
  "$message",
  type: GtPillVariant.${variant.name},
  icon: Icons.check_circle, // Optional
);
''',
    child: GtRaisedButton(
      text: 'Trigger Toast Overlay',
      onPressed: () {
        context.showToast(
          message,
          type: variant,
          icon: Icons.check_circle,
        );
      },
    ),
  );
}
