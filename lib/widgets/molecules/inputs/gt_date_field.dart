import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A date input field that displays a calendar modal for selecting dates.
///
/// [GtDateField] allows the user to select either a single date or a range
/// of dates depending on the constructor used. It presents a text field
/// visually, but interaction opens a [GtCalendarModal].
class GtDateField extends GtStatefulWidget {
  /// The label displayed above the text field.
  final String? label;

  /// The title displayed at the top of the calendar modal.
  /// Falls back to [label] or [hintText] if not provided.
  final String? calendarTitle;

  /// The hint text shown in the text field when no date is selected.
  final String? hintText;

  /// The format used to display the selected date or date range.
  final String dateFormat;

  /// The controller used to manage the calendar's selection state.
  final GtCalendarController? controller;

  /// Optional validator for the calendar value.
  final OnValidate<GtCalendarValue?>? validator;

  /// The decoration applied to the text field.
  final GtInputDecoration? decoration;

  /// The icon displayed at the trailing edge of the text field.
  final Widget? suffix;

  /// Whether the field is interactive.
  final bool isEnabled;

  /// Whether the calendar modal should open automatically when the widget builds.
  final bool autoFocus;

  /// An optional focus node for the text field.
  final FocusNode? focusNode;

  /// The action to perform when the keyboard's "done" or "next" button is pressed.
  final TextInputAction? action;

  /// Called when the value the field displays changes.
  ///
  /// The field built with the default constructor reports a change to
  /// [GtCalendarValue.day]. The field built with [GtDateField.range] reports a
  /// change to [GtCalendarValue.range] and ignores a change to the day alone,
  /// such as the month or year picked from the calendar header. After the
  /// first tap of a range the value holds a one-day range, matching the text
  /// the field shows, until the end date is picked.
  ///
  /// This also fires when the [controller]'s value is set from outside the
  /// field.
  final OnChanged<GtCalendarValue?>? onChanged;

  /// The current selection mode of the field.
  final GtCalendarSelectionMode _selectionMode;

  /// Creates a date field configured for single day selection.
  const GtDateField({
    super.key,
    this.controller,
    this.dateFormat = "dd-MM-yyyy",
    this.hintText,
    this.validator,
    this.decoration,
    this.suffix,
    this.isEnabled = true,
    this.autoFocus = false,
    this.action = TextInputAction.next,
    this.onChanged,
    this.calendarTitle,
    this.label,
    this.focusNode,
  }) : _selectionMode = .day;

  /// Creates a date field configured for date range selection.
  const GtDateField.range({
    super.key,
    this.controller,
    this.dateFormat = "dd-MM-yyyy",
    this.hintText,
    this.validator,
    this.decoration,
    this.suffix,
    this.isEnabled = true,
    this.autoFocus = false,
    this.action = TextInputAction.next,
    this.onChanged,
    this.calendarTitle,
    this.label,
    this.focusNode,
  }) : _selectionMode = .range;

  @override
  State<GtDateField> createState() => _GtDateFieldState();

  /// Gets the current selection mode (day or range).
  GtCalendarSelectionMode get selectionMode => _selectionMode;

  /// Returns true if the field is in range selection mode.
  bool get isRange => _selectionMode == GtCalendarSelectionMode.range;

  /// Returns true if the field is in single day selection mode.
  bool get isDay => _selectionMode == GtCalendarSelectionMode.day;
}

/// The state for a [GtDateField] that keeps its text in step with the
/// calendar selection and reports changes through [GtDateField.onChanged].
class _GtDateFieldState extends State<GtDateField> with GtBottomSheetMixin {
  /// The controller for the visible text field that displays the formatted date.
  late GtInputController _localCtrl;

  /// The controller that manages the underlying calendar selection state.
  late GtCalendarController _calendarController;

  /// The [_fieldValue] last reported through [GtDateField.onChanged].
  Object? _reportedValue;

  @override
  void initState() {
    super.initState();
    _calendarController =
        widget.controller ?? GtCalendarController(GtCalendarValue());

    _localCtrl = GtInputController(text: _formattedValue);
    _reportedValue = _fieldValue;

    _calendarController.addListener(_setLocalValue);
    widget.focusNode?.addListener(_onFocusChange);

    if (widget.autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showPicker());
    }
  }

  @override
  void didUpdateWidget(GtDateField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode?.removeListener(_onFocusChange);
      widget.focusNode?.addListener(_onFocusChange);
    }
  }

  @override
  void dispose() {
    _calendarController.removeListener(_setLocalValue);
    widget.focusNode?.removeListener(_onFocusChange);
    if (widget.controller == null) _calendarController.dispose();
    _localCtrl.dispose();
    super.dispose();
  }

  /// Handles focus changes to automatically open the calendar picker.
  void _onFocusChange() {
    if (widget.focusNode?.hasFocus ?? false) {
      _showPicker();
    }
  }

  /// Formats the currently selected calendar value based on the selection mode.
  String get _formattedValue {
    final val = widget.isDay
        ? _calendarController.formattedDay(widget.dateFormat)
        : _calendarController.formattedRange(widget.dateFormat);
    return val ?? "";
  }

  /// The part of the calendar value the field displays: the day, or the range
  /// for a [GtDateField.range].
  Object? get _fieldValue {
    return widget.isDay ? _calendarController.day : _calendarController.range;
  }

  /// Synchronizes the text field with the underlying calendar controller's
  /// value and reports a change to [_fieldValue] through
  /// [GtDateField.onChanged].
  void _setLocalValue() {
    _localCtrl.text = _formattedValue;
    final value = _fieldValue;
    if (value == _reportedValue) return;
    _reportedValue = value;
    widget.onChanged?.call(_calendarController.value);
  }

  /// Closes the calendar sheet after a short delay so the pick is visible.
  void _pop(BuildContext context) {
    AppDebouncer(500.milliseconds).run(context.pop);
  }

  /// Opens the [GtCalendarModal] in a draggable bottom sheet.
  void _showPicker() {
    if (!widget.isEnabled) return;
    final title = widget.calendarTitle ?? widget.label ?? widget.hintText;

    showDraggableSheet(
      context,
      useRootNavigator: false,
      builder: (controller) => GtCalendarModal(
        controller,
        controller: _calendarController,
        title: title ?? defaultHint,
        selectionMode: widget.selectionMode,
        onSelectDay: (_) => _pop(context),
        onSelectRange: (_) => _pop(context),
      ),
    );
  }

  /// The hint shown when neither [GtDateField.hintText] nor
  /// [GtDateField.label] is set.
  String get defaultHint => switch (widget._selectionMode) {
    .range => "DD-MM-YYYY - DD-MM-YYYY",
    _ => "DD-MM-YYYY",
  };

  @override
  Widget build(BuildContext context) {
    return GtInkWell(
      role: .button,
      borderRadius: context.borderRadiusXl,
      onTap: () {
        if (!widget.isEnabled) return;
        context.resetFocus();
        _showPicker();
      },
      child: IgnorePointer(
        child: GtTextField(
          isEnabled: widget.isEnabled,
          decoration: widget.decoration,
          controller: _localCtrl,
          textInputAction: widget.action,
          validator: (_) => widget.validator?.call(_calendarController.value),
          hintText: widget.hintText ?? widget.label ?? defaultHint,
          label: widget.label,
          keyboardType: TextInputType.datetime,
          suffix: widget.suffix ?? GtIcon(GtIcons.calendarDays),
        ),
      ),
    );
  }
}
