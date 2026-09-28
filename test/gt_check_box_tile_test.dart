import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

void main() {
  const iconKey = Key('leading');

  Widget buildTestWidget(Widget child) {
    return GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(home: Scaffold(body: child)),
    );
  }

  Widget tile({
    GtIndicatorPosition indicatorPosition = GtIndicatorPosition.trailing,
    double? spacingPx,
    bool hasLeading = false,
  }) {
    return GtCheckBoxTile<String>(
      'Renting',
      value: 'renting',
      isActive: false,
      onChanged: (_) {},
      indicatorPosition: indicatorPosition,
      spacingPx: spacingPx,
      leading: hasLeading
          ? const SizedBox.square(key: iconKey, dimension: 20)
          : null,
    );
  }

  final box = find.byType(GtCheckBox<String>);
  final label = find.text('Renting');

  testWidgets('places the checkbox after the title by default', (tester) async {
    await tester.pumpWidget(buildTestWidget(tile(hasLeading: true)));

    expect(
      tester.getTopRight(find.byKey(iconKey)).dx,
      lessThan(tester.getTopLeft(label).dx),
    );
    expect(tester.getTopRight(label).dx, lessThan(tester.getTopLeft(box).dx));
  });

  testWidgets('places the checkbox first when positioned leading', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestWidget(tile(indicatorPosition: .leading, hasLeading: true)),
    );

    expect(box, findsOneWidget);
    expect(
      tester.getTopRight(box).dx,
      lessThan(tester.getTopLeft(find.byKey(iconKey)).dx),
    );
    expect(
      tester.getTopRight(find.byKey(iconKey)).dx,
      lessThan(tester.getTopLeft(label).dx),
    );
  });

  testWidgets('spaces the checkbox and title by spacingPx', (tester) async {
    await tester.pumpWidget(buildTestWidget(tile(indicatorPosition: .leading)));
    final context = tester.element(find.byType(GtCheckBoxTile<String>));

    expect(
      tester.getTopLeft(label).dx - tester.getTopRight(box).dx,
      context.spacingLg,
    );

    await tester.pumpWidget(
      buildTestWidget(tile(indicatorPosition: .leading, spacingPx: 8)),
    );

    expect(
      tester.getTopLeft(label).dx - tester.getTopRight(box).dx,
      context.dp(8.px),
    );
  });

  testWidgets('applies spacingPx between the checkbox and leading', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestWidget(
        tile(indicatorPosition: .leading, spacingPx: 8, hasLeading: true),
      ),
    );
    final context = tester.element(find.byType(GtCheckBoxTile<String>));

    expect(
      tester.getTopLeft(find.byKey(iconKey)).dx - tester.getTopRight(box).dx,
      context.dp(8.px),
    );
  });
}
