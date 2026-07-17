import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtCountryField', type: GtCountryField)
Widget playgroundGtCountryFieldUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtCountryField',
    description: 'Documentation for GtCountryField',
    code: '''
GtCountryField(
  controller: GtDropdownInputController<Country>(),
  label: "Country",
)
''',
    child: GtCountryField(
      controller: GtDropdownInputController(),
      label: "Country",
    ),
  );
}
