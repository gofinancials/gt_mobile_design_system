import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:vector_graphics/vector_graphics.dart';

class GtSvg extends GtStatelessWidget {
  final String path;
  final String? package;
  final double? width;
  final double? height;
  final BoxFit fit;
  final AlignmentGeometry alignment;
  final WidgetBuilder? placeholderBuilder;
  final String? semanticsLabel;
  final Color? color;
  final GtIconVariant? variant;
  final BlendMode colorBlendMode;
  final bool _renderAsIcon;

  const GtSvg(
    this.path, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.placeholderBuilder,
    this.color,
    this.colorBlendMode = BlendMode.srcATop,
    this.semanticsLabel,
    this.package,
  }) : _renderAsIcon = false,
       variant = null;

  const GtSvg.asIcon(
    this.path, {
    super.key,
    double? size,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.placeholderBuilder,
    this.colorBlendMode = BlendMode.srcATop,
    this.variant,
    this.package,
    this.semanticsLabel,
  }) : width = size,
       height = size,
       color = null,
       _renderAsIcon = true;

  ColorFilter _getIconColor(BuildContext context) {
    final color = variant.getIconColor(context);
    return ColorFilter.mode(color, colorBlendMode);
  }

  ColorFilter? _getColor(BuildContext context) {
    if (_renderAsIcon) return _getIconColor(context);
    if (color == null) return null;
    return ColorFilter.mode(color!, colorBlendMode);
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
      colorFilter: _getColor(context),
    );
  }
}
