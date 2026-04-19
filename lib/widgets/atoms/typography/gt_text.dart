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
  /// If null, defaults to the `bodyM` text style from the current context.
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
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final computedStyle = style != null ? style! : context.textStyles.bodyS();

    return Text(
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
    );
  }
}
