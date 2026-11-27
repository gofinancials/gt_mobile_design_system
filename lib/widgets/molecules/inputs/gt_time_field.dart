import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A time input field that opens a sheet of time wheels.
///
/// [GtTimeField] looks like a text field but cannot be typed into: a tap opens
/// a [GtWheelScrollModal] holding a [GtTimeWheelScroll], and the field shows
/// the picked time in [timeFormat]. The same pattern decides the wheels, so
/// `HH:mm:ss` adds a second wheel and `hh:mm a` an AM/PM wheel.
///
/// The [controller] holds the time and the earliest and latest times the
/// wheels offer. For a time later today, keep its earliest at the current
/// time:
///
/// ```dart
/// GtTimeField(
///   label: "Schedule time",
///   controller: GtTimeController(earliest: TimeOfDay.now()),
///   timeFormat: "hh:mm a",
///   validator: (time) => time == null ? "Pick a time" : null,
/// )
/// ```
///
/// Opening the sheet on an empty field picks the time the wheels first show,
/// so a customer who sees the time they want can close the sheet without
/// scrolling. A time the wheels cannot show, such as 14:17 on a 15-minute
/// [minuteStep] or one outside the limits, moves to the time they show.
class GtTimeField extends GtStatefulWidget {
  /// The label displayed above the text field.
  final String? label;

  /// The title displayed at the top of the wheel sheet.
  ///
  /// Falls back to [label], then [hintText], then the translated
  /// "selectTime".
  final String? sheetTitle;

  /// The hint text shown in the text field when no time is picked.
  ///
  /// Falls back to [label], then [timeFormat] in capitals, such as "HH:MM".
  final String? hintText;

  /// The date pattern the picked time is shown in, which also decides the
  /// wheels. See [GtTimePattern.parse].
  ///
  /// Defaults to `HH:mm`.
  final String timeFormat;

  /// The minutes between neighbouring items of the minute wheel. Defaults to
  /// 1. See [GtTimeWheelScroll.minuteStep].
  final int minuteStep;

  /// The seconds between neighbouring items of the second wheel. Defaults to
  /// 1. See [GtTimeWheelScroll.secondStep].
  final int secondStep;

  /// The controller holding the picked time and its limits.
  final GtTimeController? controller;

  /// Optional validator for the picked time, which is null until one is
  /// picked.
  final OnValidate<GtTimeValue?>? validator;

  /// The decoration applied to the text field.
  final GtInputDecoration? decoration;

  /// The widget displayed at the trailing edge of the text field. Defaults to
  /// a clock icon.
  final Widget? suffix;

  /// Whether the field is interactive.
  final bool isEnabled;

  /// Whether the wheel sheet opens automatically when the field first builds.
  final bool autoFocus;

  /// An optional focus node; the sheet opens when it gains focus.
  final FocusNode? focusNode;

  /// The action to perform when the keyboard's "done" or "next" button is
  /// pressed.
  final TextInputAction? action;

  /// Called when the picked time changes, including a change set on the
  /// [controller] from outside the field.
  final OnChanged<GtTimeValue?>? onChanged;

  /// The label of the hour wheel. See [GtTimeWheelScroll.hourLabel].
  final String? hourLabel;

  /// The label of the minute wheel. See [GtTimeWheelScroll.minuteLabel].
  final String? minuteLabel;

  /// The label of the second wheel. See [GtTimeWheelScroll.secondLabel].
  final String? secondLabel;

  /// The label of the AM/PM wheel. See [GtTimeWheelScroll.periodLabel].
  final String? periodLabel;

  /// When the field is validated without the app calling
  /// [FormState.validate].
  ///
  /// Under [AutovalidateMode.onUserInteraction], set here or on the enclosing
  /// [GtForm], the error shows as the value changes and clears once it is
  /// valid again. Defaults to [AutovalidateMode.disabled].
  final AutovalidateMode autovalidateMode;

  /// Creates a [GtTimeField].
  const GtTimeField({
    super.key,
    this.controller,
    this.timeFormat = "HH:mm",
    this.minuteStep = 1,
    this.secondStep = 1,
    this.hintText,
    this.validator,
    this.decoration,
    this.suffix,
    this.isEnabled = true,
    this.autoFocus = false,
    this.action = TextInputAction.next,
    this.onChanged,
    this.sheetTitle,
    this.label,
    this.focusNode,
    this.hourLabel,
    this.minuteLabel,
    this.secondLabel,
    this.periodLabel,
    this.autovalidateMode = .disabled,
  });

  @override
  State<GtTimeField> createState() => _GtTimeFieldState();
}

/// The state for a [GtTimeField] that keeps its text in step with the picked
/// time and reports changes through [GtTimeField.onChanged].
class _GtTimeFieldState extends State<GtTimeField> with GtBottomSheetMixin {
  /// The controller for the visible text field that displays the time.
  late GtInputController _localCtrl;

  /// The controller holding the picked time.
  late GtTimeController _timeController;

  /// The time last reported through [GtTimeField.onChanged].
  GtTimeValue? _reportedValue;

  @override
  void initState() {
    super.initState();
    _timeController = widget.controller ?? GtTimeController();
    _localCtrl = GtInputController(text: _formattedValue);
    _reportedValue = _timeController.value;

    _timeController.addListener(_setLocalValue);
    widget.focusNode?.addListener(_onFocusChange);

    if (widget.autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showPicker());
    }
  }

  @override
  void didUpdateWidget(GtTimeField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode?.removeListener(_onFocusChange);
      widget.focusNode?.addListener(_onFocusChange);
    }
    if (oldWidget.timeFormat != widget.timeFormat) {
      _localCtrl.text = _formattedValue;
    }
  }

  @override
  void dispose() {
    _timeController.removeListener(_setLocalValue);
    widget.focusNode?.removeListener(_onFocusChange);
    if (widget.controller == null) _timeController.dispose();
    _localCtrl.dispose();
    super.dispose();
  }

  /// Opens the wheel sheet when the field gains focus.
  void _onFocusChange() {
    if (widget.focusNode?.hasFocus ?? false) {
      _showPicker();
    }
  }

  /// The picked time in [GtTimeField.timeFormat], or empty when none is.
  String get _formattedValue {
    return _timeController.formatted(widget.timeFormat) ?? "";
  }

  /// Keeps the text in step with the controller and reports a new time.
  void _setLocalValue() {
    _localCtrl.text = _formattedValue;
    final value = _timeController.value;
    if (value == _reportedValue) return;
    _reportedValue = value;
    widget.onChanged?.call(value);
  }

  /// Opens the wheel sheet.
  void _showPicker() {
    if (!widget.isEnabled) return;
    final title = widget.sheetTitle ?? widget.label ?? widget.hintText;

    showDraggableSheet<void>(
      context,
      useRootNavigator: false,
      builder: (scrollController) => GtWheelScrollModal(
        scrollController,
        title: title ?? "selectTime".tr(),
        child: GtTimeWheelScroll(
          controller: _timeController,
          pattern: widget.timeFormat,
          minuteStep: widget.minuteStep,
          secondStep: widget.secondStep,
          selectInitialTime: true,
          hourLabel: widget.hourLabel,
          minuteLabel: widget.minuteLabel,
          secondLabel: widget.secondLabel,
          periodLabel: widget.periodLabel,
        ),
      ),
    );
  }

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
          autovalidateMode: widget.autovalidateMode,
          isEnabled: widget.isEnabled,
          decoration: widget.decoration,
          controller: _localCtrl,
          textInputAction: widget.action,
          validator: (_) => widget.validator?.call(_timeController.value),
          hintText:
              widget.hintText ??
              widget.label ??
              widget.timeFormat.toUpperCase(),
          label: widget.label,
          keyboardType: TextInputType.datetime,
          suffix: widget.suffix ?? GtIcon(GtIcons.clock),
        ),
      ),
    );
  }
}
