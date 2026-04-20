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
  away,
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

  Color _getVariantColor(GtPalette palette) {
    if (color != null) return color!;
    return switch (variant) {
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

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final computedColor = _getVariantColor(palette);

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

class GtBannerCard extends GtStatefulWidget {
  final String title;
  final String subtitle;
  final bool hidden;
  final GtCardVariant variant;
  final OnPressed onClose;

  const GtBannerCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.hidden = false,
    this.variant = .normal,
    required this.onClose,
  });

  @override
  State<StatefulWidget> createState() => _GtBannerCardState();
}

class _GtBannerCardState extends State<GtBannerCard> {
  Color get _varianTextColor {
    final palette = context.palette;
    return switch (widget.variant) {
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

  @override
  Widget build(BuildContext context) {
    return GtAnimatedFade(
      child1: GtCard(
        borderRadius: context.borderRadiusXl,
        padding: context.insets.allDp(16.px),
        variant: widget.variant,
        child: Column(
          spacing: context.spacingBase,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              spacing: context.spacingSectionLg,
              crossAxisAlignment: .start,
              children: [
                Expanded(
                  child: GtText(
                    widget.title,
                    style: context.textStyles.h6(color: _varianTextColor),
                  ),
                ),
                GtCancelButton(onTap: widget.onClose),
              ],
            ),
            GtText(
              widget.subtitle,
              style: context.textStyles.bodyXs(
                color: context.palette.text.darkerSub,
              ),
            ),
          ],
        ),
      ),
      child2: const Offstage(),
      showFirst: !widget.hidden,
    );
  }
}
