import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Defines the semantic type and visual color scheme for a [GtCountIndicator].
enum GtCountIndicatorType {
  /// Represents an error state, typically colored red.
  error,

  /// Represents a success state, typically colored green.
  success,

  /// Represents an informational state, typically colored blue.
  info,

  /// Represents a warning state, typically colored yellow or orange.
  warning,

  /// Represents a neutral state, typically using a subtle background color.
  neutral,
}

/// A circular badge widget used to display numeric counts, such as unread notifications.
///
/// The indicator will automatically hide itself if the [count] is 0 or less.
/// If the [count] exceeds 9, it will display '9+'.
class GtCountIndicator extends GtStatelessWidget {
  /// The numeric value to display inside the indicator.
  ///
  /// Values less than or equal to 0 will cause the widget to be hidden.
  /// Values greater than 9 will be capped and displayed as '9+'.
  final int count;

  /// The minimum width and height of the circular indicator.
  ///
  /// If null, a default size of 20dp is used.
  final double? size;

  /// The semantic visual style of the indicator, determining its background color.
  final GtCountIndicatorType type;

  /// Creates a new [GtCountIndicator].
  ///
  /// The [count] parameter is required. The [type] defaults to
  /// [GtCountIndicatorType.error].
  const GtCountIndicator(
    this.count, {
    this.size,
    super.key,
    this.type = GtCountIndicatorType.error,
  });

  Color _getBgColor(GtPalette palette) {
    return switch (type) {
      .error => palette.error.base,
      .success => palette.success.base,
      .info => palette.information.base,
      .warning => palette.warning.base,
      _ => palette.bg.surface,
    };
  }

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const Offstage();

    final palette = context.palette;
    final bgColor = _getBgColor(palette);
    final textColor = palette.text.white;

    return RepaintBoundary(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
        constraints: BoxConstraints.tight(
          Size.square(size ?? context.dp(20.px)),
        ),
        child: Center(
          child: GtText(
            "${count > 9 ? '9+' : count}",
            textAlign: TextAlign.center,
            style: context.textStyles.bodyXs(color: textColor),
          ),
        ),
      ),
    );
  }
}
