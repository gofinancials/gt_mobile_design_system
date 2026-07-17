import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtBackButton', type: GtBackButton)
Widget playgroundGtBackButtonUseCase(BuildContext context) {
  final sensitive = context.knobs.boolean(
    label: 'Route Stack Sensitive',
    initialValue: false,
  );
  return GtWidgetDocPage(
    title: 'GtBackButton',
    description: 'Documentation for GtBackButton',
    code:
        '''
/// Default
const GtBackButton()

/// with routeStackSensitive = $sensitive
GtBackButton(routeStackSensitive: $sensitive)
''',
    child: GtBackButton(routeStackSensitive: sensitive),
  );
}
