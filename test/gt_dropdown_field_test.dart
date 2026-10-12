import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
}
