import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A data class that groups together a [TextEditingController] and a [FocusNode]
/// for an input field.
///
/// This provides a convenient way to pass both commonly used controllers together.
class GtInputValue {
  /// The controller that manages the text being edited.
  final TextEditingController controller;

  /// The focus node that controls the focus state of the input.
  final FocusNode focusNode;

  /// Creates a [GtInputValue] with the provided [controller] and [focusNode].
  GtInputValue({required this.controller, required this.focusNode});

  /// Whether the input currently has focus.
  bool get hasFocus => focusNode.hasFocus;

  /// The current text value of the input.
  String get text => controller.text;

  /// The current editing state, including text, selection, and composing range.
  TextEditingValue get editingValue => controller.value;

  /// Creates a copy of this value but with the given fields replaced with the new values.
  GtInputValue copyWith({
    TextEditingController? controller,
    FocusNode? focusNode,
  }) {
    return GtInputValue(
      controller: controller ?? this.controller,
      focusNode: focusNode ?? this.focusNode,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GtInputValue &&
        other.controller == controller &&
        other.focusNode == focusNode;
  }

  @override
  int get hashCode => Object.hash(controller, focusNode);
}

/// A controller wrapper for input widgets that manages both text editing and focus state.
///
/// This encapsulates a [GtInputValue] to simplify input field management.
class GtInputController {
  late final GtInputValue _value;

  /// Creates a [GtInputController].
  ///
  /// Initializes a new [TextEditingController] optionally seeded with [text],
  /// and automatically creates an associated [FocusNode].
  GtInputController({String? text}) {
    _value = GtInputValue(
      controller: TextEditingController(text: text),
      focusNode: FocusNode(),
    );
  }

  /// The underlying value containing the controller and focus node.
  GtInputValue get value => _value;

  /// The text editing controller.
  TextEditingController get controller => _value.controller;

  /// The focus node.
  FocusNode get focusNode => _value.focusNode;

  /// Whether the input currently has focus.
  bool get hasFocus => focusNode.hasFocus;

  /// The current text value of the controller.
  String get text => controller.text;

  /// Clears the text from the controller.
  void clear() => controller.clear();

  /// Sets the current text of the controller.
  set text(String text) => controller.text = text;

  /// Updates the text and selection of the controller.
  set editingValue(TextEditingValue value) => controller.value = value;

  /// Moves the focus to the input.
  void focus() => focusNode.requestFocus();

  /// Removes focus from the input.
  void unfocus() => focusNode.unfocus();

  /// Registers a [listener] that is notified whenever the input value changes.
  void addListener(OnPressed listener) {
    controller.addListener(listener);
  }

  /// Removes a previously registered [listener].
  void removeListener(OnPressed listener) {
    controller.removeListener(listener);
  }

  /// Disposes of the underlying controller and focus node.
  void dispose() {
    controller.dispose();
    focusNode.dispose();
  }
}

/// A function type that asynchronously builds a list of autocomplete suggestions
/// based on the user's current search [query].
typedef SuggestionBuilder<T> =
    AppSearchDelegate<FutureOr<List<GtAutocompleteItem<T>>>>;

/// Represents an individual selectable item in the autocomplete list.
class GtAutocompleteItem<T> extends AppEquatable {
  /// The underlying value of this item.
  final T value;

  /// An optional builder to dynamically compute the label from the [value].
  final MapCallback<String, T>? labelBuilder;

  /// Creates a new autocomplete item.
  const GtAutocompleteItem({required this.value, this.labelBuilder});

  /// The label that should be displayed, falling back to the string
  /// representation of [value] if no [labelBuilder] was provided.
  String get computedLabel => labelBuilder?.call(value) ?? "$value";

  @override
  List<Object?> get props => [value, labelBuilder, computedLabel];
}

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
    final gap = minDate.difference(maxDate).inYears;
    return List.generate(
      gap.abs(),
      (it) => GtAutocompleteItem(value: (maxDate.year + it)),
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
  List<GtAutocompleteItem<int>> monthSuggestions = List.generate(
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

  /// Sets the selected month.
  set month(int? month) {
    _month = month;
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
