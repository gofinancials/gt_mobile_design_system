import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:table_calendar/table_calendar.dart';

/// A highly customizable calendar widget for the GT Mobile Design System.
///
/// [GtCalendar] supports single day and date range selection modes. It integrates
/// with the `table_calendar` package and aligns with the design system's styling.
///
/// In [GtCalendarSelectionMode.range] the first tap marks a start, which the
/// [controller] holds as [GtCalendarValue.pendingRangeStart], and the next tap
/// finishes the range, whichever way round; tapping the start again finishes
/// a one-day range. [onSelectRange] fires only for a finished range.
///
/// Days before [GtCalendarController.firstDay] or after
/// [GtCalendarController.lastDay] are drawn in the disabled text color and
/// ignore taps.
class GtCalendar extends GtStatefulWidget {
  /// The controller used to manage the calendar's focused day and selection state.
  final GtCalendarController? controller;

  /// Defines the selection behavior of the calendar (e.g., single day or date range).
  ///
  /// Defaults to [GtCalendarSelectionMode.day].
  final GtCalendarSelectionMode selectionMode;

  /// Callback triggered when a specific day is selected.
  final OnChanged<DateTime>? onSelectDay;

  /// Callback triggered when a date range is finished, after its second tap.
  final OnChanged<DateTimeRange>? onSelectRange;

  /// Creates a [GtCalendar] widget.
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

/// The state for [GtCalendar].
class _GtCalendarState extends State<GtCalendar> {
  /// The controller in use, either [GtCalendar.controller] or one created
  /// locally.
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
          final isRange = widget.selectionMode == .range;
          final focusedDay = value.day;
          final firstDay = controller.firstDay;
          final lastDay = controller.lastDay;
          final rangeEnd = isRange ? value.rangeEnd : null;

          // The calendar must focus a day inside its limits, which may now
          // end before today or exclude a day picked before they changed.
          DateTime focus = focusedDay ?? controller.today;
          if (focus.isBefore(firstDay)) focus = firstDay;
          if (focus.isAfter(lastDay)) focus = lastDay;

          return TableCalendar(
            firstDay: firstDay,
            lastDay: lastDay,
            pageAnimationEnabled: false,
            focusedDay: focus,
            currentDay: controller.today,
            rangeStartDay: isRange ? value.rangeStart : null,
            rangeEndDay: rangeEnd,
            calendarFormat: .month,
            startingDayOfWeek: .monday,
            rowHeight: 40,
            // Range taps are handled here rather than by table_calendar, which
            // keeps a pending start of its own and ignores a second tap on it.
            rangeSelectionMode: .disabled,
            daysOfWeekHeight: 40,
            selectedDayPredicate: (day) {
              if (isRange) return false;
              return day.isSameDay(focusedDay);
            },
            calendarBuilders: CalendarBuilders(
              headerTitleBuilder: (context, day) {
                return _GtCalendarHeader(
                  day.format("MMMM yyyy"),
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
                // A start awaiting its end, or a one-day range, stands alone.
                BorderRadius borderRadius = BorderRadius.horizontal(
                  left: context.radiusMd,
                );
                if (rangeEnd == null || rangeEnd.isSameDay(day)) {
                  borderRadius = context.borderRadiusMd;
                }
                return GtCalendarCell(
                  day.format("d"),
                  textColor: palette.staticColors.white,
                  borderRadius: borderRadius,
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
              disabledBuilder: (context, day, focusedDay) {
                return GtCalendarCell(
                  day.format("d"),
                  textColor: textColors.disabled,
                );
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
              if (isRange) {
                final range = controller.pickRangeDay(selectedDay);
                if (range != null) widget.onSelectRange?.call(range);
                return;
              }
              controller.day = selectedDay;
              widget.onSelectDay?.call(selectedDay);
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

/// A standardized widget representing a single day cell within the [GtCalendar].
class GtCalendarCell extends GtStatelessWidget {
  /// The string representation of the day (e.g., "15" or "MO").
  final String day;

  /// The color of the day text. Defaults to the theme's darker subtext color.
  final Color? textColor;

  /// The background color of the cell. Defaults to [Colors.transparent].
  final Color bgColor;

  /// The border radius applied to the cell's background. Defaults to [.zero].
  final BorderRadius borderRadius;

  /// Creates a [GtCalendarCell].
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

/// A private widget that shows the calendar's month and year, and opens a
/// month and year [GtDateWheelScroll] in a bottom sheet to jump to another
/// month.
///
/// The month wheel shows short names, such as "Sep", so that they fit the
/// wheel's width.
class _GtCalendarHeader extends GtStatelessWidget with GtBottomSheetMixin {
  /// The formatted month and year shown in the header.
  final String day;

  /// The controller whose day the date wheel updates.
  final GtCalendarController controller;

  /// Creates a [_GtCalendarHeader].
  const _GtCalendarHeader(this.day, {required this.controller});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final style = context.textStyles.calendar(color: palette.text.darkerSub);

    return GtInkWell(
      role: .button,
      borderRadius: context.borderRadius2Xl,
      onTap: () {
        showDraggableSheet(
          context,
          useRootNavigator: false,
          builder: (scrollController) => GtWheelScrollModal(
            scrollController,
            child: GtDateWheelScroll(
              controller: controller,
              fields: const {.month, .year},
              monthFormat: "MMM",
            ),
          ),
        );
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

/// A bottom sheet modal that presents a calendar for date or date range selection.
///
/// This widget is typically used within a bottom sheet to provide a dedicated
/// interface for selecting dates, such as in [GtDateField].
class GtCalendarModal extends GtStatefulWidget {
  /// The scroll controller used for the modal's scrollable view.
  final ScrollController scrollController;

  /// The controller used to manage the calendar's state.
  final GtCalendarController controller;

  /// The title displayed at the top of the modal.
  final String title;

  /// Defines whether the user can select a single day or a date range.
  final GtCalendarSelectionMode selectionMode;

  /// Callback triggered when a specific day is selected.
  final OnChanged<DateTime>? onSelectDay;

  /// Callback triggered when a date range is finished, after its second tap.
  final OnChanged<DateTimeRange>? onSelectRange;

  /// The caption over the start of the range, already localised, such as
  /// "Start" or "From".
  ///
  /// In [GtCalendarSelectionMode.range], when both this and [rangeEndLabel]
  /// are set, a pair of boxes above the calendar shows each end of the range
  /// as it is picked and outlines the end the next tap sets: the start, then
  /// the end once a start is picked. Without both labels the pair is not
  /// shown. No default is provided, as the design system has no dictionary
  /// of its own.
  final String? rangeStartLabel;

  /// The caption over the end of the range, already localised, such as "End"
  /// or "To".
  ///
  /// See [rangeStartLabel].
  final String? rangeEndLabel;

  /// The format of the dates in the range pair. Defaults to `'dd-MM-yyyy'`.
  ///
  /// An end not yet picked shows the format itself in capitals, such as
  /// "DD-MM-YYYY".
  final String dateFormat;

  /// Creates a [GtCalendarModal].
  const GtCalendarModal(
    this.scrollController, {
    super.key,
    required this.controller,
    required this.title,
    this.selectionMode = .day,
    this.onSelectDay,
    this.onSelectRange,
    this.rangeStartLabel,
    this.rangeEndLabel,
    this.dateFormat = 'dd-MM-yyyy',
  });

  @override
  State<GtCalendarModal> createState() => _GtCalendarModalState();
}

/// The state for [GtCalendarModal].
class _GtCalendarModalState extends State<GtCalendarModal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: context.insets.symmetricDp(vertical: 24.px, horizontal: 16.px),
      child: SingleChildScrollView(
        controller: widget.scrollController,
        child: Column(
          spacing: context.spacingLg,
          crossAxisAlignment: .stretch,
          children: [
            GtTitleAppBar(
              title: widget.title,
              primary: false,
              trailing: GtOptionalWidgetPair(tail: GtCancelButton()),
            ),
            if ((
                  widget.selectionMode,
                  widget.rangeStartLabel,
                  widget.rangeEndLabel,
                )
                case (.range, final startLabel?, final endLabel?))
              _GtCalendarRangeEnds(
                controller: widget.controller,
                startLabel: startLabel,
                endLabel: endLabel,
                dateFormat: widget.dateFormat,
              ),
            GtCalendar(
              controller: widget.controller,
              selectionMode: widget.selectionMode,
              onSelectDay: widget.onSelectDay,
              onSelectRange: widget.onSelectRange,
            ),
          ],
        ),
      ),
    );
  }
}

/// A private pair of boxes showing the start and end of the range being
/// picked in a [GtCalendarModal], outlining the end the next tap sets.
class _GtCalendarRangeEnds extends GtStatelessWidget {
  /// The controller whose range is shown.
  final GtCalendarController controller;

  /// The caption over the start.
  final String startLabel;

  /// The caption over the end.
  final String endLabel;

  /// The format of the dates shown.
  final String dateFormat;

  /// Creates a [_GtCalendarRangeEnds].
  const _GtCalendarRangeEnds({
    required this.controller,
    required this.startLabel,
    required this.endLabel,
    required this.dateFormat,
  });

  @override
  Widget build(BuildContext context) {
    return GenericListener(
      valueListenable: controller,
      builder: (value) {
        final pickingEnd = value.isPickingRangeEnd;
        return Row(
          spacing: context.spacingBase,
          children: [
            Expanded(
              child: _GtCalendarRangeEnd(
                label: startLabel,
                date: value.rangeStart?.format(dateFormat),
                placeholder: dateFormat.toUpperCase(),
                awaiting: !pickingEnd,
              ),
            ),
            Expanded(
              child: _GtCalendarRangeEnd(
                label: endLabel,
                date: value.rangeEnd?.format(dateFormat),
                placeholder: dateFormat.toUpperCase(),
                awaiting: pickingEnd,
              ),
            ),
          ],
        );
      },
    );
  }
}

/// A private box showing one end of the range in [_GtCalendarRangeEnds].
class _GtCalendarRangeEnd extends GtStatelessWidget {
  /// The caption naming this end.
  final String label;

  /// The formatted date of this end, or null when it is not picked.
  final String? date;

  /// What shows in place of [date] before it is picked.
  final String placeholder;

  /// Whether the next tap on the calendar sets this end.
  final bool awaiting;

  /// Creates a [_GtCalendarRangeEnd].
  const _GtCalendarRangeEnd({
    required this.label,
    required this.date,
    required this.placeholder,
    required this.awaiting,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final styles = context.textStyles;

    Color borderColor = palette.stroke.soft;
    Color bgColor = Colors.transparent;
    if (awaiting) {
      borderColor = palette.primary.base;
      bgColor = palette.primary.alpha10;
    }

    // Plain Semantics: GtSemantics reports selection only for tabs, and the
    // box is not one. Selected marks the end the next tap sets.
    return Semantics(
      label: '$label, ${date ?? placeholder}',
      selected: awaiting,
      container: true,
      excludeSemantics: true,
      child: AnimatedContainer(
        duration: 200.milliseconds,
        padding: context.insets.symmetricDp(vertical: 6.px, horizontal: 10.px),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: context.borderRadiusMd,
          border: Border.all(color: borderColor),
        ),
        child: Row(
          spacing: context.spacingSm,
          children: [
            GtText(label, style: styles.labelXs(color: palette.text.soft)),
            Expanded(
              child: GtText(
                date ?? placeholder,
                maxLines: 1,
                overflow: .ellipsis,
                textAlign: .end,
                style: styles.labelXs(
                  weight: .w500,
                  color: date == null ? palette.text.soft : palette.text.strong,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
