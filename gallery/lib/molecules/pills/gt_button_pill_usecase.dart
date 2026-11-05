import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

const _paddingPresets = ['Default (size)', '6 × 4', '8 × 4', 'None'];

EdgeInsets? _getPadding(String preset, BuildContext context) {
  return switch (preset) {
    '6 × 4' => context.insets.symmetricDp(horizontal: 6.px, vertical: 4.px),
    '8 × 4' => context.insets.symmetricDp(horizontal: 8.px, vertical: 4.px),
    'None' => EdgeInsets.zero,
    _ => null,
  };
}

String? _getPaddingSnippet(String preset) {
  return switch (preset) {
    '6 × 4' => 'context.insets.symmetricDp(horizontal: 6.px, vertical: 4.px)',
    '8 × 4' => 'context.insets.symmetricDp(horizontal: 8.px, vertical: 4.px)',
    'None' => 'EdgeInsets.zero',
    _ => null,
  };
}

@widgetbook.UseCase(name: 'GtButtonPill', type: GtButtonPill)
Widget playgroundGtButtonPillUseCase(BuildContext context) {
  final text = context.knobs.string(
    label: 'Pill Text',
    initialValue: 'ACTION PILL',
  );
  final variant = context.knobs.object.dropdown<GtPillVariant>(
    label: 'Variant',
    options: GtPillVariant.values,
    initialOption: GtPillVariant.primary,
    labelBuilder: (v) => v.name,
  );
  final isNormal = context.knobs.boolean(
    label: 'Size: Normal',
    initialValue: true,
  );
  final showShadow = context.knobs.boolean(
    label: 'Show Shadow',
    initialValue: true,
  );
  final showIcon = context.knobs.boolean(
    label: 'Leading Icon',
    initialValue: false,
  );
  final showTrailing = context.knobs.boolean(
    label: 'Trailing Icon',
    initialValue: false,
  );
  final (styleName, textStyle) = context.knobs.object
      .dropdown<(String, TextStyle?)>(
        label: 'Text Style',
        initialOption: ('Default (buttonXs)', null),
        options: [
          ('Default (buttonXs)', null),
          ('button2s (Label/S)', context.textStyles.button2s()),
          ('buttonS', context.textStyles.buttonS()),
          (
            'button2s, own red colour',
            context.textStyles.button2s(color: context.palette.error.base),
          ),
        ],
        labelBuilder: (v) => v.$1,
      );
  final textColor = context.knobs.colorOrNull(
    label: 'Text Color',
    initialValue: null,
  );
  final paddingPreset = context.knobs.object.dropdown<String>(
    label: 'Padding',
    options: _paddingPresets,
    initialOption: _paddingPresets.first,
  );

  final styleSnippet = switch (styleName) {
    'button2s (Label/S)' => 'context.textStyles.button2s()',
    'buttonS' => 'context.textStyles.buttonS()',
    'button2s, own red colour' =>
      'context.textStyles.button2s(color: context.palette.error.base)',
    _ => null,
  };
  final paddingSnippet = _getPaddingSnippet(paddingPreset);

  final codeSnippet =
      '''
GtButtonPill(
  text: "$text",
  variant: GtPillVariant.${variant.name},
  size: ${isNormal ? 'GtPillSize.normal' : 'GtPillSize.larger'},
  showShadow: $showShadow,${showIcon ? '\n  icon: GtIcons.plus,' : ''}${showTrailing ? '\n  trailing: GtIcons.chevronRight,' : ''}${styleSnippet != null ? '\n  textStyle: $styleSnippet,' : ''}${textColor != null ? '\n  textColor: Color(0x${textColor.toARGB32().toRadixString(16).toUpperCase()}),' : ''}${paddingSnippet != null ? '\n  padding: $paddingSnippet,' : ''}
  onTap: () {},
)''';

  return GtWidgetDocPage(
    title: 'GtButtonPill',
    description:
        'An interactive pill with press action handling, feedback animations, and optional drop shadow. '
        'Text Style sets size and weight only — its colour is always replaced by Text Color, '
        'or by the variant colour when Text Color is unset. Padding overrides the size padding.',
    code: codeSnippet,
    child: Center(
      child: GtButtonPill(
        text: text,
        variant: variant,
        size: isNormal ? GtPillSize.normal : GtPillSize.larger,
        showShadow: showShadow,
        icon: showIcon ? GtIcons.plus : null,
        trailing: showTrailing ? GtIcons.chevronRight : null,
        textStyle: textStyle,
        textColor: textColor,
        padding: _getPadding(paddingPreset, context),
        onTap: () {},
      ),
    ),
  );
}
