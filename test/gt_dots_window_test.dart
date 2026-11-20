import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

import 'helpers/test_app_config.dart';

const _active = Color(0xFFFF0000);
const _inactive = Color(0xFF0000FF);

/// One dot as drawn on screen.
typedef _Seen = ({Rect rect, bool active});

/// Finds the indicator under test, whichever kind it is.
final _indicator = find.byWidgetPredicate(
  (widget) => widget is GtDots || widget is GtScaledDots,
);

void main() {
  setUpAll(registerTestAppConfig);

  Widget dots(
    int index, {
    int length = 30,
    int? maxVisible = 7,
    String? label,
    TextDirection direction = .ltr,
    bool scaled = true,
  }) {
    return GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(
        home: Directionality(
          textDirection: direction,
          child: Scaffold(
            body: Center(
              child: SizedBox(
                width: 200,
                child: scaled
                    ? GtScaledDots(
                        index,
                        length: length,
                        maxVisible: maxVisible,
                        activeColor: _active,
                        inActiveColor: _inactive,
                        semanticsLabel: label,
                      )
                    : GtDots(
                        index,
                        length: length,
                        maxVisible: maxVisible,
                        activeColor: _active,
                        inActiveColor: _inactive,
                        semanticsLabel: label,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// The dots a customer can see: drawn at some size, inside the clip.
  List<_Seen> seen(WidgetTester tester) {
    final clip = find.descendant(
      of: _indicator,
      matching: find.byType(ClipRect),
    );
    final bounds = clip.evaluate().isEmpty
        ? Rect.largest
        : tester.getRect(clip).inflate(.01);
    final result = <_Seen>[];
    for (final element
        in find
            .descendant(
              of: _indicator,
              matching: find.byType(AnimatedContainer),
            )
            .evaluate()) {
      final box = element.renderObject! as RenderBox;
      if (box.size.width < .01) continue;
      final rect = box.localToGlobal(Offset.zero) & box.size;
      if (!bounds.contains(rect.topLeft) ||
          !bounds.contains(rect.bottomRight)) {
        continue;
      }
      final widget = element.widget as AnimatedContainer;
      final decoration = widget.decoration! as BoxDecoration;
      result.add((rect: rect, active: decoration.color == _active));
    }
    result.sort((a, b) => a.rect.left.compareTo(b.rect.left));
    return result;
  }

  int activeSlot(List<_Seen> dots) => dots.indexWhere((dot) => dot.active);

  group('GtScaledDots', () {
    testWidgets('without maxVisible every page gets a dot', (tester) async {
      await tester.pumpWidget(dots(12, maxVisible: null));
      await tester.pumpAndSettle();

      expect(seen(tester), hasLength(30));
      expect(find.byType(ClipRect), findsNothing);
    });

    testWidgets('at or under maxVisible pages the dots are unchanged', (
      tester,
    ) async {
      await tester.pumpWidget(dots(2, length: 7, maxVisible: null));
      await tester.pumpAndSettle();
      final before = [for (final dot in seen(tester)) dot.rect];

      await tester.pumpWidget(dots(2, length: 7));
      await tester.pumpAndSettle();
      final after = [for (final dot in seen(tester)) dot.rect];

      expect(after, before);
    });

    testWidgets(
      'past maxVisible pages exactly maxVisible dots sit on one row',
      (tester) async {
        for (final index in [0, 1, 3, 12, 26, 29]) {
          await tester.pumpWidget(dots(index));
          await tester.pumpAndSettle();
          final result = seen(tester);

          expect(result, hasLength(7), reason: 'page $index');
          expect(
            {for (final dot in result) dot.rect.center.dy.toStringAsFixed(2)},
            hasLength(1),
            reason: 'page $index',
          );
          expect(result.where((dot) => dot.active), hasLength(1));
        }
      },
    );

    testWidgets('the active dot sits mid-window, moving to the edge near the '
        'ends of the list', (tester) async {
      const expected = {
        0: 0,
        1: 1,
        2: 2,
        3: 3,
        12: 3,
        26: 3,
        27: 4,
        28: 5,
        29: 6,
      };
      for (final MapEntry(key: index, value: slot) in expected.entries) {
        await tester.pumpWidget(dots(index));
        await tester.pumpAndSettle();

        expect(activeSlot(seen(tester)), slot, reason: 'page $index');
      }
    });

    testWidgets('dots shrink with their distance from the active dot', (
      tester,
    ) async {
      await tester.pumpWidget(dots(12));
      await tester.pumpAndSettle();
      final sizes = [for (final dot in seen(tester)) dot.rect.width];
      final full = sizes[3];

      expect(sizes, [
        for (final distance in [3, 2, 1, 0, 1, 2, 3])
          moreOrLessEquals(full * (1 - distance / 7), epsilon: .01),
      ]);
    });

    testWidgets('the window keeps its place and width as it slides', (
      tester,
    ) async {
      await tester.pumpWidget(dots(12));
      await tester.pumpAndSettle();
      final clip = find.byType(ClipRect);
      final before = tester.getRect(clip);
      final activeBefore = seen(tester)[3].rect.center;

      await tester.pumpWidget(dots(13));
      await tester.pumpAndSettle();

      expect(tester.getRect(clip), before);
      expect(seen(tester)[3].rect.center, activeBefore);
      expect(seen(tester)[3].active, isTrue);
    });

    testWidgets('the window slides over 300ms rather than jumping', (
      tester,
    ) async {
      await tester.pumpWidget(dots(12));
      await tester.pumpAndSettle();
      final translate = find.descendant(
        of: find.byType(ClipRect),
        matching: find.byType(Transform),
      );
      double shift() => tester.widget<Transform>(translate).transform[12];
      final start = shift();

      await tester.pumpWidget(dots(13));
      await tester.pump(const Duration(milliseconds: 150));
      final midway = shift();
      await tester.pump(const Duration(milliseconds: 150));
      final end = shift();

      expect(midway, lessThan(start));
      expect(midway, greaterThan(end));
      await tester.pumpAndSettle();
      expect(shift(), end);
    });

    testWidgets('slides the other way in right-to-left text', (tester) async {
      const expected = {0: 6, 3: 3, 12: 3, 29: 0};
      for (final MapEntry(key: index, value: slot) in expected.entries) {
        await tester.pumpWidget(dots(index, direction: .rtl));
        await tester.pumpAndSettle();
        final result = seen(tester);

        expect(result, hasLength(7), reason: 'page $index');
        expect(activeSlot(result), slot, reason: 'page $index');
      }
    });

    testWidgets('the label still states the real position', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(dots(11, label: 'Card 12 of 30'));
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel('Card 12 of 30'), findsOneWidget);
      final node = tester.getSemantics(find.bySemanticsLabel('Card 12 of 30'));
      var children = 0;
      node.visitChildren((SemanticsNode _) {
        children++;
        return true;
      });
      expect(children, 0);
      handle.dispose();
    });
  });

  group('GtDots', () {
    testWidgets('without maxVisible every page gets a dot', (tester) async {
      await tester.pumpWidget(dots(12, maxVisible: null, scaled: false));
      await tester.pumpAndSettle();

      expect(seen(tester), hasLength(30));
      expect(find.byType(ClipRect), findsNothing);
    });

    testWidgets('at or under maxVisible pages the dots are unchanged', (
      tester,
    ) async {
      await tester.pumpWidget(
        dots(2, length: 7, maxVisible: null, scaled: false),
      );
      await tester.pumpAndSettle();
      final before = [for (final dot in seen(tester)) dot.rect];

      await tester.pumpWidget(dots(2, length: 7, scaled: false));
      await tester.pumpAndSettle();

      expect([for (final dot in seen(tester)) dot.rect], before);
    });

    testWidgets('past maxVisible pages exactly maxVisible dots sit on one '
        'row, the active one mid-window except near the ends', (tester) async {
      const expected = {0: 0, 2: 2, 3: 3, 12: 3, 26: 3, 28: 5, 29: 6};
      for (final MapEntry(key: index, value: slot) in expected.entries) {
        await tester.pumpWidget(dots(index, scaled: false));
        await tester.pumpAndSettle();
        final result = seen(tester);

        expect(result, hasLength(7), reason: 'page $index');
        expect({
          for (final dot in result) dot.rect.center.dy.toStringAsFixed(2),
        }, hasLength(1));
        expect(activeSlot(result), slot, reason: 'page $index');
      }
    });

    testWidgets('only an edge with more pages beyond it draws a half-size '
        'dot', (tester) async {
      final cases = {
        0: [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, .5],
        12: [.5, 1.0, 1.0, 1.0, 1.0, 1.0, .5],
        29: [.5, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0],
      };
      for (final MapEntry(key: index, value: scales) in cases.entries) {
        await tester.pumpWidget(dots(index, scaled: false));
        await tester.pumpAndSettle();
        final sizes = [for (final dot in seen(tester)) dot.rect.width];
        final full = sizes[3];

        expect(sizes, [
          for (final scale in scales)
            moreOrLessEquals(full * scale, epsilon: .01),
        ], reason: 'page $index');
      }
    });

    testWidgets('the active dot keeps its full size at the edge of a small '
        'window', (tester) async {
      await tester.pumpWidget(dots(12, maxVisible: 1, scaled: false));
      await tester.pumpAndSettle();
      final result = seen(tester);

      expect(result, hasLength(1));
      expect(result.single.active, isTrue);
      expect(result.single.rect.width, moreOrLessEquals(8, epsilon: .01));
    });

    testWidgets('the window slides over 300ms rather than jumping', (
      tester,
    ) async {
      await tester.pumpWidget(dots(12, scaled: false));
      await tester.pumpAndSettle();
      final translate = find.descendant(
        of: find.byType(ClipRect),
        matching: find.byType(Transform),
      );
      double shift() => tester.widget<Transform>(translate).transform[12];
      final start = shift();

      await tester.pumpWidget(dots(13, scaled: false));
      await tester.pump(const Duration(milliseconds: 150));
      final midway = shift();
      await tester.pumpAndSettle();

      expect(midway, lessThan(start));
      expect(midway, greaterThan(shift()));
      expect(seen(tester)[3].active, isTrue);
    });

    testWidgets('the label still states the real position', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(dots(11, label: 'Card 12 of 30', scaled: false));
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel('Card 12 of 30'), findsOneWidget);
      handle.dispose();
    });
  });
}
