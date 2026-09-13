import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtWheelScroll', type: GtWheelScroll)
Widget playgroundGtWheelScrollUseCase(BuildContext context) {
  return const _WheelScrollPreview();
}

@widgetbook.UseCase(name: 'GtDateWheelScroll', type: GtDateWheelScroll)
Widget playgroundGtDateWheelScrollUseCase(BuildContext context) {
  return const _DateWheelScrollPreview();
}

@widgetbook.UseCase(name: 'GtWheelScrollModal', type: GtWheelScrollModal)
Widget playgroundGtWheelScrollModalUseCase(BuildContext context) {
  return const _WheelScrollModalPreview();
}

final _years = [
  for (int year = 2020; year <= 2035; year++)
    GtWheelScrollData(data: year, label: "$year", index: year - 2020),
];

const _fieldPresets = ['Day, Month, Year', 'Month, Year', 'Year'];

const _rangePresets = ['Default', 'Future only', 'Past only'];

Set<GtDateWheelField> _getFields(String preset) {
  return switch (preset) {
    'Month, Year' => {GtDateWheelField.month, GtDateWheelField.year},
    'Year' => {GtDateWheelField.year},
    _ => GtDateWheelField.values.toSet(),
  };
}

DateTimeRange? _getDateRange(String preset) {
  final today = DateUtils.dateOnly(DateTime.now());
  return switch (preset) {
    'Future only' => DateTimeRange(
      start: today,
      end: DateTime(today.year + 10, today.month, today.day),
    ),
    'Past only' => DateTimeRange(
      start: DateTime(today.year - 10, today.month, today.day),
      end: today,
    ),
    _ => null,
  };
}

String _getFieldsCode(String preset) {
  return switch (preset) {
    'Month, Year' => "{.month, .year}",
    'Year' => "{.year}",
    _ => "{.day, .month, .year}",
  };
}

Gradient _getCustomFadeGradient(BuildContext context) {
  final visible = context.palette.bg.strong;
  return LinearGradient(
    begin: .topCenter,
    end: .bottomCenter,
    colors: [visible.setOpacity(.3), visible, visible.setOpacity(.3)],
  );
}

GtWheelScrollGroup _buildConfiguredWheelScrollBody({
  required int year,
  required GtWheelScrollSize size,
  required bool showLabel,
  required bool isEnabled,
  required TextStyle? selectedStyle,
  required Decoration? selectedDecoration,
  required Gradient? fadeGradient,
  required OnChanged<GtWheelScrollData<int>> onChanged,
}) {
  return GtWheelScrollGroup(
    children: [
      GtWheelScroll<int>(
        items: _years,
        value: year,
        label: showLabel ? "Year" : null,
        semanticsLabel: "Year",
        size: size,
        isEnabled: isEnabled,
        selectedStyle: selectedStyle,
        selectedDecoration: selectedDecoration,
        fadeGradient: fadeGradient,
        onChanged: onChanged,
      ),
    ],
  );
}

Widget _buildSelectedDateLabel(GtCalendarController controller) {
  return GenericListener(
    valueListenable: controller,
    builder: (value) {
      final day = value.day?.format("EEE, dd MMM yyyy") ?? "No date selected";
      return GtText("Selected date: $day", textAlign: .center);
    },
  );
}

class _WheelScrollPreview extends GtStatefulWidget {
  const _WheelScrollPreview();

  @override
  State<_WheelScrollPreview> createState() => _WheelScrollPreviewState();
}

class _WheelScrollPreviewState extends State<_WheelScrollPreview> {
  int _year = 2020;

  @override
  Widget build(BuildContext context) {
    final size = context.knobs.object.dropdown(
      label: "Size",
      options: GtWheelScrollSize.values,
      initialOption: GtWheelScrollSize.large,
      labelBuilder: (value) => value.name.capitalise(),
    );
    final showLabel = context.knobs.boolean(
      label: "Show Label",
      initialValue: false,
    );
    final isEnabled = context.knobs.boolean(
      label: "Enabled",
      initialValue: true,
    );
    final custom = context.knobs.boolean(
      label: "Custom styling",
      initialValue: false,
    );

    return GtWidgetDocPage(
      title: 'GtWheelScroll',
      description: 'Documentation for GtWheelScroll',
      code:
          '''
GtWheelScrollGroup(
  children: [
    GtWheelScroll<int>(
      items: [
        for (int year = 2020; year <= 2035; year++)
          GtWheelScrollData(data: year, label: "\$year", index: year - 2020),
      ],
      value: $_year,${showLabel ? '\n      label: "Year",' : ''}
      semanticsLabel: "Year",
      size: .${size.name},
      isEnabled: $isEnabled,
      // Set custom to false (or omit these inputs) for the original defaults.
      selectedStyle: $custom
          ? context.textStyles.subHeadM(color: context.palette.primary.dark)
          : null,
      selectedDecoration: $custom
          ? BoxDecoration(
              color: context.palette.primary.alpha16,
              borderRadius: context.borderRadiusXl,
            )
          : null,
      fadeGradient: $custom
          ? LinearGradient(
              begin: .topCenter,
              end: .bottomCenter,
              colors: [
                context.palette.bg.strong.setOpacity(.3),
                context.palette.bg.strong,
                context.palette.bg.strong.setOpacity(.3),
              ],
            )
          : null,
      onChanged: (item) => setState(() => year = item.data),
    ),
  ],
)
''',
      child: Column(
        crossAxisAlignment: .stretch,
        mainAxisSize: .min,
        children: [
          GtText("Selected year: $_year", textAlign: .center),
          const GtGap.yLg(),
          _buildConfiguredWheelScrollBody(
            year: _year,
            size: size,
            showLabel: showLabel,
            isEnabled: isEnabled,
            selectedStyle: custom
                ? context.textStyles.subHeadM(
                    color: context.palette.primary.dark,
                  )
                : null,
            selectedDecoration: custom
                ? BoxDecoration(
                    color: context.palette.primary.alpha16,
                    borderRadius: context.borderRadiusXl,
                  )
                : null,
            fadeGradient: custom ? _getCustomFadeGradient(context) : null,
            onChanged: (item) => setState(() => _year = item.data),
          ),
        ],
      ),
    );
  }
}

class _DateWheelScrollPreview extends GtStatefulWidget {
  const _DateWheelScrollPreview();

  @override
  State<_DateWheelScrollPreview> createState() =>
      _DateWheelScrollPreviewState();
}

class _DateWheelScrollPreviewState extends State<_DateWheelScrollPreview> {
  final _controllers = <String, GtCalendarController>{};

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fieldsPreset = context.knobs.object.dropdown(
      label: "Fields",
      options: _fieldPresets,
      initialOption: _fieldPresets.first,
    );
    final rangePreset = context.knobs.object.dropdown(
      label: "Selectable Range",
      options: _rangePresets,
      initialOption: _rangePresets.first,
    );
    final size = context.knobs.object.dropdown(
      label: "Size",
      options: GtWheelScrollSize.values,
      initialOption: GtWheelScrollSize.regular,
      labelBuilder: (value) => value.name.capitalise(),
    );
    final showLabels = context.knobs.boolean(
      label: "Show Labels",
      initialValue: true,
    );
    final isEnabled = context.knobs.boolean(
      label: "Enabled",
      initialValue: true,
    );
    final custom = context.knobs.boolean(
      label: "Custom styling",
      initialValue: false,
    );

    final controller = _controllers.putIfAbsent(
      rangePreset,
      () => GtCalendarController(
        GtCalendarValue(),
        dateRange: _getDateRange(rangePreset),
      ),
    );

    return GtWidgetDocPage(
      title: 'GtDateWheelScroll',
      description: 'Documentation for GtDateWheelScroll',
      code:
          '''
GtDateWheelScroll(
  controller: GtCalendarController(GtCalendarValue()),
  fields: ${_getFieldsCode(fieldsPreset)},
  size: .${size.name},
  showLabels: $showLabels,
  isEnabled: $isEnabled,
  // Set custom to false (or omit these inputs) for the original defaults.
  selectedStyle: $custom
      ? context.textStyles.subHeadM(color: context.palette.primary.dark)
      : null,
  selectedDecoration: $custom
      ? BoxDecoration(
          color: context.palette.primary.alpha16,
          borderRadius: context.borderRadiusXl,
        )
      : null,
  fadeGradient: $custom
      ? LinearGradient(
          begin: .topCenter,
          end: .bottomCenter,
          colors: [
            context.palette.bg.strong.setOpacity(.3),
            context.palette.bg.strong,
            context.palette.bg.strong.setOpacity(.3),
          ],
        )
      : null,
)
''',
      child: Column(
        crossAxisAlignment: .stretch,
        mainAxisSize: .min,
        children: [
          _buildSelectedDateLabel(controller),
          const GtGap.yLg(),
          GtDateWheelScroll(
            controller: controller,
            fields: _getFields(fieldsPreset),
            size: size,
            showLabels: showLabels,
            isEnabled: isEnabled,
            selectedStyle: custom
                ? context.textStyles.subHeadM(
                    color: context.palette.primary.dark,
                  )
                : null,
            selectedDecoration: custom
                ? BoxDecoration(
                    color: context.palette.primary.alpha16,
                    borderRadius: context.borderRadiusXl,
                  )
                : null,
            fadeGradient: custom ? _getCustomFadeGradient(context) : null,
          ),
        ],
      ),
    );
  }
}

class _WheelScrollModalPreview extends GtStatefulWidget {
  const _WheelScrollModalPreview();

  @override
  State<_WheelScrollModalPreview> createState() =>
      _WheelScrollModalPreviewState();
}

class _WheelScrollModalPreviewState extends State<_WheelScrollModalPreview>
    with GtBottomSheetMixin {
  final _controller = GtCalendarController(GtCalendarValue());

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = context.knobs.string(
      label: "Title",
      initialValue: "Till when",
    );

    return GtWidgetDocPage(
      title: 'GtWheelScrollModal',
      description: 'Documentation for GtWheelScrollModal',
      code:
          '''
showDraggableSheet(
  context,
  builder: (scrollController) => GtWheelScrollModal(
    scrollController,
    title: "$title",
    child: GtDateWheelScroll(controller: controller),
  ),
);
''',
      child: Column(
        crossAxisAlignment: .stretch,
        mainAxisSize: .min,
        children: [
          _buildSelectedDateLabel(_controller),
          const GtGap.yLg(),
          GtRaisedButton(
            text: "Open wheel sheet",
            onPressed: () {
              showDraggableSheet(
                context,
                builder: (scrollController) => GtWheelScrollModal(
                  scrollController,
                  title: title,
                  child: GtDateWheelScroll(controller: _controller),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
