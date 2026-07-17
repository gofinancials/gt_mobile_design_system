import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtInstructionCard', type: GtInstructionCard)
Widget playgroundGtInstructionCardUseCase(BuildContext context) {
  final title = context.knobs.string(label: 'Title', initialValue: 'Take picture of front of ID');
  final description = context.knobs.string(label: 'Description', initialValue: 'JPEG, JPG and PNG formats, up to 10 MB.');
  final isFilled = context.knobs.boolean(label: 'Is Filled Style', initialValue: false);
  final variant = context.knobs.object.dropdown<GtCardVariant>(
    label: 'Variant',
    options: GtCardVariant.values,
    initialOption: GtCardVariant.normal,
    labelBuilder: (v) => v.name,
  );

  return GtWidgetDocPage(
    title: 'GtInstructionCard',
    description: 'An interactive onboarding instruction card prompting users to upload files or documents.',
    code: '''
GtInstructionCard(
  title: "$title",
  description: "$description",
  icon: GtIcon(GtIcons.camera, size: 24),
  variant: GtCardVariant.${variant.name},
  isFilled: $isFilled,
  onPressed: () {},
)''',
    child: GtInstructionCard(
      title: title,
      description: description,
      icon: GtIcon(GtIcons.camera, size: 24),
      variant: variant,
      isFilled: isFilled,
      onPressed: () {},
    ),
  );
}
