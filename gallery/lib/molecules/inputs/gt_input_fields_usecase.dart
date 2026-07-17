import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final _emailCtrl = GtInputController();
final _passCtrl = GtInputController();
final _phoneCtrl = GtInputController<Country>();
final _amountCtrl = GtInputController();
final _dateCtrl = GtCalendarController(GtCalendarValue());
final _dateRangeCtrl = GtCalendarController(GtCalendarValue());
final _searchCtrl2 = GtInputController();
final _inputFormKey = GlobalKey<FormState>();

@widgetbook.UseCase(
  name: 'Input Fields',
  type: GtTextField,
)
Widget playgroundInputFieldsUseCase(BuildContext context) {
  final decoration = context.knobs.object.dropdown<(String, GtInputDecoration)>(
    label: 'Input Style',
    options: context.inputStyles.all,
    initialOption: context.inputStyles.all[1],
    labelBuilder: (v) => v.$1,
  );

  return Scaffold(
    body: SafeArea(
      child: GtForm(
        formKey: _inputFormKey,
        child: SingleChildScrollView(
          padding: context.insets.allDp(24.px),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GtText('Input Fields', style: context.textStyles.d2()),
              const GtGap.ySm(),
              GtText(
                'All form input variants with live interaction.',
                style: context.textStyles.bodyM(
                  color: context.palette.text.sub,
                ),
              ),
              const GtGap.ySectionMd(),
              _InputSection(title: 'GtEmailField', child: GtEmailField(
                controller: _emailCtrl,
                label: 'Email address',
                decoration: decoration.$2,
              )),
              _InputSection(title: 'GtPasswordField', child: GtPasswordField(
                controller: _passCtrl,
                label: 'Password',
                decoration: decoration.$2,
              )),
              _InputSection(title: 'GtPhoneField', child: GtPhoneField(
                controller: _phoneCtrl,
                label: 'Phone number',
              )),
              _InputSection(title: 'GtAmountField', child: GtAmountField(
                controller: _amountCtrl,
                label: 'Amount',
                decoration: decoration.$2,
              )),
              _InputSection(title: 'GtDateField', child: GtDateField(
                controller: _dateCtrl,
                label: 'Select date',
                decoration: decoration.$2,
              )),
              _InputSection(title: 'GtDateField.range', child: GtDateField.range(
                controller: _dateRangeCtrl,
                label: 'Select date range',
                decoration: decoration.$2,
              )),
              _InputSection(title: 'GtSearchField', child: GtSearchField(
                controller: _searchCtrl2,
                hintText: 'Search...',
                decoration: context.inputStyles.searchDecoration,
                autoFocus: false,
              )),
              const GtGap.ySectionMd(),
              GtRaisedButton(
                text: 'VALIDATE ALL',
                onPressed: () => context.validateForm(_inputFormKey),
                size: GtButtonSize.large,
                alignment: Alignment.center,
              ),
              const GtGap.ySectionXl(),
            ],
          ),
        ),
      ),
    ),
  );
}

class _InputSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _InputSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.insets.onlyDp(bottom: 24.px),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GtText(
            title,
            style: context.textStyles.subHeadS(
              color: context.palette.text.sub,
            ),
          ),
          const GtGap.ySm(),
          child,
        ],
      ),
    );
  }
}
