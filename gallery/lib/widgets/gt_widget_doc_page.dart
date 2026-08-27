import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/extensions/string_extensions.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtWidgetDocPage extends GtStatelessWidget {
  final String title;
  final String? description;
  final String? code;
  final Widget child;
  final List<Widget>? knobs;

  /// What a consumer has to do to make this component accessible.
  ///
  /// Use it for the obligations the API cannot enforce on its own: which label
  /// to supply, which role the surface should declare, what a screen reader
  /// announces, and any known limitation. Toggle the Accessibility addon while
  /// reading these to see the component under the settings they describe.
  final List<String>? accessibilityNotes;

  const GtWidgetDocPage({
    required this.title,
    this.description,
    this.code,
    required this.child,
    this.knobs,
    this.accessibilityNotes,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.palette.bg.white,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: context.insets.defaultAllInsets,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GalleryPageHeader(title: title, rider: description),

              GallerySectionCard('Preview', child: child),

              // Interactive Controls (Knobs)
              if (knobs != null && knobs!.isNotEmpty)
                GallerySectionCard(
                  'Interactive Controls',
                  padding: .zero,
                  child: Wrap(
                    spacing: 24.px,
                    runSpacing: 24.px,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: knobs!,
                  ),
                ),

              if (accessibilityNotes != null && accessibilityNotes!.isNotEmpty)
                GallerySectionCard(
                  'Accessibility',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      for (final note in accessibilityNotes!)
                        _AccessibilityNote(note),
                    ],
                  ),
                ),

              if (code.hasValue)
                GallerySectionCard(
                  'Implementation',
                  padding: .zero,
                  child: _CodeBlock(code: code!.trim()),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CodeBlock extends GtStatefulWidget {
  final String code;

  const _CodeBlock({required this.code});

  @override
  State<_CodeBlock> createState() => _CodeBlockState();
}

class _CodeBlockState extends State<_CodeBlock> {
  static const _backgroundColor = Color(0xFF1E1E3F);
  static const _keywords = {
    'as',
    'async',
    'await',
    'break',
    'case',
    'catch',
    'class',
    'const',
    'continue',
    'default',
    'do',
    'else',
    'enum',
    'extends',
    'extension',
    'false',
    'final',
    'finally',
    'for',
    'get',
    'hide',
    'if',
    'implements',
    'import',
    'in',
    'is',
    'library',
    'mixin',
    'new',
    'null',
    'of',
    'on',
    'part',
    'required',
    'return',
    'set',
    'show',
    'static',
    'super',
    'switch',
    'sync',
    'this',
    'throw',
    'true',
    'try',
    'typedef',
    'var',
    'void',
    'while',
    'with',
    'yield',
  };
  static final _tokenPattern = RegExp(
    r'(//[^\n]*)|'
    r'("(?:[^"\\]|\\.)*")|'
    r"('(?:[^'\\]|\\.)*')|"
    r'(\b\d+(?:\.\d+)?\b)|'
    r'(\b[a-zA-Z_][a-zA-Z0-9_]*\b)|'
    r'([^\s<>&])|'
    r'([<>&])|'
    r'(\s+)',
  );
  static final _upperCasePattern = RegExp('[A-Z]');
  static final _tags = <String, GtStyledTextTag>{
    'comment': const GtStyledTextTag(
      style: TextStyle(color: Color(0xFFB362FF), fontStyle: FontStyle.italic),
    ),
    'string': const GtStyledTextTag(style: TextStyle(color: Color(0xFF3AD900))),
    'number': const GtStyledTextTag(style: TextStyle(color: Color(0xFFFF628C))),
    'keyword': const GtStyledTextTag(
      style: TextStyle(color: Color(0xFFFF9D00)),
    ),
    'type': const GtStyledTextTag(style: TextStyle(color: Color(0xFF9EFFFF))),
    'constant': const GtStyledTextTag(
      style: TextStyle(color: Color(0xFFFF628C)),
    ),
    'punctuation': const GtStyledTextTag(
      style: TextStyle(color: Color(0xFFFFE45E)),
    ),
  };

  String? _cachedCode;
  double? _cachedFontSize;
  Widget? _cachedHighlightedCode;

  Widget _highlightedCode(double fontSize) {
    if (_cachedCode != widget.code || _cachedFontSize != fontSize) {
      _cachedCode = widget.code;
      _cachedFontSize = fontSize;
      _cachedHighlightedCode = GtRichText(
        _highlight(widget.code),
        tags: _tags,
        style: TextStyle(
          color: const Color(0xFFF8F8F2),
          fontFamily: 'monospace',
          fontSize: fontSize,
        ),
      );
    }
    return _cachedHighlightedCode!;
  }

  @override
  Widget build(BuildContext context) {
    final fontSize = context.textStyles.bodyS().fontSize?.toDouble() ?? 14;

    return GtCard(
      borderRadius: BorderRadius.vertical(bottom: context.radius2Xl),
      padding: .zero,
      color: _backgroundColor,
      child: Align(
        alignment: .centerLeft,
        child: Padding(
          padding: context.insets.allDp(10.px),
          child: SelectionArea(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _highlightedCode(fontSize),
            ),
          ),
        ),
      ),
    );
  }

  String _highlight(String code) {
    final buffer = StringBuffer();
    for (final match in _tokenPattern.allMatches(code)) {
      final comment = match.group(1);
      final doubleString = match.group(2);
      final singleString = match.group(3);
      final number = match.group(4);
      final word = match.group(5);
      final symbol = match.group(6);
      final htmlSpecial = match.group(7);
      final whitespace = match.group(8);

      if (comment != null) {
        buffer.write('<comment>${_escapeMarkup(comment)}</comment>');
      } else if (doubleString != null) {
        buffer.write('<string>${_escapeMarkup(doubleString)}</string>');
      } else if (singleString != null) {
        buffer.write('<string>${_escapeMarkup(singleString)}</string>');
      } else if (number != null) {
        buffer.write('<number>$number</number>');
      } else if (word != null) {
        if (_keywords.contains(word)) {
          buffer.write('<keyword>$word</keyword>');
        } else if (_isConstant(word)) {
          buffer.write('<constant>$word</constant>');
        } else if (_isType(word)) {
          buffer.write('<type>$word</type>');
        } else {
          buffer.write(word);
        }
      } else if (symbol != null) {
        buffer.write('<punctuation>${_escapeMarkup(symbol)}</punctuation>');
      } else if (htmlSpecial != null) {
        buffer.write(
          '<punctuation>${_escapeMarkup(htmlSpecial)}</punctuation>',
        );
      } else if (whitespace != null) {
        buffer.write(whitespace);
      }
    }
    return buffer.toString();
  }

  bool _isConstant(String word) {
    return word.contains(_upperCasePattern) && word == word.toUpperCase();
  }

  bool _isType(String word) {
    return word.isNotEmpty && word[0] == word[0].toUpperCase();
  }

  String _escapeMarkup(String value) {
    return value
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;');
  }
}

/// A single accessibility obligation or caveat in the docs page.
class _AccessibilityNote extends StatelessWidget {
  final String note;

  const _AccessibilityNote(this.note);

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: palette.primary.base,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Expanded(child: GtText(note, style: context.textStyles.bodyS())),
      ],
    );
  }
}
