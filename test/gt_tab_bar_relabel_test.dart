import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

const _payTab = GtTabData(value: 'pay', label: 'PAY');
const _scheduleTab = GtTabData(value: 'schedule', label: 'SCHEDULE');

class _RelabelTestApp extends GtStatelessWidget {
  final GtTabController<String> controller;
  final List<GtTabData<String>> tabs;

  const _RelabelTestApp({required this.controller, required this.tabs});

  @override
  Widget build(BuildContext context) {
    return GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(
        home: Scaffold(
          body: GtTabbar<String>(controller: controller, tabs: tabs),
        ),
      ),
    );
  }
}

List<GtTabPill<GtTabData<String>>> _pills(WidgetTester tester) => tester
    .widgetList<GtTabPill<GtTabData<String>>>(
      find.byType(GtTabPill<GtTabData<String>>),
    )
    .toList();

void main() {
  testWidgets('a relabelled tab keeps its selected pill and indicator', (
    tester,
  ) async {
    final controller = GtTabController<String>(initialValue: _payTab);
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _RelabelTestApp(
        controller: controller,
        tabs: const [_payTab, _scheduleTab],
      ),
    );
    await tester.pumpAndSettle();
    expect(_pills(tester).first.isSelected, isTrue);

    // The same tabs under new labels, as an account switch would deliver them.
    await tester.pumpWidget(
      _RelabelTestApp(
        controller: controller,
        tabs: const [
          GtTabData(value: 'pay', label: 'SEND'),
          _scheduleTab,
        ],
      ),
    );
    await tester.pumpAndSettle();

    final pills = _pills(tester);
    expect(pills.first.isSelected, isTrue);
    expect(pills.last.isSelected, isFalse);
    expect(find.byKey(const Key('gt_selection_tab_indicator')), findsOneWidget);
    expect(find.text('SEND'), findsOneWidget);
  });

  testWidgets('the bar and the view agree on a relabelled tab', (tester) async {
    const tabs = [_payTab, _scheduleTab];
    final controller = GtTabController<String>(initialValue: _scheduleTab);
    addTearDown(controller.dispose);

    Widget build(List<GtTabData<String>> tabs) => GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              GtTabbar<String>(controller: controller, tabs: tabs),
              Expanded(
                child: GtTabbarView<String>(
                  controller: controller,
                  tabs: tabs,
                  tabViews: {
                    for (final tab in tabs)
                      tab.value: Center(child: Text('page-${tab.value}')),
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );

    await tester.pumpWidget(build(tabs));
    await tester.pumpAndSettle();
    expect(find.text('page-schedule'), findsOneWidget);

    // Relabel the tab that is currently selected.
    await tester.pumpWidget(
      build(const [_payTab, GtTabData(value: 'schedule', label: 'UPCOMING')]),
    );
    await tester.pumpAndSettle();

    // The bar shows the tab the view is on, rather than nothing.
    expect(_pills(tester).last.isSelected, isTrue);
    expect(controller.value?.value, 'schedule');
    expect(find.text('page-schedule'), findsOneWidget);
    expect(find.text('UPCOMING'), findsOneWidget);
  });

  testWidgets('a header reading the controller sees the new label', (
    tester,
  ) async {
    final controller = GtTabController<String>(initialValue: _payTab);
    addTearDown(controller.dispose);

    // The header sits above the bar, so it builds before the bar reconciles.
    Widget build(List<GtTabData<String>> tabs) => GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              ListenableBuilder(
                listenable: controller,
                builder: (_, _) => Text('header:${controller.value?.label}'),
              ),
              GtTabbar<String>(controller: controller, tabs: tabs),
            ],
          ),
        ),
      ),
    );

    await tester.pumpWidget(build(const [_payTab, _scheduleTab]));
    await tester.pumpAndSettle();
    expect(find.text('header:PAY'), findsOneWidget);

    await tester.pumpWidget(
      build(const [GtTabData(value: 'pay', label: 'SEND'), _scheduleTab]),
    );
    await tester.pumpAndSettle();

    expect(find.text('header:SEND'), findsOneWidget);
    expect(controller.value?.label, 'SEND');
    expect(controller.value?.value, 'pay');
  });

  test('the controller replaces a tab that only changed how it is drawn', () {
    final controller = GtTabController<String>(initialValue: _payTab);
    addTearDown(controller.dispose);
    var notifications = 0;
    controller.addListener(() => notifications++);

    controller.value = const GtTabData(value: 'pay', label: 'SEND');
    expect(controller.value?.label, 'SEND');
    expect(notifications, 1, reason: 'a new label is worth a rebuild');

    controller.value = const GtTabData(value: 'pay', label: 'SEND');
    expect(notifications, 1, reason: 'an identical tab changes nothing');

    controller.value = _scheduleTab;
    expect(notifications, 2, reason: 'a new tab notifies');
  });

  // Mirrors the 'Relabelled Tabs' gallery use case, which claims the selection,
  // the indicator and the page all hold while the header follows the label.
  testWidgets('the relabel use case arrangement holds on an account switch', (
    tester,
  ) async {
    const personalTabs = [
      GtTabData(label: 'Pay', value: 'pay'),
      GtTabData(label: 'Schedule', value: 'schedule'),
    ];
    const flexTabs = [
      GtTabData(label: 'Send', value: 'pay'),
      GtTabData(label: 'Schedule', value: 'schedule'),
    ];

    final controller = GtTabController<String>(
      initialValue: personalTabs.first,
    );
    addTearDown(controller.dispose);

    Widget build(List<GtTabData<String>> tabs) => GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              ListenableBuilder(
                listenable: controller,
                builder: (_, _) => Text('header:${controller.value?.label}'),
              ),
              GtTabbar<String>(controller: controller, tabs: tabs),
              Expanded(
                child: GtTabbarView<String>(
                  controller: controller,
                  tabs: tabs,
                  tabViews: {
                    for (final tab in tabs)
                      tab.value: Center(child: Text('page:${tab.label}')),
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );

    await tester.pumpWidget(build(personalTabs));
    await tester.pumpAndSettle();
    expect(find.text('header:Pay'), findsOneWidget);
    expect(find.text('page:Pay'), findsOneWidget);
    final indicatorBefore = tester
        .widget<AnimatedPositioned>(
          find.byKey(const Key('gt_selection_tab_indicator')),
        )
        .left;

    await tester.pumpWidget(build(flexTabs));
    await tester.pumpAndSettle();

    expect(_pills(tester).first.isSelected, isTrue);
    expect(find.text('SEND'), findsOneWidget);
    expect(find.text('header:Send'), findsOneWidget);
    expect(find.text('page:Send'), findsOneWidget);
    expect(
      tester
          .widget<AnimatedPositioned>(
            find.byKey(const Key('gt_selection_tab_indicator')),
          )
          .left,
      indicatorBefore,
      reason: 'the indicator stays on the first pill',
    );
  });

  test('tabs are identified by value, not by how they are drawn', () {
    expect(
      const GtTabData(value: 'pay', label: 'PAY'),
      const GtTabData(value: 'pay', label: 'SEND', icon: Icons.send),
    );
    expect(
      const GtTabData(value: 'pay', label: 'PAY'),
      isNot(const GtTabData(value: 'schedule', label: 'PAY')),
    );
  });
}
