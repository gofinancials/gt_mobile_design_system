import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtInstructionCard', type: GtInstructionCard)
Widget playgroundGtInstructionCardUseCase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Take picture of front of ID',
  );
  final description = context.knobs.string(
    label: 'Description',
    initialValue: 'JPEG, JPG and PNG formats, up to 10 MB.',
  );
  final isFilled = context.knobs.boolean(
    label: 'Is Filled Style',
    initialValue: false,
  );
  final variant = context.knobs.object.dropdown<GtCardVariant>(
    label: 'Variant',
    options: GtCardVariant.values,
    initialOption: GtCardVariant.normal,
    labelBuilder: (v) => v.name,
  );

  final custom = context.knobs.boolean(
    label: 'Custom styling',
    initialValue: false,
  );

  return GtWidgetDocPage(
    title: 'GtInstructionCard',
    description:
        'An interactive onboarding instruction card prompting users to upload files or documents.',
    code:
        '''
GtInstructionCard(
  // Set custom to false (or omit these inputs) for the original defaults.
  backgroundColor: $custom ? context.palette.primary.alpha16 : null,
  titleStyle: $custom ? context.textStyles.subHeadM() : null,
  titleColor: $custom ? context.palette.primary.dark : null,
  padding: $custom ? context.insets.allDp(24.px) : null,
  verticalSpacing: $custom ? 0 : null,
  borderColor: $custom ? context.palette.primary.base : null,
  descriptionStyle: $custom ? context.textStyles.bodyS() : null,
  title: "$title",
  description: "$description",
  icon: GtIcon(GtIcons.camera, size: 24),
  variant: GtCardVariant.${variant.name},
  isFilled: $isFilled,
  onPressed: () {},
)''',
    child: GtInstructionCard(
      backgroundColor: custom ? context.palette.primary.alpha16 : null,
      titleStyle: custom ? context.textStyles.subHeadM() : null,
      titleColor: custom ? context.palette.primary.dark : null,
      padding: custom ? context.insets.allDp(24.px) : null,
      verticalSpacing: custom ? 0 : null,
      borderColor: custom ? context.palette.primary.base : null,
      descriptionStyle: custom ? context.textStyles.bodyS() : null,

      title: title,
      description: description,
      icon: GtIcon(GtIcons.camera, size: 24),
      variant: variant,
      isFilled: isFilled,
      onPressed: () {},
    ),
  );
}
