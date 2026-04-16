import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Defines the standard sizes available for Go Tech buttons.
enum GtButtonSize {
  /// A small button with a baseline height of 36.
  small(36),
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
  /// A white button style, often used on dark backgrounds or for high contrast.
  white 
}

/// An abstract base class providing common properties and structural styling 
/// logic for Go Tech buttons.
///
/// This class centralizes the calculation of button dimensions, padding, and 
/// basic shape characteristics to ensure consistency across different button types.
abstract class GtButtonBase extends GtStatelessWidget {
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

  /// Creates a [GtButtonBase].
  const GtButtonBase({
    required this.onPressed,
    this.minSize,
    this.size = .medium,
    this.color,
    this.isDisabled = false,
    this.isLoading = false,
    this.alignment,
    super.key,
  });

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
      .small => i.symmetricDp(vertical: 4.px, horizontal: 8.px),
      .medium => i.symmetricDp(vertical: 8.px, horizontal: 16.px),
      .large => i.symmetricDp(vertical: 10.px, horizontal: 20.px),
    };
  }

  /// Generates the base [ButtonStyle] containing the standard size, padding, 
  /// and shape constraints for Go Tech buttons.
  ButtonStyle baseStyle(BuildContext context) {
    final height = buttonHeight(context);
    final minSize = minimumSize(context);
    final maxSize = maximumSize(context);
    final hPadding = padding(context);
    final shape = RoundedRectangleBorder(borderRadius: 10.circularBorderRadius);

    return ButtonStyle(
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
