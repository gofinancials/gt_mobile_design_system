import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// How long one sweep of the shimmer highlight takes to cross a skeleton.
const Duration _kSweepPeriod = Duration(milliseconds: 1500);

/// The share of a text line's height trimmed from its top and its bottom, so a
/// text bone reads as a bar of glyphs rather than as the whole line box.
const double _kTextLineInset = 0.18;

// -----------------------------------------------------------------------------
// Scope
// -----------------------------------------------------------------------------

/// Publishes whether the subtree below is drawn as a skeleton, and how.
///
/// A [GtSkeleton] inserts one of these; it is not built directly. Atoms read it
/// through [GtSkeletonContextExtension.inSkeleton] to decide whether to wrap
/// themselves in a [GtBone], and every [GtBone] reads it to find the shared
/// sweep it paints with. The nearest scope wins, so a [GtSkeleton] with
/// `enabled: false` keeps a subtree real inside a larger skeleton.
class GtSkeletonScope extends InheritedWidget {
  /// Whether the subtree below is drawn as bones.
  final bool enabled;

  /// Whether the highlight sweeps across the bones.
  ///
  /// False while the user has asked to reduce motion, in which case every bone
  /// is painted in [baseColor] alone.
  final bool animate;

  /// The phase of the sweep, from 0 to 1, shared by every bone in the scope.
  final Animation<double> sweep;

  /// Resolves the box the sweep's gradient is laid across.
  ///
  /// Every bone positions its gradient against this box rather than against
  /// itself, which is what keeps the highlight one continuous band across
  /// every bone instead of a separate flash on each.
  final ValueGetter<RenderBox?> frame;

  /// The resting color of a bone.
  final Color baseColor;

  /// The color at the crest of the sweep.
  final Color highlightColor;

  /// Creates a [GtSkeletonScope].
  const GtSkeletonScope({
    super.key,
    required this.enabled,
    required this.animate,
    required this.sweep,
    required this.frame,
    required this.baseColor,
    required this.highlightColor,
    required super.child,
  });

  /// The nearest scope above [context], or null outside any [GtSkeleton].
  static GtSkeletonScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GtSkeletonScope>();
  }

  @override
  bool updateShouldNotify(GtSkeletonScope oldWidget) {
    return enabled != oldWidget.enabled ||
        animate != oldWidget.animate ||
        sweep != oldWidget.sweep ||
        frame != oldWidget.frame ||
        baseColor != oldWidget.baseColor ||
        highlightColor != oldWidget.highlightColor;
  }
}

/// An extension on [BuildContext] telling a widget whether it is being drawn
/// as a skeleton.
extension GtSkeletonContextExtension on BuildContext {
  /// Whether the nearest [GtSkeleton] above this context is enabled.
  ///
  /// Atoms check this before wrapping themselves in a [GtBone], so a widget
  /// outside any skeleton gains no extra render object. Reads `false` outside
  /// any [GtSkeleton], and rebuilds the caller when the setting changes.
  bool get inSkeleton => GtSkeletonScope.maybeOf(this)?.enabled ?? false;
}

// -----------------------------------------------------------------------------
// Skeleton
// -----------------------------------------------------------------------------

/// Draws [child] as a shimmering skeleton of itself while [enabled].
///
/// The design system's atoms are skeleton-aware: below an enabled
/// [GtSkeleton], [GtText] paints a bar over each line it lays out, [GtIcon]
/// and the image atoms paint a block over their bounds, and controls such as
/// buttons and pills paint a single block in their own shape. Anything built
/// from them — a tile, a card, a receipt — therefore becomes its own skeleton,
/// laid out exactly as the real thing, with no skeleton written by hand.
///
/// ```dart
/// GtSkeleton(
///   enabled: controller.account.isLoading,
///   semanticsLabel: 'Loading account',
///   child: GtAccountListTile(...),
/// )
/// ```
///
/// While enabled, the subtree is hidden from assistive technology, takes no
/// focus and absorbs taps, so the placeholder data a skeleton is laid out with
/// is never read out or acted on. [semanticsLabel] is announced in its place.
///
/// One highlight sweeps across every bone in the skeleton together. A
/// [GtSkeleton] nested in an enabled one joins its parent's sweep, and every
/// skeleton starts its sweep in phase with the wall clock, so separate
/// skeletons on one screen move together too. With
/// [GtAccessibilityContextExtension.reduceMotion] set the bones hold still in
/// their base color, which is also what lets a test that sets
/// [MediaQueryData.disableAnimations] `pumpAndSettle`.
///
/// The tree below is the same whether or not [enabled] is set, so toggling it
/// keeps the subtree's state.
///
/// [child] must be a box. For a list of skeleton rows, inside or outside a
/// [CustomScrollView], use [GtSkeletonList].
class GtSkeleton extends GtStatefulWidget {
  /// The subtree drawn as a skeleton.
  final Widget child;

  /// Whether [child] is drawn as a skeleton. When false, [child] is drawn as
  /// it is.
  final bool enabled;

  /// What is announced while the skeleton is on screen, such as "Loading
  /// transactions".
  ///
  /// The package holds no copy of its own, so the host supplies a localised
  /// string. Null announces nothing, which suits a skeleton nested in a larger
  /// one, or one standing in for an image.
  final String? semanticsLabel;

  /// Overrides the resting color of the bones.
  ///
  /// Defaults to [GtPaletteBgColors.soft] from the palette's fill colors.
  final Color? baseColor;

  /// Overrides the color at the crest of the sweep.
  ///
  /// Defaults to a blend of [baseColor] towards white in light mode, and
  /// towards [GtPaletteBgColors.sub] from the fill colors in dark mode.
  final Color? highlightColor;

  /// Overrides how long one sweep takes. Defaults to 1.5 seconds.
  final Duration? period;

  /// Creates a [GtSkeleton] over [child].
  const GtSkeleton({
    super.key,
    required this.child,
    this.enabled = true,
    this.semanticsLabel,
    this.baseColor,
    this.highlightColor,
    this.period,
  });

  @override
  State<GtSkeleton> createState() => _GtSkeletonState();
}

/// The state of a [GtSkeleton], which owns the sweep's ticker.
class _GtSkeletonState extends State<GtSkeleton>
    with SingleTickerProviderStateMixin {
  /// Drives the sweep while this skeleton owns it.
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.period ?? _kSweepPeriod,
  );

  /// The enabled skeleton above this one, if any, whose sweep this one joins.
  GtSkeletonScope? _parent;

  /// Whether the user has asked to reduce motion.
  bool _reduceMotion = false;

  /// Whether this skeleton joins its parent's sweep instead of running its own.
  bool get _joinsParent => widget.enabled && (_parent?.enabled ?? false);

  /// Whether this skeleton's own ticker should be running.
  bool get _shouldSweep => widget.enabled && !_joinsParent && !_reduceMotion;

  /// The box this skeleton's sweep is laid across: its own.
  RenderBox? _frame() {
    if (!mounted) return null;
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox) return null;
    return renderObject;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _parent = GtSkeletonScope.maybeOf(context);
    _reduceMotion = context.reduceMotion;
    _syncSweep();
  }

  @override
  void didUpdateWidget(covariant GtSkeleton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.duration = widget.period ?? _kSweepPeriod;
    _syncSweep();
  }

  /// Starts or stops the ticker to match [_shouldSweep].
  ///
  /// A sweep starts at the phase the wall clock puts it at, rather than at
  /// zero, so a skeleton mounted after another one sweeps in step with it.
  void _syncSweep() {
    if (!_shouldSweep) {
      _controller.stop();
      return;
    }
    if (_controller.isAnimating) return;

    final period = _controller.duration!.inMicroseconds;
    final now = DateTime.now().microsecondsSinceEpoch;
    _controller.value = (now % period) / period;
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final enabled = widget.enabled;
    final label = widget.semanticsLabel;
    final announces = enabled && label.hasValue;

    Color baseColor = palette.fill.soft;
    if (widget.baseColor != null) {
      baseColor = widget.baseColor!;
    }

    Color highlightColor = Color.lerp(
      baseColor,
      palette.staticColors.white,
      .6,
    )!;
    if (context.isInDarkMode) {
      highlightColor = Color.lerp(baseColor, palette.fill.sub, .5)!;
    }
    if (widget.highlightColor != null) {
      highlightColor = widget.highlightColor!;
    }

    Animation<double> sweep = _controller;
    ValueGetter<RenderBox?> frame = _frame;
    bool animate = !_reduceMotion;
    if (_joinsParent) {
      sweep = _parent!.sweep;
      frame = _parent!.frame;
      animate = _parent!.animate;
    }

    return GtSkeletonScope(
      enabled: enabled,
      animate: animate,
      sweep: sweep,
      frame: frame,
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Semantics(
        container: announces,
        liveRegion: announces ? true : null,
        label: announces ? label : null,
        child: ExcludeSemantics(
          excluding: enabled,
          child: ExcludeFocus(
            excluding: enabled,
            child: AbsorbPointer(absorbing: enabled, child: widget.child),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Bone
// -----------------------------------------------------------------------------

/// Paints a shimmering block over [child] while an enabled [GtSkeleton] is
/// above it, and paints [child] as it is otherwise.
///
/// [child] is still laid out, so a bone takes exactly the space the real
/// widget takes and nothing shifts when the skeleton lifts; it is only not
/// painted. Where [child] lays out text, the bone paints one bar per line,
/// trimmed to the extent of that line's glyphs, rather than a block over the
/// whole paragraph.
///
/// The atoms wrap themselves in a bone already. Reach for it directly to bone a
/// widget the atoms do not cover, such as a custom painter.
class GtBone extends SingleChildRenderObjectWidget {
  /// The corners of the block.
  ///
  /// Defaults to [ThemeContextExtension.borderRadiusSm]. Ignored when
  /// [shape] is [BoxShape.circle], and for text, whose bars are rounded to
  /// their own height.
  final BorderRadiusGeometry? borderRadius;

  /// The shape of the block. Defaults to [BoxShape.rectangle].
  final BoxShape shape;

  /// Creates a [GtBone] over [child].
  const GtBone({
    super.key,
    required super.child,
    this.borderRadius,
    this.shape = .rectangle,
  });

  /// Resolves the corners of the block against [context].
  BorderRadius _resolveRadius(BuildContext context) {
    final radius = borderRadius ?? context.borderRadiusSm;
    return radius.resolve(Directionality.maybeOf(context));
  }

  @override
  RenderGtBone createRenderObject(BuildContext context) {
    return RenderGtBone(
      scope: GtSkeletonScope.maybeOf(context),
      borderRadius: _resolveRadius(context),
      shape: shape,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderGtBone renderObject) {
    renderObject
      ..scope = GtSkeletonScope.maybeOf(context)
      ..borderRadius = _resolveRadius(context)
      ..shape = shape;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<BoxShape>('shape', shape));
    properties.add(
      DiagnosticsProperty<BorderRadiusGeometry>('borderRadius', borderRadius),
    );
  }
}

/// The render object behind [GtBone].
///
/// It lays [child] out as a [RenderProxyBox] does and, while [scope] is
/// enabled, paints the bone in its place. It listens to the scope's sweep only
/// while attached, and repaints on each tick without rebuilding anything.
class RenderGtBone extends RenderProxyBox {
  /// Creates a [RenderGtBone].
  RenderGtBone({
    required GtSkeletonScope? scope,
    required BorderRadius borderRadius,
    required BoxShape shape,
  }) : _scope = scope,
       _borderRadius = borderRadius,
       _shape = shape;

  /// The skeleton this bone belongs to, or null outside any [GtSkeleton].
  GtSkeletonScope? get scope => _scope;

  /// The backing store for [scope].
  GtSkeletonScope? _scope;
  set scope(GtSkeletonScope? value) {
    if (value == _scope) return;
    if (attached) _sweepOf(_scope)?.removeListener(markNeedsPaint);
    _scope = value;
    if (attached) _sweepOf(_scope)?.addListener(markNeedsPaint);
    markNeedsPaint();
  }

  /// The corners of the block.
  BorderRadius get borderRadius => _borderRadius;

  /// The backing store for [borderRadius].
  BorderRadius _borderRadius;
  set borderRadius(BorderRadius value) {
    if (value == _borderRadius) return;
    _borderRadius = value;
    markNeedsPaint();
  }

  /// The shape of the block.
  BoxShape get shape => _shape;

  /// The backing store for [shape].
  BoxShape _shape;
  set shape(BoxShape value) {
    if (value == _shape) return;
    _shape = value;
    markNeedsPaint();
  }

  /// Whether this bone is painted in place of its child.
  bool get _isBoned => _scope?.enabled ?? false;

  /// The sweep to repaint on, or null when [scope] does not animate.
  static Animation<double>? _sweepOf(GtSkeletonScope? scope) {
    if (scope == null || !scope.enabled || !scope.animate) return null;
    return scope.sweep;
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _sweepOf(_scope)?.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    _sweepOf(_scope)?.removeListener(markNeedsPaint);
    super.detach();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final scope = _scope;
    if (scope == null || !scope.enabled) {
      super.paint(context, offset);
      return;
    }

    final paint = Paint()..color = scope.baseColor;
    if (scope.animate) {
      paint.shader = _sweepShader(scope, offset);
    }

    final canvas = context.canvas;
    for (final block in _blocks(offset)) {
      canvas.drawRRect(block, paint);
    }
  }

  /// The blocks to paint for this bone, in the canvas's coordinates.
  ///
  /// One bar per line where the child lays out text, otherwise a single block
  /// in [shape] over the whole bone.
  List<RRect> _blocks(Offset offset) {
    final paragraph = _paragraphOf(child);
    if (paragraph != null) return _textLines(paragraph, offset);

    final rect = offset & size;
    if (shape == .circle) {
      final radius = Radius.circular(size.shortestSide / 2);
      final circle = Rect.fromCenter(
        center: rect.center,
        width: size.shortestSide,
        height: size.shortestSide,
      );
      return [RRect.fromRectAndRadius(circle, radius)];
    }
    return [borderRadius.toRRect(rect)];
  }

  /// Finds the paragraph [box] lays out, looking through any proxies that
  /// share its origin, such as the semantics a [Text] adds.
  static RenderParagraph? _paragraphOf(RenderBox? box) {
    RenderBox? current = box;
    while (current is RenderProxyBox) {
      current = current.child;
    }
    if (current is! RenderParagraph) return null;
    return current;
  }

  /// One bar per laid-out line of [paragraph], trimmed to its glyphs.
  ///
  /// Empty boxes, such as those of zero-size inline placeholders, are skipped,
  /// so they neither paint a sliver of their own nor split a line in two.
  static List<RRect> _textLines(RenderParagraph paragraph, Offset offset) {
    final length = paragraph.text
        .toPlainText(includeSemanticsLabels: false)
        .length;
    final boxes = paragraph.getBoxesForSelection(
      TextSelection(baseOffset: 0, extentOffset: length),
    );

    final lines = <Rect>[];
    for (final box in boxes) {
      final rect = box.toRect();
      if (rect.isEmpty) continue;
      final isSameLine =
          lines.isNotEmpty &&
          rect.top < lines.last.bottom &&
          rect.bottom > lines.last.top;
      if (isSameLine) {
        lines.last = lines.last.expandToInclude(rect);
        continue;
      }
      lines.add(rect);
    }

    return [for (final line in lines) _textBar(line.shift(offset))];
  }

  /// The bar painted for one [line] of text.
  static RRect _textBar(Rect line) {
    final inset = line.height * _kTextLineInset;
    final bar = Rect.fromLTRB(
      line.left,
      line.top + inset,
      line.right,
      line.bottom - inset,
    );
    return RRect.fromRectAndRadius(bar, Radius.circular(bar.height / 2));
  }

  /// The sweep's gradient, laid across [scope]'s frame and shifted to the
  /// sweep's current phase.
  ///
  /// The gradient is positioned in the frame's coordinates, so every bone
  /// paints its own slice of one shared band. Positions are compared in global
  /// coordinates, which holds even where the frame is not an ancestor the
  /// render tree can walk to directly.
  Shader _sweepShader(GtSkeletonScope scope, Offset offset) {
    Rect bounds = offset & size;
    final frame = scope.frame();
    if (frame != null && frame.attached && frame.hasSize) {
      final inFrame =
          localToGlobal(Offset.zero) - frame.localToGlobal(Offset.zero);
      bounds = (offset - inFrame) & frame.size;
    }

    final gradient = LinearGradient(
      begin: const Alignment(-1, -.3),
      end: const Alignment(1, .3),
      colors: [scope.baseColor, scope.highlightColor, scope.baseColor],
      stops: const [.35, .5, .65],
      transform: _GtSweepTransform(scope.sweep.value),
    );
    return gradient.createShader(bounds);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(FlagProperty('boned', value: _isBoned, ifTrue: 'boned'));
    properties.add(EnumProperty<BoxShape>('shape', shape));
  }
}

/// Slides the sweep's gradient across its bounds.
///
/// At a [phase] of 0 the highlight sits one full width before the bounds, and
/// at 1 one full width past them, so it enters and leaves off-screen.
class _GtSweepTransform extends GradientTransform {
  /// How far through the sweep the highlight is, from 0 to 1.
  final double phase;

  /// Creates a [_GtSweepTransform] at [phase].
  const _GtSweepTransform(this.phase);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    final slide = math.max(bounds.width, 1) * (phase * 2 - 1);
    return Matrix4.translationValues(slide, 0, 0);
  }
}
