import 'package:flutter/material.dart';
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

  /// The accessible name announced for this checkbox.
  ///
  /// A checkbox without a name is announced as "checkbox, checked" with no
  /// indication of what it controls. Supply the label of the option this
  /// checkbox selects, unless an enclosing widget already labels it.
  final String? semanticsLabel;

  /// A description of what selecting this checkbox does.
  final String? semanticHint;

  /// Creates a new [GtCheckBox] instance.
  const GtCheckBox({
    required this.value,
    required this.onChanged,
    required this.isActive,
    this.disabled = false,
    this.shape = GtCheckBoxShape.square,
    this.activeColor,
    this.semanticsLabel,
    this.semanticHint,
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

    // GtTapTarget is deliberately the outermost widget. Hit slop only works
    // for positions the parent also accepts, and the RepaintBoundary sizes
    // itself to the 20dp box — nesting the slop inside it would let the
    // boundary reject the touch before the slop was ever consulted.
    return GtTapTarget(
      child: RepaintBoundary(
        child: GtDisabledOverlay(
          disabled,
          child: GtInkWell(
            hapticFeedbackType: .selection,
            borderRadius: borderRadius,
            role: .checkbox,
            semanticsLabel: semanticsLabel,
            semanticHint: semanticHint,
            isChecked: isActive,
            // The tick and the inner container are decoration; the checked
            // state already conveys everything they show.
            excludeDescendantSemantics: true,
            onTap: () => onChanged(value),
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
                      return GtIcon.withColor(
                        GtIcons.checkSolid,
                        alignment: Alignment.center,
                        size: context.dp(14.px),
                        color: context.palette.staticColors.white,
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
    return Center(
      heightFactor: 1,
      widthFactor: 1,
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
