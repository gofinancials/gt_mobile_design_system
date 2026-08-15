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

  const transferSections = [
    GtSummarySection(
      tiles: [
        GtSummaryTileData(label: 'Transaction Fee', value: 'No Fees'),
        GtSummaryTileData(label: 'From', value: 'Savings • 0123456789'),
      ],
    ),
    GtSummarySection(
      tiles: [
        GtSummaryTileData(label: 'Account Number', value: '0123456789'),
        GtSummaryTileData(
          label: 'Bank Name',
          value: 'Sterling Bank',
          leading: AppImageData(GtVectors.logo),
        ),
      ],
    ),
  ];

  const paymentsSection = GtSummaryPaymentsSection(
    title: 'Payments',
    entries: [
      GtSummaryPaymentEntry(
        name: 'Basit Samad',
        detail: '0123456789',
        amount: '₦10,000.00',
        fees: 'Fees: ₦0',
      ),
      GtSummaryPaymentEntry(
        name: 'Funmilola Malik',
        detail: '0123456789',
        amount: '₦10,000.00',
        fees: 'Fees: ₦50',
      ),
    ],
  );

  group('GtSummaryBody', () {
    testWidgets('renders one card per section', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const GtSummaryBody(amount: '₦20,000.00', sections: transferSections),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('summary-section-0')), findsOneWidget);
      expect(find.byKey(const Key('summary-section-1')), findsOneWidget);
      expect(find.byKey(const Key('summary-section-2')), findsNothing);
    });

    testWidgets('renders every tile in every section', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const GtSummaryBody(amount: '₦20,000.00', sections: transferSections),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Transaction Fee'), findsOneWidget);
      expect(find.text('No Fees'), findsOneWidget);
      expect(find.text('Savings • 0123456789'), findsOneWidget);
      expect(find.text('Sterling Bank'), findsOneWidget);
    });

    testWidgets('leads the first card with the amount by default', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const GtSummaryBody(amount: '₦20,000.00', sections: transferSections),
        ),
      );
      await tester.pumpAndSettle();

      final amount = find.byKey(const Key('summary-amount'));
      expect(amount, findsOneWidget);

      // Inside the first card, not floating above it.
      expect(
        find.descendant(
          of: find.byKey(const Key('summary-section-0')),
          matching: amount,
        ),
        findsOneWidget,
      );
      expect(find.byKey(const Key('summary-amount-caption')), findsNothing);
    });

    testWidgets('lifts a featured amount out of the cards', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const GtSummaryBody(
            amount: '₦30,052.50',
            amountStyle: .featured,
            amountCaption: 'Bulk payment total',
            sections: transferSections,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byKey(const Key('summary-section-0')),
          matching: find.byKey(const Key('summary-amount')),
        ),
        findsNothing,
      );
      expect(find.text('Bulk payment total'), findsOneWidget);
    });

    testWidgets('renders the title and description when supplied', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const GtSummaryBody(
            amount: '₦20,000.00',
            title: 'Summary',
            description: 'Check the details below before you send.',
            sections: transferSections,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // The heading is uppercased; the description is left as written.
      expect(find.text('SUMMARY'), findsOneWidget);
      expect(
        find.text('Check the details below before you send.'),
        findsOneWidget,
      );
    });

    testWidgets('omits the title and description when absent', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const GtSummaryBody(amount: '₦20,000.00', sections: transferSections),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('summary-title')), findsNothing);
      expect(find.byKey(const Key('summary-description')), findsNothing);
    });

    testWidgets('renders a section title only when one is given', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const GtSummaryBody(
            amount: '₦20,000.00',
            sections: [
              GtSummarySection(
                title: 'Recipient',
                tiles: [GtSummaryTileData(label: 'Name', value: 'ALEX')],
              ),
              GtSummarySection(
                tiles: [GtSummaryTileData(label: 'Bank', value: 'Sterling')],
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(GtSectionHeader), findsOneWidget);
    });

    testWidgets('mixes card kinds in the order given', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const GtSummaryBody(
            amount: '₦30,052.50',
            amountStyle: .featured,
            sections: [
              GtSummarySection(
                layout: .stacked,
                tiles: [
                  GtSummaryTileData(
                    label: 'Name of bulk payment',
                    value: 'Staff Salary',
                  ),
                ],
              ),
              paymentsSection,
              GtSummaryRatesSection(
                description: 'Success rates in the last 30 minutes',
                rates: [GtSuccessRateData(name: 'Sterling Bank', rate: .98)],
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      // The payee card sits between the two others, as the design has it.
      expect(find.byType(GtSummaryPaymentsCard), findsOneWidget);
      expect(find.byType(GtSummaryRatesCard), findsOneWidget);
      expect(find.text('Staff Salary'), findsOneWidget);
    });
  });

  group('GtSummaryTile', () {
    testWidgets('columns layout brackets the value with its images', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const GtSummaryTile(
            GtSummaryTileData(
              label: 'Category',
              value: 'Transfer',
              leading: AppImageData(GtVectors.logo),
              trailing: AppImageData(GtVectors.sterling),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final tile = tester.widget<GtDoubleColumnListTile>(
        find.byType(GtDoubleColumnListTile),
      );

      expect(tile.valuePrefix, isNotNull);
      expect(tile.valueSuffix, isNotNull);
    });

    testWidgets('stacked layout puts the label above the value', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const GtSummaryTile(
            GtSummaryTileData(
              label: 'Name of bulk payment',
              value: 'Staff Salary',
            ),
            layout: .stacked,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(GtInfoListTile), findsOneWidget);
      expect(find.byType(GtDoubleColumnListTile), findsNothing);

      final label = tester.getTopLeft(find.text('Name of bulk payment'));
      final value = tester.getTopLeft(find.text('Staff Salary'));
      expect(value.dy, greaterThan(label.dy));
      expect(value.dx, label.dx);
    });

    testWidgets('a tappable row fires its handler', (tester) async {
      var taps = 0;

      await tester.pumpWidget(
        buildTestWidget(
          GtSummaryTile(
            GtSummaryTileData(
              label: 'Reference',
              value: 'TRX24072983910527NGN',
              onTap: () => taps++,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(GtInkWell));
      await tester.pumpAndSettle();

      expect(taps, 1);
    });
  });

  group('GtSummaryPaymentsCard', () {
    testWidgets('renders a row per payee with its fee', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const GtSummaryPaymentsCard(paymentsSection)),
      );
      await tester.pumpAndSettle();

      expect(find.byType(GtPaymentListTile), findsNWidgets(2));
      expect(find.text('Basit Samad'), findsOneWidget);
      expect(find.text('Fees: ₦50'), findsOneWidget);
    });

    testWidgets('counts the payees beside the title', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const GtSummaryPaymentsCard(paymentsSection)),
      );
      await tester.pumpAndSettle();

      expect(find.text('• 2'), findsOneWidget);

      // Beside the title rather than pushed to the far edge.
      final title = tester.getTopRight(
        find.byKey(const Key('summary-payments-title')),
      );
      final count = tester.getTopLeft(
        find.byKey(const Key('summary-payments-count')),
      );
      expect(count.dx - title.dx, lessThan(16));
    });

    testWidgets('hides the count when suppressed', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const GtSummaryPaymentsCard(
            GtSummaryPaymentsSection(
              title: 'Payments',
              showCount: false,
              entries: [
                GtSummaryPaymentEntry(
                  name: 'Basit Samad',
                  detail: '0123456789',
                  amount: '₦10,000.00',
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('summary-payments-count')), findsNothing);
    });
  });

  group('GtSummaryRatesCard', () {
    const rate = GtSuccessRateData(name: 'Sterling Bank', rate: .98);

    testWidgets('renders the description and a tile per rate', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const GtSummaryRatesCard(
            GtSummaryRatesSection(
              description: 'Success rates in the last 30 minutes',
              rates: [rate],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Success rates in the last 30 minutes'), findsOneWidget);
      expect(find.byType(GtSuccessRateTile), findsOneWidget);
    });

    testWidgets('needs both a label and a handler to show its action', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const GtSummaryRatesCard(
            GtSummaryRatesSection(
              description: 'Success rates in the last 30 minutes',
              rates: [rate],
              // A label with no handler would render a dead row.
              actionLabel: 'See all bank transfer rates',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('summary-rates-action')), findsNothing);
      expect(find.byType(GtDashedDivider), findsNothing);
    });

    testWidgets('the action row navigates when tapped', (tester) async {
      var taps = 0;

      await tester.pumpWidget(
        buildTestWidget(
          GtSummaryRatesCard(
            GtSummaryRatesSection(
              description: 'Success rates in the last 30 minutes',
              rates: const [rate],
              actionLabel: 'See all bank transfer rates',
              onAction: () => taps++,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(GtDashedDivider), findsOneWidget);

      await tester.tap(find.text('See all bank transfer rates'));
      await tester.pumpAndSettle();

      expect(taps, 1);
    });
  });

  group('GtSummaryScaffold', () {
    GtSummaryScaffold buildScaffold({
      GtSummaryTitleStyle titleStyle = GtSummaryTitleStyle.appBar,
      IconData? secondaryIcon,
      OnPressed? onSecondaryAction,
      OnPressed? onAction,
      OnPressed? onBack,
    }) {
      return GtSummaryScaffold(
        title: 'Summary',
        titleStyle: titleStyle,
        actionLabel: 'Confirm',
        secondaryIcon: secondaryIcon,
        onSecondaryAction: onSecondaryAction,
        onAction: onAction ?? () {},
        onBack: onBack,
        body: const GtSummaryBody(
          amount: '₦20,000.00',
          sections: transferSections,
        ),
      );
    }

    testWidgets('centres the title in the app bar by default', (tester) async {
      await tester.pumpWidget(buildTestWidget(buildScaffold()));
      await tester.pumpAndSettle();

      expect(find.byType(GtAppBar), findsOneWidget);
      expect(find.byType(GtActionAppBar), findsNothing);
      expect(find.byKey(const Key('summary-title')), findsNothing);
      expect(find.text('SUMMARY'), findsOneWidget);
    });

    testWidgets('the headline style moves the title into the body', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(buildScaffold(titleStyle: .headline)),
      );
      await tester.pumpAndSettle();

      expect(find.byType(GtActionAppBar), findsOneWidget);
      expect(find.byType(GtAppBar), findsNothing);

      // Forwarded from the scaffold, so the caller states it only once.
      expect(find.byKey(const Key('summary-title')), findsOneWidget);
      expect(find.text('SUMMARY'), findsOneWidget);
    });

    testWidgets('the back chevron pops the route by default', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          Builder(
            builder: (context) => GtRaisedButton(
              text: 'Open',
              onPressed: () => Navigator.of(
                context,
              ).push(MaterialPageRoute<void>(builder: (_) => buildScaffold())),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(GtRaisedButton));
      await tester.pumpAndSettle();
      expect(find.byType(GtSummaryScaffold), findsOneWidget);

      // No onBack supplied: the chevron pops without the caller wiring it.
      await tester.tap(find.byType(GtBackButton));
      await tester.pumpAndSettle();

      expect(find.byType(GtSummaryScaffold), findsNothing);
    });

    testWidgets('hides the back chevron when there is nothing to pop', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(buildScaffold()));
      await tester.pumpAndSettle();

      expect(find.byType(GtIcon), findsNothing);
    });

    testWidgets('the action button fires its handler', (tester) async {
      var taps = 0;

      await tester.pumpWidget(
        buildTestWidget(buildScaffold(onAction: () => taps++)),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('summary-action')));
      await tester.pumpAndSettle();

      expect(taps, 1);
    });

    testWidgets('needs both an icon and a handler for the secondary action', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(buildScaffold(secondaryIcon: GtIcons.calendar)),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('summary-secondary-action')), findsNothing);
    });

    testWidgets('renders the secondary action beside the primary one', (
      tester,
    ) async {
      var taps = 0;

      await tester.pumpWidget(
        buildTestWidget(
          buildScaffold(
            secondaryIcon: GtIcons.calendar,
            onSecondaryAction: () => taps++,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final secondary = find.byKey(const Key('summary-secondary-action'));
      expect(secondary, findsOneWidget);

      final primaryRight = tester.getTopRight(
        find.byKey(const Key('summary-action')),
      );
      expect(tester.getTopLeft(secondary).dx, greaterThan(primaryRight.dx));

      await tester.tap(secondary);
      await tester.pumpAndSettle();

      expect(taps, 1);
    });
  });
}
