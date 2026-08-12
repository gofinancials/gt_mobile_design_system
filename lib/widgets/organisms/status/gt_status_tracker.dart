import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A vertical status timeline widget that renders a list of [GtStatusStepData] items.
///
/// Automatically determines connector lines between steps and resolves terminal success checkmarks.
class GtStatusTracker extends GtStatelessWidget {
  /// The ordered list of step data items to display.
  final List<GtStatusStepData> steps;

  /// Optional padding around the status tracker list.
  final EdgeInsetsGeometry? padding;

  /// Creates a [GtStatusTracker].
  const GtStatusTracker({super.key, required this.steps, this.padding});

  @override
  Widget build(BuildContext context) {
    if (!steps.hasValue) return const SizedBox.shrink();
    Color connectorColor = context.palette.stroke.sub;
    final isCompleted = steps.every((it) => it.isSuccess);

    if (isCompleted) {
      connectorColor = context.palette.success.darker;
    }

    Widget content = Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      spacing: context.spacingSm,
      children: [
        for (final (index, step) in steps.indexed) ...[
          GtStatusTrackerStep(
            data: step,
            showAsTerminalSuccess: index == steps.length - 1,
            key: ValueKey((step.label, step.state, index)),
          ),
          if (index < steps.length - 1)
            GtStatusTrackerStepConnector(connectorColor),
        ],
      ],
    );

    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }

    return content;
  }
}
