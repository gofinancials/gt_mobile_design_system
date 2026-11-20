import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A data class representing a single selectable item within a dropdown or autocomplete list.
class GtDropdownData<T> extends AppEquatable {
  /// The underlying value of this item.
  final T value;

  /// The optional display text for the item.
  final String? label;

  /// The optional leading widget for the item.
  final AppImageData? leading;

  /// The optional size of the [leading] image.
  final double? leadingSize;

  /// An optional builder to dynamically compute the label from the [value].
  final MapCallback<String, T>? labelBuilder;

  /// The optional matcher that replaces the default label search in [filter].
  final AppSearchDelegate<bool>? _filterDelegate;

  /// Creates a new [GtDropdownData] item.
  const GtDropdownData({
    required this.value,
    this.label,
    this.labelBuilder,
    this.leading,
    this.leadingSize,
    AppSearchDelegate<bool>? filterDelegate,
  }) : _filterDelegate = filterDelegate;

  /// The label that should be displayed, falling back to the string
  /// representation of [value] if no [labelBuilder] was provided.
  String get computedLabel => labelBuilder?.call(value) ?? label ?? "$value";

  /// Filters this item based on a search query.
  ///
  /// Returns `true` if the item should be included in the results,
  /// and `false` otherwise.
  bool filter(String? query) {
    if (_filterDelegate != null) return _filterDelegate(query.value);
    if (!query.hasValue) return true;
    return computedLabel.includes(query.value);
  }

  @override
  List<Object?> get props => [value, label, computedLabel];
}

/// A [ValueNotifier] that specifically manages changes to a [GtDropdownData] selection.
class GtDropdownDataNotifier<T> extends ValueNotifier<GtDropdownData<T>?> {
  /// Creates a [GtDropdownDataNotifier] with an initial [value].
  GtDropdownDataNotifier(super.value);
}

/// A data class that groups together a [TextEditingController] and a [FocusNode]
/// for an input field.
///
/// This provides a convenient way to pass both commonly used controllers together.
class GtInputValue<T> {
  /// The controller that manages the text being edited.
  late final TextEditingController controller;

  /// The focus node that controls the focus state of the input.
  late final FocusNode focusNode;

  /// The notifier that holds the currently selected dropdown item.
  final GtDropdownDataNotifier<T> _selection;

  /// Whether setting [selection] also writes its label to [controller].
  final bool _updateControllerWithSelection;

  /// Creates a [GtInputValue] with the provided [controller] and [focusNode].
  GtInputValue({
    required this.controller,
    required this.focusNode,
    GtDropdownDataNotifier<T>? selectionNotifier,
  }) : _selection = selectionNotifier ?? GtDropdownDataNotifier<T>(null),
       _updateControllerWithSelection = false;

  /// Creates a [GtInputValue] initialized with an optional [selection].
  ///
  /// Automatically instantiates a [TextEditingController] seeded with the selection's computed label
  /// and a new [FocusNode].
  GtInputValue.selection({required GtDropdownData<T>? selection})
    : _selection = GtDropdownDataNotifier<T>(selection),
      controller = TextEditingController(text: selection?.computedLabel),
      focusNode = FocusNode(),
      _updateControllerWithSelection = true;

  /// The [ValueNotifier] that tracks the currently selected dropdown item.
  GtDropdownDataNotifier<T> get selectionNotifier => _selection;

  /// The currently selected dropdown item, if any.
  GtDropdownData<T>? get selection => _selection.value;

  /// Updates the current selection and sets the controller's text to the new computed label.
  set selection(GtDropdownData<T>? selection) {
    _selection.value = selection;
    if (!_updateControllerWithSelection) return;
    controller.text = selection?.computedLabel ?? "";
  }

  /// Whether the input currently has focus.
  bool get hasFocus => focusNode.hasFocus;

  /// The current text value of the input.
  String get text => controller.text;

  /// The current editing state, including text, selection, and composing range.
  TextEditingValue get editingValue => controller.value;

  /// Creates a copy of this value but with the given fields replaced with the new values.
  GtInputValue<T> copyWith({
    TextEditingController? controller,
    FocusNode? focusNode,
  }) {
    return GtInputValue<T>(
      controller: controller ?? this.controller,
      focusNode: focusNode ?? this.focusNode,
      selectionNotifier: _selection,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GtInputValue &&
        other.controller == controller &&
        other.focusNode == focusNode &&
        other._selection == _selection;
  }

  @override
  int get hashCode => Object.hash(controller, focusNode, _selection);
}

/// A controller wrapper for input widgets that manages both text editing and focus state.
///
/// This encapsulates a [GtInputValue] to simplify input field management.
class GtInputController<T> {
  GtInputValue<T> _value;

  /// Creates a [GtInputController].
  ///
  /// Initializes a new [TextEditingController] optionally seeded with [text],
  /// and automatically creates an associated [FocusNode].
  GtInputController({String? text})
    : _value = GtInputValue<T>(
        controller: TextEditingController(text: text),
        focusNode: FocusNode(),
      );

  /// Internal constructor for subclasses to prevent double-initialization memory leaks.
  GtInputController._withValue(this._value);

  /// Creates a [GtInputController] for dropdown inputs.
  ///
  /// Initializes a controller specifically tailored for dropdowns or autocomplete fields,
  /// optionally seeded with an initial [selection].
  factory GtInputController.dropdown({GtDropdownData<T>? selection}) =
      GtDropdownInputController<T>;

  /// The underlying value containing the controller and focus node.
  GtInputValue<T> get value => _value;

  /// The text editing controller.
  TextEditingController get controller => _value.controller;

  /// The focus node.
  FocusNode get focusNode => _value.focusNode;

  /// The currently selected dropdown item, if any.
  GtDropdownData<T>? get selection => _value.selection;

  /// The [ValueNotifier] that tracks the currently selected dropdown item.
  GtDropdownDataNotifier<T> get selectionNotifier => _value.selectionNotifier;

  /// Updates the current selection in the underlying value.
  set selection(GtDropdownData<T>? selection) {
    _value.selection = selection;
  }

  /// Whether the input currently has focus.
  bool get hasFocus => focusNode.hasFocus;

  /// The current text value of the controller and/or selectionNotifier.
  ({String controllerText, String? selectionLabel})
  get controllerAndSelectionText => (
    controllerText: controller.text,
    selectionLabel: selectionNotifier.value?.computedLabel,
  );

  /// The current text value of the controller.
  String get text => controller.text;

  /// Clears the text from the controller.
  void clear() => controller.clear();

  /// Sets the current text of the controller.
  set text(String text) => controller.text = text;

  /// Updates the editing state of the controller.
  set editingValue(TextEditingValue value) => controller.value = value;

  /// Moves the focus to the input.
  void focus() => focusNode.requestFocus();

  /// Removes focus from the input.
  void unfocus() => focusNode.unfocus();

  /// Registers a [listener] that is notified whenever the text editing state or selection changes.
  void addListener(OnPressed listener) {
    controller.addListener(listener);
    _value.selectionNotifier.addListener(listener);
  }

  /// Removes a previously registered [listener] from the text editing controller and selection notifier.
  void removeListener(OnPressed listener) {
    controller.removeListener(listener);
    selectionNotifier.removeListener(listener);
  }

  /// Disposes of the underlying controller, focus node, and selection notifier.
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    _value.selectionNotifier.dispose();
  }
}

/// A specialized [GtInputController] for dropdown and autocomplete inputs.
///
/// Extends [GtInputController] to initialize specifically with a [GtDropdownData] selection.
class GtDropdownInputController<T> extends GtInputController<T> {
  /// Creates a [GtDropdownInputController] initialized with an optional [selection].
  GtDropdownInputController({GtDropdownData<T>? selection})
    : super._withValue(GtInputValue<T>.selection(selection: selection));
}

/// A function type that asynchronously builds a list of autocomplete suggestions
/// based on the user's current search [query].
typedef SuggestionBuilder<T> =
    AppSearchDelegate<FutureOr<List<GtAutocompleteItem<T>>>>;

/// Represents an individual selectable item in the autocomplete list.
typedef GtAutocompleteItem<T> = GtDropdownData<T>;

/// A controller for managing the state of a date of birth field.
///
/// This controller handles date selection logic, age calculations, and bounds
/// constraints for a date of birth input. Ages are counted in whole calendar
/// years, birthday to birthday, so leap days count and someone born on
/// 29 February turns a year older on 1 March in common years.
class GtDobController extends ChangeNotifier {
  /// The exclusive maximum age for the date of birth.
  ///
  /// `maxAge: 18` means "under 18": someone whose 18th birthday is today is
  /// rejected.
  final int maxAge;

  /// The inclusive minimum age for the date of birth.
  ///
  /// `minAge: 18` accepts someone whose 18th birthday is today. `minAge: 0`
  /// accepts a newborn born today.
  final int minAge;

  /// The selected year, or null while it is unset.
  int? _year;

  /// The selected month (1-12), or null while it is unset.
  int? _month;

  /// The selected day (1-31), or null while it is unset.
  int? _day;

  /// Gets the currently selected date of birth, or null if the date is incomplete.
  DateTime? get dob {
    if (year == null || month == null || day == null) return null;
    return DateTime(year!, month!, day!);
  }

  /// Calculates the current age in whole calendar years from the selected
  /// [dob], birthday to birthday.
  ///
  /// Returns `0` if the date of birth is incomplete.
  int get age {
    final birthday = dob;
    if (birthday == null) return 0;
    return birthday.yearsUntil(_today);
  }

  /// The start of the current local day.
  DateTime get _today => DateTime.now().startOfDay;

  /// Returns the latest date of birth that is [years] old today.
  ///
  /// When today's day doesn't exist in that year (29 February in a common
  /// year), this is the last day of the month, since someone born on 1 March
  /// isn't [years] old until tomorrow.
  DateTime _latestBirthdayFor(int years) {
    final today = _today;
    final year = today.year - years;
    final anniversary = DateTime(year, today.month, today.day);
    final isInSameMonth = anniversary.month == today.month;
    if (isInSameMonth) return anniversary;
    return DateTime(year, today.month + 1, 0);
  }

  /// The most recent allowed date of birth, inclusive: the latest date that
  /// is [minAge] years old today.
  DateTime get minDate => _latestBirthdayFor(minAge);

  /// The oldest allowed date of birth, inclusive: the day after the latest
  /// date that is [maxAge] years old today, since [maxAge] is exclusive.
  DateTime get maxDate {
    final latestTooOld = _latestBirthdayFor(maxAge);
    final nextDay = latestTooOld.day + 1;
    return DateTime(latestTooOld.year, latestTooOld.month, nextDay);
  }

  /// Returns whether the currently selected date is complete, not in the
  /// future, at least [minAge] years old and under [maxAge].
  bool get hasValidDate {
    final birthday = dob;
    if (birthday == null) return false;
    final today = _today;
    final currentAge = birthday.yearsUntil(today);
    final isInFuture = birthday.isAfter(today);
    final isOldEnough = currentAge >= minAge;
    final isYoungEnough = currentAge < maxAge;
    return !isInFuture && isOldEnough && isYoungEnough;
  }

  /// The currently selected year.
  int? get year => _year;

  /// The currently selected month (1-12).
  int? get month => _month;

  /// The currently selected day (1-31).
  int? get day => _day;

  /// Generates the valid birth years, oldest first, from the year of
  /// [maxDate] through the year of [minDate], both inclusive.
  List<GtAutocompleteItem<int>> get yearSuggestions {
    final oldestYear = maxDate.year;
    final latestYear = minDate.year;
    final yearCount = latestYear - oldestYear + 1;
    final years = List.generate(yearCount, (it) => oldestYear + it);
    return years.mapList((it) => GtAutocompleteItem(value: it));
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

  /// A static list of valid month suggestions (1-12).
  final List<GtAutocompleteItem<int>> monthSuggestions = List.generate(
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
