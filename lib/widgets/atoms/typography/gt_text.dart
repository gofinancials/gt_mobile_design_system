import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtText extends GtStatelessWidget {
  final String? data;
  final TextStyle? style;
  final TextAlign? textAlign;
  final Locale? locale;
  final StrutStyle? strutStyle;
  final bool? softWrap;
  final int? maxLines;
  final TextDirection? textDirection;
  final TextOverflow? overflow;

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
    final computedStyle = style != null ? style! : context.textStyles.bodyM();

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
