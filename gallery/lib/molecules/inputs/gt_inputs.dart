import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gallery/widgets/gt_widget_doc_page.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final _inputCtrl = GtInputController();
final _inputCtrl2 = GtInputController();
final _inputCtrl3 = GtInputController();
final _inputCtrl4 = GtInputController();
final _inputCtrl5 = GtInputController();
final _inputCtrl6 = GtInputController();
final _inputCtrl7 = GtInputController();
final _inputCtrl8 = GtInputController();
final _inputCtrl9 = GtInputController();
final _inputCtrl10 = GtCalendarController(GtCalendarValue());
final _inputCtrl11 = GtCalendarController(GtCalendarValue());
final _inputCtrl12 = GtInputController();
final _inputCtrl13 = GtDobController();
final _inputCtrl14 = GtDropdownInputController<Country>();
final _inputCtrl15 = GtInputController<Country>();
final _inputCtrl16 = GtInputController<Country>();
final _formKey2 = GlobalKey<FormState>();

FutureOr<List<GtDropdownData<Country>>> get _allCountries async {
  final countries = await AppCountryUtility.fetchCountries();
  return countries.mapList(
    (it) => GtDropdownData(
      value: it,
      label: it.displayName,
      filterDelegate: (query) {
        if (!query.hasValue) return true;
        final hasPhoneCode = it.countryCode.includes(query);
        final hasCountryName = it.displayName.includes(query);

        return hasPhoneCode || hasCountryName;
      },
    ),
  );
}

final allCountries = _allCountries;

@widgetbook.UseCase(name: 'GtFormExample', type: GtForm)
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

  return GtForm(
    formKey: _formKey2,
    child: Scaffold(
      body: SafeArea(
        child: GtWidgetDocPage(
          title: "GtForm Example",
          child: Column(
            crossAxisAlignment: .stretch,
            mainAxisSize: .min,
            children: [
              GtTextField(
                controller: _inputCtrl,
                label: isSearch ? null : "Enter text here",
                hintText: !isSearch ? null : "Enter multiline text here",
                key: PageStorageKey("gt-input"),
                prefix: prefix.$2,
                suffix: suffix.$2,
                textAlign: textAlign,
                decoration: decoration.$2,
                validator: AppValidators.required,
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
                validator: AppValidators.required,
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
                label: "Enter password here",
                decoration: decoration.$2,
              ),
              const GtGap.yXl(),
              GtAmountField(
                controller: _inputCtrl5,
                label: "Enter amount here",
                decoration: decoration.$2,
              ),
              const GtGap.yXl(),
              GtSearchField(
                controller: _inputCtrl6,
                hintText: "Search here",
                prefix: GtIcon(GtIcons.magnifier, variant: .soft),
                decoration: decoration.$2,
                autoFocus: false,
              ),
              const GtGap.yXl(),
              GtUrlField(
                controller: _inputCtrl7,
                label: "Enter URL here",
                decoration: decoration.$2,
              ),
              const GtGap.yXl(),
              GtTransferField(
                amountController: _inputCtrl8,
                noteController: _inputCtrl9,
                firstParticipant: GtTransferParticipantData(
                  label: "from",
                  image: AppImageData(GtNetworkImages.savings),
                  validate: true,
                  name: "FLEX",
                  balance: 2000,
                  imageType: .image,
                  data: "1234567890",
                ),
                secondParticipant: GtTransferParticipantData(
                  label: "to",
                  image: AppImageData(GtNetworkImages.sampleAvatar1),
                  validate: false,
                  name: "Alex Lobaloba",
                  tag: AppImageData(GtVectors.logo),
                  imageType: .avatar,
                  data: "1234567890",
                ),
                noteHint: "Add a note (optional)",
              ),
              const GtGap.yXl(),
              GtTransferField(
                amountController: _inputCtrl8,
                noteController: _inputCtrl9,
                participantSeparator: GtSvg(GtVectors.moveMoney),
                min: 400,
                max: 1000,
                firstParticipant: GtTransferParticipantData(
                  label: "from",
                  image: AppImageData(GtNetworkImages.savings),
                  validate: true,
                  name: "FLEX",
                  balance: 2000,
                  imageType: .image,
                  data: "1234567890",
                ),
                secondParticipant: GtTransferParticipantData.empty(label: "to"),
                noteHint: "Add a note (optional)",
              ),
              const GtGap.yXl(),
              GtDateField(
                controller: _inputCtrl10,
                calendarTitle: "Select your birthday",
                decoration: decoration.$2,
              ),
              const GtGap.yXl(),
              GtDateField.range(
                controller: _inputCtrl11,
                calendarTitle: "Select your vacation dates",
                decoration: decoration.$2,
              ),
              const GtGap.yXl(),
              GtAutocompleteField.builder(
                controller: _inputCtrl12,
                hintText: "Search for a country",
                decoration: decoration.$2,
                validator: AppValidators.required,
                textInputAction: TextInputAction.done,
                builder: (query) async {
                  final countries = await AppCountryUtility.searchCountries(
                    query,
                  );
                  return countries.mapList(
                    (it) => GtAutocompleteItem(value: it.displayName),
                  );
                },
              ),
              const GtGap.yXl(),
              GtDobField(controller: _inputCtrl13, decoration: decoration.$2),
              const GtGap.yXl(),
              GtCountryField(
                controller: _inputCtrl14,
                decoration: decoration.$2,
                validator: AppValidators.required,
                sheetTitle: "Select Country",
                label: "Select a country [Default tiles with Title]",
              ),
              const GtGap.yXl(),
              GtDropdownField<Country>(
                controller: _inputCtrl14,
                decoration: decoration.$2,
                options: allCountries,
                label: "Select a country [Custom tiles]",
                validator: AppValidators.required,
                optionBuilder: (value, value2) {
                  return GtCountrySelectionListTile(
                    value.value,
                    isSelected: value == value2.selection,
                    onSelect: (val) {
                      value2.selection = value;
                      context.maybePop();
                    },
                    showCountryCode: true,
                  );
                },
              ),
              const GtGap.yXl(),
              GtDropdownField<Country>(
                controller: _inputCtrl14,
                decoration: decoration.$2,
                options: allCountries,
                label: "Select a country [Custom list]",
                validator: AppValidators.required,
                optionsBuilder: (options, controller, scrollContoller) {
                  return ListView.separated(
                    padding: context.insets.allDp(16.px),
                    controller: scrollContoller,
                    itemCount: options.length,
                    separatorBuilder: (context, index) => const GtGap.yLg(),
                    itemBuilder: (context, index) {
                      final value = options[index];
                      final isSelected = value == controller.selection;

                      return GtCountrySelectionListTile(
                        value.value,
                        isSelected: isSelected,
                        onSelect: (val) {
                          controller.selection = value;
                          context.maybePop();
                        },
                        showCountryCode: true,
                      );
                    },
                  );
                },
              ),
              const GtGap.yXl(),
              GtPhoneField(controller: _inputCtrl15, label: "Phone number"),
              const GtGap.yXl(),
              GtPhoneField(
                controller: _inputCtrl16,
                label: "Phone number without country code",
                showCountryCode: false,
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
    ),
  );
}
