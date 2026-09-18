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

  for (final (name, tile, build, label)
      in <(String, Finder, Widget Function({OnPressed? onTap}), String)>[
        (
          'GtInfoListTile',
          find.byType(GtInfoListTile),
          ({onTap}) => GtInfoListTile('Label', text: 'Value', onTap: onTap),
          'Label',
        ),
        (
          'GtInstructionListTile',
          find.byType(GtInstructionListTile),
          ({onTap}) => GtInstructionListTile(
            'Have your ID ready',
            icon: GtIcons.info,
            onTap: onTap,
          ),
          'Have your ID ready',
        ),
      ]) {
    // Scoped to the tile under test, so an unrelated ink well elsewhere in the
    // tree cannot answer for it.
    final inkWell = find.descendant(of: tile, matching: find.byType(GtInkWell));

    group(name, () {
      testWidgets('a static row does not announce as a button', (tester) async {
        await withSemantics(tester, () async {
          await tester.pumpWidget(buildTestWidget(build()));

          // Regression guard: the tile used to wrap in GtInkWell(role: .button)
          // whatever onTap was, so a static row read as a button.
          expect(inkWell, findsNothing);
          expectSemantics(tester, tile, isButton: false, hasTapAction: false);
        });
      });

      testWidgets('a tappable row announces as a button', (tester) async {
        var taps = 0;

        await withSemantics(tester, () async {
          await tester.pumpWidget(buildTestWidget(build(onTap: () => taps++)));

          expect(inkWell, findsOneWidget);
          expectSemantics(
            tester,
            tile,
            label: contains(label),
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
