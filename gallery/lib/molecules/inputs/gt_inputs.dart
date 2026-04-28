import 'dart:math';

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
          GenericListener(
            valueListenable: _calendarCtrl,
            builder: (data) {
              final day =
                  data.day?.format("EEE, dd MMM yyyy") ?? "No day selected";
              final range = data.range;
              final start =
                  range?.start.format("dd MMM yyyy") ?? "No start selected";
              final end = range?.end.format("dd MMM yyyy") ?? "No endselected";

              return GtText(
                "Selected day is: $day, selected range is $start - $end",
                textAlign: .center,
              );
            },
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

final _inputCtrl = GtInputController();
final _inputCtrl2 = GtInputController();
final _inputCtrl3 = GtInputController();
final _inputCtrl4 = GtInputController();
final _inputCtrl5 = GtInputController();
final _inputCtrl6 = GtInputController();
final _inputCtrl7 = GtInputController();
final _inputCtrl8 = GtInputController();
final _formKey2 = GlobalKey<FormState>();

@widgetbook.UseCase(name: 'GtTextField', type: GtTextField)
Widget buildGtTextFieldUsecase(BuildContext context) {
  final prefix = context.knobs.object.dropdown<(String, Widget?)>(
    label: "Prefix Icon",
    options: [
      ("None", null),
      ("Search", GtIcon(GtIcons.magnifier, variant: .soft)),
    ],
    labelBuilder: (value) => value.$1,
  );
  final suffix = context.knobs.object.dropdown<(String, Widget?)>(
    label: "Suffix Icon",
    options: [
      ("None", null),
      ("Keyboard", GtIcon(GtIcons.keyboard, variant: .sub)),
    ],
    labelBuilder: (value) => value.$1,
  );
  final textAlign = context.knobs.object.dropdown<TextAlign>(
    label: "Text Alignment",
    options: TextAlign.values,
    labelBuilder: (value) => value.name,
  );
  final decoration = context.knobs.object.dropdown<(String, GtInputDecoration)>(
    label: "Input Style",
    options: context.inputStyles.all,
    initialOption: context.inputStyles.all[1],
    labelBuilder: (value) => value.$1,
  );
  final helperText = context.knobs.stringOrNull(label: "Helper Text");

  final isSearch = decoration.$1.includes("Search");
  final isWhite = decoration.$1.includes("white");

  return GtForm(
    formKey: _formKey2,
    child: Scaffold(
      appBar: GtTitleAppBar(title: "GtTextField Showcase"),
      backgroundColor: isWhite ? context.palette.bg.weak : null,
      body: SingleChildScrollView(
        padding: context.insets.defaultAllInsets,
        child: Column(
          crossAxisAlignment: .stretch,
          mainAxisSize: .min,
          children: [
            ...GtGap.ySection4xl() * 2,
            GenericListener(
              valueListenable: _inputCtrl.controller,
              builder: (data) {
                return GtText(
                  "Provided text is: ${data.text}",
                  textAlign: .center,
                );
              },
            ),
            const GtGap.yLg(),
            GtTextField(
              controller: _inputCtrl,
              label: isSearch ? null : "Enter text here",
              hintText: !isSearch ? null : "Enter multiline text here",
              key: PageStorageKey("gt-input"),
              prefix: prefix.$2,
              suffix: suffix.$2,
              textAlign: textAlign,
              decoration: decoration.$2,
              validator: (_) => "Field is invalid",
              helperText: helperText,
            ),
            const GtGap.yXl(),
            GtTextField.multiline(
              controller: _inputCtrl2,
              label: isSearch ? null : "Enter multiline text here",
              hintText: !isSearch ? null : "Enter multiline text here",
              key: PageStorageKey("gt-multiline-input"),
              prefix: prefix.$2,
              suffix: suffix.$2,
              textAlign: textAlign,
              decoration: decoration.$2,
              validator: (_) => "Field is invalid",
              helperText: helperText,
            ),
            const GtGap.yXl(),
            GtEmailField(
              controller: _inputCtrl3,
              label: "Enter email here",
              decoration: decoration.$2,
            ),
            const GtGap.yXl(),
            GtPasswordField(
              controller: _inputCtrl4,
              label: isSearch ? null : "Enter password here",
              decoration: decoration.$2,
            ),
            const GtGap.yXl(),
            GtAmountField(
              controller: _inputCtrl5,
              label: "Enter ammount here",
              decoration: decoration.$2,
            ),
            const GtGap.yXl(),
            GtSearchField(
              controller: _inputCtrl6,
              hintText: "Search here",
              prefix: GtIcon(GtIcons.magnifier, variant: .soft),
              decoration: decoration.$2,
            ),
            const GtGap.yXl(),
            GtUrlField(
              controller: _inputCtrl7,
              label: "Enter URL here",
              decoration: decoration.$2,
            ),
            const GtGap.yXl(),
            GtTimeField(
              controller: _inputCtrl8,
              decoration: decoration.$2,
            ),
            const GtGap.ySectionSm(),
            GtRaisedButton(
              onPressed: () {
                context.validateForm(_formKey2);
              },
              text: "Simulate error",
            ),
          ],
        ),
      ),
    ),
  );
}
