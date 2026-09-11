import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

const _buttonStylePresets = ['Default', 'labelM', 'subHeadS', 'bodyS'];

TextStyle? _getButtonStyle(String preset, BuildContext context, Color color) {
  final styles = context.textStyles;
  return switch (preset) {
    'labelM' => styles.labelM(color: color),
    'subHeadS' => styles.subHeadS(color: color),
    'bodyS' => styles.bodyS(color: color),
    _ => null,
  };
}

String _colorSource(Color value) =>
    'Color(0x${value.toARGB32().toRadixString(16)})';

@widgetbook.UseCase(name: 'GtActionCard', type: GtActionCard)
Widget playgroundGtActionCardUseCase(BuildContext context) {
  final mode = context.knobs.object.dropdown<String>(
    label: 'Card Mode',
    options: ['standard', 'dismissible', 'dismissibleTrailing'],
    initialOption: 'standard',
  );
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Refer a Friend, Earn ₦5,000 each',
  );
  final subtitle = context.knobs.string(
    label: 'Subtitle',
    initialValue: 'Love your Pro account? Share with your friends.',
  );
  final actionText = context.knobs.string(
    label: 'Action Text',
    initialValue: 'Share Invite',
  );
  final dismissText = context.knobs.string(
    label: 'Dismiss Text',
    initialValue: 'DISMISS',
  );
  final variant = context.knobs.object.dropdown<GtCardVariant>(
    label: 'Variant',
    options: GtCardVariant.values,
    initialOption: GtCardVariant.away,
    labelBuilder: (v) => v.name,
  );
  final backgroundColor = context.knobs.colorOrNull(
    label: 'Background Colour',
    initialValue: null,
  );
  final buttonVariant = context.knobs.objectOrNull.dropdown<GtButtonVariant?>(
    label: 'Button Variant',
    options: [null, ...GtButtonVariant.values],
    initialOption: null,
    labelBuilder: (v) => v?.name ?? 'Default (from card variant)',
  );
  final actionButtonColor = context.knobs.colorOrNull(
    label: 'Action Button Colour',
    initialValue: null,
  );
  final actionButtonTextColor = context.knobs.colorOrNull(
    label: 'Action Button Text Colour',
    initialValue: null,
  );
  final actionStylePreset = context.knobs.object.dropdown<String>(
    label: 'Action Button Style',
    options: _buttonStylePresets,
    initialOption: _buttonStylePresets.first,
  );
  final dismissButtonTextColor = context.knobs.colorOrNull(
    label: 'Dismiss Button Text Colour',
    initialValue: null,
  );
  final dismissStylePreset = context.knobs.object.dropdown<String>(
    label: 'Dismiss Button Style',
    options: _buttonStylePresets,
    initialOption: _buttonStylePresets.first,
  );

  // A style replaces the button's label style wholesale, colour included, so
  // the presets carry the text colour knob, falling back to a colour that
  // reads on each button while it is unset.
  final actionStyleColor =
      actionButtonTextColor ?? context.palette.staticColors.white;
  final dismissStyleColor =
      dismissButtonTextColor ?? variant.getTextColor(context.palette);
  final actionButtonStyle = _getButtonStyle(
    actionStylePreset,
    context,
    actionStyleColor,
  );
  final dismissButtonStyle = _getButtonStyle(
    dismissStylePreset,
    context,
    dismissStyleColor,
  );

  final stylingSource = [
    if (backgroundColor != null)
      '\n  backgroundColor: ${_colorSource(backgroundColor)},',
    if (buttonVariant != null)
      '\n  buttonVariant: GtButtonVariant.${buttonVariant.name},',
    if (actionButtonColor != null)
      '\n  actionButtonColor: ${_colorSource(actionButtonColor)},',
    if (actionButtonTextColor != null)
      '\n  actionButtonTextColor: ${_colorSource(actionButtonTextColor)},',
    if (actionButtonStyle != null)
      '\n  actionButtonStyle: context.textStyles.$actionStylePreset('
          'color: ${_colorSource(actionStyleColor)}),',
  ].join();
  final dismissStylingSource = [
    if (dismissButtonTextColor != null)
      '\n  dismissButtonTextColor: ${_colorSource(dismissButtonTextColor)},',
    if (dismissButtonStyle != null)
      '\n  dismissButtonStyle: context.textStyles.$dismissStylePreset('
          'color: ${_colorSource(dismissStyleColor)}),',
  ].join();

  Widget cardWidget;
  String codeSnippet;

  if (mode == 'dismissible') {
    cardWidget = GtActionCard.dismissible(
      title: title,
      subtitle: subtitle,
      icon: GtIcons.gift,
      onActionTap: () {},
      actionText: actionText,
      variant: variant,
      onDismiss: () {},
      dismissText: dismissText,
      backgroundColor: backgroundColor,
      buttonVariant: buttonVariant,
      actionButtonColor: actionButtonColor,
      actionButtonTextColor: actionButtonTextColor,
      actionButtonStyle: actionButtonStyle,
      dismissButtonTextColor: dismissButtonTextColor,
      dismissButtonStyle: dismissButtonStyle,
    );
    codeSnippet =
        '''GtActionCard.dismissible(
  title: "$title",
  subtitle: "$subtitle",
  icon: GtIcons.gift,
  onActionTap: () {},
  actionText: "$actionText",
  variant: GtCardVariant.${variant.name},
  onDismiss: () {},
  dismissText: "$dismissText",$stylingSource$dismissStylingSource
)''';
  } else if (mode == 'dismissibleTrailing') {
    cardWidget = GtActionCard.dismissibleTrailing(
      title: title,
      subtitle: subtitle,
      trailing: GtSvg(
        GtVectorIllustrations.serviceStatus,
        width: context.dp(80.px),
        height: context.dp(80.px),
        alignment: Alignment.topRight,
      ),
      onActionTap: () {},
      actionText: actionText,
      variant: variant,
      onDismiss: () {},
      dismissText: dismissText,
      backgroundColor: backgroundColor,
      buttonVariant: buttonVariant,
      actionButtonColor: actionButtonColor,
      actionButtonTextColor: actionButtonTextColor,
      actionButtonStyle: actionButtonStyle,
      dismissButtonTextColor: dismissButtonTextColor,
      dismissButtonStyle: dismissButtonStyle,
    );
    codeSnippet =
        '''GtActionCard.dismissibleTrailing(
  title: "$title",
  subtitle: "$subtitle",
  trailing: GtSvg(GtVectorIllustrations.serviceStatus, width: 80, height: 80),
  onActionTap: () {},
  actionText: "$actionText",
  variant: GtCardVariant.${variant.name},
  onDismiss: () {},
  dismissText: "$dismissText",$stylingSource$dismissStylingSource
)''';
  } else {
    cardWidget = GtActionCard(
      title: title,
      subtitle: subtitle,
      icon: GtIcons.gift,
      onActionTap: () {},
      actionText: actionText,
      variant: variant,
      backgroundColor: backgroundColor,
      buttonVariant: buttonVariant,
      actionButtonColor: actionButtonColor,
      actionButtonTextColor: actionButtonTextColor,
      actionButtonStyle: actionButtonStyle,
    );
    codeSnippet =
        '''GtActionCard(
  title: "$title",
  subtitle: "$subtitle",
  icon: GtIcons.gift,
  onActionTap: () {},
  actionText: "$actionText",
  variant: GtCardVariant.${variant.name},$stylingSource
)''';
  }

  return GtWidgetDocPage(
    title: 'GtActionCard',
    description:
        'An actionable card featuring promo information, call-to-actions, and optional dismiss buttons.',
    code: codeSnippet,
    child: cardWidget,
  );
}
