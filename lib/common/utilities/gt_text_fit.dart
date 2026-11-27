import 'package:flutter/widgets.dart';

/// Measures plain text as a [Text] would lay it out, for widgets that choose a
/// layout, or rewrite their text, by what fits.
///
/// Holds one [TextPainter], configured once and reused for every query, so a
/// search that measures many candidates pays for one painter rather than one
/// per candidate. Call [dispose] when done with it.
///
/// [GtActionButtonBar] asks whether each caption [fits] its slot to decide
/// between a fitted and a scrolling row. [GtText.middleEllipsis] asks for the
/// [middleEllipsis] of its text, which keeps the head and tail of a value
/// whose end carries its meaning, such as an account number or an IBAN.
///
/// ```dart
/// final fit = GtTextFit.of(context, style: style, maxLines: 1);
/// final shown = fit.middleEllipsis('GB29NWBK60161331926819', 160);
/// fit.dispose(); // shown is 'GB29NWBK…31926819', or as much as fits.
/// ```
class GtTextFit {
  /// The character that stands in for the text [middleEllipsis] removes.
  static const String ellipsis = '…';

  final TextPainter _painter;

  /// The style every query is measured in.
  final TextStyle style;

  /// Creates a [GtTextFit] measuring in [style] exactly as given.
  ///
  /// Unlike a [Text], this applies no ambient [DefaultTextStyle], bold-text
  /// setting or text scale; pass the resolved values, or use [GtTextFit.of].
  ///
  /// [maxLines] caps the lines a query may wrap onto before it no longer
  /// [fits]. Null leaves wrapping uncapped, so only [fits]'s whole-word check
  /// can fail.
  GtTextFit({
    required this.style,
    required TextDirection textDirection,
    TextScaler textScaler = .noScaling,
    int? maxLines,
    StrutStyle? strutStyle,
    Locale? locale,
    TextHeightBehavior? textHeightBehavior,
    TextWidthBasis textWidthBasis = .parent,
  }) : _painter = TextPainter(
         textDirection: textDirection,
         textScaler: textScaler,
         maxLines: maxLines,
         strutStyle: strutStyle,
         locale: locale,
         textHeightBehavior: textHeightBehavior,
         textWidthBasis: textWidthBasis,
       );

  /// Creates a [GtTextFit] that measures [style] as a [Text] in [context]
  /// would draw it.
  ///
  /// [style] is resolved by [resolveStyle]. The text scale, the text height
  /// behaviour and, when [textDirection] is null, the direction are read from
  /// [context].
  ///
  /// [textWidthBasis] defaults to [TextWidthBasis.parent], as [GtText] lays
  /// out.
  factory GtTextFit.of(
    BuildContext context, {
    TextStyle? style,
    int? maxLines,
    StrutStyle? strutStyle,
    Locale? locale,
    TextDirection? textDirection,
    TextWidthBasis textWidthBasis = .parent,
  }) {
    return GtTextFit(
      style: resolveStyle(context, style),
      textDirection: textDirection ?? Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
      maxLines: maxLines,
      strutStyle: strutStyle,
      locale: locale,
      textHeightBehavior: resolveTextHeightBehavior(context),
      textWidthBasis: textWidthBasis,
    );
  }

  /// [style] as a [Text] in [context] would draw it: merged over the ambient
  /// [DefaultTextStyle], unless it does not inherit, and set bold when the
  /// user has asked for bold text.
  ///
  /// Registers [context] as a dependant of both, so a widget that calls this
  /// in `build` is rebuilt when either changes.
  static TextStyle resolveStyle(BuildContext context, TextStyle? style) {
    final resolved = DefaultTextStyle.of(context).style.merge(style);
    if (!MediaQuery.boldTextOf(context)) return resolved;

    return resolved.merge(const TextStyle(fontWeight: .bold));
  }

  /// The text height behaviour a [Text] in [context] would lay out with.
  static TextHeightBehavior? resolveTextHeightBehavior(BuildContext context) {
    return DefaultTextStyle.of(context).textHeightBehavior ??
        DefaultTextHeightBehavior.maybeOf(context);
  }

  /// Whether [text] wraps into [maxWidth] within the configured `maxLines`.
  ///
  /// When [wholeWords] is true, [text] must also do so without breaking any
  /// word, so a single word wider than [maxWidth] does not fit even with lines
  /// to spare. Left false, it fits whenever a [Text] would draw it without
  /// overflowing, splitting a long word across lines if it must.
  bool fits(String text, double maxWidth, {bool wholeWords = false}) {
    _painter.text = TextSpan(text: text, style: style);
    if (wholeWords) {
      // Read before narrowing: once a word has to break to fit the width, the
      // engine reports the width of its fragments rather than of the word.
      _painter.layout();
      if (_painter.minIntrinsicWidth > maxWidth) return false;
    }
    _painter.layout(maxWidth: maxWidth);

    return !_painter.didExceedMaxLines;
  }

  /// [text] as it fits [maxWidth], with characters taken from its middle and
  /// replaced by a single [ellipsis] when it does not.
  ///
  /// Returns [text] itself when it already [fits]. Otherwise keeps the most
  /// grapheme clusters that fit, split evenly between head and tail with any
  /// odd one going to the head, and trims the spaces either side of the
  /// [ellipsis]. When not even the [ellipsis] fits, returns it alone.
  ///
  /// With a `maxLines` above one, the kept text may wrap, splitting a word if
  /// it must, as a [Text] would.
  ///
  /// Each candidate costs one layout. The search starts from where the cut
  /// would fall if every cluster were equally wide, then gallops outwards
  /// and bisects, so a value of even varied glyphs settles in a few layouts
  /// rather than the log₂ of its length.
  String middleEllipsis(String text, double maxWidth) {
    if (fits(text, maxWidth)) return text;

    final characters = text.characters.toList();
    final count = characters.length;
    if (count < 2) return ellipsis;
    // Laid out by the failed fit above, so free to read.
    final wholeWidth = _painter.maxIntrinsicWidth;
    final room = (_painter.maxLines ?? 1) * maxWidth;

    String best = ellipsis;
    bool tryKeeping(int kept) {
      final candidate = _keep(characters, kept);
      if (!fits(candidate, maxWidth)) return false;
      best = candidate;
      return true;
    }

    // Keeping none is the lone ellipsis, the fallback either way, so it is
    // never measured; keeping all is the whole text, which does not fit.
    int fitting = 0;
    int failing = count;
    final guess = switch (wholeWidth) {
      > 0 => (count * room / wholeWidth).floor() - 1,
      _ => count - 1,
    }.clamp(1, count - 1);
    if (tryKeeping(guess)) {
      fitting = guess;
      for (int step = 1; fitting + step < failing; step *= 2) {
        if (!tryKeeping(fitting + step)) {
          failing = fitting + step;
          break;
        }
        fitting += step;
      }
    } else {
      failing = guess;
      for (int step = 1; failing - step > fitting; step *= 2) {
        if (tryKeeping(failing - step)) {
          fitting = failing - step;
          break;
        }
        failing -= step;
      }
    }

    // Bisect what the gallop left between the last fit and the first miss.
    while (failing - fitting > 1) {
      final kept = (fitting + failing) ~/ 2;
      if (tryKeeping(kept)) {
        fitting = kept;
      } else {
        failing = kept;
      }
    }

    return best;
  }

  /// [characters] cut down to [kept] clusters either side of an [ellipsis].
  String _keep(List<String> characters, int kept) {
    final head = characters.take((kept + 1) ~/ 2).join().trimRight();
    final tail = characters.skip(characters.length - kept ~/ 2).join();

    return '$head$ellipsis${tail.trimLeft()}';
  }

  /// The size [text] lays out at between [minWidth] and [maxWidth].
  ///
  /// Respects the configured `maxLines`, so a [text] that does not [fits] is
  /// cut short at the last line rather than measured whole.
  Size sizeOf(
    String text, {
    double minWidth = 0,
    double maxWidth = double.infinity,
  }) {
    _painter.text = TextSpan(text: text, style: style);
    _painter.layout(minWidth: minWidth, maxWidth: maxWidth);

    return _painter.size;
  }

  /// The distance from the top of [text], laid out at [maxWidth], to its
  /// first [baseline].
  double baselineOf(
    String text,
    TextBaseline baseline, {
    double maxWidth = double.infinity,
  }) {
    _painter.text = TextSpan(text: text, style: style);
    _painter.layout(maxWidth: maxWidth);

    return _painter.computeDistanceToActualBaseline(baseline);
  }

  /// Releases the painter. The [GtTextFit] must not be used afterwards.
  void dispose() => _painter.dispose();
}
