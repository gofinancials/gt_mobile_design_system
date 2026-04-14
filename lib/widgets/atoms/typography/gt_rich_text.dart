import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:styled_text/styled_text.dart';

class GtRichText extends GtStatelessWidget {
  final TextAlign? textAlign;
  final TextStyle? textStyle;
  final TextOverflow? textOverflow;
  final String? text;
  final Color? hashTagColor;
  final int? maxLines;
  final OnChanged<String>? onTextTap;
  final Map<String, StyledTextActionTag>? tags;

  const GtRichText(
    this.text, {
    this.textStyle,
    this.textAlign,
    this.maxLines,
    this.hashTagColor,
    this.textOverflow,
    this.onTextTap,
    super.key,
    this.tags,
  });

  String? get _parsedText {
    String inputText = text.value;
    final hashTags = AppRegex.hashTagRegex.allMatches(inputText);

    if (!hashTags.hasValue) return text;

    final splitText = inputText.split(" ");

    for (var (index, it) in splitText.indexed) {
      final match = AppRegex.hashTagRegex.stringMatch(it);
      if (!match.hasValue) continue;
      splitText[index] = "<ht>$match</ht>";
    }

    return splitText.join(" ");
  }

  @override
  Widget build(BuildContext context) {
    final style = textStyle ?? context.textStyles.bodyM();
    final content = _parsedText.value;

    launch(String? text, Map<String?, String?> attributes) {
      final url = attributes["href"] ?? text.value;
      if (onTextTap != null) {
        onTextTap?.call(url);
        return;
      }
      launchUrl(url);
    }

    final defaultTags = {
      'p': StyledTextActionTag(
        (text, attributes) => onTextTap?.call(text.value),
        style: style,
      ),
      'e': StyledTextActionTag(
        (text, attributes) => onTextTap?.call(text.value),
        style: style.copyWith(color: context.palette.error.base),
      ),
      'ht': StyledTextActionTag(
        (text, attributes) => onTextTap?.call(text.value),
        style: style.copyWith(
          color: hashTagColor ?? context.palette.highlighted.base,
        ),
      ),
      'h1': StyledTextActionTag(
        (text, attributes) => onTextTap?.call(text.value),
        style: context.textStyles.h1(),
      ),
      'h2': StyledTextActionTag(
        (text, attributes) => onTextTap?.call(text.value),
        style: context.textStyles.h2(),
      ),
      'h3': StyledTextActionTag(
        (text, attributes) => onTextTap?.call(text.value),
        style: context.textStyles.h3(),
      ),
      'h4': StyledTextActionTag(
        (text, attributes) => onTextTap?.call(text.value),
        style: context.textStyles.h4(),
      ),
      'h5': StyledTextActionTag(
        (text, attributes) => onTextTap?.call(text.value),
        style: context.textStyles.h5(),
      ),
      'h6': StyledTextActionTag(
        (text, attributes) => onTextTap?.call(text.value),
        style: context.textStyles.h6(),
      ),
      'b': StyledTextActionTag(
        (text, attributes) => onTextTap?.call(text.value),
        style: style.copyWith(fontWeight: FontWeight.bold),
      ),
      'sb': StyledTextActionTag(
        (text, attributes) => onTextTap?.call(text.value),
        style: style.copyWith(fontWeight: FontWeight.w600),
      ),
      'm': StyledTextActionTag(
        (text, attributes) => onTextTap?.call(text.value),
        style: style.copyWith(fontWeight: FontWeight.w500),
      ),
      'em': StyledTextActionTag(
        (text, attributes) => onTextTap?.call(text.value),
        style: style.copyWith(fontStyle: FontStyle.italic),
      ),
      'strong': StyledTextActionTag(
        (text, attributes) => onTextTap?.call(text.value),
        style: style.copyWith(fontWeight: FontWeight.bold),
      ),
      'u': StyledTextActionTag(
        (text, attributes) => onTextTap?.call(text.value),
        style: style.copyWith(
          decoration: TextDecoration.underline,
          decorationColor: style.color,
        ),
      ),
      'bu': StyledTextActionTag(
        (text, attributes) => onTextTap?.call(text.value),
        style: style.copyWith(
          decoration: TextDecoration.underline,
          decorationColor: style.color,
          fontWeight: FontWeight.bold,
        ),
      ),
      'mu': StyledTextActionTag(
        (text, attributes) => onTextTap?.call(text.value),
        style: style.copyWith(
          decoration: TextDecoration.underline,
          decorationColor: style.color,
          fontWeight: FontWeight.w600,
        ),
      ),
      'a': StyledTextActionTag(
        launch,
        style: style.copyWith(
          decoration: TextDecoration.underline,
          decorationColor: style.color,
        ),
      ),
      'ba': StyledTextActionTag(
        launch,
        style: style.copyWith(
          decoration: TextDecoration.underline,
          decorationColor: style.color,
          fontWeight: FontWeight.w600,
        ),
      ),
      'sba': StyledTextActionTag(
        launch,
        style: style.copyWith(
          decoration: TextDecoration.underline,
          decorationColor: style.color,
          fontWeight: FontWeight.w600,
        ),
      ),
      'ma': StyledTextActionTag(
        launch,
        style: style.copyWith(
          decoration: TextDecoration.underline,
          decorationColor: style.color,
          fontWeight: FontWeight.w500,
        ),
      ),
    };

    final computedTags = defaultTags;

    if (tags != null) computedTags.addAll(tags!);

    return StyledText(
      text: content,
      textAlign: textAlign,
      style: style,
      maxLines: maxLines,
      overflow: textOverflow,
      textDirection: text.directionality,
      tags: computedTags,
    );
  }
}
