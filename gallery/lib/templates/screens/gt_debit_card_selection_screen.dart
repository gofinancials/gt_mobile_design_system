import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Widgetbook preview for [GtDebitCardSelectionScreen].
@widgetbook.UseCase(
  name: 'GtDebitCardSelectionScreen',
  type: GtDebitCardSelectionScreen,
)
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
    onClose: () => context.showToast('Closed', type: .info),
    onVariantSelected: (variant) {
      final label = switch (variant) {
        .physical => 'Physical card selected',
        .virtual => 'Virtual card selected',
      };
      context.showToast(label, type: .success);
    },
    variants: const [.physical, .virtual],
  );
}
