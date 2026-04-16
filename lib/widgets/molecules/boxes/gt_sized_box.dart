import 'package:flutter/widgets.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A standardized sized box that automatically scales its dimensions to device-independent pixels (DP).
///
/// This widget acts as a wrapper around Flutter's [SizedBox], ensuring that the
/// provided [height] and [width] are consistently scaled across different screen densities.
class GtSizedBox extends GtStatelessWidget {
  /// The optional height in logical pixels, which will be scaled to DP.
  final double? height;

  /// The optional width in logical pixels, which will be scaled to DP.
  final double? width;

  /// The widget below this widget in the tree.
  final Widget? child;

  /// Creates a new [GtSizedBox].
  const GtSizedBox({super.key, this.height, this.width, this.child});

  @override
  Widget build(BuildContext context) {
    final computedHeight = height == null ? null : context.dp(height!.px);
    final computedWidth = width == null ? null : context.dp(width!.px);
    if (computedWidth == null && computedHeight == null) {
      return const SizedBox.shrink();
    }
    return SizedBox(height: computedHeight, width: computedWidth, child: child);
  }
}

/// A standardized square box that forces its child to have equal width and height.
///
/// The provided [size] is automatically scaled to device-independent pixels (DP).
class GtSquareBox extends GtStatelessWidget {
  /// The dimension for both the width and height in logical pixels, which will be scaled to DP.
  final double? size;

  /// The widget below this widget in the tree.
  final Widget? child;

  /// Creates a new [GtSquareBox].
  const GtSquareBox({super.key, this.size, this.child});

  @override
  Widget build(BuildContext context) {
    final computedSize = size == null ? null : context.dp(size!.px);
    return SizedBox.square(dimension: computedSize, child: child);
  }
}

/// A widget that sizes its child to a fraction of the total available space.
///
/// This is useful for creating responsive layouts where a widget needs to take up
/// a specific percentage of its parent's constraints (e.g., 50% width).
class GtFractionalBox extends GtStatelessWidget {
  /// The fraction of the available width to occupy, ranging from 0.0 to 1.0.
  final double? widthFactor;

  /// The fraction of the available height to occupy, ranging from 0.0 to 1.0.
  final double? heightFactor;

  /// The widget below this widget in the tree.
  final Widget? child;

  /// The alignment of the child within the box.
  final Alignment? alignment;

  /// Creates a new [GtFractionalBox].
  ///
  /// Asserts that at least one factor is provided and that both factors are within
  /// the valid range of 0.0 to 1.0 inclusive.
  const GtFractionalBox({
    super.key,
    this.heightFactor,
    this.widthFactor,
    this.alignment,
    this.child,
  }) : assert(
         heightFactor != null || widthFactor != null,
         'At least one of heightFactor or widthFactor must be non-null.',
       ),
       assert(
         heightFactor == null || (heightFactor >= 0.0 && heightFactor <= 1.0),
         'heightFactor must be between 0.0 and 1.0, inclusive.',
       ),
       assert(
         widthFactor == null || (widthFactor >= 0.0 && widthFactor <= 1.0),
         'widthFactor must be between 0.0 and 1.0, inclusive.',
       );

  @override
  Widget build(BuildContext context) {
    if (heightFactor == null && widthFactor == null) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final computedHeight = heightFactor == null
            ? null
            : constraints.biggest.height * heightFactor!.clamp(0, 1.0);
        final computedWidth = widthFactor == null
            ? null
            : constraints.biggest.width * widthFactor!.clamp(0, 1.0);

        return ConstrainedBox(
          constraints: BoxConstraints.tightFor(
            height: computedHeight ?? constraints.biggest.height,
            width: computedWidth ?? constraints.biggest.width,
          ),
          child: FractionallySizedBox(
            alignment: alignment ?? Alignment.center,
            heightFactor: heightFactor,
            widthFactor: widthFactor,
            child: child,
          ),
        );
      },
    );
  }
}
