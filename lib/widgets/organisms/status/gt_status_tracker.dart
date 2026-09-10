import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A vertical status timeline widget that renders a list of [GtStatusStepData] items.
///
/// Automatically determines connector lines between steps and resolves terminal success checkmarks.
/// See [GtStatusTrackerVariant] for the available layouts.
class GtStatusTracker extends GtStatelessWidget {
  /// The ordered list of step data items to display.
  final List<GtStatusStepData> steps;

  /// Optional padding around the status tracker list.
  final EdgeInsetsGeometry? padding;

  /// How the steps are laid out. Defaults to [GtStatusTrackerVariant.standard].
  final GtStatusTrackerVariant variant;

  /// Creates a [GtStatusTracker].
  const GtStatusTracker({
    super.key,
    required this.steps,
    this.padding,
    this.variant = .standard,
  });

  @override
  Widget build(BuildContext context) {
    if (!steps.hasValue) return const SizedBox.shrink();

    Widget content = switch (variant) {
      .standard => _GtStandardStatusTracker(steps),
      .compact => _GtCompactStatusTracker(steps),
    };

    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }

    return content;
  }
}

/// A private widget that renders [GtStatusTracker] in its
/// [GtStatusTrackerVariant.standard] layout.
///
/// Stacks a [GtStatusTrackerStep] per step with a
/// [GtStatusTrackerStepConnector] between each, and turns the connectors
/// green once every step has succeeded.
class _GtStandardStatusTracker extends GtStatelessWidget {
  /// The ordered steps to render. [GtStatusTracker] never passes an empty list.
  final List<GtStatusStepData> steps;

  /// Creates a [_GtStandardStatusTracker].
  const _GtStandardStatusTracker(this.steps);

  @override
  Widget build(BuildContext context) {
    Color connectorColor = context.palette.stroke.sub;
    final isCompleted = steps.every((it) => it.isSuccess);

    if (isCompleted) {
      connectorColor = context.palette.success.darker;
    }

    return Column(
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
  }
}

/// A private widget that renders [GtStatusTracker] in its
/// [GtStatusTrackerVariant.compact] layout.
///
/// Stacks a [GtStatusTrackerCompactStep] per step, each carrying the connector
/// to the next. The connectors turn green once every step before the last has
/// succeeded and the last is no longer pending.
class _GtCompactStatusTracker extends GtStatelessWidget {
  /// The ordered steps to render. [GtStatusTracker] never passes an empty list.
  final List<GtStatusStepData> steps;

  /// Creates a [_GtCompactStatusTracker].
  const _GtCompactStatusTracker(this.steps);

  @override
  Widget build(BuildContext context) {
    final lastIndex = steps.length - 1;
    Color connectorColor = context.palette.stroke.sub;
    final isTravelled = steps.take(lastIndex).every((it) => it.isSuccess);

    if (isTravelled && !steps.last.isPending) {
      connectorColor = context.palette.success.base;
    }

    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      spacing: context.spacingBase,
      children: [
        for (final (index, step) in steps.indexed)
          GtStatusTrackerCompactStep(
            data: step,
            connectorColor: index < lastIndex ? connectorColor : null,
            key: ValueKey((step.label, step.state, index)),
          ),
      ],
    );
  }
}
