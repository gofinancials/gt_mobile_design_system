import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtIconButton', type: GtIconButton)
Widget playgroundGtIconButtonUseCase(BuildContext context) {
  final variant = context.knobs.object.dropdown(
    label: 'Variant',
    options: GtButtonVariant.values,
    initialOption: GtButtonVariant.primary,
    labelBuilder: (v) => v.name,
  );
  final shape = context.knobs.object.dropdown(
    label: 'Shape',
    options: GtIconButtonShape.values,
    initialOption: GtIconButtonShape.round,
    labelBuilder: (s) => s.name,
  );
  final size = context.knobs.object.dropdown(
    label: 'Size',
    options: GtButtonSize.values,
    initialOption: GtButtonSize.large,
    labelBuilder: (s) => s.name,
  );
  final isDisabled = context.knobs.boolean(label: 'Disabled', initialValue: false);
  final isLoading = context.knobs.boolean(label: 'Loading', initialValue: false);

  final codeSnippet = '''
GtIconButton(
  icon: GtIcons.add,
  variant: GtButtonVariant.${variant.name},
  shape: GtIconButtonShape.${shape.name},
  size: GtButtonSize.${size.name},
  isDisabled: $isDisabled,
  isLoading: $isLoading,
  onPressed: () {},
)''';

  return GtWidgetDocPage(
    title: 'GtIconButton',
    description: '''
<b>GtIconButton</b> is an icon-only button with configurable shapes (square, round) and sizes.

<b>When to use:</b> Toolbar actions, quick icon options, floating actions, or close/dismiss buttons.''',
    code: codeSnippet,
    child: GtIconButton(
      icon: GtIcons.add,
      variant: variant,
      shape: shape,
      size: size,
      isDisabled: isDisabled,
      isLoading: isLoading,
      onPressed: () {},
    ),
  );
}
