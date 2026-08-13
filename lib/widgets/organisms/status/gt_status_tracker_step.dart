import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Renders a single step row in a [GtStatusTracker], including its node,
/// uppercase label, subtitle, and vertical connecting line.
class GtStatusTrackerStep extends GtStatelessWidget {
  /// The data specifying label, subtitle, state, and explicit color/icon overrides.
  final GtStatusStepData data;

  /// Whether this success step is the terminal completed step (checkmark).
  final bool showAsTerminalSuccess;

  /// Creates a [GtStatusTrackerStep].
  const GtStatusTrackerStep({
    super.key,
    required this.data,
    this.showAsTerminalSuccess = false,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    final textColor = data.state.textColor(palette);

    Color subColor = palette.text.soft;
    if (data.subtitleColor != null) {
      subColor = data.subtitleColor!;
    }

    TableCellVerticalAlignment cellAlignment = .top;
    if (!data.subtitle.hasValue) cellAlignment = .middle;

    return IntrinsicHeight(
      child: Table(
        defaultVerticalAlignment: cellAlignment,
        columnWidths: {
          0: FixedColumnWidth(context.dp(18.px)),
          1: FixedColumnWidth(context.dp(8.px)),
          2: FlexColumnWidth(),
        },
        children: [
          TableRow(
            children: [
              _StatusNode(data, showAsTerminalSuccess: showAsTerminalSuccess),
              const SizedBox.shrink(),
              Column(
                crossAxisAlignment: .start,
                mainAxisSize: .min,
                spacing: context.spacingSm,
                children: [
                  GtText(
                    data.label.upper,
                    style: context.textStyles.button2s(
                      color: textColor,
                      heightPx: 12,
                    ),
                  ),
                  if (data.subtitle.hasValue)
                    GtText(
                      data.subtitle.value,
                      style: context.textStyles.bodyXs(
                        color: subColor,
                        heightPx: 12,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Renders a vertical connecting line segment between steps in a [GtStatusTracker].
class GtStatusTrackerStepConnector extends GtStatelessWidget {
  /// The color of the connecting line segment.
  final Color color;

  /// Creates a [GtStatusTrackerStepConnector].
  const GtStatusTrackerStepConnector(this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Table(
        defaultVerticalAlignment: .middle,
        columnWidths: {
          0: FixedColumnWidth(context.dp(18.px)),
          1: FixedColumnWidth(context.dp(8.px)),
          2: FlexColumnWidth(),
        },
        children: [
          TableRow(
            children: [
              Container(
                height: context.dp(21.px),
                alignment: .center,
                child: GtSizedBox(
                  height: 12,
                  child: VerticalDivider(color: color, width: 2, thickness: 2),
                ),
              ),
              ...const SizedBox.shrink() * 2,
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  final Color color;
  final bool filled;
  final double size;

  const _StatusDot({
    required this.color,
    required this.filled,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: filled ? color : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2.25),
      ),
    );
  }
}

class _StatusNode extends StatelessWidget {
  final GtStatusStepData data;
  final bool showAsTerminalSuccess;

  const _StatusNode(this.data, {required this.showAsTerminalSuccess});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final nodeColor = data.iconColor ?? data.state.color(palette);
    final size = context.dp(16.px);

    if (data.icon != null) {
      return GtIcon.withColor(data.icon!, color: nodeColor, size: size);
    }

    if (showAsTerminalSuccess && data.state == GtStatusStepState.success) {
      return GtIcon.withColor(GtIcons.checkSolid, color: nodeColor, size: size);
    }

    return switch (data.state.nodeKind) {
      .spinner => GtSpinner(
        color: nodeColor,
        size: size,
        strokeWidth: 3,
        alignment: .topCenter,
      ),
      .filledDot => _StatusDot(color: nodeColor, filled: true, size: size),
      .outlineDot => _StatusDot(color: nodeColor, filled: false, size: size),
      .icon => GtIcon.withColor(data.state.icon, color: nodeColor, size: size),
    };
  }
}
