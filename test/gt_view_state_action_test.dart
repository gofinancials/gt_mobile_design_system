import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class _ViewStateTestApp extends GtStatelessWidget {
  final Widget child;

  const _ViewStateTestApp({required this.child});

  @override
  Widget build(BuildContext context) {
    return GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(home: Scaffold(body: child)),
    );
  }
}

/// Reads the leading icon off the action button the view state draws.
IconData? _actionLeading(WidgetTester tester) {
  return tester.widget<GtRaisedButton>(find.byType(GtRaisedButton)).leading;
}

void main() {
  testWidgets('GtStatusState draws actionLeading on every constructor', (
    tester,
  ) async {
    final states = <String, GtStatusState>{
      'default': GtStatusState(
        variant: .success,
        title: 'No invoices',
        actionLabel: 'New invoice',
        actionLeading: GtIcons.plus,
        onActionPressed: () {},
      ),
      'success': GtStatusState.success(
        title: 'No invoices',
        actionLabel: 'New invoice',
        actionLeading: GtIcons.plus,
        onActionPressed: () {},
      ),
      'error': GtStatusState.error(
        title: 'No invoices',
        actionLabel: 'New invoice',
        actionLeading: GtIcons.plus,
        onActionPressed: () {},
      ),
      'custom': GtStatusState.custom(
        title: 'No invoices',
        graphic: const SizedBox(height: 48),
        actionLabel: 'New invoice',
        actionLeading: GtIcons.plus,
        onActionPressed: () {},
      ),
    };

    for (final MapEntry(key: name, value: state) in states.entries) {
      await tester.pumpWidget(_ViewStateTestApp(child: state));

      expect(_actionLeading(tester), GtIcons.plus, reason: name);
      expect(find.byIcon(GtIcons.plus), findsOneWidget, reason: name);
    }
  });

  testWidgets('GtStatusState leaves the action bare without actionLeading', (
    tester,
  ) async {
    await tester.pumpWidget(
      _ViewStateTestApp(
        child: GtStatusState.success(
          title: 'Complete',
          actionLabel: 'Done',
          onActionPressed: () {},
        ),
      ),
    );

    expect(_actionLeading(tester), isNull);
  });

  testWidgets('GtEmptyState draws actionLeading', (tester) async {
    await tester.pumpWidget(
      _ViewStateTestApp(
        child: GtEmptyState(
          title: 'No invoices',
          actionText: 'New invoice',
          actionLeading: GtIcons.plus,
          onActionPressed: () {},
        ),
      ),
    );

    expect(_actionLeading(tester), GtIcons.plus);
    expect(find.byIcon(GtIcons.plus), findsOneWidget);
  });
}
