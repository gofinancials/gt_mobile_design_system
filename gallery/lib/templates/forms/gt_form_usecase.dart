import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final _emailCtrl2 = GtInputController();
final _passCtrl2 = GtInputController();
final _formKey = GlobalKey<FormState>();

@widgetbook.UseCase(
  name: 'Interactive Preview',
  type: GtForm,
)
Widget playgroundGtFormUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtForm',
    description: 'Form wrapper with validation. Fill fields and tap Validate to see error states.',
    child: GtForm(
      formKey: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GtEmailField(controller: _emailCtrl2, label: 'Email'),
          const GtGap.yLg(),
          GtPasswordField(controller: _passCtrl2, label: 'Password'),
          const GtGap.ySectionMd(),
          GtRaisedButton(
            text: 'VALIDATE',
            onPressed: () => context.validateForm(_formKey),
            size: GtButtonSize.large,
            alignment: Alignment.center,
          ),
          const GtGap.yMd(),
          GtText(
            'Uses AppValidators.required on both fields.',
            style: context.textStyles.bodyS(
              color: context.palette.text.sub,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
