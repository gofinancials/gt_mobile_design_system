import 'package:flutter/material.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:gallery/lib.dart';
import 'package:google_fonts/google_fonts.dart';
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
  @override
  Widget build(BuildContext context) {
    // final palette = context.palette;

    return GtCard(
      borderRadius: BorderRadius.vertical(bottom: context.radius2Xl),
      padding: .zero,
      color: SyntaxThemeExtension.shadesOfPurpleSuperDark.backgroundColor,
      child: Align(
        alignment: .centerLeft,
        child: SyntaxView(
          code: widget.code,
          syntax: Syntax.DART,
          syntaxTheme: SyntaxThemeExtension.shadesOfPurpleSuperDark, // Theme
          fontSize: context.textStyles.bodyS().fontSize?.toDouble() ?? 14,
          withZoom: false,
          withLinesCount: false,
        ),
      ),
    );
  }
}

extension SyntaxThemeExtension on SyntaxTheme {
  static SyntaxTheme get shadesOfPurpleSuperDark {
    return SyntaxTheme(
      linesCountColor: Colors.white60,
      backgroundColor: const Color(0xFF1E1E3F),
      baseStyle: GoogleFonts.firaCode(color: const Color(0xFFF8F8F2)),
      numberStyle: const TextStyle(color: Color(0xFFFF628C)),
      commentStyle: const TextStyle(
        color: Color(0xFFB362FF),
        fontStyle: FontStyle.italic,
      ),
      keywordStyle: const TextStyle(color: Color(0xFFFF9D00)),
      stringStyle: const TextStyle(color: Color(0xFF3AD900)),
      punctuationStyle: const TextStyle(color: Color(0xFFFFE45E)),
      classStyle: const TextStyle(color: Color(0xFF9EFFFF)),
      constantStyle: const TextStyle(color: Color(0xFFFF628C)),
      zoomIconColor: const Color(0xFFB362FF),
    );
  }
}

// class _DartSyntaxHighlighter extends GtStatelessWidget {
//   final String code;
//   final GtPalette palette;

//   const _DartSyntaxHighlighter({required this.code, required this.palette});

//   @override
//   Widget build(BuildContext context) {
//     // Dart keywords
//     final keywords = {
//       'import',
//       'void',
//       'class',
//       'extends',
//       'const',
//       'final',
//       'return',
//       'super',
//       'this',
//       'true',
//       'false',
//       'null',
//       'var',
//       'if',
//       'else',
//       'for',
//       'in',
//       'switch',
//       'case',
//       'default',
//       'new',
//       'get',
//       'set',
//       'as',
//       'show',
//       'hide',
//       'library',
//       'part',
//       'of',
//     };

//     final StringBuffer buffer = StringBuffer();
//     final regex = RegExp(
//       r'(//.*)|' // Comment
//       r'("(?:[^"\\]|\\.)*")|' // Double quoted string
//       r"('(?:[^'\\]|\\.)*')|" // Single quoted string
//       r'(\b\d+(?:\.\d+)?\b)|' // Number
//       r'(\b[a-zA-Z_][a-zA-Z0-9_]*\b)|' // Identifier/Word
//       r'([^\s<>&])|' // Symbol (excluding html special chars)
//       r'([<>&])|' // Html special chars
//       r'(\s+)', // Whitespace
//     );

//     final matches = regex.allMatches(code);
//     for (final match in matches) {
//       final comment = match.group(1);
//       final doubleStr = match.group(2);
//       final singleStr = match.group(3);
//       final number = match.group(4);
//       final word = match.group(5);
//       final symbol = match.group(6);
//       final htmlSpecial = match.group(7);
//       final whitespace = match.group(8);

//       if (comment != null) {
//         buffer.write('<cmt>${_escapeHtml(comment)}</cmt>');
//       } else if (doubleStr != null) {
//         buffer.write('<str>${_escapeHtml(doubleStr)}</str>');
//       } else if (singleStr != null) {
//         buffer.write('<str>${_escapeHtml(singleStr)}</str>');
//       } else if (number != null) {
//         buffer.write('<num>${_escapeHtml(number)}</num>');
//       } else if (word != null) {
//         if (keywords.contains(word)) {
//           buffer.write('<kw>$word</kw>');
//         } else if (word[0].toUpperCase() == word[0] && word[0] != '_') {
//           buffer.write('<typ>$word</typ>');
//         } else {
//           buffer.write(word);
//         }
//       } else if (symbol != null) {
//         buffer.write('<sym>${_escapeHtml(symbol)}</sym>');
//       } else if (htmlSpecial != null) {
//         buffer.write('<sym>${_escapeHtml(htmlSpecial)}</sym>');
//       } else if (whitespace != null) {
//         buffer.write(whitespace);
//       }
//     }

//     final tags = {
//       'cmt': GtStyledTextTag(
//         style: TextStyle(
//           color: palette.stroke.sub,
//           fontStyle: FontStyle.italic,
//         ),
//       ),
//       'str': GtStyledTextTag(style: TextStyle(color: palette.away.darker)),
//       'num': GtStyledTextTag(style: TextStyle(color: palette.stable.darker)),
//       'kw': GtStyledTextTag(
//         style: TextStyle(
//           color: palette.primary.base,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       'typ': GtStyledTextTag(style: TextStyle(color: palette.highlighted.dark)),
//       'sym': GtStyledTextTag(style: TextStyle(color: palette.text.sub)),
//     };

//     return GtRichText(
//       buffer.toString(),
//       tags: tags,
//       style: context.textStyles.bodyS().copyWith(fontFamily: 'fira-code'),
//     );
//   }

//   String _escapeHtml(String text) {
//     return text
//         .replaceAll('&', '&amp;')
//         .replaceAll('<', '&lt;')
//         .replaceAll('>', '&gt;');
//   }
// }

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
