import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:vector_graphics/vector_graphics.dart';

/// A widget for efficiently rendering scalable vector graphics (SVGs).
///
/// This widget wraps the `vector_graphics` package for high-performance rendering.
/// It supports two primary modes: as a general-purpose scalable graphic, or as a
/// semantically colored icon via [GtSvg.asIcon].
class GtSvg extends GtStatelessWidget {
  /// The path to the vector graphic asset.
  final String path;

  /// The name of the package containing the asset, if not the host application.
  /// Defaults to 'gt_mobile_ui' internally if null.
  final String? package;

  /// The optional width to constrain the graphic.
  final double? width;

  /// The optional height to constrain the graphic.
  final double? height;

  /// How the graphic should be inscribed into the space allocated during layout.
  final BoxFit fit;

  /// How to align the graphic within its bounds. Defaults to [Alignment.center].
  final AlignmentGeometry alignment;

  /// A builder function that returns a widget to display while the graphic is loading.
  final WidgetBuilder? placeholderBuilder;

  /// A semantic label for the graphic, used by screen readers and accessibility tools.
  final String? semanticsLabel;

  /// An explicit color to apply to the graphic as a [BlendMode.dstIn] color filter.
  final Color? color;

  /// The semantic variant defining the color when rendered as an icon.
  final GtIconVariant? variant;

  /// Internal flag to determine if the graphic should be treated as an icon.
  final bool _renderAsIcon;

  /// Creates a standard [GtSvg] for general-purpose vector rendering.
  ///
  /// This allows explicit setting of [width], [height], and an optional [color]
  /// override. For rendering standardized icons, prefer [GtSvg.asIcon].
  const GtSvg(
    this.path, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.placeholderBuilder,
    this.color,
    this.semanticsLabel,
    this.package,
  }) : _renderAsIcon = false,
       variant = null;

  /// Creates a [GtSvg] configured specifically to act as an icon.
  ///
  /// This sets both the width and height to the provided [size], and automatically
  /// applies a semantic color filter based on the chosen [variant].
  const GtSvg.asIcon(
    this.path, {
    super.key,
    double? size,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.placeholderBuilder,
    this.variant,
    this.package,
    this.semanticsLabel,
  }) : width = size,
       height = size,
       color = null,
       _renderAsIcon = true;

  ColorFilter _getIconColor(BuildContext context) {
    final color = variant.getIconColor(context);
    return ColorFilter.mode(color, BlendMode.srcIn);
  }

  ColorFilter? _getColor(BuildContext context) {
    if (_renderAsIcon) return _getIconColor(context);
    if (color == null) return null;
    return ColorFilter.mode(color!, BlendMode.srcIn);
  }

  @override
  Widget build(BuildContext context) {
    return VectorGraphic(
      loader: path.vectorBytes(package ?? 'gt_mobile_ui'),
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      clipBehavior: Clip.antiAlias,
      colorFilter: _getColor(context),
    );
  }
}
