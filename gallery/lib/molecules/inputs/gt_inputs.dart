import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final _formKey = GlobalKey<FormState>();

@widgetbook.UseCase(name: 'GtPinInput', type: GtPinInput)
Widget buildGtPinInputUsecase(BuildContext context) {
  return Scaffold(
    appBar: GtTitleAppBar(title: "GtPinInput Showcase"),
    body: GtForm(
      formKey: _formKey,
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
              onPressed: () => context.validateForm(_formKey),
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

final _calendarCtrl = GtCalendarController(GtCalendarValue());

@widgetbook.UseCase(name: 'GtCalendar', type: GtCalendar)
Widget buildGtCalendarUsecase(BuildContext context) {
  return Scaffold(
    appBar: GtTitleAppBar(title: "GtCalendar Showcase"),
    body: Padding(
      padding: context.insets.defaultAllInsets,
      child: Column(
        crossAxisAlignment: .stretch,
        mainAxisSize: .min,
        children: [
          ...GtGap.ySection4xl() * 2,
          GtText(
            "CtCalendar Widget",
            style: context.textStyles.bodyS(),
            textAlign: .center,
          ),
          const GtGap.yLg(),
          GtCalendar(
            controller: _calendarCtrl,
            key: PageStorageKey("gt-calendar"),
            selectionMode: context.knobs.object.dropdown(
              label: "Selection Mode",
              options: GtCalendarSelectionMode.values,
              initialOption: GtCalendarSelectionMode.day,
              labelBuilder: (value) => value.name.capitalise(),
            ),
          ),
        ],
      ),
    ),
  );
}
