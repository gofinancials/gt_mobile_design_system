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

  const timestamp = 'Sep 10, 2025 11:03 AM';

  // Every step is settled so no spinner animates, which lets tests settle.
  const steps = [
    GtStatusStepData(
      label: 'Processed',
      state: GtStatusStepState.success,
      subtitle: timestamp,
    ),
    GtStatusStepData(
      label: 'Sent',
      state: GtStatusStepState.success,
      subtitle: timestamp,
    ),
    GtStatusStepData(
      label: 'Delivered',
      state: GtStatusStepState.success,
      subtitle: timestamp,
    ),
  ];

  const sections = [
    GtTransferDetailSection(
      tiles: [
        GtReceiptTileData(
          label: 'Category',
          value: 'Transfer',
          image: AppImageData(GtVectors.logo),
        ),
        GtReceiptTileData(label: 'Source Account', value: 'Savings · 102029'),
      ],
    ),
    GtTransferDetailSection(
      tiles: [
        GtReceiptTileData(label: 'Reference', value: 'TRX24072983910527NGN'),
      ],
    ),
  ];

  const recipient = GtReceiptParticipant(
    title: 'Frances Nkatie',
    image: AppImageData(GtVectors.logo),
  );

  GtTransferDetailBody buildBody({
    List<GtStatusStepData> steps = steps,
    List<GtTransferDetailSection> sections = sections,
    List<GtReceiptAction> actions = const [],
    String currency = AppStrings.naira,
    String? amountSemanticsLabel,
  }) {
    return GtTransferDetailBody(
      recipient: recipient,
      amount: 20000,
      currency: currency,
      amountSemanticsLabel: amountSemanticsLabel,
      steps: steps,
      sections: sections,
      actions: actions,
    );
  }

  Finder tileIn(String key) {
    return find.descendant(
      of: find.byKey(Key(key)),
      matching: find.byType(GtDoubleColumnListTile),
    );
  }

  group('GtTransferDetailBody', () {
    testWidgets('renders the recipient, currency and amount', (tester) async {
      await tester.pumpWidget(buildTestWidget(buildBody()));

      expect(find.byKey(const Key('transfer-detail-avatar')), findsOneWidget);
      expect(find.text('Frances Nkatie'), findsOneWidget);
      expect(find.text('${AppStrings.naira} '), findsOneWidget);

      final amount = tester.widget<GtBalanceText>(
        find.byKey(const Key('transfer-detail-amount')),
      );
      expect(amount.amtDisplay, '20,000.00');
      expect(amount.showVisibilityIcon, isFalse);
      expect(find.byIcon(GtIcons.eyeClosed), findsNothing);
      expect(find.byIcon(GtIcons.eyeOpen), findsNothing);
    });

    testWidgets('announces the amount as a transfer amount', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(buildTestWidget(buildBody()));

      // The header merges into a single node, so match within its label.
      expect(
        find.bySemanticsLabel(
          RegExp('Transfer amount is 20,000.00 ${AppStrings.naira}'),
        ),
        findsOneWidget,
      );
      expect(find.bySemanticsLabel(RegExp('Balance is')), findsNothing);

      await tester.pumpWidget(
        buildTestWidget(buildBody(amountSemanticsLabel: 'You sent 20,000')),
      );

      expect(find.bySemanticsLabel(RegExp('You sent 20,000')), findsOneWidget);

      handle.dispose();
    });

    testWidgets('renders a custom currency', (tester) async {
      await tester.pumpWidget(buildTestWidget(buildBody(currency: r'$')));

      expect(find.text(r'$ '), findsOneWidget);
      expect(find.text('${AppStrings.naira} '), findsNothing);
    });

    testWidgets('renders an avatar with its tag for avatar recipients', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const GtTransferDetailBody(
            recipient: GtReceiptParticipant(
              title: 'Frances Nkatie',
              image: AppImageData(GtAssetImages.avatar),
              imageType: GtReceiptImageType.avatar,
              tag: AppImageData(GtVectors.logo),
            ),
            amount: 20000,
            steps: steps,
          ),
        ),
      );

      final avatar = tester.widget<GtAvatar>(find.byType(GtAvatar));
      expect(avatar.tag, isNotNull);
      expect(avatar.showBorder, isTrue);
    });

    testWidgets('renders the steps in a compact status tracker', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(buildBody()));

      expect(find.byKey(const Key('transfer-detail-status')), findsOneWidget);

      final tracker = tester.widget<GtStatusTracker>(
        find.byType(GtStatusTracker),
      );
      expect(tracker.variant, GtStatusTrackerVariant.compact);
      expect(find.text('Processed'), findsOneWidget);
      expect(find.text(timestamp), findsNWidgets(3));
    });

    testWidgets('omits the status card when there are no steps', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(buildBody(steps: const [])));

      expect(find.byKey(const Key('transfer-detail-status')), findsNothing);
    });

    testWidgets('renders one card per section with keyed tiles', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(buildBody()));

      expect(
        find.byKey(const Key('transfer-detail-section-0')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('transfer-detail-section-1')),
        findsOneWidget,
      );
      expect(find.byKey(const Key('transfer-detail-section-2')), findsNothing);

      expect(
        find.byKey(const Key('transfer-detail-section-0-tile-1')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('transfer-detail-section-1-tile-0')),
        findsOneWidget,
      );
      expect(find.text('TRX24072983910527NGN'), findsOneWidget);
    });

    testWidgets('emphasises values and leads them with row images', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(buildBody()));

      final category = tester.widget<GtDoubleColumnListTile>(
        tileIn('transfer-detail-section-0-tile-0'),
      );
      expect(category.highlightValue, isTrue);
      expect(category.valuePrefix, isNotNull);
      expect(category.valueSuffix, isNull);
    });

    testWidgets('renders the actions and invokes them', (tester) async {
      var taps = 0;

      await tester.pumpWidget(
        buildTestWidget(
          buildBody(
            actions: [
              GtReceiptAction.primary(
                label: 'Send again',
                icon: GtIcons.arrowNorthEast,
                onTap: () => taps++,
              ),
              GtReceiptAction(
                label: 'View receipt',
                icon: GtIcons.fileContent,
                onTap: () {},
              ),
            ],
          ),
        ),
      );

      expect(find.byType(GtReceiptActionButton), findsNWidgets(2));

      await tapAndSettle(
        tester,
        find.byKey(const Key('transfer-detail-action-0')),
      );

      expect(taps, 1);
    });

    testWidgets('omits the action row when there are no actions', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(buildBody()));

      expect(find.byType(GtReceiptActionButton), findsNothing);
    });

    testWidgets('asserts when a section has no tiles', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          buildBody(sections: const [GtTransferDetailSection(tiles: [])]),
        ),
      );

      expect(tester.takeException(), isAssertionError);
    });
  });

  group('GtReceiptDetailTile', () {
    testWidgets('keeps label emphasis and trailing images by default', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const GtReceiptDetailTile(
            GtReceiptTileData(
              label: 'Category',
              value: 'Transfer',
              image: AppImageData(GtVectors.logo),
            ),
          ),
        ),
      );

      final tile = tester.widget<GtDoubleColumnListTile>(
        find.byType(GtDoubleColumnListTile),
      );
      expect(tile.highlightValue, isFalse);
      expect(tile.valueSuffix, isNotNull);
      expect(tile.valuePrefix, isNull);
      expect(tile.labelSuffix, isNull);
    });

    testWidgets('renders an info icon only when onInfoTap is supplied', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const GtReceiptDetailTile(
            GtReceiptTileData(label: 'Stamp duty', value: '₦50'),
          ),
        ),
      );

      expect(find.byKey(const Key('receipt-tile-info')), findsNothing);

      await tester.pumpWidget(
        buildTestWidget(
          GtReceiptDetailTile(
            GtReceiptTileData(
              label: 'Stamp duty',
              value: '₦50',
              onInfoTap: () {},
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('receipt-tile-info')), findsOneWidget);
    });

    testWidgets('invokes onInfoTap without invoking onTap', (tester) async {
      var infoTaps = 0;
      var rowTaps = 0;

      await tester.pumpWidget(
        buildTestWidget(
          GtReceiptDetailTile(
            GtReceiptTileData(
              label: 'Fees (VAT Incl)',
              value: '₦25',
              onTap: () => rowTaps++,
              onInfoTap: () => infoTaps++,
            ),
          ),
        ),
      );

      await tapAndSettle(tester, find.byKey(const Key('receipt-tile-info')));

      expect(infoTaps, 1);
      expect(rowTaps, 0);
    });

    testWidgets('announces the info icon to screen readers', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        buildTestWidget(
          GtReceiptDetailTile(
            GtReceiptTileData(
              label: 'Fees (VAT Incl)',
              value: '₦25',
              onInfoTap: () {},
            ),
          ),
        ),
      );

      expect(
        find.bySemanticsLabel('More information about Fees (VAT Incl)'),
        findsOneWidget,
      );

      await tester.pumpWidget(
        buildTestWidget(
          GtReceiptDetailTile(
            GtReceiptTileData(
              label: 'Fees (VAT Incl)',
              value: '₦25',
              onInfoTap: () {},
              infoSemanticsLabel: 'How fees are calculated',
            ),
          ),
        ),
      );

      expect(find.bySemanticsLabel('How fees are calculated'), findsOneWidget);

      handle.dispose();
    });
  });

  group('GtTransferDetailScaffold', () {
    Widget buildScaffold({
      VoidCallback? onClose,
      VoidCallback? onReportProblem,
      OnPressed? onDownload,
    }) {
      return GtThemeProvider(
        theme: kPersonalTheme,
        child: MaterialApp(
          home: GtTransferDetailScaffold(
            onClose: onClose ?? () {},
            onReportProblem: onReportProblem ?? () {},
            onDownload: onDownload,
            buttonText: 'Report a problem',
            body: buildBody(),
          ),
        ),
      );
    }

    Finder reportButton() {
      return find.descendant(
        of: find.byType(GtButtonBottomNavBar),
        matching: find.byType(GtRaisedButton),
      );
    }

    testWidgets('renders the body beneath the bottom bar', (tester) async {
      await tester.pumpWidget(buildScaffold());

      expect(find.byType(GtTransferDetailBody), findsOneWidget);
      expect(reportButton(), findsOneWidget);
    });

    testWidgets('routes the close button to onClose', (tester) async {
      var closes = 0;
      await tester.pumpWidget(buildScaffold(onClose: () => closes++));

      await tapAndSettle(tester, find.byType(GtCancelButton));

      expect(closes, 1);
    });

    testWidgets('routes the bottom action to onReportProblem', (tester) async {
      var reports = 0;
      await tester.pumpWidget(buildScaffold(onReportProblem: () => reports++));

      await tapAndSettle(tester, reportButton());

      expect(reports, 1);
    });

    testWidgets('renders the download action only when onDownload is set', (
      tester,
    ) async {
      await tester.pumpWidget(buildScaffold());

      expect(find.byIcon(GtIcons.download), findsNothing);

      var downloads = 0;
      await tester.pumpWidget(buildScaffold(onDownload: () => downloads++));

      expect(find.byIcon(GtIcons.download), findsOneWidget);

      await tapAndSettle(tester, find.byIcon(GtIcons.download));

      expect(downloads, 1);
    });
  });
}
