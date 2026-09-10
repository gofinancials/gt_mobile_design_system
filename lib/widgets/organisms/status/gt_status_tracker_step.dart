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

/// Renders a single step row in a [GtStatusTracker] using
/// [GtStatusTrackerVariant.compact].
///
/// Lays out a 12dp node — with an optional connector hanging beneath it — the
/// label in its natural casing, and the subtitle as a trailing, right-aligned
/// timestamp. A step without a subtitle, typically a pending one, renders no
/// timestamp.
class GtStatusTrackerCompactStep extends GtStatelessWidget {
  /// The data specifying label, subtitle, state, and explicit color/icon overrides.
  final GtStatusStepData data;

  /// The colour of the connector drawn beneath the node, leading to the next
  /// step.
  ///
  /// When null no connector is drawn, as for the final step.
  final Color? connectorColor;

  /// Creates a [GtStatusTrackerCompactStep].
  const GtStatusTrackerCompactStep({
    super.key,
    required this.data,
    this.connectorColor,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final nodeSize = context.dp(12.px);

    Color subColor = palette.text.sub;
    if (data.subtitleColor != null) {
      subColor = data.subtitleColor!;
    }

    return MergeSemantics(
      child: Row(
        crossAxisAlignment: .start,
        spacing: context.dp(9.px),
        children: [
          SizedBox(
            width: nodeSize,
            child: Column(
              mainAxisSize: .min,
              spacing: context.spacingSm,
              children: [
                _CompactStatusNode(data, size: nodeSize),
                if (connectorColor case Color color)
                  Container(
                    width: context.dp(2.px),
                    height: context.dp(8.px),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: context.borderRadiusXs,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: context.insets.symmetricDp(vertical: 1.px),
              child: Row(
                spacing: context.spacingBase,
                children: [
                  Expanded(
                    child: GtText(
                      data.label,
                      style: context.textStyles.subHeadXs(
                        weight: .w600,
                        color: palette.text.darkerSub,
                        heightPx: 12,
                      ),
                      maxLines: 1,
                      overflow: .ellipsis,
                    ),
                  ),
                  if (data.subtitle.hasValue)
                    GtText(
                      data.subtitle.value,
                      style: context.textStyles.subHeadXs(
                        color: subColor,
                        heightPx: 12,
                      ),
                      maxLines: 1,
                    ),
                ],
              ),
            ),
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
  final double borderWidth;

  const _StatusDot({
    required this.color,
    required this.filled,
    required this.size,
    this.borderWidth = 2.25,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: filled ? color : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(color: color, width: borderWidth),
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

class _CompactStatusNode extends StatelessWidget {
  final GtStatusStepData data;
  final double size;

  const _CompactStatusNode(this.data, {required this.size});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    Color stateColor = data.state.color(palette);
    if (data.isSuccess) stateColor = palette.success.base;

    final nodeColor = data.iconColor ?? stateColor;

    if (data.icon != null) {
      return _CompactStatusIcon(data.icon!, color: nodeColor, size: size);
    }

    return switch (data.state.nodeKind) {
      .spinner => GtSpinner(
        color: nodeColor,
        size: size,
        strokeWidth: context.dp(2.px),
      ),
      .filledDot => _StatusDot(color: nodeColor, filled: true, size: size),
      .outlineDot => _StatusDot(
        color: nodeColor,
        filled: false,
        size: size,
        borderWidth: 1.5,
      ),
      .icon => _CompactStatusIcon(
        data.state.icon,
        color: nodeColor,
        size: size,
      ),
    };
  }
}

class _CompactStatusIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;

  const _CompactStatusIcon(
    this.icon, {
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = context.dp(14.px);

    return SizedBox.square(
      dimension: size,
      child: OverflowBox(
        maxWidth: iconSize,
        maxHeight: iconSize,
        child: GtIcon.withColor(icon, color: color, size: iconSize),
      ),
    );
  }
}
