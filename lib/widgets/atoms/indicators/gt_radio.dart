import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Defines the visual style of the [GtRadio] component.
enum GtRadioStyle {
  /// The standard radio style featuring a filled inner circle when active.
  standard,

  /// A donut-shaped style featuring a thicker border and hollow center when active.
  donut;

  const GtRadioStyle();

  /// Returns `true` if the style is [GtRadioStyle.donut].
  bool get isDonut => this == .donut;
}

/// A highly customizable, stateless radio button component for the Go Tech design system.
///
/// It supports two modes of operation:
/// 1. Standard mode using [groupValue] to compare against its [value].
/// 2. Conditional mode using a direct boolean [condition] to determine if it is active.
class GtRadio<T> extends GtStatelessWidget {
  /// The value represented by this radio button.
  final T value;

  /// The currently selected value for a group of radio buttons.
  ///
  /// If this matches [value], the radio button will be drawn as active.
  final T? groupValue;

  /// A direct boolean condition to determine if the radio button is active.
  ///
  /// This is used exclusively when constructed with [GtRadio.conditional].
  final bool? condition;

  /// Called when the user selects this radio button.
  final OnChanged<T> onChanged;

  /// The color to use when the radio button is active.
  ///
  /// If null, defaults to the primary base color from the current palette.
  final Color? activeColor;

  /// Whether the radio button is disabled and non-interactive.
  final bool disabled;

  /// The visual style variant of the radio button.
  ///
  /// Defaults to [GtRadioStyle.standard].
  final GtRadioStyle style;

  /// Creates a standard [GtRadio] that compares [value] against [groupValue].
  const GtRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.disabled = false,
    this.activeColor,
    this.style = .standard,
  }) : condition = null;

  /// Creates a [GtRadio] whose active state is directly controlled by [condition].
  const GtRadio.conditional({
    super.key,
    required this.value,
    required this.condition,
    required this.onChanged,
    this.activeColor,
    this.disabled = false,
    this.style = .standard,
  }) : groupValue = null;

  /// Determines if the radio button is currently in the active state.
  bool get _isActive {
    if (condition != null) {
      return condition!;
    }
    return groupValue == value;
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    final color = activeColor ?? palette.primary.base;
    final borderColor = _isActive ? color : palette.bg.soft;
    final borderWidth = switch (_isActive) {
      true => style.isDonut ? 4.0 : 1.8,
      _ => 1.8,
    };

    final size = context.dp(20.px);

    return RepaintBoundary(
      child: GtDisabledOverlay(
        disabled,
        child: InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            onChanged(value);
          },
          child: AnimatedContainer(
            duration: 500.milliseconds,
            height: size,
            width: size,
            constraints: BoxConstraints.tightFor(height: size, width: size),
            decoration: BoxDecoration(
              border: Border.all(color: borderColor, width: borderWidth),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: GtAnimatedSwitcher(
              child: Builder(
                builder: (context) {
                  if (_isActive && !style.isDonut) {
                    return _ActiveInnerContainer(color);
                  }
                  if (_isActive && style.isDonut) return const Offstage();
                  return const _InActiveInnerContainer();
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

/// An internal widget used to render the inner circle of an active [GtRadio].
class _ActiveInnerContainer extends StatelessWidget {
  /// The active color of the radio button.
  final Color color;

  const _ActiveInnerContainer(this.color);

  @override
  Widget build(BuildContext context) {
    final size = context.dp(10.px);

    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}

/// An internal widget used to render the inner container of an inactive [GtRadio].
class _InActiveInnerContainer extends StatelessWidget {
  const _InActiveInnerContainer();

  @override
  Widget build(BuildContext context) {
    return Center(
      heightFactor: 1,
      widthFactor: 1,
      child: Container(
        decoration: BoxDecoration(
          color: context.palette.icon.white,
          shape: BoxShape.circle,
          boxShadow: context.shadows.indicatorShadow(),
        ),
      ),
    );
  }
}
