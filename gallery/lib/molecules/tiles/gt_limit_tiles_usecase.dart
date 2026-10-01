import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtLimitInfoListTile', type: GtLimitInfoListTile)
Widget playgroundGtLimitInfoListTileUseCase(BuildContext context) {
  final label = context.knobs.string(
    label: 'Limit Label',
    initialValue: 'Daily Transfer Limit',
  );
  final value = context.knobs.string(
    label: 'Limit Value',
    initialValue: '₦ 5,000,000.00',
  );

  return GtWidgetDocPage(
    title: 'GtLimitInfoListTile',
    description:
        'A list tile used to display information about a specific limit, showing a label and value.',
    code:
        '''
GtLimitInfoListTile(
  "$label",
  value: "$value",
  leading: GtIcons.gauge,
)''',
    child: Center(
      child: GtCard(
        padding: context.insets.allDp(16.px),
        variant: GtCardVariant.normal,
        child: GtLimitInfoListTile(label, value: value, leading: GtIcons.gauge),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'GtLimitEditListTile', type: GtLimitEditListTile)
Widget playgroundGtLimitEditListTileUseCase(BuildContext context) {
  final category = context.knobs.string(
    label: 'Category',
    initialValue: 'Intra-Bank Transfer',
  );
  final value = context.knobs.double.slider(
    label: 'Utilized Value',
    initialValue: 200000.0,
    min: 0.0,
    max: 1000000.0,
  );
  final max = context.knobs.double.slider(
    label: 'Max Value',
    initialValue: 1000000.0,
    min: 100000.0,
    max: 2000000.0,
  );

  return GtWidgetDocPage(
    title: 'GtLimitEditListTile',
    description:
        'A list tile for displaying and editing a limit, featuring a visual progress bar.',
    code:
        '''
GtLimitEditListTile(
  "$category",
  value: $value,
  max: $max,
  onEdit: () {},
  onTapInfo: () {},
)''',
    child: Center(
      child: GtCard(
        padding: context.insets.allDp(16.px),
        variant: GtCardVariant.normal,
        child: GtLimitEditListTile(
          category,
          value: value,
          max: max,
          onEdit: () {},
          onTapInfo: () {},
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'GtGoalProgressListTile',
  type: GtGoalProgressListTile,
)
Widget playgroundGtGoalProgressListTileUseCase(BuildContext context) {
  final goalAmount = context.knobs.double.slider(
    label: 'Goal Amount',
    initialValue: 500000.0,
    min: 10000.0,
    max: 2000000.0,
  );
  final currentAmount = context.knobs.double.slider(
    label: 'Current Amount',
    initialValue: 200000.0,
    min: 0.0,
    max: goalAmount,
  );
  final editText = context.knobs.string(
    label: 'Edit Text',
    initialValue: 'edit',
  );
  final showEdit = context.knobs.boolean(
    label: 'Show Edit',
    initialValue: true,
  );
  final buttonVariant = context.knobs.object.dropdown<GtButtonVariant>(
    label: 'Button Variant',
    options: GtButtonVariant.values,
    initialOption: GtButtonVariant.primary,
    labelBuilder: (v) => v.name,
  );
  final asCard = context.knobs.boolean(label: 'As Card', initialValue: true);

  return GtWidgetDocPage(
    title: 'GtGoalProgressListTile',
    description:
        'A list tile showing progress towards a savings goal, with an optional edit action whose button variant can be changed.',
    code:
        '''
GtGoalProgressListTile(
  currentAmount: $currentAmount,
  goalAmount: $goalAmount,
  editText: "$editText",
  onEdit: ${showEdit ? '() {}' : 'null'},
  buttonVariant: GtButtonVariant.${buttonVariant.name},
  asCard: $asCard,
)''',
    child: GtGoalProgressListTile(
      currentAmount: currentAmount,
      goalAmount: goalAmount,
      editText: editText,
      onEdit: showEdit ? () {} : null,
      buttonVariant: buttonVariant,
      asCard: asCard,
    ),
  );
}
