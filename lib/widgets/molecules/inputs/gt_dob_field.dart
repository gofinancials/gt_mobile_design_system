import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A Date of Birth input field that provides separate autocomplete inputs
/// for day, month, and year.
///
/// [GtDobField] ensures users can only select valid dates within the bounds
/// configured in its [GtDobController].
class GtDobField extends GtStatefulWidget {
  /// The controller used to manage the date selection state.
  final GtDobController? controller;

  /// The decoration applied to the text field.
  final GtInputDecoration? decoration;

  /// The icon displayed at the trailing edge of the field.
  final Widget? suffix;

  /// Whether the field is interactive.
  final bool isEnabled;

  /// Callback fired when the complete selected date changes.
  final OnChanged<DateTime?>? onChanged;

  /// Creates a [GtDobField].
  const GtDobField({
    super.key,
    this.controller,
    this.decoration,
    this.suffix,
    this.isEnabled = true,
    this.onChanged,
  });

  @override
  State<GtDobField> createState() => _GtDobFieldState();
}

class _GtDobFieldState extends State<GtDobField> with GtBottomSheetMixin {
  /// The controller used to manage the date selection state.
  late GtDobController _dobController;

  /// The local controller managing the text input for the day field.
  late final GtInputController _dayCtrl;

  /// The local controller managing the text input for the month field.
  late final GtInputController _monthCtrl;

  /// The local controller managing the text input for the year field.
  late final GtInputController _yearCtrl;

  @override
  void initState() {
    super.initState();
    _dobController = widget.controller ?? GtDobController();
    _dayCtrl = GtInputController(text: "${_dobController.day ?? ''}");
    _monthCtrl = GtInputController(
      text: _dobController.month?.asMonthName ?? '',
    );
    _yearCtrl = GtInputController(text: "${_dobController.year ?? ''}");
  }

  @override
  void dispose() {
    if (widget.controller == null) _dobController.dispose();
    _dayCtrl.dispose();
    _monthCtrl.dispose();
    _yearCtrl.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant GtDobField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller &&
        widget.controller != null) {
      _dobController = widget.controller!;
    }
    _dayCtrl.text = _dobController.day?.toString() ?? '';
    _monthCtrl.text = _dobController.month?.asMonthName ?? '';
    _yearCtrl.text = _dobController.year?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final decoration =
        widget.decoration ?? context.inputStyles.defaultDecoration;
    return ListenableBuilder(
      listenable: _dobController,
      builder: (context, child) {
        return FormField(
          builder: (state) {
            return Column(
              spacing: context.spacingBase,
              mainAxisSize: .min,
              crossAxisAlignment: .stretch,
              children: [
                child!,
                if (state.hasError)
                  GtText(state.errorText ?? '', style: decoration.errorStyle),
              ],
            );
          },
          initialValue: _dobController.dob,
          validator: (value) {
            return AppValidators.dobValidator(
              value?.toIso8601String(),
              minAge: _dobController.minAge,
            );
          },
        );
      },
      child: Row(
        crossAxisAlignment: .center,
        spacing: context.spacingBase,
        children: [
          Expanded(
            child: GtAutocompleteField<int>.builder(
              key: const ValueKey("gt_dob_field_day"),
              label: "day".ctr(),
              builder: (query) {
                return _dobController.daySuggestions.whereList(
                  (it) => it.computedLabel.includes(query),
                );
              },
              onChange: (value) {
                _dobController.day = value?.value;
              },
              controller: _dayCtrl,
              textInputAction: .next,
              suffix: Offstage(),
            ),
          ),
          Expanded(
            flex: 2,
            child: GtAutocompleteField<int>(
              key: const ValueKey("gt_dob_field_month"),
              label: "month".ctr(),
              suggestions: _dobController.monthSuggestions,
              controller: _monthCtrl,
              onChange: (value) {
                final selectedDay = _dobController.day ?? 1;
                final monthLastDay = value?.value.monthDays.length ?? 31;
                if (selectedDay > monthLastDay) {
                  _dayCtrl.text = "";
                  _dobController.day = null;
                }
                _dobController.month = value?.value;
              },
              textInputAction: .next,
              suffix: Offstage(),
            ),
          ),
          Expanded(
            child: GtAutocompleteField<int>(
              key: const ValueKey("gt_dob_field_year"),
              label: "year".ctr(),
              suggestions: _dobController.yearSuggestions,
              controller: _yearCtrl,
              onChange: (value) {
                _dobController.year = value?.value;
              },
              textInputAction: .next,
              suffix: Offstage(),
            ),
          ),
        ],
      ),
    );
  }
}
