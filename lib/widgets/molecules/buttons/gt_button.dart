import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Defines the standard sizes available for Go Tech buttons.
enum GtButtonSize {
  /// A pill style extra small button with a baseline height of 20.
  pill(24),

  /// An extra small button with a baseline height of 36.
  xsmall(28),

  /// A small button with a baseline height of 36.
  small(32),

  /// A medium button with a baseline height of 40.
  medium(40),

  /// A large button with a baseline height of 48.
  large(48);

  const GtButtonSize(this.value);

  /// The baseline height value in logical pixels.
  final double value;
}

/// Defines the standard visual styles or variants available for Go Tech buttons.
enum GtButtonVariant {
  /// The primary button style, typically used for the most important actions.
  primary,

  /// A destructive button style, used for critical actions like delete or remove.
  destructive,

  /// A secondary button style for alternative or less important actions.
  secondary,

  /// A secondary destructive button style, used actions like delete or remove.
  destructiveAlt,

  /// A white button style, often used on dark backgrounds or for high contrast.
  white,

  /// A featured button style, used to highlight special or premium actions.
  featured,

  /// An informational button style, used to convey neutral or general information.
  info,

  /// A success button style, used to confirm positive or successful actions.
  success,

  /// A warning button style, used to indicate caution or potential issues.
  warning,

  /// A highlighted button style, used to draw extra attention to an action.
  highlighted,

  /// A stable button style, used to indicate a neutral, grounded state.
  stable,

  /// A verified button style, used in contexts involving trust or authentication.
  verified,

  /// An away button style, used to indicate an inactive, paused, or absent state.
  away,

  neutral,

  neutralAlt,
}

/// An abstract base class providing common properties and structural styling
/// logic for Go Tech buttons.
///
/// This class centralizes the calculation of button dimensions, padding, and
/// basic shape characteristics to ensure consistency across different button types.
abstract class GtButton extends GtStatelessWidget {
  /// The callback that is called when the button is tapped or otherwise activated.
  final OnPressed onPressed;

  /// The size category of the button, determining its height and default padding.
  /// Defaults to [GtButtonSize.medium].
  final GtButtonSize size;

  /// An optional custom minimum size for the button. If null, a default is calculated.
  final Size? minSize;

  /// Whether the button is currently disabled, preventing user interaction.
  final bool isDisabled;

  /// Whether the button is in a loading state.
  /// Typically used to display a progress indicator instead of its label.
  final bool isLoading;

  /// An optional custom color to override the default background color of the button variant.
  final Color? color;

  /// The alignment of the button's content (e.g., text and icons) within the button's bounds.
  final AlignmentGeometry? alignment;

  /// Creates a [GtButton].
  const GtButton({
    required this.onPressed,
    this.minSize,
    this.size = .large,
    this.color,
    this.isDisabled = false,
    this.isLoading = false,
    this.alignment,
    super.key,
  });

  bool isFocused(Set<WidgetState> states) {
    return states.contains(WidgetState.focused);
  }

  bool isHovered(Set<WidgetState> states) {
    return states.contains(WidgetState.hovered);
  }

  bool isPressed(Set<WidgetState> states) {
    return states.contains(WidgetState.pressed);
  }

  bool isActive(Set<WidgetState> states) {
    return isFocused(states) || isHovered(states) || isPressed(states);
  }

  /// Calculates the required height of the button based on its [size] and the
  /// current device pixel ratio using Go Tech's layout utilities.
  double buttonHeight(BuildContext context) {
    return context.dp(size.value.px);
  }

  /// Calculates the minimum size constraints for the button.
  Size minimumSize(BuildContext context) {
    final height = buttonHeight(context);
    final width = minSize?.width;
    return switch (size) {
      .pill => Size(width ?? context.dp(52.px), height),
      .xsmall => Size(width ?? context.dp(67.px), height),
      .small => Size(width ?? context.dp(68.px), height),
      .medium => Size(width ?? context.dp(80.px), height),
      .large => Size(width ?? context.dp(120.px), height),
    };
  }

  /// Calculates the maximum size constraints, restricting the height while allowing infinite width.
  Size maximumSize(BuildContext context) {
    final height = buttonHeight(context);
    return Size(double.infinity, height);
  }

  /// Calculates the internal padding for the button based on its [size].
  EdgeInsetsGeometry padding(BuildContext context) {
    final i = context.insets;
    return switch (size) {
      .pill => i.symmetricDp(horizontal: 6.px),
      .xsmall => i.allDp(6.px),
      .small => i.symmetricDp(horizontal: 8.px),
      .medium => i.symmetricDp(horizontal: 16.px),
      .large => i.symmetricDp(horizontal: 20.px),
    };
  }

  /// Generates the base [ButtonStyle] containing the standard size, padding,ß
  /// and shape constraints for Go Tech buttons.
  ButtonStyle baseStyle(BuildContext context) {
    final height = buttonHeight(context);
    final minSize = minimumSize(context);
    final maxSize = maximumSize(context);
    final hPadding = padding(context);
    final radius = switch (size) {
      .pill => 6.8,
      .xsmall => 8,
      _ => 10,
    };
    final borderRadius = BorderRadius.circular(context.dp(radius.px));
    final shape = RoundedRectangleBorder(borderRadius: borderRadius);

    return ButtonStyle (
      minimumSize: WidgetStatePropertyAll(minSize),
      fixedSize: WidgetStatePropertyAll(Size.fromHeight(height)),
      maximumSize: WidgetStatePropertyAll(maxSize),
      elevation: WidgetStateProperty.all(0),
      shape: WidgetStateProperty.all(shape),
      padding: WidgetStateProperty.all(hPadding),
      alignment: alignment,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
