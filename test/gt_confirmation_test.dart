import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

void main() {
  Widget buildTestWidget(Widget child) {
    return GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(home: Scaffold(body: child)),
    );
  }

  Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  /// The rendered label of the single [GtPill] in the tree.
  ///
  /// [GtPill] renders through `Text.rich`, so `find.text` cannot match it.
  String pillLabel(WidgetTester tester) {
    return tester.widget<GtPill>(find.byType(GtPill)).text;
  }

  const sections = [
    GtConfirmationSection(
      title: 'Account Details',
      tiles: [
        GtReceiptTileData(label: 'Name', value: 'OLOWOFALA ALAO'),
        GtReceiptTileData(label: 'Account Number', value: '3910527NGN'),
      ],
    ),
    GtConfirmationSection(
      title: 'Transaction Details',
      tiles: [GtReceiptTileData(label: 'Status', value: 'Delivered')],
    ),
  ];

  GtConfirmationBody buildBody({
    List<GtConfirmationSection> sections = sections,
    AppImageData? stamp,
    String? disclaimer,
    GtReceiptStatusData status = const GtReceiptStatusData(
      status: GtReceiptStatus.success,
      title: 'Delivered',
    ),
  }) {
    return GtConfirmationBody(
      amount: '20,000.00',
      date: 'September 29, 2025',
      time: '02:45 PM',
      status: status,
      stamp: stamp,
      disclaimer: disclaimer,
      sections: sections,
    );
  }

  group('GtConfirmationBody', () {
    testWidgets('renders the amount, timestamp and section content', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(buildBody()));

      expect(find.byKey(const Key('confirmation-amount')), findsOneWidget);
      expect(find.text('20,000.00'), findsOneWidget);
      // The timestamp renders through Text.rich, so find.text cannot match it.
      final timestamp = tester.widget<Text>(
        find.byKey(const Key('confirmation-timestamp')),
      );
      final timestampText = timestamp.textSpan?.toPlainText();
      expect(timestampText, contains('September 29, 2025'));
      expect(timestampText, contains('02:45 PM'));

      // GtSectionHeader uppercases the section title.
      expect(find.text('ACCOUNT DETAILS'), findsOneWidget);
      expect(find.text('TRANSACTION DETAILS'), findsOneWidget);
      expect(find.text('OLOWOFALA ALAO'), findsOneWidget);
      expect(find.text('3910527NGN'), findsOneWidget);
    });

    testWidgets('renders one card per section with keyed tiles', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(buildBody()));

      expect(find.byKey(const Key('confirmation-section-0')), findsOneWidget);
      expect(find.byKey(const Key('confirmation-section-1')), findsOneWidget);
      expect(find.byKey(const Key('confirmation-section-2')), findsNothing);

      expect(
        find.byKey(const Key('confirmation-section-0-tile-0')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('confirmation-section-0-tile-1')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('confirmation-section-1-tile-0')),
        findsOneWidget,
      );
    });

    testWidgets('omits the stamp when none is supplied', (tester) async {
      await tester.pumpWidget(buildTestWidget(buildBody()));

      expect(find.byKey(const Key('confirmation-stamp')), findsNothing);
    });

    testWidgets('renders the stamp when one is supplied', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(buildBody(stamp: const AppImageData(GtVectors.logo))),
      );

      expect(find.byKey(const Key('confirmation-stamp')), findsOneWidget);
    });

    testWidgets('omits the disclaimer when none is supplied', (tester) async {
      await tester.pumpWidget(buildTestWidget(buildBody()));

      expect(find.byKey(const Key('confirmation-disclaimer')), findsNothing);
    });

    testWidgets('renders the disclaimer when one is supplied', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(buildBody(disclaimer: 'Transfers may be delayed.')),
      );

      expect(find.byKey(const Key('confirmation-disclaimer')), findsOneWidget);
      expect(find.text('Transfers may be delayed.'), findsOneWidget);
    });

    testWidgets('asserts when no sections are supplied', (tester) async {
      await tester.pumpWidget(buildTestWidget(buildBody(sections: const [])));

      expect(tester.takeException(), isAssertionError);
    });

    testWidgets('asserts when a section has no tiles', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          buildBody(
            sections: const [GtConfirmationSection(title: 'Empty', tiles: [])],
          ),
        ),
      );

      expect(tester.takeException(), isAssertionError);
    });

    testWidgets('invokes onTap for interactive tiles', (tester) async {
      var taps = 0;

      await tester.pumpWidget(
        buildTestWidget(
          buildBody(
            sections: [
              GtConfirmationSection(
                title: 'Transaction Details',
                tiles: [
                  GtReceiptTileData(
                    label: 'Reference',
                    value: 'TRX24072983910527NGN',
                    onTap: () => taps++,
                  ),
                ],
              ),
            ],
          ),
        ),
      );

      await tapAndSettle(
        tester,
        find.byKey(const Key('confirmation-section-0-tile-0')),
      );

      expect(taps, 1);
    });
  });

  group('GtReceiptStatusPill', () {
    testWidgets('renders the custom title uppercased', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const GtReceiptStatusPill(
            status: GtReceiptStatusData(
              status: GtReceiptStatus.success,
              title: 'Delivered',
            ),
          ),
        ),
      );

      expect(pillLabel(tester), 'DELIVERED');
    });

    testWidgets('falls back to the localised status title', (tester) async {
      for (final status in GtReceiptStatus.values) {
        await tester.pumpWidget(
          buildTestWidget(
            GtReceiptStatusPill(status: GtReceiptStatusData(status: status)),
          ),
        );

        final data = GtReceiptStatusData(status: status);
        expect(
          pillLabel(tester),
          data.displayTitle.upper,
          reason: 'expected a pill label for ${status.name}',
        );
      }
    });

    testWidgets('renders a spinner for the processing status', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const GtReceiptStatusPill(
            status: GtReceiptStatusData(status: GtReceiptStatus.processing),
          ),
        ),
      );

      expect(find.byType(GtSpinner), findsOneWidget);
    });

    testWidgets('renders no spinner for settled statuses', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const GtReceiptStatusPill(
            status: GtReceiptStatusData(status: GtReceiptStatus.success),
          ),
        ),
      );

      expect(find.byType(GtSpinner), findsNothing);
    });

    testWidgets('invokes onPressed when tapped', (tester) async {
      var taps = 0;

      await tester.pumpWidget(
        buildTestWidget(
          GtReceiptStatusPill(
            status: GtReceiptStatusData(
              status: GtReceiptStatus.success,
              onPressed: () => taps++,
            ),
          ),
        ),
      );

      await tapAndSettle(tester, find.byType(GtReceiptStatusPill));

      expect(taps, 1);
    });
  });

  group('GtConfirmationScaffold', () {
    Widget buildScaffold({OnPressed? onShare, VoidCallback? onClose}) {
      return GtThemeProvider(
        theme: kPersonalTheme,
        child: MaterialApp(
          home: GtConfirmationScaffold(
            title: 'Transfer Confirmation',
            onClose: onClose ?? () {},
            onShare: onShare,
            body: buildBody(),
          ),
        ),
      );
    }

    testWidgets('renders the uppercased title and the body', (tester) async {
      await tester.pumpWidget(buildScaffold());

      expect(find.text('TRANSFER CONFIRMATION'), findsOneWidget);
      expect(find.byType(GtConfirmationBody), findsOneWidget);
    });

    testWidgets('omits the share action when onShare is null', (tester) async {
      await tester.pumpWidget(buildScaffold());

      expect(find.byType(GtIconButton), findsNothing);
    });

    testWidgets('renders the share action when onShare is supplied', (
      tester,
    ) async {
      var taps = 0;
      await tester.pumpWidget(buildScaffold(onShare: () => taps++));

      expect(find.byType(GtIconButton), findsOneWidget);

      await tapAndSettle(tester, find.byType(GtIconButton));

      expect(taps, 1);
    });

    testWidgets('routes the back button to onClose', (tester) async {
      var closes = 0;
      await tester.pumpWidget(buildScaffold(onClose: () => closes++));

      // GtBackButton aligns its chevron to centre-left within a wider cell, so
      // target the constrained box holding the icon rather than the cell.
      await tapAndSettle(
        tester,
        find.descendant(
          of: find.byType(GtBackButton),
          matching: find.byType(GtSquareConstrainedBox),
        ),
      );

      expect(closes, 1);
    });

    testWidgets('renders no bottom navigation bar', (tester) async {
      await tester.pumpWidget(buildScaffold(onShare: () {}));

      expect(find.byType(GtButtonBottomNavBar), findsNothing);
    });
  });
}
