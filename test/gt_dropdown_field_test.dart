import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

const _options = [
  GtDropdownData(value: 'today', label: 'Today'),
  GtDropdownData(value: 'tomorrow', label: 'Tomorrow'),
  GtDropdownData(value: 'next-week', label: 'Next week'),
];

class _DropdownTestApp extends GtStatelessWidget {
  final Widget child;

  const _DropdownTestApp({required this.child});

  @override
  Widget build(BuildContext context) {
    return GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(
        home: Scaffold(body: Center(child: child)),
      ),
    );
  }
}

/// Pumps a dropdown field and opens its sheet.
Future<void> _openSheet(
  WidgetTester tester, {
  required bool showSearch,
  String? sheetTitle,
}) async {
  await tester.pumpWidget(
    _DropdownTestApp(
      child: GtDropdownField<String>(
        label: 'Invoice date',
        options: _options,
        sheetTitle: sheetTitle,
        showSearch: showSearch,
      ),
    ),
  );
  await tester.tap(find.byType(GtDropdownField<String>));
  await tester.pumpAndSettle();
}

/// Pumps a dropdown field over [options] and opens its sheet.
Future<void> _openSheetWith(
  WidgetTester tester,
  OptionsHolder<String> options, {
  Widget? emptyWidget,
}) async {
  await tester.pumpWidget(
    _DropdownTestApp(
      child: GtDropdownField<String>(
        label: 'Invoice date',
        options: options,
        sheetTitle: 'Invoice date',
        emptyWidget: emptyWidget,
        debounceTime: 100.milliseconds,
      ),
    ),
  );
  await tester.tap(find.byType(GtDropdownField<String>));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('the sheet shows a search field by default', (tester) async {
    await _openSheet(tester, showSearch: true, sheetTitle: 'Invoice date');

    expect(find.byType(GtDropDownModal<String>), findsOneWidget);
    expect(find.byType(GtSearchField), findsOneWidget);
  });

  testWidgets('showSearch false leaves the search field out', (tester) async {
    await _openSheet(tester, showSearch: false, sheetTitle: 'Invoice date');

    expect(find.byType(GtSearchField), findsNothing);
    for (final option in _options) {
      expect(find.text(option.label!), findsOneWidget);
    }
  });

  testWidgets('a sheet without a title keeps its cancel button', (
    tester,
  ) async {
    for (final showSearch in [true, false]) {
      await _openSheet(tester, showSearch: showSearch);

      expect(
        find.byType(GtCancelButton),
        findsOneWidget,
        reason: 'showSearch: $showSearch',
      );
      expect(
        find.byType(GtSearchField),
        showSearch ? findsOneWidget : findsNothing,
        reason: 'showSearch: $showSearch',
      );

      await tester.pumpWidget(const SizedBox());
    }
  });

  testWidgets('a search that matches nothing keeps the search field', (
    tester,
  ) async {
    await _openSheetWith(tester, _options);

    await tester.enterText(
      find.descendant(
        of: find.byType(GtSearchField),
        matching: find.byType(TextField),
      ),
      'xyz',
    );
    await tester.pumpAndSettle(200.milliseconds);

    expect(find.byType(GtSearchField), findsOneWidget);
    expect(find.byType(GtEmptyStateCard), findsOneWidget);
    expect(find.text('noResults'), findsOneWidget);
    for (final option in _options) {
      expect(find.text(option.label!), findsNothing);
    }
  });

  testWidgets('empty options show the default empty state', (tester) async {
    final cases = <String, OptionsHolder<String>>{
      'list': <GtDropdownData<String>>[],
      'future': Future.value(<GtDropdownData<String>>[]),
    };

    for (final MapEntry(:key, :value) in cases.entries) {
      await _openSheetWith(tester, value);

      expect(find.byType(GtEmptyStateCard), findsOneWidget, reason: key);
      expect(find.text('noData'), findsOneWidget, reason: key);
      expect(find.byType(GtSearchField), findsNothing, reason: key);

      await tester.pumpWidget(const SizedBox());
    }
  });

  testWidgets('empty options show the given emptyWidget', (tester) async {
    await _openSheetWith(
      tester,
      Future.value(<GtDropdownData<String>>[]),
      emptyWidget: const Text('No branches'),
    );

    expect(find.text('No branches'), findsOneWidget);
    expect(find.byType(GtEmptyStateCard), findsNothing);
  });
}
