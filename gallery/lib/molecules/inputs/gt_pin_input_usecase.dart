import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final _formKey = GlobalKey<FormState>();

@widgetbook.UseCase(name: 'GtPinInput code', type: GtPinInput)
Widget playgroundGtPinInputUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtPinInput',
    description: 'Documentation for GtPinInput',
    code: '''
GtPinInput(
  controller: TextEditingController(),
  onFieldSubmitted: (value) {
   // handle submission 
  }
  length: 4,
  alignment: .center,
  size: .medium,
)
''',
    child: GtForm(
      formKey: _formKey,
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          GtText(
            "Pin Input Example",
            style: context.textStyles.bodyS(),
            textAlign: .center,
          ),
          const GtGap.yLg(),
          GtPinInput(
            onFieldSubmitted: (value) {
              context.showToast("Completed input with vale $value");
            },
            validator: (value) => "Pin Is Invalid",
          ),
          const GtGap.ySectionSm(),
          GtRaisedButton(
            onPressed: () => context.validateForm(_formKey),
            text: "Simulate Error",
            alignment: .center,
            size: .medium,
          ),
        ],
      ),
    ),
  );
}
