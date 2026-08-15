import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

import 'helpers/test_app_config.dart';

void main() {
  setUpAll(registerTestAppConfig);

  Widget buildTestWidget(Widget child) {
    return GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(home: Scaffold(body: child)),
    );
  }

  const rates = [
    GtSuccessRateData(name: 'Sterling Bank', rate: 1),
    GtSuccessRateData(name: 'Opay', rate: .99),
    GtSuccessRateData(name: 'Kuda MFB', rate: .98),
    GtSuccessRateData(name: 'Paystack-Titan', rate: .87),
    GtSuccessRateData(name: 'Moniepoint', rate: 0),
  ];

  /// The rendered labels of every success-rate pill, in order.
  List<String> pillLabels(WidgetTester tester) {
    return tester
        .widgetList<GtPill>(find.byType(GtPill))
        .map((pill) => pill.text)
        .toList();
  }

  group('GtSuccessRateData', () {
    test('matches on name when no delegate is supplied', () {
      const entry = GtSuccessRateData(name: 'Sterling Bank', rate: 1);

      expect(entry.filter('sterling'), isTrue);
      expect(entry.filter('STERLING'), isTrue);
      expect(entry.filter('kuda'), isFalse);
    });

    test('an empty or null query always matches', () {
      const entry = GtSuccessRateData(name: 'Sterling Bank', rate: 1);

      expect(entry.filter(null), isTrue);
      expect(entry.filter(''), isTrue);
    });

    test('defers to a supplied filter delegate', () {
      final entry = GtSuccessRateData(
        name: 'Sterling Bank',
        rate: 1,
        filterDelegate: (query) => 'STL'.includes(query),
      );

      expect(entry.filter('stl'), isTrue);
      // The delegate wins outright: the name no longer matches on its own.
      expect(entry.filter('sterling'), isFalse);
    });
  });

  group('GtSuccessRateBody', () {
    testWidgets('renders a row per entry in a lazily built list', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(const GtSuccessRateBody(rates: rates)),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('success-rate-list')), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byKey(const Key('success-rate-row-0')), findsOneWidget);
      expect(find.byKey(const Key('success-rate-row-4')), findsOneWidget);
      expect(find.byKey(const Key('success-rate-row-5')), findsNothing);

      expect(find.text('Sterling Bank'), findsOneWidget);
      expect(find.text('Moniepoint'), findsOneWidget);
    });

    testWidgets('stitches the rows into one continuous card', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const GtSuccessRateBody(rates: rates)),
      );
      await tester.pumpAndSettle();

      // Only the outer edges are rounded, so a lazy list still reads as the
      // single card the design calls for. The separators between rows are
      // GtCardListTiles too, so read the types from the keyed rows alone.
      final types = tester
          .widgetList<GtCardListTile>(find.byType(GtCardListTile))
          .where((tile) => tile.key != null)
          .map((tile) => tile.type)
          .toList();

      expect(types.first, GtCardListTileType.starter);
      expect(types.last, GtCardListTileType.terminus);
      expect(
        types.sublist(1, types.length - 1),
        everyElement(GtCardListTileType.medial),
      );
    });

    testWidgets('rounds every corner when a single entry matches', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const GtSuccessRateBody(
            rates: [GtSuccessRateData(name: 'Sterling Bank', rate: 1)],
          ),
        ),
      );
      await tester.pumpAndSettle();

      final tile = tester.widget<GtCardListTile>(find.byType(GtCardListTile));

      expect(tile.type, GtCardListTileType.sole);
    });

    testWidgets('renders each rate as a rounded percentage', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const GtSuccessRateBody(rates: rates)),
      );
      await tester.pumpAndSettle();

      expect(pillLabels(tester), ['100%', '99%', '98%', '87%', '0%']);
    });

    testWidgets('renders the description when one is supplied', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const GtSuccessRateBody(
            rates: rates,
            description: 'See how recipient banks are performing.',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('success-rate-description')), findsOneWidget);
      expect(
        find.text('See how recipient banks are performing.'),
        findsOneWidget,
      );
    });

    testWidgets('omits the description when none is supplied', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const GtSuccessRateBody(rates: rates)),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('success-rate-description')), findsNothing);
    });

    testWidgets('hides the search field when showSearch is false', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const GtSuccessRateBody(rates: rates, showSearch: false),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('success-rate-search')), findsNothing);
    });

    testWidgets('filters entries as the query is typed', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const GtSuccessRateBody(
            rates: rates,
            debounceTime: Duration(milliseconds: 10),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('success-rate-search')),
        'ku',
      );
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pumpAndSettle();

      expect(find.text('Kuda MFB'), findsOneWidget);
      expect(find.text('Sterling Bank'), findsNothing);
      expect(find.byKey(const Key('success-rate-row-1')), findsNothing);
    });

    testWidgets('shows the empty widget when nothing matches', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const GtSuccessRateBody(
            rates: rates,
            debounceTime: Duration(milliseconds: 10),
            emptyWidget: Text('No banks found'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('success-rate-search')),
        'zzzz',
      );
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pumpAndSettle();

      expect(find.text('No banks found'), findsOneWidget);
      expect(find.byKey(const Key('success-rate-list')), findsNothing);
    });

    testWidgets('shows the loading widget while a future resolves', (
      tester,
    ) async {
      final completer = Completer<List<GtSuccessRateData>>();

      await tester.pumpWidget(
        buildTestWidget(
          GtSuccessRateBody(
            rates: completer.future,
            loadingWidget: const Text('Loading rates'),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Loading rates'), findsOneWidget);
      expect(find.byKey(const Key('success-rate-search')), findsNothing);

      completer.complete(rates);
      await tester.pumpAndSettle();

      expect(find.text('Loading rates'), findsNothing);
      expect(find.text('Sterling Bank'), findsOneWidget);
    });

    testWidgets('shows the error widget when the future fails', (tester) async {
      // Completed after the first pump so the body is already listening; a
      // pre-failed future would surface as an unhandled async error instead.
      final completer = Completer<List<GtSuccessRateData>>();

      await tester.pumpWidget(
        buildTestWidget(
          GtSuccessRateBody(
            rates: completer.future,
            errorWidget: const Text('Could not load rates'),
          ),
        ),
      );
      await tester.pump();

      completer.completeError(Exception('boom'));
      await tester.pumpAndSettle();

      expect(find.text('Could not load rates'), findsOneWidget);
      expect(find.byKey(const Key('success-rate-list')), findsNothing);
    });

    testWidgets('delegates a single row to builder', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          GtSuccessRateBody(
            rates: rates,
            builder: (entry) => Text('custom ${entry.name}'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('custom Sterling Bank'), findsOneWidget);
      expect(find.byType(GtSuccessRateTile), findsNothing);
    });

    testWidgets('delegates the whole list to listBuilder', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          GtSuccessRateBody(
            rates: rates,
            listBuilder: (entries, controller) =>
                Text('${entries.length} banks'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('5 banks'), findsOneWidget);
      expect(find.byKey(const Key('success-rate-list')), findsNothing);
    });

    testWidgets('invokes onTap for interactive rows', (tester) async {
      var taps = 0;

      await tester.pumpWidget(
        buildTestWidget(
          GtSuccessRateBody(
            rates: [
              GtSuccessRateData(
                name: 'Sterling Bank',
                rate: 1,
                onTap: () => taps++,
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('success-rate-row-0')));
      await tester.pumpAndSettle();

      expect(taps, 1);
    });

    testWidgets('reloads when a new rates instance is supplied', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(const GtSuccessRateBody(rates: rates)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Sterling Bank'), findsOneWidget);

      await tester.pumpWidget(
        buildTestWidget(
          const GtSuccessRateBody(
            rates: [GtSuccessRateData(name: 'Zenith Bank', rate: .98)],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Zenith Bank'), findsOneWidget);
      expect(find.text('Sterling Bank'), findsNothing);
    });

    testWidgets('keeps existing rows visible while a reload is in flight', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(const GtSuccessRateBody(rates: rates)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Sterling Bank'), findsOneWidget);

      final completer = Completer<List<GtSuccessRateData>>();
      await tester.pumpWidget(
        buildTestWidget(GtSuccessRateBody(rates: completer.future)),
      );
      await tester.pump();

      // setLoading retains the previous data, so a refresh does not flash a
      // spinner over rows the user is already reading.
      expect(find.text('Sterling Bank'), findsOneWidget);
      expect(find.byType(GtSpinner), findsNothing);

      completer.complete(const [
        GtSuccessRateData(name: 'Zenith Bank', rate: .98),
      ]);
      await tester.pumpAndSettle();

      expect(find.text('Zenith Bank'), findsOneWidget);
      expect(find.text('Sterling Bank'), findsNothing);
    });

    testWidgets('preserves the active query across a reload', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const GtSuccessRateBody(
            rates: rates,
            debounceTime: Duration(milliseconds: 10),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('success-rate-search')),
        'ku',
      );
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pumpAndSettle();

      expect(find.text('Kuda MFB'), findsOneWidget);
      expect(find.text('Sterling Bank'), findsNothing);

      // The visible list is derived from source + query on every build, so a
      // reload cannot silently drop the filter.
      await tester.pumpWidget(
        buildTestWidget(
          const GtSuccessRateBody(
            rates: [
              GtSuccessRateData(name: 'Kuda Bank', rate: .98),
              GtSuccessRateData(name: 'Sterling Bank', rate: 1),
            ],
            debounceTime: Duration(milliseconds: 10),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Kuda Bank'), findsOneWidget);
      expect(find.text('Sterling Bank'), findsNothing);
    });
  });

  group('GtSuccessRateModal', () {
    Widget buildModal({OnPressed? onRefresh, String? title}) {
      return GtThemeProvider(
        theme: kPersonalTheme,
        child: MaterialApp(
          home: Scaffold(
            body: GtSuccessRateModal(
              title: title ?? 'Transfer Success Rate',
              onRefresh: onRefresh,
              body: const GtSuccessRateBody(rates: rates),
            ),
          ),
        ),
      );
    }

    testWidgets('renders the uppercased title and the body', (tester) async {
      await tester.pumpWidget(buildModal());
      await tester.pumpAndSettle();

      expect(find.text('TRANSFER SUCCESS RATE'), findsOneWidget);
      expect(find.byType(GtSuccessRateBody), findsOneWidget);
    });

    testWidgets('omits the refresh action when onRefresh is null', (
      tester,
    ) async {
      await tester.pumpWidget(buildModal());
      await tester.pumpAndSettle();

      expect(find.byType(GtIconButton), findsNothing);
    });

    testWidgets('renders and invokes the refresh action', (tester) async {
      var refreshes = 0;
      await tester.pumpWidget(buildModal(onRefresh: () => refreshes++));
      await tester.pumpAndSettle();

      expect(find.byType(GtIconButton), findsOneWidget);

      await tester.tap(find.byType(GtIconButton));
      await tester.pumpAndSettle();

      expect(refreshes, 1);
    });
  });
}
