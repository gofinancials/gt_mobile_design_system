import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final formKey = GlobalKey<FormState>();

@widgetbook.UseCase(name: 'GtPinInput', type: GtPinInput)
Widget buildGtPinInputUsecase(BuildContext context) {
  return Scaffold(
    appBar: GtTitleAppBar(title: "GtPinInput Showcase"),
    body: GtForm(
      formKey: formKey,
      child: SingleChildScrollView(
        padding: context.insets.defaultAllInsets,
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            ...GtGap.ySection4xl() * 2,
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
              onPressed: () => context.validateForm(formKey),
              text: "Simulate Error",
              alignment: .center,
              size: .medium,
            ),
          ],
        ),
      ),
    ),
  );
}
