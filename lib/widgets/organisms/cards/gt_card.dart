import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:flutter/material.dart';

/// Defines the style of the card's corners.
enum CornerStyle {
  /// A continuous rectangle border resulting in a smooth, squircle-like curve.
  continous,

  /// A standard rounded rectangle border.
  rounded,
}

/// Defines the visual semantic variants for [GtCard] backgrounds.
enum GtCardVariant {
  /// The standard, neutral card variant.
  normal,

  /// A featured variant, typically using a prominent background color.
  featured,

  /// An informational variant, typically using a blue-tinted background.
  info,

  /// A success variant, typically using a green-tinted background.
  success,

  /// A warning variant, typically using a yellow or orange-tinted background.
  warning,

  /// An error variant, typically using a red-tinted background.
  error,

  /// A highlighted variant for general emphasis.
  highlighted,

  /// A stable variant indicating a steady state.
  stable,

  /// A verified variant, often synonymous with success.
  verified,

  /// An away variant, typically indicating offline or inactive status.
  away;

  /// Gets the background color associated with the card variant from the theme [palette].
  Color getBgColor(GtPalette palette) {
    return switch (this) {
      .away => palette.away.lighter,
      .error => palette.error.lighter,
      .featured => palette.feature.lighter,
      .highlighted => palette.highlighted.lighter,
      .info => palette.information.lighter,
      .stable => palette.stable.lighter,
      .success => palette.success.lighter,
      .verified => palette.success.lighter,
      .warning => palette.warning.lighter,
      _ => palette.bg.weak,
    };
  }

  /// Gets the primary text color associated with the card variant from the theme [palette].
  Color getTextColor(GtPalette palette) {
    return switch (this) {
      .away => palette.away.dark,
      .error => palette.error.dark,
      .featured => palette.feature.dark,
      .highlighted => palette.highlighted.dark,
      .info => palette.information.dark,
      .stable => palette.stable.dark,
      .success => palette.success.dark,
      .verified => palette.success.dark,
      .warning => palette.warning.dark,
      _ => palette.text.strong,
    };
  }

  /// Gets the icon color associated with the card variant from the theme [palette].
  Color getIconColor(GtPalette palette) {
    return switch (this) {
      .away => palette.away.base,
      .error => palette.error.base,
      .featured => palette.feature.base,
      .highlighted => palette.highlighted.base,
      .info => palette.information.base,
      .stable => palette.stable.base,
      .success => palette.success.base,
      .verified => palette.success.base,
      .warning => palette.warning.base,
      _ => palette.text.darkerSub,
    };
  }

  /// Gets the border color associated with the card variant from the theme [palette].
  Color getBorderColor(GtPalette palette) {
    return switch (this) {
      .away => palette.away.light,
      .error => palette.error.light,
      .featured => palette.feature.light,
      .highlighted => palette.highlighted.light,
      .info => palette.information.light,
      .stable => palette.stable.light,
      .success => palette.success.light,
      .verified => palette.success.light,
      .warning => palette.warning.light,
      _ => palette.stroke.sub,
    };
  }

  /// Gets the corresponding [GtButtonVariant] for the card variant, used for
  /// buttons inside the card to ensure a consistent theme.
  GtButtonVariant get buttonVariant => switch (this) {
    .away => .away,
    .error => .destructive,
    .featured => .featured,
    .highlighted => .highlighted,
    .info => .info,
    .stable => .stable,
    .success => .success,
    .verified => .verified,
    .warning => .warning,
    _ => .black,
  };
}

/// A highly customizable card widget that provides a stylized container for content.
///
/// [GtCard] supports various visual variants, corner styles (including continuous squircles),
/// gradients, background images, and custom borders. It automatically animates
/// changes to its decoration and constraints over a 500ms duration.
class GtCard extends GtStatelessWidget {
  /// An optional color to override the default background color provided by the [variant].
  final Color? color;

  /// The widget below this widget in the tree.
  final Widget child;

  /// Additional constraints to apply to the card.
  final BoxConstraints? constraints;

  /// Empty space to inscribe inside the card.
  final EdgeInsetsGeometry? padding;

  /// The style of the card's corners. Defaults to [CornerStyle.rounded].
  final CornerStyle cornerStyle;

  /// Empty space to surround the card.
  final EdgeInsetsGeometry? margin;

  /// A list of shadows cast by the card.
  final List<BoxShadow>? shadows;

  /// An optional border to draw around the card.
  final BorderSide? border;

  /// The border radius of the card. If null, defaults to a large border radius from the design system.
  final BorderRadius? borderRadius;

  /// An optional gradient to use for the background.
  final Gradient? gradient;

  /// An optional image to paint above the background.
  final DecorationImage? image;

  /// The semantic variant determining the default background color. Defaults to [GtCardVariant.normal].
  final GtCardVariant variant;

  /// Creates a [GtCard].
  const GtCard({
    this.color,
    this.padding,
    this.margin,
    this.borderRadius,
    this.constraints,
    this.shadows,
    this.image,
    this.cornerStyle = CornerStyle.rounded,
    this.border,
    this.gradient,
    this.variant = GtCardVariant.normal,
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final computedColor = color ?? variant.getBgColor(palette);

    final shape = switch (cornerStyle) {
      CornerStyle.continous => ContinuousRectangleBorder(
        borderRadius: borderRadius ?? context.borderRadius2Xl,
        side: border ?? BorderSide.none,
      ),
      _ => RoundedRectangleBorder(
        borderRadius: borderRadius ?? context.borderRadius2Xl,
        side: border ?? BorderSide.none,
      ),
    };
    return AnimatedContainer(
      constraints: constraints,
      decoration: ShapeDecoration(
        color: gradient == null ? computedColor : null,
        shadows: shadows,
        shape: shape,
        gradient: gradient,
        image: image,
      ),
      width: double.infinity,
      margin: margin,
      padding: padding ?? context.insets.defaultAllInsets,
      duration: 500.milliseconds,
      child: child,
    );
  }
}
