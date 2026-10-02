import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class _Item extends Identifiable {
  const _Item(String id) : super(uuid: id);
}

class _SkeletonTestApp extends GtStatelessWidget {
  final Widget child;
  final ThemeMode themeMode;

  const _SkeletonTestApp({required this.child, this.themeMode = .light});

  @override
  Widget build(BuildContext context) {
    return GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(
        theme: kPersonalTheme.materialLight,
        darkTheme: kPersonalTheme.materialDark,
        themeMode: themeMode,
        home: Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(context).copyWith(disableAnimations: true),
            child: Scaffold(body: child),
          ),
        ),
      ),
    );
  }
}

/// Every semantics label reachable from the root, flattened.
List<String> _semanticLabels(WidgetTester tester) {
  final labels = <String>[];
  void visit(SemanticsNode node) {
    if (node.label.hasValue) labels.add(node.label);
    node.visitChildren((child) {
      visit(child);
      return true;
    });
  }

  final owner = tester.renderObject(find.byType(MaterialApp)).owner!;
  visit(owner.semanticsOwner!.rootSemanticsNode!);
  return labels;
}

void main() {
  final cardSkeletons = <String, Widget Function()>{
    'GtSectionHeader': () => GtSectionHeader.skeleton(),
    'GtTransactionGroupHeader': () => GtTransactionGroupHeader.skeleton(),
    'GtInboxCard': () => GtInboxCard.skeleton(),
    'GtBillCard': () => GtBillCard.skeleton(),
    'GtBillCard.tile': GtBillCard.tileSkeleton,
    'GtNotificationCard': () => GtNotificationCard.skeleton(),
    'GtPaymentSourceCard': () => GtPaymentSourceCard.skeleton(label: 'Pay'),
    'GtAddressCard': () => GtAddressCard.skeleton(),
    'GtSummaryTile': () => GtSummaryTile.skeleton(),
  };

  group('card skeleton builders', () {
    for (final mode in [ThemeMode.light, ThemeMode.dark]) {
      for (final MapEntry(key: name, value: build) in cardSkeletons.entries) {
        testWidgets('$name builds in ${mode.name} mode, hidden from readers', (
          tester,
        ) async {
          final handle = tester.ensureSemantics();
          await tester.pumpWidget(
            _SkeletonTestApp(
              themeMode: mode,
              child: SingleChildScrollView(child: build()),
            ),
          );
          await tester.pumpAndSettle();

          expect(tester.takeException(), isNull);
          expect(find.byType(GtSkeleton), findsWidgets);
          expect(_semanticLabels(tester), isEmpty);
          handle.dispose();
        });
      }
    }
  });

  group('GtGuageChart', () {
    GtArcPainter arcPainter(WidgetTester tester) {
      final paint = tester.widget<CustomPaint>(
        find.descendant(
          of: find.byType(GtGuageChart),
          matching: find.byType(CustomPaint),
        ),
      );
      return paint.painter! as GtArcPainter;
    }

    testWidgets('draws an empty track in the bone color in a skeleton', (
      tester,
    ) async {
      await tester.pumpWidget(
        const _SkeletonTestApp(
          child: GtSkeleton(child: GtGuageChart(value: .7, width: 240)),
        ),
      );
      await tester.pumpAndSettle();

      final scope = tester.widget<GtSkeletonScope>(
        find.byType(GtSkeletonScope),
      );
      final painter = arcPainter(tester);
      expect(painter.value, 0);
      expect(painter.trackColor, scope.baseColor);
      expect(painter.valueColor, scope.baseColor);
    });

    testWidgets('draws its value outside a skeleton', (tester) async {
      await tester.pumpWidget(
        const _SkeletonTestApp(child: GtGuageChart(value: .7, width: 240)),
      );
      await tester.pumpAndSettle();

      expect(arcPainter(tester).value, .7);
    });
  });

  testWidgets('GtLineChartArea is one bone in a skeleton', (tester) async {
    await tester.pumpWidget(
      _SkeletonTestApp(
        child: GtSkeleton(
          child: GtLineChartArea([
            GtLineChartItem(10, date: DateTime(2026, 1)),
            GtLineChartItem(40, date: DateTime(2026, 2)),
          ], color: Colors.blue),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byType(GtLineChartArea),
        matching: find.byType(GtBone),
      ),
      findsWidgets,
    );
  });

  testWidgets('a loading summary scaffold bones only its body', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _SkeletonTestApp(
        child: GtSummaryScaffold(
          title: 'Summary',
          actionLabel: 'Confirm',
          onAction: () {},
          isLoading: true,
          loadingSemanticsLabel: 'Loading summary',
          body: const GtSummaryBody(
            amount: '₦20,000.00',
            sections: [
              GtSummarySection(
                tiles: [
                  GtSummaryTileData(label: 'Account Name', value: 'Ada Obi'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final labels = _semanticLabels(tester);
    expect(labels, contains('SUMMARY'));
    expect(labels, contains('CONFIRM'));
    expect(labels, contains('Loading summary'));
    expect(labels, isNot(contains('Ada Obi')));
    expect(
      find.descendant(
        of: find.byType(GtSkeleton),
        matching: find.byType(GtSummaryBody),
      ),
      findsOneWidget,
    );
    handle.dispose();
  });

  testWidgets('a summary scaffold is not boned by default', (tester) async {
    await tester.pumpWidget(
      _SkeletonTestApp(
        child: GtSummaryScaffold(
          title: 'Summary',
          actionLabel: 'Confirm',
          onAction: () {},
          body: const GtSummaryBody(
            amount: '₦20,000.00',
            sections: [
              GtSummarySection(
                tiles: [
                  GtSummaryTileData(label: 'Account Name', value: 'Ada Obi'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(GtSkeleton), findsNothing);
  });

  testWidgets('GtAsyncStateBody draws a skeleton list on the loading arm', (
    tester,
  ) async {
    await tester.pumpWidget(
      _SkeletonTestApp(
        child: GtAsyncStateBody(
          task: const FutureListData<_Item>.pristine(),
          emptyDescription: 'Nothing here yet',
          errorTitle: 'Something went wrong',
          loading: GtSkeletonList(
            itemCount: 3,
            itemBuilder: (context, i) => GtSectionHeader('Row $i'),
          ),
          builder: (context) => const GtText('data'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(GtSkeletonList), findsOneWidget);
    expect(find.byType(GtSpinner), findsNothing);
    expect(find.text('ROW 2'), findsOneWidget);
  });

  testWidgets('GtCardListView.skeleton groups its rows under one skeleton', (
    tester,
  ) async {
    await tester.pumpWidget(
      _SkeletonTestApp(
        child: GtCardListView.skeleton(
          itemCount: 3,
          itemBuilder: (context, i) => GtSectionHeader('Row $i'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(GtSkeleton), findsOneWidget);
    expect(find.byType(GtCardListTile), findsNWidgets(5));
  });

  testWidgets('GtCardListSliver.skeleton bones each row in a scroll view', (
    tester,
  ) async {
    await tester.pumpWidget(
      _SkeletonTestApp(
        child: CustomScrollView(
          slivers: [
            GtCardListSliver.skeleton(
              itemCount: 3,
              itemBuilder: (context, i) => GtSectionHeader('Row $i'),
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(GtSkeleton), findsNWidgets(3));
  });

  group('card skeletons are neutral by default', () {
    for (final mode in [ThemeMode.light, ThemeMode.dark]) {
      testWidgets('GtNotificationCard in ${mode.name}', (tester) async {
        await tester.pumpWidget(
          _SkeletonTestApp(
            themeMode: mode,
            child: GtNotificationCard.skeleton(),
          ),
        );
        await tester.pumpAndSettle();

        final card = find.byType(GtCard);
        final palette = tester.element(card).palette;
        expect(tester.widget<GtCard>(card).color, palette.bg.weak);
      });
    }

    testWidgets('GtNotificationCard keeps a variant it is given', (
      tester,
    ) async {
      await tester.pumpWidget(
        _SkeletonTestApp(child: GtNotificationCard.skeleton(variant: .error)),
      );
      await tester.pumpAndSettle();

      final card = find.byType(GtCard);
      final palette = tester.element(card).palette;
      expect(tester.widget<GtCard>(card).color, isNot(palette.bg.weak));
    });

    testWidgets('GtPaymentSourceCard', (tester) async {
      await tester.pumpWidget(
        _SkeletonTestApp(child: GtPaymentSourceCard.skeleton()),
      );
      await tester.pumpAndSettle();

      expect(
        tester.widget<GtCard>(find.byType(GtCard)).variant,
        GtCardVariant.normal,
      );
    });
  });

  group('dashboard', () {
    const navItems = [
      GtBottomNavigationItem(
        selectedIcon: GtIcons.homeFilled,
        unselectedIcon: GtIcons.home,
        label: 'Home',
      ),
      GtBottomNavigationItem(
        selectedIcon: GtIcons.walletAltFilled,
        unselectedIcon: GtIcons.walletAlt,
        label: 'Payments',
      ),
    ];

    Widget dashboard({required bool isLoading, OnPressed? onHelp}) {
      return GtDashboardScaffold(
        onClickHelp: () {},
        data: [
          GtDashboardPageData(
            page: const GtText('Balance details'),
            appBar: GtHomeAppBar(
              userFullName: 'Ada Obi',
              onClickHelp: onHelp ?? () {},
              helpSemanticsLabel: 'Help',
            ),
            navItem: navItems[0],
            isLoading: isLoading,
            loadingSemanticsLabel: 'Loading your accounts',
          ),
          GtDashboardPageData(
            page: const GtText('Payments page'),
            navItem: navItems[1],
          ),
        ],
      );
    }

    testWidgets('a loading page bones only its body', (tester) async {
      final handle = tester.ensureSemantics();
      var helpTaps = 0;
      await tester.pumpWidget(
        _SkeletonTestApp(
          child: dashboard(isLoading: true, onHelp: () => helpTaps++),
        ),
      );
      await tester.pumpAndSettle();

      final labels = _semanticLabels(tester);
      expect(labels, contains('Loading your accounts'));
      expect(labels, contains('Help'));
      expect(labels.join(' '), contains('Payments'));
      expect(labels, isNot(contains('Balance details')));

      await tester.tap(find.bySemanticsLabel('Help'));
      expect(helpTaps, 1);

      await tester.tap(find.bySemanticsLabel(RegExp('Payments')).first);
      await tester.pumpAndSettle();
      expect(find.text('Payments page'), findsOneWidget);
      expect(find.byType(GtSkeleton), findsNothing);
      handle.dispose();
    });

    testWidgets('a loaded page draws no skeleton', (tester) async {
      await tester.pumpWidget(
        _SkeletonTestApp(child: dashboard(isLoading: false)),
      );
      await tester.pumpAndSettle();

      expect(find.byType(GtSkeleton), findsNothing);
      expect(find.byType(GtBone), findsNothing);
    });

    testWidgets('account slides with no accounts draw a placeholder', (
      tester,
    ) async {
      final controller = GtAccountDataController<int>(accounts: const []);
      addTearDown(controller.dispose);
      Widget slides({required bool enabled}) => _SkeletonTestApp(
        child: GtSkeleton(
          enabled: enabled,
          child: GtAccountDetailSlides<int>(
            controller: controller,
            hidden: false,
            onToggleHide: () {},
          ),
        ),
      );

      await tester.pumpWidget(slides(enabled: false));
      await tester.pumpAndSettle();
      expect(find.byType(GtBalanceText), findsNothing);
      expect(find.byType(GtAccountCopyPill), findsNothing);

      await tester.pumpWidget(slides(enabled: true));
      await tester.pumpAndSettle();
      expect(find.byType(GtBalanceText), findsOneWidget);
      expect(find.byType(GtAccountCopyPill), findsOneWidget);
      expect(find.byType(GtBone), findsWidgets);
    });

    testWidgets('a loading home app bar bones only its avatar', (tester) async {
      var helpTaps = 0;
      await tester.pumpWidget(
        _SkeletonTestApp(
          child: GtHomeAppBar(
            isLoading: true,
            onClickHelp: () => helpTaps++,
            helpSemanticsLabel: 'Help',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.ancestor(
          of: find.byType(GtAvatar),
          matching: find.byType(GtSkeleton),
        ),
        findsOneWidget,
      );
      expect(
        find.ancestor(
          of: find.byType(GtIconButton),
          matching: find.byType(GtSkeleton),
        ),
        findsNothing,
      );

      await tester.tap(find.byType(GtIconButton));
      expect(helpTaps, 1);
    });
  });
}
