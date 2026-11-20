import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

import 'helpers/test_app_config.dart';

void main() {
  setUpAll(registerTestAppConfig);

  Future<void> pump(WidgetTester tester, Widget child) async {
    await tester.pumpWidget(
      GtThemeProvider(
        theme: kPersonalTheme,
        child: MaterialApp(home: Scaffold(body: child)),
      ),
    );
    await tester.pumpAndSettle();
  }

  Icon tick(WidgetTester tester) {
    return tester.widget<Icon>(
      find.byWidgetPredicate(
        (widget) => widget is Icon && widget.icon == GtIcons.checkSolid,
      ),
    );
  }

  GtPalette palette(WidgetTester tester) {
    return tester.element(find.byType(Scaffold)).palette;
  }

  testWidgets('both tiles draw the tick in the success color by default', (
    tester,
  ) async {
    await pump(
      tester,
      GtSelectionListTile<String>(
        'Savings',
        value: 'savings',
        isSelected: true,
        onSelect: (_) {},
      ),
    );
    expect(tick(tester).color, palette(tester).success.base);
    expect(tick(tester).size, 28);

    await pump(
      tester,
      GtSelectionListTile<String>.withDescription(
        'Lagos',
        description: 'Head office',
        value: 'lagos',
        isSelected: true,
        onSelect: (_) {},
      ),
    );
    expect(tick(tester).color, palette(tester).success.base);
    expect(tick(tester).size, 24);
  });

  testWidgets('tickColor and tickSize restyle both ticks', (tester) async {
    const color = Color(0xFF7A1F3D);

    await pump(
      tester,
      GtSelectionListTile<String>(
        'Savings',
        value: 'savings',
        isSelected: true,
        tickColor: color,
        tickSize: 20,
        onSelect: (_) {},
      ),
    );
    expect(tick(tester).color, color);
    expect(tick(tester).size, 20);

    await pump(
      tester,
      GtSelectionListTile<String>.withDescription(
        'Lagos',
        description: 'Head office',
        value: 'lagos',
        isSelected: true,
        tickColor: color,
        tickSize: 18,
        onSelect: (_) {},
      ),
    );
    expect(tick(tester).color, color);
    expect(tick(tester).size, 18);
  });

  testWidgets('the dropdown sheet passes tickColor to its options', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    const color = Color(0xFF7A1F3D);
    final controller = GtDropdownInputController<String>();
    addTearDown(controller.dispose);

    await pump(
      tester,
      GtDropdownField<String>(
        controller: controller,
        options: const [
          GtDropdownData(value: 'Embassy A', label: 'Embassy A'),
          GtDropdownData(value: 'Embassy B', label: 'Embassy B'),
        ],
        showSearch: false,
        tickColor: color,
      ),
    );
    controller.selection = const GtDropdownData(
      value: 'Embassy B',
      label: 'Embassy B',
    );
    await tester.tap(find.byType(GtDropdownField<String>));
    await tester.pumpAndSettle();

    // Every row keeps a hidden tick for its layout; all take the color.
    final ticks = tester.widgetList<Icon>(
      find.byWidgetPredicate(
        (widget) => widget is Icon && widget.icon == GtIcons.checkSolid,
      ),
    );
    expect(ticks, hasLength(2));
    expect(ticks.map((icon) => icon.color), everyElement(color));
  });
}
