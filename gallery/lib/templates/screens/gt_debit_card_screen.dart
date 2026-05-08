import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/data/models/media_data.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Widgetbook preview for [GtDebitCardScreen].
@widgetbook.UseCase(name: 'GtDebitCardScreen', type: GtDebitCardScreen)
Widget buildGtDebitCardScreenUsecase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Organize\nyour\nhustle\nspending',
  );
  final subtitle = context.knobs.string(
    label: 'Subtitle',
    initialValue:
        'Request your card in minutes and enjoy fast, secure payments—anywhere.',
  );
  final illustration = context.knobs.object.dropdown<(String, AppImageData?)>(
    label: 'Illustration',
    options: [
      // ('None', null),
      ('Card', AppImageData(imageData: GtNetworkImages.debitCard)),
    ],
    initialOption: ('Card', AppImageData(imageData: GtNetworkImages.debitCard)),
    labelBuilder: (value) => value.$1,
  );
  final buttonText = context.knobs.string(
    label: 'Button text',
    initialValue: 'continue',
  );

  return GtDebitCardScreen(
    image: illustration.$2,
    title: title,
    subtitle: subtitle,
    onClose: () => context.showToast('Closed', type: .info),
    button: GtRaisedButton(
      text: buttonText,
      onPressed: () => context.showToast('Continue tapped', type: .success),
    ),
  );
}
