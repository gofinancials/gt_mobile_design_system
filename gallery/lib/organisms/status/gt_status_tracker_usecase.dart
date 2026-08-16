import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/extensions/string_extensions.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtStatusTracker', type: GtStatusTracker)
Widget playgroundGtStatusTrackerUseCase(BuildContext context) {
  return const _StatusTrackerGalleryView();
}

class _StatusTrackerGalleryView extends StatefulWidget {
  const _StatusTrackerGalleryView();

  @override
  State<_StatusTrackerGalleryView> createState() =>
      _StatusTrackerGalleryViewState();
}

class _StatusTrackerGalleryViewState extends State<_StatusTrackerGalleryView>
    with GtBottomModalMixin {
  @override
  Widget build(BuildContext context) {
    final step1State = context.knobs.object.dropdown(
      label: 'Step 1 State',
      options: GtStatusStepState.values,
      initialOption: GtStatusStepState.success,
      labelBuilder: (s) => s.name,
    );
    final step2State = context.knobs.object.dropdown(
      label: 'Step 2 State',
      options: GtStatusStepState.values,
      initialOption: GtStatusStepState.active,
      labelBuilder: (s) => s.name,
    );
    final step3State = context.knobs.object.dropdown(
      label: 'Step 3 State',
      options: GtStatusStepState.values,
      initialOption: GtStatusStepState.pending,
      labelBuilder: (s) => s.name,
    );

    final step1Label = context.knobs.string(
      label: 'Step 1 Label',
      initialValue: 'Processed',
    );
    final step2Label = context.knobs.string(
      label: 'Step 2 Label',
      initialValue: 'Sending',
    );
    final step3Label = context.knobs.string(
      label: 'Step 3 Label',
      initialValue: 'Delivered',
    );

    final step1Sub = context.knobs.string(
      label: 'Step 1 Subtitle',
      initialValue: '10th Sept, 2025 11:03:00 AM',
    );
    final step2Sub = context.knobs.string(
      label: 'Step 2 Subtitle',
      initialValue: '10th Sept, 2025 11:03:00 AM',
    );
    final step3Sub = context.knobs.stringOrNull(
      label: 'Step 3 Subtitle',
      initialValue: null,
    );

    final currentSteps = [
      GtStatusStepData(
        label: step1Label,
        state: step1State,
        subtitle: step1Sub,
      ),
      GtStatusStepData(
        label: step2Label,
        state: step2State,
        subtitle: step2Sub,
      ),
      GtStatusStepData(
        label: step3Label,
        state: step3State,
        subtitle: step3Sub,
      ),
    ];

    final codeSnippet =
        '''
GtStatusTracker(
  steps: [
    GtStatusStepData(
      label: '$step1Label',
      state: GtStatusStepState.${step1State.name},
      subtitle: '$step1Sub',
    ),
    GtStatusStepData(
      label: '$step2Label',
      state: GtStatusStepState.${step2State.name},
      subtitle: '$step2Sub',
    ),
    GtStatusStepData(
      label: '$step3Label',
      state: GtStatusStepState.${step3State.name},${step3Sub.hasValue ? '\n      subtitle: $step3Sub' : ''},
    ),
  ],
)''';

    return GtWidgetDocPage(
      title: 'GtStatusTracker',
      description: '''
<b>GtStatusTracker</b> renders a vertical multi-step status timeline with semantic state indicators, connecting lines, and automatic terminal checkmarks.

It seamlessly integrates inside floating bottom sheets or standalone card views.''',
      code: codeSnippet,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: context.spacingLg,
        children: [
          GtCard(
            padding: context.insets.allDp(20.px),
            child: GtStatusTracker(steps: currentSteps),
          ),
          Wrap(
            spacing: context.spacingMd,
            runSpacing: context.spacingBase,
            children: [
              _ScenarioChip(
                label: 'Test Processing',
                onTap: () => _openSheetWith(context, [
                  const GtStatusStepData(
                    label: 'Processing',
                    state: GtStatusStepState.active,
                    subtitle: '10th Sept, 2025 11:03:00 AM',
                  ),
                  const GtStatusStepData(
                    label: 'Sent',
                    state: GtStatusStepState.pending,
                  ),
                  const GtStatusStepData(
                    label: 'Delivered',
                    state: GtStatusStepState.pending,
                  ),
                ]),
              ),
              _ScenarioChip(
                label: 'Test Failed Sending',
                onTap: () => _openSheetWith(context, [
                  const GtStatusStepData(
                    label: 'Processed',
                    state: GtStatusStepState.success,
                    subtitle: '10th Sept, 2025 11:03:00 AM',
                  ),
                  const GtStatusStepData(
                    label: 'Sending',
                    state: GtStatusStepState.failed,
                    subtitle: 'Failed. 10th Sept, 2025 11:03:00 AM',
                  ),
                  const GtStatusStepData(
                    label: 'Delivered',
                    state: GtStatusStepState.pending,
                  ),
                ]),
              ),
              _ScenarioChip(
                label: 'Test Reversed',
                onTap: () => _openSheetWith(context, [
                  const GtStatusStepData(
                    label: 'Processed',
                    state: GtStatusStepState.success,
                    subtitle: '10th Sept, 2025 11:03:00 AM',
                  ),
                  const GtStatusStepData(
                    label: 'Sending',
                    state: GtStatusStepState.failed,
                    subtitle: 'Failed. 10th Sept, 2025 11:03:00 AM',
                  ),
                  const GtStatusStepData(
                    label: 'Reversed',
                    state: GtStatusStepState.reversed,
                    subtitle: '10th Sept, 2025 11:03:00 AM',
                  ),
                ]),
              ),
              _ScenarioChip(
                label: 'Test Fully Delivered',
                onTap: () => _openSheetWith(context, [
                  const GtStatusStepData(
                    label: 'Processed',
                    state: GtStatusStepState.success,
                    subtitle: '10th Sept, 2025 11:03:00 AM',
                  ),
                  const GtStatusStepData(
                    label: 'Sent',
                    state: GtStatusStepState.success,
                    subtitle: '10th Sept, 2025 11:03:00 AM',
                  ),
                  const GtStatusStepData(
                    label: 'Delivered',
                    state: GtStatusStepState.success,
                    subtitle: '10th Sept, 2025 11:03:00 AM',
                  ),
                ]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _openSheetWith(BuildContext context, List<GtStatusStepData> steps) {
    showBottomModalWithChild(
      context,
      child: Padding(
        padding: context.insets.defaultAllInsets,
        child: GtStatusTracker(steps: steps),
      ),
      useRootNavigator: false,
    );
  }
}

class _ScenarioChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ScenarioChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GtRaisedButton(text: label, size: .pill, onPressed: onTap);
  }
}
