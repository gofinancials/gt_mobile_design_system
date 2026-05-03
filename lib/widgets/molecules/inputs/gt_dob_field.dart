import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A controller for managing the state of a [GtDobField].
///
/// This controller handles date selection logic, age calculations, and bounds
/// constraints for a date of birth input.
class GtDobController extends ChangeNotifier {
  /// The maximum allowed age for the date of birth.
  final int maxAge;

  /// The minimum allowed age for the date of birth.
  final int minAge;

  int? _year;
  int? _month;
  int? _day;

  /// Gets the currently selected Date of Birth, or null if the date is incomplete.
  DateTime? get dob {
    if (year == null || month == null || day == null) return null;
    return DateTime(year!, month!, day!);
  }

  /// Calculates the current age based on the selected [dob].
  ///
  /// Returns 0 if the date of birth is incomplete.
  int get age {
    if (dob == null) return 0;
    return DateTime.now().year - dob!.year;
  }

  DateTime get _now => DateTime.now();

  /// The most recent allowed date based on [minAge].
  DateTime get minDate => _now.subtract(365.days * minAge);

  /// The oldest allowed date based on [maxAge].
  DateTime get maxDate => _now.subtract(365.days * maxAge);

  /// Returns whether the currently selected date is complete and within the
  /// allowed age bounds ([maxAge] and [minAge]).
  bool get hasValidDate {
    if (dob == null) return false;
    return dob! >= maxDate && dob! <= minDate;
  }

  /// The currently selected year.
  int? get year => _year;

  /// The currently selected month (1-12).
  int? get month => _month;

  /// The currently selected day (1-31).
  int? get day => _day;

  /// Generates a list of valid year suggestions based on age constraints.
  List<GtAutocompleteItem<int>> get yearSuggestions {
    final gap = maxDate.difference(minDate).inYears;
    return List.generate(
      gap.abs(),
      (it) => GtAutocompleteItem(value: (minDate.year - it)),
    );
  }

  /// Generates a list of valid day suggestions for the selected [month].
  List<GtAutocompleteItem<int>> get daySuggestions {
    return [
      for (final day in (month?.monthDays ?? 1.monthDays))
        GtAutocompleteItem(
          value: day,
          labelBuilder: (it) {
            if (it >= 10) return "$it";
            return "0$it";
          },
        ),
    ];
  }

  /// Generates a list of valid month suggestions.
  List<GtAutocompleteItem<int>> get monthSuggestions => List.generate(
    12,
    (index) => GtAutocompleteItem(
      value: (index + 1),
      labelBuilder: (it) => it.asMonthName,
    ),
  );

  /// Sets the selected year.
  set year(int? year) {
    _year = year;
    notifyListeners();
  }

  /// Sets the selected month. Revalidates the selected day based on the new month.
  set month(int month) {
    _month = month;
    if (month.monthDays.length < daySuggestions.length) {
      day = null;
    }
    notifyListeners();
  }

  /// Sets the selected day.
  set day(int? day) {
    _day = day;
    notifyListeners();
  }

  /// Creates a [GtDobController] with age constraints and an optional initial date.
  GtDobController({this.maxAge = 200, this.minAge = 0, DateTime? dob})
    : _year = dob?.year,
      _month = dob?.month,
      _day = dob?.day,
      assert(minAge < maxAge);

  /// Clears the currently selected date.
  void reset() {
    _year = null;
    _month = null;
    _day = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _year = null;
    _month = null;
    _day = null;
    super.dispose();
  }
}

/// A Date of Birth input field that provides separate autocomplete inputs
/// for day, month, and year.
///
/// [GtDobField] ensures users can only select valid dates within the bounds
/// configured in its [GtDobController].
class GtDobField extends GtStatefulWidget {
  /// The controller used to manage the date selection state.
  final GtDobController? controller;

  /// Optional validator for the complete date of birth.
  final OnValidate<DateTime?>? validator;

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
    this.validator,
    this.decoration,
    this.suffix,
    this.isEnabled = true,
    this.onChanged,
  });

  @override
  State<GtDobField> createState() => _GtDobFieldState();
}

class _GtDobFieldState extends State<GtDobField> with GtBottomSheetMixin {
  late GtDobController _dobController;
  late final GtInputController _dayCtrl;
  late final GtInputController _monthCtrl;
  late final GtInputController _yearCtrl;

  @override
  void initState() {
    super.initState();
    _dobController = widget.controller ?? GtDobController();
    _dayCtrl = GtInputController(
      GtInputValue(
        controller: TextEditingController(text: _dobController.day?.toString()),
        focusNode: FocusNode(),
      ),
    );
    _monthCtrl = GtInputController(
      GtInputValue(
        controller: TextEditingController(
          text: _dobController.month?.toString(),
        ),
        focusNode: FocusNode(),
      ),
    );
    _yearCtrl = GtInputController(
      GtInputValue(
        controller: TextEditingController(
          text: _dobController.year?.toString(),
        ),
        focusNode: FocusNode(),
      ),
    );
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
    _monthCtrl.text = _dobController.month?.toString() ?? '';
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
          validator: widget.validator,
        );
      },
      child: Row(
        crossAxisAlignment: .center,
        spacing: context.spacingBase,
        children: [
          Expanded(
            child: GtAutocompleteField<int>.builder(
              key: const ValueKey("gt_dob_field_day"),
              hintText: "day".ctr(),
              builder: (query) {
                return _dobController.daySuggestions.whereList(
                  (it) => it.computedLabel.includes(query),
                );
              },
              onChange: (value) {
                _dobController.day = value.value;
              },
              textInputAction: .next,
              suffix: Offstage(),
            ),
          ),
          Expanded(
            child: GtAutocompleteField<int>(
              key: const ValueKey("gt_dob_field_day"),
              hintText: "month".ctr(),
              suggestions: _dobController.monthSuggestions,
              onChange: (value) {
                _dobController.month = value.value;
              },
              textInputAction: .next,
              suffix: Offstage(),
            ),
          ),
          Expanded(
            child: GtAutocompleteField<int>(
              key: const ValueKey("gt_dob_field_day"),
              hintText: "year".ctr(),
              suggestions: _dobController.yearSuggestions,
              onChange: (value) {
                _dobController.year = value.value;
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
