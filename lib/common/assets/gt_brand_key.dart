/// Words that say what kind of institution a brand is rather than which one,
/// so "Kuda MFB", "Kuda Microfinance Bank" and "Kuda" share one key.
/// `mircofinance` is a misspelling the Figma catalogue carries.
const _brandStopWords = {
  'and',
  'bank',
  'for',
  'limited',
  'ltd',
  'mfb',
  'microfinance',
  'mircofinance',
  'nig',
  'nigeria',
  'of',
  'plc',
  'the',
};

/// The lower-case words of [name] that identify a brand, without the
/// [_brandStopWords]: "Kuda Microfinance Bank" gives `[kuda]`.
List<String> gtBrandWords(String name) {
  return name
      .toLowerCase()
      .split(RegExp('[^a-z0-9]+'))
      .where((word) => word.isNotEmpty && !_brandStopWords.contains(word))
      .toList();
}

/// [name]'s [gtBrandWords] run together: "GTBank Plc", "GT Bank" and "gtbank"
/// all give `gtbank`.
///
/// Pure Dart, so the generator in `tools/brand_logos` keys the catalogue the
/// same way the lookups key a gateway's name.
String gtBrandKey(String name) => gtBrandWords(name).join();

/// [name] whole, then, when it has a bracketed part, the text before the
/// bracket and the text inside it. "OPay Digital Services Limited (OPay)" is
/// found by its bracket and "Access Bank (Diamond)" by its whole name.
Iterable<String> gtBrandNameParts(String name) sync* {
  yield name;
  final open = name.indexOf('(');
  if (open < 0) return;
  yield name.substring(0, open);
  yield name.substring(open + 1).replaceAll(')', '');
}
