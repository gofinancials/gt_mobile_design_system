import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtTimeField', type: GtTimeField)
Widget playgroundGtTimeFieldUseCase(BuildContext context) {
  return const _TimeFieldPreview();
}

@widgetbook.UseCase(name: 'GtTimeWheelScroll', type: GtTimeWheelScroll)
Widget playgroundGtTimeWheelScrollUseCase(BuildContext context) {
  return const _TimeWheelScrollPreview();
}

const _formats = ['HH:mm', 'HH:mm:ss', 'hh:mm a', 'h:mm:ss a'];

const _steps = [1, 5, 15, 30];

const _limitOptions = ['None', 'From now', 'Business hours (09:00–17:00)'];

/// The earliest and latest times a preview can apply, by knob label.
(TimeOfDay?, TimeOfDay?) _limitsFor(String option) {
  return switch (option) {
    'From now' => (TimeOfDay.now(), null),
    'Business hours (09:00–17:00)' => (
      const TimeOfDay(hour: 9, minute: 0),
      const TimeOfDay(hour: 17, minute: 0),
    ),
    _ => (null, null),
  };
}

String _limitsSnippet(String option) {
  return switch (option) {
    'From now' =>
      '\n// For a time later today; move it on when the date changes:\n'
          '_timeCtrl.setLimits(earliest: TimeOfDay.now());\n',
    'Business hours (09:00–17:00)' =>
      '\n_timeCtrl.setLimits(\n'
          '  earliest: const TimeOfDay(hour: 9, minute: 0),\n'
          '  latest: const TimeOfDay(hour: 17, minute: 0),\n'
          ');\n',
    _ => '',
  };
}

/// Shows the controller's time, or that none is picked.
Widget _buildPickedLabel(GtTimeController controller, String format) {
  return GenericListener(
    valueListenable: controller,
    builder: (value) {
      final time = value?.format(format) ?? 'No time picked';
      return GtText('Picked time: $time', textAlign: .center);
    },
  );
}

/// The knobs both previews share, applying the limits to [controller] after
/// the frame, as setting them notifies the wheels mid-build otherwise.
mixin _TimeKnobs<T extends StatefulWidget> on State<T> {
  final controller = GtTimeController();
  String _appliedLimits = _limitOptions.first;

  void applyLimits(String option) {
    if (option == _appliedLimits) return;
    _appliedLimits = option;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final (earliest, latest) = _limitsFor(option);
      controller.setLimits(earliest: earliest, latest: latest);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  String formatKnob() {
    return context.knobs.object.dropdown<String>(
      label: 'Time Format',
      options: _formats,
      initialOption: _formats.first,
    );
  }

  int stepKnob() {
    return context.knobs.object.dropdown<int>(
      label: 'Minute Step',
      options: _steps,
      initialOption: _steps.first,
    );
  }

  String limitsKnob() {
    final limits = context.knobs.object.dropdown<String>(
      label: 'Time Limits',
      options: _limitOptions,
      initialOption: _limitOptions.first,
    );
    applyLimits(limits);
    return limits;
  }
}

class _TimeFieldPreview extends GtStatefulWidget {
  const _TimeFieldPreview();

  @override
  State<_TimeFieldPreview> createState() => _TimeFieldPreviewState();
}

class _TimeFieldPreviewState extends State<_TimeFieldPreview> with _TimeKnobs {
  @override
  Widget build(BuildContext context) {
    final label = context.knobs.string(
      label: 'Label',
      initialValue: 'Schedule time',
    );
    final sheetTitle = context.knobs.string(
      label: 'Sheet Title',
      initialValue: 'Pick a time',
    );
    final format = formatKnob();
    final step = stepKnob();
    final limits = limitsKnob();
    final isEnabled = context.knobs.boolean(
      label: 'Enabled',
      initialValue: true,
    );
    final decoration = context.knobs.object
        .dropdown<(String, GtInputDecoration)>(
          label: 'Input Style',
          options: context.inputStyles.all,
          initialOption: context.inputStyles.all.first,
          labelBuilder: (v) => v.$1,
        );

    return GtWidgetDocPage(
      title: 'GtTimeField',
      description: '''
<b>GtTimeField</b> is a time input that opens a sheet of wheels on tap and shows the picked time in <b>timeFormat</b>.

The format decides the wheels too: <b>HH:mm</b> shows hours and minutes, <b>HH:mm:ss</b> adds seconds, and <b>hh:mm a</b> shows 12-hour hours with an AM/PM wheel in the app's locale. <b>minuteStep</b> thins the minute wheel, such as 15 for quarter hours; it defaults to 1.

The <b>GtTimeController</b> holds the time and its <b>earliest</b> and <b>latest</b> times; hours with no step inside them leave the wheel. Opening the sheet on an empty field picks the time the wheels first show. Try the Time Limits knob.''',
      code:
          '''
final _timeCtrl = GtTimeController();
${_limitsSnippet(limits)}
GtTimeField(
  controller: _timeCtrl,
  label: '$label',
  sheetTitle: '$sheetTitle',
  timeFormat: '$format',${step == 1 ? '' : '\n  minuteStep: $step,'}
  isEnabled: $isEnabled,
  validator: (time) => time == null ? 'Pick a time' : null,
  decoration: /* Selected: ${decoration.$1} */,
)''',
      child: SizedBox(
        width: 320.px,
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .stretch,
          children: [
            GtTimeField(
              controller: controller,
              label: label,
              sheetTitle: sheetTitle.isEmpty ? null : sheetTitle,
              timeFormat: format,
              minuteStep: step,
              isEnabled: isEnabled,
              decoration: decoration.$2,
            ),
            const GtGap.yLg(),
            _buildPickedLabel(controller, format),
          ],
        ),
      ),
    );
  }
}

class _TimeWheelScrollPreview extends GtStatefulWidget {
  const _TimeWheelScrollPreview();

  @override
  State<_TimeWheelScrollPreview> createState() =>
      _TimeWheelScrollPreviewState();
}

class _TimeWheelScrollPreviewState extends State<_TimeWheelScrollPreview>
    with _TimeKnobs {
  @override
  Widget build(BuildContext context) {
    final format = formatKnob();
    final step = stepKnob();
    final limits = limitsKnob();
    final showLabels = context.knobs.boolean(
      label: 'Show Labels',
      initialValue: true,
    );
    final isEnabled = context.knobs.boolean(
      label: 'Enabled',
      initialValue: true,
    );

    return GtWidgetDocPage(
      title: 'GtTimeWheelScroll',
      description:
          'Hour, minute and, as the pattern needs, second and AM/PM wheels '
          'for a screen that shows the time picker inline. It reads and '
          'writes a GtTimeController and offers only times within its '
          'limits, at the minute step.',
      code:
          '''
final _timeCtrl = GtTimeController();
${_limitsSnippet(limits)}
GtTimeWheelScroll(
  controller: _timeCtrl,
  pattern: '$format',${step == 1 ? '' : '\n  minuteStep: $step,'}
  showLabels: $showLabels,
  isEnabled: $isEnabled,
)''',
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        children: [
          _buildPickedLabel(controller, format),
          const GtGap.yLg(),
          GtTimeWheelScroll(
            controller: controller,
            pattern: format,
            minuteStep: step,
            showLabels: showLabels,
            isEnabled: isEnabled,
          ),
        ],
      ),
    );
  }
}
