import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

void main() {
  const tabs = [
    GtTabData(label: 'First', value: 0),
    GtTabData(label: 'Second', value: 1),
    GtTabData(label: 'Third', value: 2),
    GtTabData(label: 'Fourth', value: 3),
    GtTabData(label: 'Fifth', value: 4),
  ];

  testWidgets('eager tab view supports horizontal swiping', (tester) async {
    final controller = GtTabController<int>(initialValue: tabs.first);
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _TestApp(
        child: GtTabbarView<int>(
          controller: controller,
          tabs: tabs,
          tabViews: {
            for (final tab in tabs)
              tab.value: ColoredBox(
                key: Key('eager-page-${tab.value}'),
                color: Colors.transparent,
              ),
          },
        ),
      ),
    );

    await tester.drag(find.byType(PageView), const Offset(-400, 0));
    await tester.pumpAndSettle();

    expect(controller.value, tabs[1]);
    expect(find.byKey(const Key('eager-page-1')), findsOneWidget);
  });

  testWidgets('lazy tab view builds pages on demand and supports swiping', (
    tester,
  ) async {
    final controller = GtTabController<int>(initialValue: tabs.first);
    addTearDown(controller.dispose);
    final buildCounts = List<int>.filled(tabs.length, 0);

    await tester.pumpWidget(
      _TestApp(
        child: GtTabbarView<int>.lazy(
          controller: controller,
          tabs: tabs,
          tabBuilders: {
            for (final (index, tab) in tabs.indexed)
              tab.value: (_) {
                buildCounts[index]++;
                return ColoredBox(
                  key: Key('page-$index'),
                  color: Colors.transparent,
                );
              },
          },
        ),
      ),
    );

    expect(find.byKey(const Key('page-0')), findsOneWidget);
    expect(find.byKey(const Key('page-4')), findsNothing);
    expect(
      buildCounts.where((count) => count > 0).length,
      lessThan(tabs.length),
    );

    await tester.drag(find.byType(PageView), const Offset(-400, 0));
    await tester.pumpAndSettle();

    expect(controller.value, tabs[1]);
    expect(find.byKey(const Key('page-1')), findsOneWidget);
  });

  testWidgets('controller changes animate the lazy view to the matching page', (
    tester,
  ) async {
    final controller = GtTabController<int>(initialValue: tabs.first);
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _TestApp(
        child: GtTabbarView<int>.lazy(
          controller: controller,
          tabs: tabs,
          tabBuilders: {
            for (final tab in tabs)
              tab.value: (_) => ColoredBox(
                key: Key('page-${tab.value}'),
                color: Colors.transparent,
              ),
          },
        ),
      ),
    );

    controller.value = tabs[2];
    await tester.pumpAndSettle();

    expect(controller.value, tabs[2]);
    expect(find.byKey(const Key('page-2')), findsOneWidget);
  });

  testWidgets('lazy view initializes an empty controller', (tester) async {
    final controller = GtTabController<int>();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _TestApp(
        child: GtTabbarView<int>.lazy(
          controller: controller,
          tabs: tabs,
          tabBuilders: {
            for (final tab in tabs)
              tab.value: (_) => const ColoredBox(color: Colors.transparent),
          },
        ),
      ),
    );

    expect(controller.value, tabs.first);
  });
}

class _TestApp extends StatelessWidget {
  final Widget child;

  const _TestApp({required this.child});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: SizedBox.expand(child: child)),
    );
  }
}
