import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

enum GtCheckBoxShape { square, circle }

class GtCheckBox<T> extends GtStatelessWidget {
  final T value;
  final bool isActive;
  final OnChanged<T> onChanged;
  final Color? activeColor;
  final bool disabled;
  final GtCheckBoxShape shape;

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

class _InActiveInnerContainer extends StatelessWidget {
  final BoxShape shape;
  final BorderRadius? borderRadius;

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
