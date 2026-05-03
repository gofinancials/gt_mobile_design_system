import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final String hintText;

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

  /// Callback fired when the selected value changes.
  final OnChanged<DateTime?>? onChanged;

  /// The current selection mode of the field.
  final GtCalendarSelectionMode _selectionMode;

  /// Creates a date field configured for single day selection.
  const GtDateField({
    super.key,
    this.controller,
    this.dateFormat = "MM-dd-yyyy",
    this.hintText = "MM-DD-YYYY",
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
  }) : _selectionMode = GtCalendarSelectionMode.day;

  /// Creates a date field configured for date range selection.
  const GtDateField.range({
    super.key,
    this.controller,
    this.dateFormat = "MM-dd-yyyy",
    this.hintText = "MM-DD-YYYY",
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
  }) : _selectionMode = GtCalendarSelectionMode.range;

  @override
  State<GtDateField> createState() => _GtDateFieldState();

  /// Gets the current selection mode (day or range).
  GtCalendarSelectionMode get selectionMode => _selectionMode;

  /// Returns true if the field is in range selection mode.
  bool get isRange => _selectionMode == GtCalendarSelectionMode.range;

  /// Returns true if the field is in single day selection mode.
  bool get isDay => _selectionMode == GtCalendarSelectionMode.day;
}

class _GtDateFieldState extends State<GtDateField> with GtBottomSheetMixin {
  late GtInputController _localCtrl;
  late GtCalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    _calendarController =
        widget.controller ?? GtCalendarController(GtCalendarValue());

    _localCtrl = GtInputController(
      GtInputValue(
        controller: TextEditingController(text: _formattedValue),
        focusNode: widget.focusNode ?? FocusNode(),
      ),
    );

    _calendarController.addListener(_setLocalValue);
    widget.focusNode?.addListener(_onFocusChange);

    if (widget.autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showPicker());
    }
  }

  void _onFocusChange() {
    if (widget.focusNode?.hasFocus ?? false) {
      _showPicker();
    }
  }

  String get _formattedValue {
    final val = widget.isDay
        ? _calendarController.formattedDay(widget.dateFormat)
        : _calendarController.formattedRange(widget.dateFormat);
    return val ?? "";
  }

  void _setLocalValue() {
    _localCtrl.text = _formattedValue;
  }

  void _showPicker() {
    if (!widget.isEnabled) return;
    showDraggableSheet(
      context,
      builder: (controller) => GtCalendarModal(
        controller,
        controller: _calendarController,
        title: widget.calendarTitle ?? widget.label ?? widget.hintText,
        selectionMode: widget.selectionMode,
        onSelectDay: (_) => context.pop(),
        onSelectRange: (_) => context.pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!widget.isEnabled) return;
        HapticFeedback.mediumImpact();
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
          hintText: widget.hintText,
          label: widget.label,
          keyboardType: TextInputType.datetime,
          suffix: widget.suffix ?? GtIcon(GtIcons.calendarDays),
        ),
      ),
    );
  }
}
