import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtEmptyStateCard', type: GtEmptyStateCard)
Widget playgroundGtEmptyStateCardUseCase(BuildContext context) {
  final description = context.knobs.string(
    label: 'Description',
    initialValue: 'You currently do not have any team member here',
  );
  final variant = context.knobs.object.dropdown<GtCardVariant>(
    label: 'Variant',
    options: GtCardVariant.values,
    initialOption: GtCardVariant.normal,
    labelBuilder: (v) => v.name,
  );

  return GtWidgetDocPage(
    title: 'GtEmptyStateCard',
    description: 'A static card displaying empty state placeholder messages and status icons.',
    code: '''
GtEmptyStateCard(
  icon: GtIcons.userSearch,
  description: "$description",
  variant: GtCardVariant.${variant.name},
)''',
    child: GtEmptyStateCard(
      icon: GtIcons.userSearch,
      description: description,
      variant: variant,
    ),
  );
}

@widgetbook.UseCase(name: 'GtActionableEmptyStateCard', type: GtActionableEmptyStateCard)
Widget playgroundGtActionableEmptyStateCardUseCase(BuildContext context) {
  final title = context.knobs.string(label: 'Title', initialValue: 'No transfers yet');
  final description = context.knobs.string(
    label: 'Description',
    initialValue: 'Your bulk transfers will appear after you create one',
  );
  final buttontext = context.knobs.string(label: 'Button Text', initialValue: 'NEW bulk transfer');
  final variant = context.knobs.object.dropdown<GtCardVariant>(
    label: 'Variant',
    options: GtCardVariant.values,
    initialOption: GtCardVariant.normal,
    labelBuilder: (v) => v.name,
  );

  return GtWidgetDocPage(
    title: 'GtActionableEmptyStateCard',
    description: 'An empty state card featuring a main button action to prompt workflow initiation.',
    code: '''
GtActionableEmptyStateCard(
  icon: GtIcons.fileContent,
  title: "$title",
  description: "$description",
  buttontext: "$buttontext",
  variant: GtCardVariant.${variant.name},
  onPressed: () {},
)''',
    child: GtActionableEmptyStateCard(
      icon: GtIcons.fileContent,
      title: title,
      description: description,
      buttontext: buttontext,
      variant: variant,
      onPressed: () {},
    ),
  );
}
