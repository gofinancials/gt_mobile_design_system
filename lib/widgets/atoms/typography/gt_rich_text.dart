import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:styled_text/styled_text.dart';

/// A versatile rich text widget that parses and renders HTML-like tags using the Go Tech design system.
///
/// This widget uses the `styled_text` package under the hood to apply custom text styles
/// to specific tags within the [text] string. It comes pre-configured with standard tags
/// like `<b>`, `<i>`, `<a>`, `<p>`, headings (`<h1>`-`<h6>`), and custom tags like `<ht>`
/// for hashtags and `<e>` for error styling.
///
/// Additionally, it automatically detects hashtags in the raw [text] and wraps them
/// in `<ht>` tags.
class GtRichText extends GtStatelessWidget {
  /// How the text should be aligned horizontally.
  final TextAlign? textAlign;

  /// The base text style applied to the text. Defaults to the `bodyM` style from the current context.
  final TextStyle? textStyle;

  /// How visual overflow should be handled.
  final TextOverflow? textOverflow;

  /// The raw string containing the text and any HTML-like styling tags.
  final String? text;

  /// The color used to style automatically detected hashtags (`<ht>` tags). Defaults to the highlighted base color.
  final Color? hashTagColor;

  /// The maximum number of lines for the text to span, wrapping if necessary.
  final int? maxLines;

  /// A callback triggered when interactive text elements (like links or specific tags) are tapped.
  final OnChanged<String>? onTextTap;

  /// Additional custom styling tags to merge with the default set.
  final Map<String, StyledTextActionTag>? tags;

  /// Creates a new [GtRichText] widget.
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
