import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtAddressCard', type: GtAddressCard)
Widget playgroundGtAddressCardUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtAddressCard',
    description: 'Documentation for GtAddressCard',
    code: '''
GtAddressCard(
  line1: "123 Main Street",
  line2: "Lagos, Nigeria",
)
''',
    child: const GtAddressCard(
      line1: "123 Main Street",
      line2: "Lagos, Nigeria",
    ),
  );
}
