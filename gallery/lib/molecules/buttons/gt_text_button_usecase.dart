import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtTextButton', type: GtTextButton)
Widget playgroundGtTextButtonUseCase(BuildContext context) {
  final text = context.knobs.string(label: 'Button Text', initialValue: 'LEARN MORE');
  final variant = context.knobs.object.dropdown(
    label: 'Variant',
    options: GtButtonVariant.values,
    initialOption: GtButtonVariant.primary,
    labelBuilder: (v) => v.name,
  );
  final textCase = context.knobs.object.dropdown(
    label: 'Text Case',
    options: GtButtonTextCase.values,
    initialOption: GtButtonTextCase.upper,
    labelBuilder: (c) => c.name,
  );
  final size = context.knobs.object.dropdown(
    label: 'Size',
    options: GtButtonSize.values,
    initialOption: GtButtonSize.large,
    labelBuilder: (s) => s.name,
  );
  final isDisabled = context.knobs.boolean(label: 'Disabled', initialValue: false);
  final isLoading = context.knobs.boolean(label: 'Loading', initialValue: false);

  final hasIcon = context.knobs.boolean(label: 'Has Icon', initialValue: false);
  final icon = hasIcon ? GtIcons.chevronRight : null;

  final codeSnippet = '''
GtTextButton(
  text: '$text',
  variant: GtButtonVariant.${variant.name},
  textCase: GtButtonTextCase.${textCase.name},
  size: GtButtonSize.${size.name},
  isDisabled: $isDisabled,
  isLoading: $isLoading,
  ${hasIcon ? "trailing: GtIcons.chevronRight," : ""}
  onPressed: () {},
)''';

  return GtWidgetDocPage(
    title: 'GtTextButton',
    description: '''
<b>GtTextButton</b> is a borderless, flat text button designed for low-priority actions.

<b>When to use:</b> Inline actions (e.g. "Forgot password?", "Learn more", "Skip") or minimal actions where a visual border is unnecessary.''',
    code: codeSnippet,
    child: GtTextButton(
      text: text,
      variant: variant,
      textCase: textCase,
      size: size,
      isDisabled: isDisabled,
      isLoading: isLoading,
      trailing: icon,
      onPressed: () {},
    ),
  );
}
