import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtAddressCard', type: GtAddressCard)
Widget playgroundGtAddressCardUseCase(BuildContext context) {
  final line1 = context.knobs.string(
    label: 'Address Line 1',
    initialValue: '210 Sanusi Street',
  );
  final line2 = context.knobs.string(
    label: 'Address Line 2',
    initialValue: 'Surulere, Lagos Nigeria 234768',
  );
  final variant = context.knobs.object.dropdown<GtCardVariant>(
    label: 'Variant',
    options: GtCardVariant.values,
    initialOption: GtCardVariant.normal,
    labelBuilder: (v) => v.name,
  );
  final borderStyle = context.knobs.object.dropdown<BorderStyle>(
    label: 'Border Style',
    options: BorderStyle.values,
    initialOption: BorderStyle.solid,
    labelBuilder: (v) => v.name,
  );

  return GtWidgetDocPage(
    title: 'GtAddressCard',
    description:
        'A structured card specifically styled for displaying addresses and verification borders.',
    code:
        '''
GtAddressCard(
  line1: "$line1",
  line2: "$line2",
  variant: GtCardVariant.${variant.name},
  borderStyle: BorderStyle.${borderStyle.name},
)''',
    child: GtAddressCard(
      line1: line1,
      line2: line2,
      variant: variant,
      borderStyle: borderStyle,
    ),
  );
}
