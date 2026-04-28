import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtTimeField extends GtStatefulWidget {
  final String label;
  final String timeFormat;
  final GtInputController? controller;
  final OnValidate<String?>? validator;
  final TextInputFormatter? formatter;
  final GtInputDecoration? decoration;
  final Color? fillColor;
  final TimeOfDay? selectedTime;
  final bool formatTime;
  final bool isEnabled;
  final bool autoFocus;
  final FocusNode? focusNode;
  final OnChanged<String?>? onFieldSubmitted;
  final TextInputAction? action;

  const GtTimeField({
    super.key,
    this.controller,
    this.timeFormat = "hh:mm a",
    this.label = "HH:MM, AM/PM",
    this.selectedTime,
    this.validator,
    this.formatTime = true,
    this.decoration,
    this.fillColor,
    this.isEnabled = true,
    this.autoFocus = false,
    this.onFieldSubmitted,
    this.action = TextInputAction.next,
    this.focusNode,
  }) : formatter = null;

  @override
  State<GtTimeField> createState() => _GtTimeFieldState();

  void setTime(DateTime time) {
    controller?.text = time.toIso8601String();
  }
}

class _GtTimeFieldState extends State<GtTimeField> {
  late GtInputController _localCtrl;

  @override
  void initState() {
    super.initState();
    _localCtrl = widget.controller ?? GtInputController();
    widget.controller?.controller.addListener(_setLocalValue);
    widget.controller?.focusNode.addListener(() {
      if (widget.focusNode?.hasFocus ?? false) {
        _showPicker();
      }
    });

    if (widget.autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _showPicker();
      });
    }
  }

  void _setLocalValue() {
    if (widget.controller?.text.isNotEmpty ?? false) {
      _localCtrl.text = "";
    }
    _localCtrl.text = AppTextFormatter.formatDate(
      widget.controller?.text,
      format: widget.timeFormat,
      fallback: '',
    );
  }

  DateTime get now => DateTime.now();

  DateTime get _selectedDate {
    return DateTime.tryParse(widget.controller?.text ?? '') ??
        widget.selectedTime?.asDate ??
        now;
  }

  void _setTime(DateTime? time) {
    if (time == null) return;
    widget.setTime(time);
    _setLocalValue();
  }

  void _showPicker() async {
    showCupertinoModalPopup(
      context: context,
      useRootNavigator: false,
      builder: (context) {
        if (!Platform.isAndroid) {
          return _MaterialDatePickerContainer(
            onChange: _setTime,
            initialDate: _selectedDate,
            key: ValueKey(_selectedDate),
          );
        }
        return _CupertinoDatePickerContainer(
          onChange: _setTime,
          initialDate: _selectedDate,
          key: ValueKey(_selectedDate),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return InkWell(
          onTap: () async {
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
              onFieldSubmitted: widget.onFieldSubmitted,
              textInputAction: widget.action,
              inputFormatters: [
                if (widget.formatter != null) widget.formatter!,
              ],
              validator: (_) {
                if (widget.validator != null) {
                  return widget.validator!(widget.controller?.text);
                }
                return null;
              },
              label: widget.label,
              keyboardType: TextInputType.datetime,
              prefix: GtIcon(Icons.timer, variant: .sub),
              suffix: GtIcon(Icons.arrow_downward_rounded, variant: .sub),
            ),
          ),
        );
      },
    );
  }
}

class _CupertinoDatePickerContainer extends GtStatefulWidget {
  final OnChanged<DateTime?> onChange;
  final DateTime? initialDate;

  const _CupertinoDatePickerContainer({
    required this.onChange,
    this.initialDate,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _CupertinoDatePickerContainerState();
}

class _CupertinoDatePickerContainerState
    extends State<_CupertinoDatePickerContainer> {
  final ValueNotifier<DateTime?> _timeRef = ValueNotifier(null);

  void _selectDate() {
    widget.onChange(_timeRef.value);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: GtCard(
        margin: context.insets.defaultAllInsets,
        constraints: BoxConstraints.tightFor(
          width: double.infinity,
          height: context.fractionalHeight(50),
        ),
        padding: context.insets.allDp(24.px),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(children: [GtCancelButton()]),
            Expanded(
              child: CupertinoDatePicker(
                backgroundColor: context.palette.bg.weak,
                onDateTimeChanged: (time) => _timeRef.value = time,
                mode: CupertinoDatePickerMode.time,
                initialDateTime: widget.initialDate,
              ),
            ),
            GtOutlineButton(
              onPressed: _selectDate,
              text: "select".ctr(),
              size: .medium,
            ),
          ],
        ),
      ),
    );
  }
}

enum GtTimePeriod { am, pm }

class _MaterialDatePickerContainer extends GtStatefulWidget {
  final ValueChanged<DateTime?> onChange;
  final DateTime? initialDate;

  const _MaterialDatePickerContainer({
    required this.onChange,
    this.initialDate,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _MaterialDatePickerContainerState();
}

class _MaterialDatePickerContainerState
    extends State<_MaterialDatePickerContainer>
    with SingleTickerProviderStateMixin {
  late final ValueNotifier<int> hour;
  late final ValueNotifier<int> minute;
  late final ValueNotifier<GtTimePeriod> period;
  late final List<int> hours;
  late final List<int> minutes;
  late final FixedExtentScrollController _hourCtrl;
  late final FixedExtentScrollController _minuteCtrl;
  late final FixedExtentScrollController _periodCtrl;

  @override
  void initState() {
    super.initState();
    hour = ValueNotifier(initialDate.hour);
    minute = ValueNotifier(initialDate.minute);
    period = ValueNotifier(isMorning ? GtTimePeriod.am : GtTimePeriod.pm);

    hours = List.generate(24, (index) => index);
    minutes = List.generate(60, (index) => index);

    _hourCtrl = FixedExtentScrollController(initialItem: hour.value);
    _minuteCtrl = FixedExtentScrollController(initialItem: minute.value);
    _periodCtrl = FixedExtentScrollController(initialItem: period.value.index);

    _trackTimeValidity();
  }

  bool get isMorning => hour.value <= 11;
  bool get isPostMorning => hour.value > 11;
  bool get isAmPeriod => period.value == GtTimePeriod.am;
  bool get isPmPeriod => period.value == GtTimePeriod.pm;

  DateTime get initialDate {
    return widget.initialDate ?? DateTime.now();
  }

  void _trackTimeValidity() {
    hour.addListener(_hourListener);
    period.addListener(_periodListener);
  }

  void _hourListener() {
    if (_periodCtrl.position.isScrollingNotifier.value) return;

    GtTimePeriod targetPeriod = period.value;

    if (isMorning && isPmPeriod) targetPeriod = GtTimePeriod.am;
    if (isPostMorning && isAmPeriod) targetPeriod = GtTimePeriod.pm;

    if (period.value == targetPeriod) return;

    _goToCtrlPosition(_periodCtrl, targetPeriod.index);
  }

  void _periodListener() {
    if (_hourCtrl.position.isScrollingNotifier.value) return;

    int addend = 0;

    if (isAmPeriod && isPostMorning) addend = -12;
    if (isPmPeriod && isMorning) addend = 12;

    if (addend == 0) return;

    _goToCtrlPosition(_hourCtrl, hour.value + addend);
  }

  void _goToCtrlPosition(
    FixedExtentScrollController controller, [
    int? index,
    OnPressed? onCompletion,
  ]) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.animateToItem(
        index ?? controller.initialItem,
        duration: 300.milliseconds,
        curve: Curves.decelerate,
      );
      if (onCompletion != null) {
        onCompletion();
      }
    });
  }

  void _selectDate() {
    widget.onChange(TimeOfDay(hour: hour.value, minute: minute.value).asDate);
    context.pop();
  }

  @override
  void dispose() {
    hour.removeListener(_hourListener);
    period.removeListener(_periodListener);
    hour.dispose();
    minute.dispose();
    period.dispose();
    _hourCtrl.dispose();
    _minuteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: GtCard(
        margin: context.insets.defaultAllInsets,
        constraints: BoxConstraints.tightFor(
          width: double.infinity,
          height: context.fractionalHeight(50),
        ),
        padding: context.insets.allDp(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(children: [GtCancelButton()]),
            const GtGap.yBase(),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: ValueListenableBuilder<int>(
                      valueListenable: hour,
                      builder: (context, currentHour, _) {
                        return WheelScrollSheet<int>(
                          key: const Key("hour::wheel"),
                          selectedData: currentHour,
                          onSelect: (newHour) => hour.value = newHour,
                          controller: _hourCtrl,
                          items: [
                            for (final (index, hour) in hours.indexed)
                              GtWheelScrollData(
                                data: hour,
                                label: hour.asHourName,
                                index: index,
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: ValueListenableBuilder<int>(
                      valueListenable: minute,
                      builder: (context, currentMinute, _) {
                        return WheelScrollSheet<int>(
                          key: const Key("minute::wheel"),
                          selectedData: currentMinute,
                          onSelect: (newMinute) => minute.value = newMinute,
                          controller: _minuteCtrl,
                          items: [
                            for (final (index, minute) in minutes.indexed)
                              GtWheelScrollData(
                                data: minute,
                                label: minute.asMinuteName,
                                index: index,
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: ValueListenableBuilder<GtTimePeriod>(
                      valueListenable: period,
                      builder: (context, currentPeriod, _) {
                        return WheelScrollSheet<GtTimePeriod>(
                          key: const Key("period::wheel"),
                          selectedData: currentPeriod,
                          onSelect: (newPeriod) => period.value = newPeriod,
                          controller: _periodCtrl,
                          items: [
                            for (final period in GtTimePeriod.values)
                              GtWheelScrollData(
                                data: period,
                                label: ["AM", "PM"][period.index],
                                index: period.index,
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const GtGap.yBase(),
            GtOutlineButton(
              onPressed: _selectDate,
              text: "select".ctr(),
              size: .medium,
            ),
          ],
        ),
      ),
    );
  }
}
