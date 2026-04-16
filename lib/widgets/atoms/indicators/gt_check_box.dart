import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Defines the visual shape of a [GtCheckBox].
enum GtCheckBoxShape {
  /// A standard square checkbox with slightly rounded corners.
  square,

  /// A completely circular checkbox.
  circle,
}

/// A highly customizable, stateless checkbox component for the Go Tech design system.
///
/// Supports both square and circular shapes, custom active colors, and disabled states.
class GtCheckBox<T> extends GtStatelessWidget {
  /// The value represented by this checkbox.
  final T value;

  /// Whether this checkbox is currently checked/active.
  final bool isActive;

  /// Called when the checkbox is tapped and the value should change.
  final OnChanged<T> onChanged;

  /// The color to use when the checkbox is active.
  ///
  /// If null, defaults to the primary base color from the current palette.
  final Color? activeColor;

  /// Whether the checkbox is disabled and non-interactive.
  final bool disabled;

  /// The visual shape of the checkbox. Defaults to [GtCheckBoxShape.square].
  final GtCheckBoxShape shape;

  /// Creates a new [GtCheckBox] instance.
  const GtCheckBox({
    required this.value,
    required this.onChanged,
    required this.isActive,
    this.disabled = false,
    this.shape = GtCheckBoxShape.square,
    this.activeColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    final color = activeColor ?? palette.primary.base;
    final borderColor = isActive ? color : palette.bg.soft;
    final size = context.dp(20.px);

    final boxShape = shape == .circle ? BoxShape.circle : BoxShape.rectangle;
    final borderRadius = shape != .circle ? 4.8.circularBorderRadius : null;

    return RepaintBoundary(
      child: GtDisabledOverlay(
        disabled,
        child: InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            onChanged(value);
          },
          child: Container(
            alignment: Alignment.center,
            height: size,
            width: size,
            constraints: BoxConstraints.tightFor(height: size, width: size),
            decoration: BoxDecoration(
              color: isActive ? color : GtColors.transparent.value,
              border: Border.all(color: borderColor, width: 1.8),
              borderRadius: borderRadius,
              shape: boxShape,
            ),
            child: GtAnimatedSwitcher(
              child: Builder(
                builder: (context) {
                  if (isActive) {
                    return GtIcon(
                      Icons.check,
                      alignment: Alignment.center,
                      size: context.dp(15.px),
                      variant: GtIconVariant.white,
                    );
                  }
                  return _InActiveInnerContainer(
                    boxShape,
                    borderRadius: borderRadius,
                  );
                },
                key: ValueKey<T>(value),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// An internal widget used to render the inner container of an inactive [GtCheckBox].
class _InActiveInnerContainer extends StatelessWidget {
  /// The shape of the inner container.
  final BoxShape shape;

  /// The border radius of the inner container, used when [shape] is [BoxShape.rectangle].
  final BorderRadius? borderRadius;

  /// Creates a new [_InActiveInnerContainer].
  const _InActiveInnerContainer(this.shape, {this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Container(
        decoration: BoxDecoration(
          color: context.palette.icon.white,
          shape: shape,
          borderRadius: borderRadius,
          boxShadow: context.shadows.indicatorShadow(),
        ),
      ),
    );
  }
}
