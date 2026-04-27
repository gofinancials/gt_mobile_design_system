import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:table_calendar/table_calendar.dart';

class GtCalendar extends GtStatefulWidget {
  final GtCalendarController? controller;
  final GtCalendarSelectionMode selectionMode;
  final OnChanged<DateTime>? onSelectDay;
  final OnChanged<DateTimeRange>? onSelectRange;

  const GtCalendar({
    super.key,
    this.controller,
    this.onSelectDay,
    this.onSelectRange,
    this.selectionMode = .day,
  });

  @override
  State<GtCalendar> createState() => _GtCalendarState();
}

class _GtCalendarState extends State<GtCalendar> {
  late final GtCalendarController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? GtCalendarController(GtCalendarValue());
  }

  @override
  Widget build(BuildContext context) {
    final style = context.textStyles;
    final palette = context.palette;
    final textColors = palette.text;
    final insets = context.insets;

    return GtCard(
      padding: insets.symmetricDp(vertical: 2.px),
      child: GenericListener(
        valueListenable: controller,
        builder: (value) {
          final focusedDay = value.day;
          final selectedRange = switch (widget.selectionMode) {
            .range => value.range,
            _ => null,
          };

          return TableCalendar(
            firstDay: controller.firstDay,
            lastDay: controller.lastDay,
            pageAnimationEnabled: false,
            focusedDay: focusedDay ?? controller.today,
            currentDay: focusedDay,
            rangeStartDay: selectedRange?.start,
            rangeEndDay: selectedRange?.end,
            calendarFormat: .month,
            startingDayOfWeek: .monday,
            rowHeight: 40,
            rangeSelectionMode: switch (widget.selectionMode) {
              .range => .enforced,
              _ => .disabled,
            },
            daysOfWeekHeight: 40,
            selectedDayPredicate: (day) => switch (widget.selectionMode) {
              .range => false,
              _ => day.isSameDay(focusedDay),
            },
            calendarBuilders: CalendarBuilders(
              headerTitleBuilder: (context, day) {
                return _GtCalendarHeader(
                  day.format("MMM yyyy"),
                  controller: controller,
                );
              },
              selectedBuilder: (context, day, focusedDay) {
                return GtCalendarCell(
                  day.format("d"),
                  textColor: palette.staticColors.white,
                  borderRadius: context.borderRadiusMd,
                  bgColor: palette.primary.base,
                );
              },
              rangeStartBuilder: (context, day, focusedDay) {
                return GtCalendarCell(
                  day.format("d"),
                  textColor: palette.staticColors.white,
                  borderRadius: BorderRadius.horizontal(left: context.radiusMd),
                  bgColor: palette.primary.base,
                );
              },
              rangeEndBuilder: (context, day, focusedDay) {
                return GtCalendarCell(
                  day.format("d"),
                  textColor: palette.staticColors.white,
                  borderRadius: BorderRadius.horizontal(
                    right: context.radiusMd,
                  ),
                  bgColor: palette.primary.base,
                );
              },
              withinRangeBuilder: (context, day, focusedDay) {
                return GtCalendarCell(day.format("d"));
              },
              defaultBuilder: (context, day, focusedDay) {
                return GtCalendarCell(day.format("d"));
              },
              dowBuilder: (context, date) {
                final day = date.format("EE").substring(0, 2).upper;
                return GtCalendarCell(day, textColor: textColors.soft);
              },
            ),
            calendarStyle: CalendarStyle(
              isTodayHighlighted: false,
              tablePadding: insets.allDp(12.px),
              outsideTextStyle: style.calendar(color: textColors.disabled),
              cellPadding: .zero,
              rangeHighlightColor: palette.primary.alpha10,
              rangeHighlightScale: 2,
            ),
            onDaySelected: (selectedDay, day) {
              controller.day = selectedDay;
              widget.onSelectDay?.call(selectedDay);
            },
            onRangeSelected: (start, end, focusedDay) {
              if (start == null || end == null) return;
              final range = DateTimeRange(start: start, end: end);
              controller.range = range;
              widget.onSelectRange?.call(range);
            },
            headerStyle: HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
              formatButtonShowsNext: false,
              leftChevronIcon: GtIcon(
                GtIcons.chevronLeft,
                variant: .soft,
                alignment: .centerLeft,
                size: 16,
              ),
              rightChevronIcon: GtIcon(
                GtIcons.chevronRight,
                variant: .soft,
                alignment: .centerRight,
                size: 16,
              ),
            ),
          );
        },
      ),
    );
  }
}

class GtCalendarCell extends GtStatelessWidget {
  final String day;
  final Color? textColor;
  final Color bgColor;
  final BorderRadius borderRadius;

  const GtCalendarCell(
    this.day, {
    super.key,
    this.textColor,
    this.bgColor = Colors.transparent,
    this.borderRadius = .zero,
  });

  @override
  Widget build(BuildContext context) {
    final style = context.textStyles;
    final palette = context.palette;
    final color = textColor ?? palette.text.darkerSub;

    final textStyle = style.calendar(color: color);

    return GtSquareConstrainedBox(
      40,
      child: AnimatedContainer(
        duration: 500.milliseconds,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: bgColor,
          shape: .rectangle,
        ),
        child: Center(
          child: GtText(day, style: textStyle, textAlign: .center),
        ),
      ),
    );
  }
}

class _GtCalendarHeader extends GtStatelessWidget {
  final String day;
  final GtCalendarController controller;

  const _GtCalendarHeader(this.day, {required this.controller});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final style = context.textStyles.calendar(color: palette.text.darkerSub);

    return InkWell(
      onTap: () async {
        final year = await showDatePicker(
          context: context,
          firstDate: controller.firstDay,
          lastDate: controller.lastDay,
          initialDate: controller.day ?? controller.today,
          initialDatePickerMode: .year,
        );
        if (year == null) return;
        controller.day = year;
      },
      child: Padding(
        padding: context.insets.symmetricDp(vertical: 12.px),
        child: Row(
          spacing: context.spacingBase,
          mainAxisAlignment: .center,
          children: [
            GtText(day, style: style),
            GtIcon(GtIcons.chevronDown, variant: .soft, size: 14),
          ],
        ),
      ),
    );
  }
}
