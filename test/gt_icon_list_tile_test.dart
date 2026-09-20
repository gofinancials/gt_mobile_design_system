import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

import 'helpers/semantics_matchers.dart';

void main() {
  Widget buildTestWidget(Widget child) {
    return GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(
        home: Scaffold(body: Center(child: child)),
      ),
    );
  }

  // byType matches the exact runtime type, which misses the private subclass
  // behind the .alt factory; a predicate matches both.
  final tile = find.byWidgetPredicate((w) => w is GtIconListTile);

  /// Finds [type] inside the tile under test, so an unrelated widget of the
  /// same type elsewhere in the tree cannot answer for it.
  Finder within(Type type) {
    return find.descendant(of: tile, matching: find.byType(type));
  }

  for (final (name, build)
      in <(String, GtIconListTile Function({OnPressed? onTap}))>[
        (
          'GtIconListTile',
          ({onTap}) =>
              GtIconListTile('Title', icon: GtIcons.chevronRight, onTap: onTap),
        ),
        (
          'GtIconListTile.alt',
          ({onTap}) => GtIconListTile.alt(
            'Title',
            icon: GtIcons.chevronRight,
            onTap: onTap,
          ),
        ),
      ]) {
    group(name, () {
      testWidgets('a static row does not announce as a button', (tester) async {
        await withSemantics(tester, () async {
          await tester.pumpWidget(buildTestWidget(build()));

          // Regression guard: the tile used to wrap in GtInkWell(role: .button)
          // whatever onTap was, so an informational row read as a button.
          expect(within(GtInkWell), findsNothing);
          expectSemantics(tester, tile, isButton: false, hasTapAction: false);
        });
      });

      testWidgets('a tappable row announces as a button', (tester) async {
        var taps = 0;

        await withSemantics(tester, () async {
          await tester.pumpWidget(buildTestWidget(build(onTap: () => taps++)));

          expect(within(GtInkWell), findsOneWidget);
          expectSemantics(
            tester,
            tile,
            label: 'Title',
            isButton: true,
            hasTapAction: true,
          );

          await tester.tap(tile);
          expect(taps, 1);
        });
      });
    });
  }
}
