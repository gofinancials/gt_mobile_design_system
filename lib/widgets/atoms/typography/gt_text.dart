import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A foundational text widget for the Go Tech design system.
///
/// This widget wraps Flutter's standard [Text] widget, applying the design system's
/// default typography styles automatically if no [style] is provided.
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
  final bool? softWrap;

  /// The maximum number of lines for the text to span, wrapping if necessary.
  final int? maxLines;

  /// The directionality of the text.
  final TextDirection? textDirection;

  /// How visual overflow should be handled.
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
    super.key,
  }) : assert(
         headingLevel == null || (headingLevel >= 1 && headingLevel <= 6),
         'headingLevel must be between 1 and 6',
       );

  @override
  Widget build(BuildContext context) {
    final computedStyle = style != null ? style! : context.textStyles.bodyS();

    final text = Text(
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

    if (headingLevel == null) return text;

    return GtSemantics(role: .heading, headingLevel: headingLevel, child: text);
  }
}
