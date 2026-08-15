import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtOutlineButton', type: GtOutlineButton)
Widget playgroundGtOutlineButtonUseCase(BuildContext context) {
  final text = context.knobs.string(
    label: 'Button Text',
    initialValue: 'SECONDARY',
  );
  final variant = context.knobs.object.dropdown(
    label: 'Variant',
    options: GtButtonVariant.values,
    initialOption: GtButtonVariant.secondary,
    labelBuilder: (v) => v.name,
  );
  final size = context.knobs.object.dropdown(
    label: 'Size',
    options: GtButtonSize.values,
    initialOption: GtButtonSize.large,
    labelBuilder: (s) => s.name,
  );
  final isDisabled = context.knobs.boolean(
    label: 'Disabled',
    initialValue: false,
  );
  final isLoading = context.knobs.boolean(
    label: 'Loading',
    initialValue: false,
  );

  final hasIcon = context.knobs.boolean(label: 'Has Icon', initialValue: false);
  final icon = hasIcon ? GtIcons.checkSolid : null;

  final codeSnippet =
      '''
GtOutlineButton(
  text: '$text',
  variant: GtButtonVariant.${variant.name},
  size: GtButtonSize.${size.name},
  isDisabled: $isDisabled,
  isLoading: $isLoading,
  ${hasIcon ? "leading: GtIcons.checkSolid," : ""}
  onPressed: () {},
)''';

  return GtWidgetDocPage(
    title: 'GtOutlineButton',
    description: '''
<b>GtOutlineButton</b> is a bordered button with a transparent background for secondary actions.

<b>When to use:</b> Secondary choices, negative responses (like Cancel), or when placed adjacent to a primary <b>GtRaisedButton</b>.''',
    code: codeSnippet,
    child: GtOutlineButton(
      text: text,
      variant: variant,
      size: size,
      isDisabled: isDisabled,
      isLoading: isLoading,
      leading: icon,
      onPressed: () {},
    ),
  );
}
