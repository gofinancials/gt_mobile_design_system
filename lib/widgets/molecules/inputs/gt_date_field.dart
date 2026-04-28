import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtDateField extends GtStatefulWidget {
  final String hintText;
  final String dateFormat;
  final GtInputController? controller;
  final OnValidate<String?>? validator;
  final TextInputFormatter? formatter;
  final GtInputDecoration? decoration;
  final DateTime? lastDate;
  final DateTime? firstDate;
  final Color? fillColor;
  final Color? iconColor;
  final IconData? trailingIcon;
  final DateTime? selectedDate;
  final bool formatDate;
  final bool isEnabled;
  final bool autoFocus;
  final bool _isManual;
  final FocusNode? focusNode;
  final OnChanged<String?>? onFieldSubmitted;
  final TextInputAction? action;
  final String? hint;

  const GtDateField({
    super.key,
    this.controller,
    this.dateFormat = "MM-dd-yyyy",
    this.hintText = "MM-DD-YYYY",
    this.selectedDate,
    this.validator,
    this.firstDate,
    this.lastDate,
    this.formatDate = true,
    this.decoration,
    this.fillColor,
    this.iconColor,
    this.trailingIcon,
    this.isEnabled = true,
    this.autoFocus = false,
    this.onFieldSubmitted,
    this.action = TextInputAction.next,
    this.focusNode,
  }) : _isManual = false,
       hint = null,
       formatter = null;

  const GtDateField.manual({
    super.key,
    this.controller,
    this.dateFormat = "MM-dd-yyyy",
    this.hintText = "MM-DD-YYYY",
    this.selectedDate,
    this.validator,
    this.firstDate,
    this.lastDate,
    this.formatter,
    this.formatDate = true,
    this.decoration,
    this.fillColor,
    this.iconColor,
    this.trailingIcon,
    this.isEnabled = true,
    this.autoFocus = false,
    this.onFieldSubmitted,
    this.action = TextInputAction.next,
    this.focusNode,
    this.hint,
  }) : _isManual = true;

  @override
  State<GtDateField> createState() => _GtDateFieldState();

  void setDate(DateTime date) {
    controller?.text = date.toIso8601String();
  }
}

class _GtDateFieldState extends State<GtDateField> {
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
      format: widget.dateFormat,
      fallback: '',
    );
  }

  DateTime get _firstDate {
    return widget.firstDate ?? DateTime(1900);
  }

  DateTime get _selectedDate {
    return DateTime.tryParse(widget.controller?.text ?? '') ??
        widget.selectedDate ??
        _lastDate;
  }

  DateTime get _lastDate {
    final days = (365 * 18).ceil();
    return widget.lastDate ?? DateTime.now().add(Duration(days: days));
  }

  void _setDate(DateTime? date) {
    if (date == null || widget._isManual) return;
    widget.setDate(date);
    _setLocalValue();
  }

  void _showPicker() async {
    showCupertinoModalPopup(
      context: context,
      useRootNavigator: false,
      builder: (context) {
        if (Platform.isAndroid) {
          return _MaterialDatePickerContainer(
            onChangeDate: _setDate,
            initialDate: _selectedDate,
            maxDate: _lastDate,
            minDate: _firstDate,
            key: ValueKey(_selectedDate),
          );
        }
        return _CupertinoDatePickerContainer(
          onChangeDate: _setDate,
          initialDate: _selectedDate,
          maxDate: _lastDate,
          minDate: _firstDate,
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
            if (!widget.isEnabled || widget._isManual) return;
            HapticFeedback.mediumImpact();
            context.resetFocus();
            _showPicker();
          },
          child: IgnorePointer(
            ignoring: !widget._isManual,
            child: GtTextField(
              isEnabled: widget.isEnabled,
              decoration: widget.decoration,
              controller: widget._isManual ? widget.controller : _localCtrl,
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
              hintText: widget.hintText,
              label: widget.hintText,
              keyboardType: TextInputType.datetime,
              prefix: GtIcon(GtIcons.calendarDays, variant: .sub),
              autofillHints: [
                if (widget._isManual && widget.hint.hasValue) widget.hint!,
              ],
              suffix: GtIcon(
                widget.trailingIcon ?? GtIcons.chevronDownOutline,
                variant: .sub,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CupertinoDatePickerContainer extends GtStatefulWidget {
  final OnChanged<DateTime?> onChangeDate;
  final DateTime? initialDate;
  final DateTime? minDate;
  final DateTime? maxDate;

  const _CupertinoDatePickerContainer({
    required this.onChangeDate,
    this.initialDate,
    this.maxDate,
    this.minDate,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _CupertinoDatePickerContainerState();
}

class _CupertinoDatePickerContainerState
    extends State<_CupertinoDatePickerContainer> {
  late final ValueNotifier<DateTime> _dateRef;

  @override
  void initState() {
    super.initState();
    _dateRef = ValueNotifier(widget.initialDate ?? DateTime.now());
  }

  @override
  void dispose() {
    _dateRef.dispose();
    super.dispose();
  }

  void _selectDate() {
    widget.onChangeDate(_dateRef.value);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return GtBasePicker(
      onSelect: _selectDate,
      picker: CupertinoDatePicker(
        dateOrder: DatePickerDateOrder.mdy,
        backgroundColor: context.palette.bg.weak,
        onDateTimeChanged: (date) => _dateRef.value = date,
        mode: CupertinoDatePickerMode.date,
        initialDateTime: widget.initialDate,
        minimumDate: widget.minDate,
        maximumDate: widget.maxDate,
      ),
    );
  }
}

class _MaterialDatePickerContainer extends GtStatefulWidget {
  final ValueChanged<DateTime?> onChangeDate;
  final DateTime? initialDate;
  final DateTime? minDate;
  final DateTime? maxDate;

  const _MaterialDatePickerContainer({
    required this.onChangeDate,
    this.initialDate,
    this.maxDate,
    this.minDate,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _MaterialDatePickerContainerState();
}

class _MaterialDatePickerContainerState
    extends State<_MaterialDatePickerContainer>
    with SingleTickerProviderStateMixin {
  late final ValueNotifier<int> month;
  late final ValueNotifier<int> day;
  late final ValueNotifier<int> year;
  late final ValueNotifier<List<int>> days;
  late final List<int> years;
  late final FixedExtentScrollController _monthCtrl;
  late final FixedExtentScrollController _dayCtrl;
  late final FixedExtentScrollController _yearCtrl;

  @override
  void initState() {
    super.initState();
    month = ValueNotifier(initialDate.month);
    day = ValueNotifier(initialDate.day);
    year = ValueNotifier(initialDate.year);
    days = ValueNotifier(month.value.monthDays);

    int yearDifference = (_maxDate.year - _minDate.year) + 1;

    years = List.generate(
      yearDifference,
      (index) => _minDate.year + index,
      growable: false,
    );

    month.addListener(() {
      final monthDays = month.value.monthDays;
      if (monthDays == days.value) return;
      if (day.value > monthDays.last) {
        day.value = monthDays.last;
      }
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        days.value = [...monthDays];
      });
    });

    _monthCtrl = FixedExtentScrollController(
      initialItem: initialDate.months.indexOf(initialDate.month),
    );
    _dayCtrl = FixedExtentScrollController(
      initialItem: days.value.indexOf(initialDate.day),
    );
    _yearCtrl = FixedExtentScrollController(
      initialItem: years.indexOf(initialDate.year),
    );

    _setDateValidityStatus(shouldUpdateSelection: false);
    _trackDateValidity();
  }

  DateTime get _minDate {
    return widget.minDate ?? DateTime(1900);
  }

  DateTime get _maxDate {
    return widget.maxDate ?? DateTime.now();
  }

  int get _maxMonthIndex {
    return _maxDate.months.indexOf(_maxDate.month);
  }

  int get _maxDayIndex {
    return days.value.indexOf(_maxDate.day);
  }

  int get _maxYearIndex {
    return years.indexOf(_maxDate.year);
  }

  DateTime get initialDate {
    return widget.initialDate ?? _maxDate;
  }

  void _trackDateValidity() {
    _monthCtrl.addListener(_setDateValidityStatus);
    _yearCtrl.addListener(_setDateValidityStatus);
    _dayCtrl.addListener(_setDateValidityStatus);
  }

  void _setDateValidityStatus({bool shouldUpdateSelection = true}) {
    final currentDate = DateTime(year.value, month.value, day.value);
    final isValidDate = currentDate <= _maxDate && currentDate >= _minDate;
    if (!isValidDate && shouldUpdateSelection) {
      _goToCtrlPosition(_monthCtrl, _maxMonthIndex, () {
        _goToCtrlPosition(_dayCtrl, _maxDayIndex, () {
          _goToCtrlPosition(_yearCtrl, _maxYearIndex);
        });
      });
    }
  }

  void _goToCtrlPosition(
    FixedExtentScrollController controller, [
    int? index,
    OnPressed? onCompletion,
  ]) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.animateToItem(
        index ?? controller.initialItem,
        duration: const Duration(milliseconds: 100),
        curve: Curves.decelerate,
      );
      if (onCompletion != null) {
        onCompletion();
      }
    });
  }

  void _selectDate() {
    final selectedDate = DateTime(year.value, month.value, day.value);
    widget.onChangeDate(selectedDate);
    context.pop();
  }

  @override
  void dispose() {
    day.dispose();
    year.dispose();
    month.dispose();
    days.dispose();
    _monthCtrl.dispose();
    _yearCtrl.dispose();
    _dayCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GtBasePicker(
      onSelect: _selectDate,
      picker: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: ValueListenableBuilder<int>(
              valueListenable: month,
              builder: (context, currentMonth, _) {
                return WheelScrollSheet<int>(
                  key: const Key("month::wheel"),
                  selectedData: currentMonth,
                  onSelect: (newMonth) => month.value = newMonth,
                  controller: _monthCtrl,
                  items: [
                    for (final month in _minDate.months)
                      GtWheelScrollData(
                        data: month,
                        label: month.asMonthName.ctr(),
                        index: month - 1,
                      ),
                  ],
                );
              },
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: ValueListenableBuilder<List<int>>(
              valueListenable: days,
              builder: (context, days, _) {
                return ValueListenableBuilder<int>(
                  valueListenable: day,
                  builder: (context, currentDay, _) {
                    return WheelScrollSheet<int>(
                      key: Key("$days"),
                      selectedData: currentDay,
                      onSelect: (newDay) => day.value = newDay,
                      controller: _dayCtrl,
                      items: [
                        for (final day in days)
                          GtWheelScrollData(
                            data: day,
                            label: "$day",
                            index: day - 1,
                          ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: ValueListenableBuilder<int>(
              valueListenable: year,
              builder: (context, currentYear, _) {
                return WheelScrollSheet<int>(
                  key: const Key("year::wheel"),
                  onSelect: (newYear) => year.value = newYear,
                  selectedData: currentYear,
                  controller: _yearCtrl,
                  items: [
                    for (final year in years)
                      GtWheelScrollData(
                        data: year,
                        label: "$year",
                        index: years.indexOf(year),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

extension on num {
  String get asMonthName => switch (this) {
    1 => "january",
    2 => "february",
    3 => "march",
    4 => "april",
    5 => "may",
    6 => "june",
    7 => "july",
    8 => "august",
    9 => "september",
    10 => "october",
    11 => "november",
    12 => "december",
    _ => "",
  };
}
