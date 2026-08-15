import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtProductCard', type: GtProductCard)
Widget playgroundGtProductCardUseCase(BuildContext context) {
  final name = context.knobs.string(
    label: 'Product Name',
    initialValue: 'Premium',
  );
  final description = context.knobs.string(
    label: 'Description',
    initialValue: 'Try a premium account for more benefits',
  );
  final variant = context.knobs.object.dropdown<GtCardVariant>(
    label: 'Variant',
    options: GtCardVariant.values,
    initialOption: GtCardVariant.featured,
    labelBuilder: (v) => v.name,
  );

  return GtWidgetDocPage(
    title: 'GtProductCard',
    description:
        'A grid/list product option card detailing financial features.',
    code:
        '''
GtProductCard(
  name: "$name",
  icon: GtIcons.gemSparkle,
  variant: GtCardVariant.${variant.name},
  ${description.isNotEmpty ? 'description: "$description",' : ''}
)''',
    child: GtProductCard(
      name: name,
      icon: GtIcons.gemSparkle,
      variant: variant,
      description: description.isEmpty ? null : description,
    ),
  );
}
