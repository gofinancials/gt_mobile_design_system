import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtRaisedButton', type: GtRaisedButton)
Widget playgroundGtRaisedButtonUseCase(BuildContext context) {
  final text = context.knobs.string(
    label: 'Button Text',
    initialValue: 'PRIMARY BUTTON',
  );
  final isDisabled = context.knobs.boolean(
    label: 'Disabled',
    initialValue: false,
  );
  final isLoading = context.knobs.boolean(
    label: 'Loading',
    initialValue: false,
  );
  final variant = context.knobs.object.dropdown(
    label: 'Variant',
    options: GtButtonVariant.values,
    initialOption: GtButtonVariant.primary,
    labelBuilder: (v) => v.name,
  );
  final size = context.knobs.object.dropdown(
    label: 'Size',
    options: GtButtonSize.values,
    initialOption: GtButtonSize.large,
    labelBuilder: (s) => s.name,
  );

  final codeSnippet =
      '''
GtRaisedButton(
  text: '$text',
  variant: GtButtonVariant.${variant.name},
  size: GtButtonSize.${size.name},
  isDisabled: $isDisabled,
  isLoading: $isLoading,
  onPressed: () {},
)''';

  return GtWidgetDocPage(
    title: 'GtRaisedButton',
    description: '''
<b>GtRaisedButton</b> is a filled, elevated button for primary actions.

<b>When to use:</b> Primary call-to-actions, logins, main submission screens.
For secondary actions, consider using <b>GtOutlineButton</b> or <b>GtTextButton</b>.''',
    code: codeSnippet,
    child: GtRaisedButton(
      text: text,
      variant: variant,
      size: size,
      isDisabled: isDisabled,
      isLoading: isLoading,
      onPressed: () {},
    ),
  );
}
