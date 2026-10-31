import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:vector_graphics/vector_graphics_compat.dart';
import 'package:vector_graphics_compiler/vector_graphics_compiler.dart'
    show encodeSvg;

/// A widget for efficiently rendering scalable vector graphics (SVGs).
///
/// This widget wraps the `vector_graphics` package, rendering with its picture
/// strategy so edges stay crisp at any size or scale.
///
/// It supports two primary modes: as a general-purpose scalable graphic, or as a
/// semantically colored icon via [GtSvg.asIcon].
///
/// Inside an enabled [GtSkeleton] it is painted as a [GtBone] block.
class GtSvg extends GtStatefulWidget {
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
  ///
  /// Defaults to a [GtImageShimmer] at [width] and [height].
  final WidgetBuilder? placeholderBuilder;

  /// An optional widget to display if the graphic fails to load.
  ///
  /// If null, an empty [SizedBox] of [width] by [height] is rendered, so a
  /// failed graphic stops signalling that it is still loading.
  final Widget? errorWidget;

  /// A semantic label for the graphic, used by screen readers and accessibility tools.
  final String? semanticsLabel;

  /// Whether this graphic is purely decorative.
  ///
  /// Decorative graphics are excluded from the semantics tree. Prefer setting
  /// this explicitly over simply omitting [semanticsLabel], so the intent is
  /// visible to readers and to the lint that flags unlabelled graphics.
  final bool isDecorative;

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
    this.errorWidget,
    this.color,
    this.semanticsLabel,
    this.isDecorative = false,
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
    this.errorWidget,
    this.variant,
    this.package,
    this.semanticsLabel,
    this.isDecorative = false,
  }) : width = size,
       height = size,
       color = null,
       _renderAsIcon = true;

  /// The tint for an icon-style graphic, taken from its [variant].
  ColorFilter _getIconColor(BuildContext context) {
    final color = variant.getIconColor(context);
    return ColorFilter.mode(color, BlendMode.srcIn);
  }

  /// The tint to draw the graphic with: its [variant]'s when rendered as an
  /// icon, otherwise [color], or none when [color] is null.
  ColorFilter? _getColor(BuildContext context) {
    if (_renderAsIcon) return _getIconColor(context);
    if (color == null) return null;
    return ColorFilter.mode(color!, BlendMode.srcIn);
  }

  @override
  State<GtSvg> createState() => _GtSvgState();
}

/// The state of a [GtSvg], which owns the loader for its graphic.
class _GtSvgState extends State<GtSvg> {
  /// The loader for the graphic at [GtSvg.path].
  late _SafeBytesLoader _loader = _createLoader();

  /// Whether the graphic failed to load.
  final _hasError = ValueNotifier(false);

  @override
  void dispose() {
    _hasError.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(GtSvg oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.path == widget.path && oldWidget.package == widget.package) {
      return;
    }
    _loader = _createLoader();
    _hasError.value = false;
  }

  /// Creates a loader for [GtSvg.path] that reports failures to [_showError].
  _SafeBytesLoader _createLoader() {
    return _SafeBytesLoader(
      widget.path.vectorBytes(widget.package),
      onError: _showError,
    );
  }

  /// Swaps the graphic for the error widget once a load has failed.
  void _showError() {
    // A loader can throw before it first awaits, while the graphic is still
    // building, so the rebuild waits until that build is done.
    scheduleMicrotask(() {
      if (!mounted) return;
      _hasError.value = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final errorBox = SizedBox(width: widget.width, height: widget.height);

    // The public `VectorGraphic` constructor forces the raster strategy, which
    // caches a bitmap and rescales it with bilinear filtering, leaving edges
    // jagged whenever the graphic is drawn at another size or under a scaling
    // transform. The picture strategy replays the vector commands instead.
    Widget graphic = BoolListener(
      valueListenable: _hasError,
      builder: (hasError) => switch (hasError) {
        true => widget.errorWidget ?? errorBox,
        false => createCompatVectorGraphic(
          strategy: RenderingStrategy.picture,
          loader: _loader,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
          alignment: widget.alignment,
          placeholderBuilder: (context) {
            if (widget.placeholderBuilder != null) {
              return widget.placeholderBuilder!(context);
            }
            return GtImageShimmer(width: widget.width, height: widget.height);
          },
          // Loading cannot fail, but compiled bytes that do not decode still
          // reach this, and without it the placeholder would never resolve.
          errorBuilder: (_, _, _) => widget.errorWidget ?? errorBox,
          semanticsLabel: widget.semanticsLabel,
          clipBehavior: Clip.antiAlias,
          colorFilter: widget._getColor(context),
        ),
      },
    );

    if (context.inSkeleton) {
      graphic = GtBone(child: graphic);
    }

    // An unlabelled graphic is decoration as far as the user is concerned;
    // announcing it as an anonymous image only adds a stop with no payload.
    if (widget.isDecorative || widget.semanticsLabel == null) {
      return ExcludeSemantics(child: graphic);
    }

    return graphic;
  }
}

/// Wraps a [BytesLoader] so that a failed load is reported to [onError]
/// rather than thrown.
///
/// `vector_graphics` drops a future it chains onto every load, so a load that
/// throws surfaces as an uncaught error even when its error builder handles
/// it. This loader resolves to an empty graphic instead.
///
/// It keeps the default [cacheKey] of the loader itself, so each [GtSvg] runs
/// its own load. Sharing a key would hand one pending load to every widget
/// showing the same graphic, and only the first would hear of a failure.
class _SafeBytesLoader extends BytesLoader {
  /// The loader that reads the graphic.
  final BytesLoader inner;

  /// Called when [inner] fails to load.
  final VoidCallback onError;

  /// Creates a [_SafeBytesLoader] around [inner].
  const _SafeBytesLoader(this.inner, {required this.onError});

  /// A blank graphic, returned in place of one that failed to load.
  static final _emptyGraphic = encodeSvg(
    xml: '<svg xmlns="http://www.w3.org/2000/svg" width="1" height="1"/>',
    debugName: 'GtSvg failed load',
    // The optimizers need native path ops, which only the build-time compiler
    // initialises.
    enableClippingOptimizer: false,
    enableMaskingOptimizer: false,
    enableOverdrawOptimizer: false,
  ).buffer.asByteData();

  @override
  Future<ByteData> loadBytes(BuildContext? context) async {
    try {
      return await inner.loadBytes(context);
    } catch (_) {
      onError();
      return _emptyGraphic;
    }
  }
}
