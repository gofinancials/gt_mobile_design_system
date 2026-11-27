import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

const _title = 'An equal split of the general public and other businesses';

void main() {
  /// Pumps [tile] in a column 375 wide, as on the Flex onboarding question.
  Future<void> pumpTile(WidgetTester tester, Widget tile) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      GtThemeProvider(
        theme: kPersonalTheme,
        child: MaterialApp(
          home: Scaffold(
            body: Builder(builder: (context) => Column(children: [tile])),
          ),
        ),
      ),
    );
  }

  RenderParagraph titleParagraph(WidgetTester tester) =>
      tester.renderObject<RenderParagraph>(find.text(_title));

  final tiles = <String, (Widget Function({int? titleMaxLines}), Finder)>{
    'GtRadioTile': (
      ({int? titleMaxLines}) => GtRadioTile<String>(
        _title,
        value: 'a',
        groupValue: null,
        onChanged: (_) {},
        padding: const EdgeInsets.symmetric(vertical: 12),
        titleMaxLines: titleMaxLines,
      ),
      find.byType(GtRadio<String>),
    ),
    'GtCheckBoxTile': (
      ({int? titleMaxLines}) => GtCheckBoxTile<String>(
        _title,
        value: 'a',
        isActive: false,
        onChanged: (_) {},
        padding: const EdgeInsets.symmetric(vertical: 12),
        titleMaxLines: titleMaxLines,
      ),
      find.byType(GtCheckBox<String>),
    ),
    'GtSwitchTile': (
      ({int? titleMaxLines}) => GtSwitchTile(
        _title,
        value: false,
        onChanged: (_) {},
        padding: const EdgeInsets.symmetric(vertical: 12),
        titleMaxLines: titleMaxLines,
      ),
      find.byType(GtSwitch),
    ),
  };

  for (final MapEntry(key: name, value: (build, control)) in tiles.entries) {
    group(name, () {
      testWidgets('wraps a long title and keeps every word', (tester) async {
        await pumpTile(tester, build());

        final paragraph = titleParagraph(tester);
        expect(paragraph.didExceedMaxLines, isFalse);
        final lines = paragraph
            .getBoxesForSelection(
              const TextSelection(baseOffset: 0, extentOffset: _title.length),
            )
            .map((box) => box.top)
            .toSet();
        expect(lines.length, greaterThan(1));
      });

      testWidgets('keeps the control centred on a wrapped row', (tester) async {
        await pumpTile(tester, build());

        final row = tester.getRect(find.byType(GtIndicatorTile));
        expect(
          tester.getCenter(control).dy,
          moreOrLessEquals(row.center.dy, epsilon: 0.5),
        );
      });

      testWidgets('ends a capped title in an ellipsis', (tester) async {
        await pumpTile(tester, build(titleMaxLines: 1));

        final paragraph = titleParagraph(tester);
        expect(paragraph.maxLines, 1);
        expect(paragraph.overflow, TextOverflow.ellipsis);
        expect(paragraph.didExceedMaxLines, isTrue);
      });
    });
  }
}
