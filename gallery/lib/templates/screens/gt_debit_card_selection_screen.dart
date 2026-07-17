import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtDebitCardSelectionScreen', type: GtDebitCardSelectionScreen)
Widget buildGtDebitCardSelectionScreenDoc(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtDebitCardSelectionScreen',
    description: 'A layout template allowing users to select between physical and virtual debit card types.',
    code: '''
GtDebitCardSelectionScreen(
  title: "Select card type",
  subtitle: "Select your preferred card type",
  onClose: () => handleClose(),
  onVariantSelected: (variant) {
    // Handle physical or virtual card selection
  },
)''',
    child: GtEmptyStateCard(
      description: 'Select "GtDebitCardSelectionScreen Gallery" in the sidebar to view the interactive card selection screen in full screen.',
      icon: GtIcons.alarmClock,
    ),
  );
}

@widgetbook.UseCase(name: 'GtDebitCardSelectionScreen Gallery', type: GtDebitCardSelectionScreen)
Widget buildGtDebitCardSelectionScreenUsecase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Select card type',
  );
  final subtitle = context.knobs.string(
    label: 'Subtitle',
    initialValue: 'Select your preferred card type',
  );

  return GtDebitCardSelectionScreen(
    title: title,
    subtitle: subtitle,
    onClose: () => context.showToast('Closed', type: GtPillVariant.info),
    onVariantSelected: (variant) {
      final label = switch (variant) {
        GtDebitCardVariant.physical => 'Physical card selected',
        GtDebitCardVariant.virtual => 'Virtual card selected',
      };
      context.showToast(label, type: GtPillVariant.success);
    },
  );
}
