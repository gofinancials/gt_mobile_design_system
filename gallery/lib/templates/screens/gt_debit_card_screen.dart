import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/data/models/media_data.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtDebitCardScreen', type: GtDebitCardScreen)
Widget buildGtDebitCardScreenDoc(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtDebitCardScreen',
    description: 'A layout template showcasing debit card options with high-quality illustrations and primary call-to-action buttons.',
    code: '''
GtDebitCardScreen(
  image: AppImageData.network(GtNetworkImages.debitCard),
  title: "Organize your hustle spending",
  subtitle: "Request your card in minutes and enjoy fast, secure payments.",
  onClose: () => handleClose(),
  button: GtRaisedButton(
    text: "continue",
    onPressed: () => handleContinue(),
  ),
)''',
    child: GtEmptyStateCard(
      description: 'Select "GtDebitCardScreen Gallery" in the sidebar to view the interactive debit card screen in full screen.',
      icon: GtIcons.alarmClock,
    ),
  );
}

@widgetbook.UseCase(name: 'GtDebitCardScreen Gallery', type: GtDebitCardScreen)
Widget buildGtDebitCardScreenUsecase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Organize\nyour\nhustle\nspending',
  );
  final subtitle = context.knobs.string(
    label: 'Subtitle',
    initialValue: 'Request your card in minutes and enjoy fast, secure payments—anywhere.',
  );
  final illustration = context.knobs.object.dropdown<(String, AppImageData?)>(
    label: 'Illustration',
    options: const [('Card', AppImageData.network(GtNetworkImages.debitCard))],
    initialOption: const ('Card', AppImageData.network(GtNetworkImages.debitCard)),
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
    onClose: () => context.showToast('Closed', type: GtPillVariant.info),
    button: GtRaisedButton(
      text: buttonText,
      onPressed: () => context.showToast('Continue tapped', type: GtPillVariant.success),
      textColor: context.palette.primary.base,
      variant: GtButtonVariant.white,
    ),
  );
}
