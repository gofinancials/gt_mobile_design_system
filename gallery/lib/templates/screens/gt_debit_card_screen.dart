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
    description:
        'A layout template showcasing debit card options with high-quality illustrations and primary call-to-action buttons.',
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
      description:
          'Select "GtDebitCardScreen Gallery" in the sidebar to view the interactive debit card screen in full screen.',
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
    initialValue:
        'Request your card in minutes and enjoy fast, secure payments—anywhere.',
  );
  final illustration = context.knobs.object.dropdown<(String, AppImageData?)>(
    label: 'Illustration',
    options: const [('Card', AppImageData.network(GtNetworkImages.debitCard))],
    initialOption: const (
      'Card',
      AppImageData.network(GtNetworkImages.debitCard),
    ),
    labelBuilder: (value) => value.$1,
  );
  final imageAlignment = context.knobs.object.dropdown<Alignment>(
    label: 'Image Alignment',
    options: const [Alignment.centerRight, Alignment.center],
    initialOption: Alignment.centerRight,
    labelBuilder: (value) =>
        value == Alignment.center ? 'center' : 'centerRight',
  );
  final imageWidth = context.knobs.doubleOrNull.slider(
    label: 'Image Width',
    min: 120,
    max: 400,
    divisions: 28,
    initialValue: 358,
    defaultToNull: true,
  );
  final imageHeight = context.knobs.doubleOrNull.slider(
    label: 'Image Height',
    min: 120,
    max: 400,
    divisions: 28,
    initialValue: 280,
    defaultToNull: true,
  );
  final titleSpacingPx = context.knobs.doubleOrNull.slider(
    label: 'Title Spacing',
    min: 0,
    max: 32,
    divisions: 16,
    initialValue: 12,
    defaultToNull: true,
  );
  final buttonText = context.knobs.string(
    label: 'Button text',
    initialValue: 'continue',
  );
  final textAlign = context.knobs.object.dropdown<TextAlign>(
    label: 'Text Align',
    options: const [TextAlign.start, TextAlign.center],
    initialOption: TextAlign.start,
    labelBuilder: (value) => value.name,
  );
  final welcomeStyles = context.knobs.boolean(
    label: 'Welcome Text Styles (Display 3.5 / Body M)',
    initialValue: false,
  );
  final textured = context.knobs.boolean(
    label: 'Textured Background',
    initialValue: false,
  );

  TextStyle? titleStyle;
  TextStyle? subtitleStyle;
  if (welcomeStyles) {
    final white = context.palette.staticColors.white;
    titleStyle = context.textStyles.d3_5(color: white);
    subtitleStyle = context.textStyles.bodyM(color: white);
  }

  DecorationImage? backgroundImage;
  if (textured) {
    backgroundImage = const DecorationImage(
      image: NetworkImage(GtNetworkImages.avatarTexture1),
      fit: BoxFit.cover,
      opacity: .24,
    );
  }

  return GtDebitCardScreen(
    image: illustration.$2,
    title: title,
    subtitle: subtitle,
    textAlign: textAlign,
    titleStyle: titleStyle,
    subtitleStyle: subtitleStyle,
    backgroundImage: backgroundImage,
    imageAlignment: imageAlignment,
    imageWidth: imageWidth,
    imageHeight: imageHeight,
    titleSpacingPx: titleSpacingPx,
    onClose: () => context.showToast('Closed', type: GtPillVariant.info),
    button: GtRaisedButton(
      text: buttonText,
      onPressed: () =>
          context.showToast('Continue tapped', type: GtPillVariant.success),
      textColor: context.palette.primary.base,
      variant: GtButtonVariant.white,
    ),
  );
}
