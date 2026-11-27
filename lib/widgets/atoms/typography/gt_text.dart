import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A foundational text widget for the Go Tech design system.
///
/// This widget wraps Flutter's standard [Text] widget, applying the design system's
/// default typography styles automatically if no [style] is provided.
///
/// Inside an enabled [GtSkeleton] it is laid out as usual but painted as one
/// [GtBone] bar per line, trimmed to that line's glyphs, and it drops its
/// [headingLevel], since the skeleton hides it from assistive technology.
///
/// Set [middleEllipsis] for a value whose end carries its meaning, such as an
/// account number, an IBAN or a reference: it is then shortened from the
/// middle, keeping its head and tail, instead of losing its end.
class GtText extends GtStatelessWidget {
  /// The text string to display.
  final String? data;

  /// The style to use for the text.
  ///
  /// If null, defaults to the `bodyS` text style from the current context.
  final TextStyle? style;

  /// How the text should be aligned horizontally. Defaults to [TextAlign.start].
  final TextAlign? textAlign;

  /// The locale used to select region-specific glyphs.
  final Locale? locale;

  /// The strut style used for the vertical layout.
  final StrutStyle? strutStyle;

  /// Whether the text should break at soft line breaks.
  ///
  /// Ignored when [middleEllipsis] is set, which always wraps within
  /// [maxLines].
  final bool? softWrap;

  /// The maximum number of lines for the text to span, wrapping if necessary.
  final int? maxLines;

  /// The directionality of the text.
  final TextDirection? textDirection;

  /// How visual overflow should be handled.
  ///
  /// Ignored when [middleEllipsis] is set.
  final TextOverflow? overflow;

  /// An alternative semantics label for this text.
  final String? semanticsLabel;

  /// Where this text sits in the screen's structure, from 1 to 6.
  ///
  /// Text renders a semantics node on its own, so this is not about being
  /// *announced* — it already is. It is about being announced as a **heading**,
  /// which is what lets a screen reader user jump between sections instead of
  /// swiping through every element in order. Styling text with `h1()`–`h6()`
  /// gives none of that by itself.
  ///
  /// Reserve it for structural headings: level 1 for the screen's title, 2 for
  /// a section within it, and so on. Marking every large-looking label as a
  /// heading is as unhelpful as marking none of them.
  final int? headingLevel;

  /// Whether text too long for its box is shortened from the middle rather
  /// than the end. Defaults to false.
  ///
  /// When set, a [data] that does not wrap into the width it is given within
  /// [maxLines] lines, or one line when [maxLines] is null, keeps as many
  /// characters as fit, split between its head and tail either side of a
  /// single `…`. So `"Domiciliary Account • 0123456789"` can read
  /// `"Domiciliary…0123456789"` rather than `"Domiciliary Account • 01…"`.
  /// [overflow] and [softWrap] are ignored. A shortened [data] is still
  /// announced whole, as the [semanticsLabel] when none is given.
  ///
  /// The cut is measured by [GtTextFit] against the width the text is laid
  /// out at, so it follows the ambient text scale and bold-text setting. In an
  /// unbounded width the text is never shortened. Unlike a [LayoutBuilder], it
  /// can sit under an [IntrinsicHeight] or [IntrinsicWidth], reporting the
  /// whole [data] as its widest and a lone `…` as its narrowest.
  ///
  /// Leave it off for prose, names and labels, where the start matters most
  /// and a plain end ellipsis reads better.
  final bool middleEllipsis;

  /// Creates a new [GtText] widget.
  const GtText(
    this.data, {
    this.style,
    this.textAlign,
    this.locale,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.strutStyle,
    this.textDirection,
    this.semanticsLabel,
    this.headingLevel,
    this.middleEllipsis = false,
    super.key,
  }) : assert(
         headingLevel == null || (headingLevel >= 1 && headingLevel <= 6),
         'headingLevel must be between 1 and 6',
       );

  @override
  Widget build(BuildContext context) {
    final computedStyle = style != null ? style! : context.textStyles.bodyS();

    Widget text = Text(
      data ?? "",
      style: computedStyle,
      strutStyle: strutStyle,
      textAlign: textAlign ?? TextAlign.start,
      locale: locale,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      textDirection: textDirection,
      textWidthBasis: TextWidthBasis.parent,
      semanticsLabel: semanticsLabel,
    );

    if (middleEllipsis) {
      final full = data ?? "";
      final lines = maxLines ?? 1;

      text = _GtMiddleEllipsisText(
        full,
        spec: (
          style: GtTextFit.resolveStyle(context, computedStyle),
          textDirection: textDirection ?? Directionality.of(context),
          textScaler: MediaQuery.textScalerOf(context),
          maxLines: lines,
          strutStyle: strutStyle,
          locale: locale,
          textHeightBehavior: GtTextFit.resolveTextHeightBehavior(context),
        ),
        builder: (_, shown) => Text(
          shown,
          style: computedStyle,
          strutStyle: strutStyle,
          textAlign: textAlign ?? TextAlign.start,
          locale: locale,
          maxLines: lines,
          // A backstop only: the shown text already fits, unless a lone `…`
          // is still too wide.
          overflow: .ellipsis,
          textDirection: textDirection,
          textWidthBasis: TextWidthBasis.parent,
          semanticsLabel: semanticsLabel ?? (shown == full ? null : full),
        ),
      );
    }

    if (context.inSkeleton) return GtBone(child: text);
    if (headingLevel == null) return text;

    return GtSemantics(role: .heading, headingLevel: headingLevel, child: text);
  }
}

/// Everything [GtTextFit] measures a [_GtMiddleEllipsisText] with, resolved
/// by [GtText] so that a change to any of it rebuilds the text.
typedef _GtTextFitSpec = ({
  TextStyle style,
  TextDirection textDirection,
  TextScaler textScaler,
  int maxLines,
  StrutStyle? strutStyle,
  Locale? locale,
  TextHeightBehavior? textHeightBehavior,
});

/// Builds [GtText.middleEllipsis]'s [Text] at layout time, from [text] as
/// [GtTextFit.middleEllipsis] cuts it to the incoming width.
class _GtMiddleEllipsisText extends AbstractLayoutBuilder<String> {
  /// The whole text, before any cut.
  final String text;

  /// How [text] is measured.
  final _GtTextFitSpec spec;

  @override
  final Widget Function(BuildContext context, String shown) builder;

  /// Creates a [_GtMiddleEllipsisText].
  const _GtMiddleEllipsisText(
    this.text, {
    required this.spec,
    required this.builder,
  });

  @override
  _RenderGtMiddleEllipsisText createRenderObject(BuildContext context) {
    return _RenderGtMiddleEllipsisText(text, spec);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderGtMiddleEllipsisText renderObject,
  ) {
    renderObject
      ..text = text
      ..spec = spec;
  }
}

/// Cuts its text to the incoming width before building its [Text] child, and
/// answers intrinsic and dry layout queries by measuring the cut directly, so
/// it never has to build speculatively.
///
/// A proxy box, so a [GtBone] looks straight through it to the paragraph.
///
/// Re-measures when the system's fonts change, as a [RenderParagraph] does.
/// On web an asset font arrives after the first frame, and a cut measured in
/// the fallback font would overflow once drawn in the real one, falling back
/// to the [Text]'s end ellipsis.
class _RenderGtMiddleEllipsisText extends RenderProxyBox
    with
        RelayoutWhenSystemFontsChangeMixin,
        RenderObjectWithLayoutCallbackMixin,
        RenderAbstractLayoutBuilderMixin<String, RenderBox> {
  _RenderGtMiddleEllipsisText(this._text, this._spec);

  /// The most widths [_cutTo] remembers. A box animating its width asks for
  /// a new one each frame; the oldest is dropped rather than kept forever.
  static const int _maxCuts = 8;

  String _text;
  _GtTextFitSpec _spec;
  GtTextFit? _fit;
  String _shown = "";

  /// [_text] as cut to each recently asked width, so that intrinsic, dry and
  /// real layout at one width share a single search, and a relayout that
  /// only a child asked for runs none.
  final Map<double, String> _cuts = {};

  /// The whole text, before any cut.
  set text(String value) {
    if (value == _text) return;
    _text = value;
    _cuts.clear();
    markNeedsLayout();
  }

  /// How [text] is measured.
  set spec(_GtTextFitSpec value) {
    if (value == _spec) return;
    _spec = value;
    _fit?.dispose();
    _fit = null;
    _cuts.clear();
    markNeedsLayout();
  }

  GtTextFit get _measure {
    return _fit ??= GtTextFit(
      style: _spec.style,
      textDirection: _spec.textDirection,
      textScaler: _spec.textScaler,
      maxLines: _spec.maxLines,
      strutStyle: _spec.strutStyle,
      locale: _spec.locale,
      textHeightBehavior: _spec.textHeightBehavior,
    );
  }

  /// [_text] as [GtTextFit.middleEllipsis] cuts it to [width], remembered.
  String _cutTo(double width) {
    if (_cuts[width] case final cut?) return cut;
    if (_cuts.length >= _maxCuts) _cuts.remove(_cuts.keys.first);

    return _cuts[width] = _measure.middleEllipsis(_text, width);
  }

  @override
  String get layoutInfo => _shown;

  @override
  void performLayout() {
    _shown = _cutTo(constraints.maxWidth);
    runLayoutCallback();
    super.performLayout();
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    final ellipsis = _measure.sizeOf(GtTextFit.ellipsis).width;
    return math.min(ellipsis, computeMaxIntrinsicWidth(height));
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return _measure.sizeOf(_text).width;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    final shown = _cutTo(width);
    return _measure.sizeOf(shown, maxWidth: width).height;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return computeMinIntrinsicHeight(width);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final shown = _cutTo(constraints.maxWidth);
    final size = _measure.sizeOf(
      shown,
      minWidth: constraints.minWidth,
      maxWidth: constraints.maxWidth,
    );

    return constraints.constrain(size);
  }

  @override
  double? computeDryBaseline(
    BoxConstraints constraints,
    TextBaseline baseline,
  ) {
    final shown = _cutTo(constraints.maxWidth);
    return _measure.baselineOf(shown, baseline, maxWidth: constraints.maxWidth);
  }

  @override
  void systemFontsDidChange() {
    // The painter caches its last layout, in what may be the fallback font.
    _fit?.dispose();
    _fit = null;
    _cuts.clear();
    super.systemFontsDidChange();
  }

  @override
  void dispose() {
    _fit?.dispose();
    super.dispose();
  }
}
