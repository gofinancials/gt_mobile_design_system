import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:styled_text/styled_text.dart';

class GtStyledTextTag extends StyledTextTag {
  /// A callback to be called when the tag is tapped.
  final StyledTextTagActionCallback? onTap;

  const GtStyledTextTag({super.style, this.onTap});

  @override
  GestureRecognizer? createRecognizer(
    String? text,
    Map<String?, String?> attributes,
  ) {
    return TapGestureRecognizer()..onTap = () => onTap?.call(text, attributes);
  }
}

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
  final TextStyle? style;

  /// How visual overflow should be handled.
  final TextOverflow? textOverflow;

  /// The raw string containing the text and any HTML-like styling tags.
  final String? text;

  /// The color used to style automatically detected hashtags (`<ht>` tags). Defaults to the highlighted base color.
  final Color? hashTagColor;

  /// The color used for links (`<a>`, `<b><a>`, etc.). Defaults to the base text color.
  final Color? linkColor;

  /// The maximum number of lines for the text to span, wrapping if necessary.
  final int? maxLines;

  /// A callback triggered when interactive text elements (like links or specific tags) are tapped.
  final OnChanged<String>? onTextTap;

  /// Additional custom styling tags to merge with the default set.
  final Map<String, GtStyledTextTag>? tags;

  /// Creates a new [GtRichText] widget.
  const GtRichText(
    this.text, {
    this.style,
    this.textAlign,
    this.maxLines,
    this.hashTagColor,
    this.textOverflow,
    this.onTextTap,
    this.linkColor,
    super.key,
    this.tags,
  });

  /// Parses the input [text] to detect and wrap hashtags in `<ht>` tags.
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

  void _launch(String? text, Map<String?, String?> attributes) {
    final url = attributes["href"] ?? text.value;
    if (!url.hasValue) return;
    launchUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    final style = this.style ?? context.textStyles.bodyM();
    final content = _parsedText.value;

    final Map<String, StyledTextTag> defaultTags = {
      'i': StyledTextTag(style: style.copyWith(fontStyle: .italic)),
      'im': StyledTextTag(
        style: style.copyWith(fontStyle: .italic, fontWeight: .w500),
      ),
      'ib': StyledTextTag(
        style: style.copyWith(fontStyle: .italic, fontWeight: .bold),
      ),
      'p': StyledTextTag(style: style),
      'e': StyledTextTag(
        style: style.copyWith(color: context.palette.error.base),
      ),
      'ht': GtStyledTextTag(
        style: style.copyWith(
          color: hashTagColor ?? context.palette.highlighted.base,
        ),
        onTap: (text, attributes) => onTextTap?.call(text.value),
      ),
      'h1': StyledTextTag(style: context.textStyles.h1()),
      'h2': StyledTextTag(style: context.textStyles.h2()),
      'h3': StyledTextTag(style: context.textStyles.h3()),
      'h4': StyledTextTag(style: context.textStyles.h4()),
      'h5': StyledTextTag(style: context.textStyles.h5()),
      'h6': StyledTextTag(style: context.textStyles.h6()),
      'b': StyledTextTag(style: style.copyWith(fontWeight: FontWeight.bold)),
      'sb': StyledTextTag(style: style.copyWith(fontWeight: FontWeight.w600)),
      'm': StyledTextTag(style: style.copyWith(fontWeight: FontWeight.w500)),
      'em': StyledTextTag(style: style.copyWith(fontStyle: FontStyle.italic)),
      'strong': StyledTextTag(
        style: style.copyWith(fontWeight: FontWeight.bold),
      ),
      'u': StyledTextTag(
        style: style.copyWith(
          decoration: TextDecoration.underline,
          decorationColor: style.color,
        ),
      ),
      'bu': StyledTextTag(
        style: style.copyWith(
          decoration: TextDecoration.underline,
          decorationColor: style.color,
          fontWeight: FontWeight.bold,
        ),
      ),
      'mu': StyledTextTag(
        style: style.copyWith(
          decoration: TextDecoration.underline,
          decorationColor: style.color,
          fontWeight: FontWeight.w600,
        ),
      ),
      'a': StyledTextActionTag(
        _launch,
        style: style.copyWith(color: linkColor ?? style.color),
      ),
      'ba': StyledTextActionTag(
        _launch,
        style: style.copyWith(
          color: linkColor ?? style.color,
          fontWeight: FontWeight.w600,
        ),
      ),
      'sba': StyledTextActionTag(
        _launch,
        style: style.copyWith(
          color: linkColor ?? style.color,
          fontWeight: FontWeight.w600,
        ),
      ),
      'ma': StyledTextActionTag(
        _launch,
        style: style.copyWith(
          color: linkColor ?? style.color,
          fontWeight: FontWeight.w500,
        ),
      ),
    };

    final computedTags = defaultTags;

    if (tags != null) computedTags.addAll(tags!);

    return StyledText(
      key: ValueKey(Object.hash(computedTags, context.isInDarkMode)),
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
