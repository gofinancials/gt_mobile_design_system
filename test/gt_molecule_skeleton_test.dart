import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class _MoleculeSkeletonApp extends GtStatelessWidget {
  final Widget child;
  final ThemeMode themeMode;

  const _MoleculeSkeletonApp({required this.child, this.themeMode = .light});

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
            child: Scaffold(
              body: Padding(padding: const .all(16), child: child),
            ),
          ),
        ),
      ),
    );
  }
}

/// The outermost bone below [of], which is the one a skeleton actually paints.
RenderGtBone _outerBone(WidgetTester tester, Finder of) {
  final bones = find.descendant(of: of, matching: find.byType(GtBone));
  return tester.renderObject<RenderGtBone>(bones.first);
}

void main() {
  group('controls draw as a single bone', () {
    testWidgets('a raised button paints one block in its own shape', (
      tester,
    ) async {
      await tester.pumpWidget(
        _MoleculeSkeletonApp(
          child: GtSkeleton(
            child: GtRaisedButton(text: 'Continue', onPressed: () {}),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final bone = _outerBone(tester, find.byType(GtRaisedButton));
      expect(bone.shape, BoxShape.rectangle);
      expect(bone, paintsExactlyCountTimes(#drawRRect, 1));
    });

    testWidgets('a button outside any skeleton gains no bone', (tester) async {
      await tester.pumpWidget(
        _MoleculeSkeletonApp(
          child: GtRaisedButton(text: 'Continue', onPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(GtBone), findsNothing);
    });

    testWidgets('a round icon button bones as a circle', (tester) async {
      await tester.pumpWidget(
        _MoleculeSkeletonApp(
          child: GtSkeleton(
            child: GtIconButton(
              icon: GtIcons.user,
              shape: .round,
              onPressed: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final bone = _outerBone(tester, find.byType(GtIconButton));
      expect(bone.shape, BoxShape.circle);
      expect(bone, paintsExactlyCountTimes(#drawRRect, 1));
    });

    testWidgets('a pill and an avatar bone in their own shapes', (
      tester,
    ) async {
      await tester.pumpWidget(
        const _MoleculeSkeletonApp(
          child: GtSkeleton(
            child: Column(
              children: [
                GtStatusPill.custom(text: 'Pending'),
                GtAvatar(initials: 'AO'),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final pill = _outerBone(tester, find.byType(GtPill));
      expect(pill.shape, BoxShape.rectangle);
      expect(pill, paintsExactlyCountTimes(#drawRRect, 1));

      final avatar = _outerBone(tester, find.byType(GtAvatar));
      expect(avatar.shape, BoxShape.circle);
      expect(avatar, paintsExactlyCountTimes(#drawRRect, 1));
    });

    testWidgets('a text field bones its body', (tester) async {
      await tester.pumpWidget(
        const _MoleculeSkeletonApp(
          child: GtSkeleton(child: GtTextField(label: 'Account number')),
        ),
      );
      await tester.pumpAndSettle();

      final bone = _outerBone(tester, find.byType(GtTextField));
      expect(bone, paintsExactlyCountTimes(#drawRRect, 1));
    });
  });

  group('rich text bypassing GtText', () {
    testWidgets('a balance paints a bar over its line', (tester) async {
      await tester.pumpWidget(
        const _MoleculeSkeletonApp(
          child: GtSkeleton(child: GtBalanceText(amount: 25000)),
        ),
      );
      await tester.pumpAndSettle();

      final bone = _outerBone(tester, find.byType(GtBalanceText));
      RenderObject? child = bone.child;
      while (child is RenderProxyBox) {
        child = child.child;
      }
      expect(child, isA<RenderParagraph>());
      expect(bone, paintsExactlyCountTimes(#drawRRect, 1));
    });
  });

  group('tile skeleton builders', () {
    final builders = <String, Widget Function()>{
      'GtTransactionListTile': GtTransactionListTile.skeleton,
      'GtPaymentListTile': GtPaymentListTile.skeleton,
      'GtInfoListTile': GtInfoListTile.skeleton,
      'GtListTile': GtListTile.skeleton,
      'GtAccountListTile': GtAccountListTile.skeleton,
      'GtContactListTile': GtContactListTile.skeleton,
      'GtSelectionListTile': () =>
          const GtSelectionListTile<int>.skeleton(value: 0),
      'GtGoalProgressListTile': GtGoalProgressListTile.skeleton,
      'GtStandardTextTileTemplate': GtStandardTextTileTemplate.skeleton,
    };

    for (final entry in builders.entries) {
      for (final mode in [ThemeMode.light, ThemeMode.dark]) {
        testWidgets(
          '${entry.key}.skeleton builds in ${mode.name} mode and reads out '
          'nothing',
          (tester) async {
            final handle = tester.ensureSemantics();
            await tester.pumpWidget(
              _MoleculeSkeletonApp(themeMode: mode, child: entry.value()),
            );
            await tester.pumpAndSettle();

            expect(tester.takeException(), isNull);
            expect(find.byType(GtBone), findsWidgets);
            expect(find.bySemanticsLabel(RegExp('.+')), findsNothing);
            handle.dispose();
          },
        );
      }
    }

    testWidgets('rows in a skeleton list join the list sweep', (tester) async {
      await tester.pumpWidget(
        _MoleculeSkeletonApp(
          child: GtSkeletonList(
            itemCount: 3,
            itemBuilder: (_, _) => GtTransactionListTile.skeleton(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final scopes = tester
          .widgetList<GtSkeletonScope>(find.byType(GtSkeletonScope))
          .toList();
      expect(scopes, hasLength(4));
      for (final scope in scopes) {
        expect(scope.sweep, same(scopes.first.sweep));
      }
    });
  });

  group('composite controls draw a single block, not text bars', () {
    Future<RenderGtBone> pumpBoned(
      WidgetTester tester,
      Widget control,
      Type type,
    ) async {
      await tester.pumpWidget(
        _MoleculeSkeletonApp(
          child: Center(child: GtSkeleton(child: control)),
        ),
      );
      await tester.pumpAndSettle();
      return _outerBone(tester, find.byType(type));
    }

    testWidgets('GtAccountSwitchButton', (tester) async {
      final bone = await pumpBoned(
        tester,
        GtAccountSwitchButton(text: 'Business', onPressed: () {}),
        GtAccountSwitchButton,
      );
      expect(bone, paintsExactlyCountTimes(#drawRRect, 1));
    });

    testWidgets('GtActionButton disc', (tester) async {
      final bone = await pumpBoned(
        tester,
        GtActionButton(
          icon: GtIcons.user,
          backgroundColor: Colors.blue,
          onPressed: () {},
        ),
        GtActionButton,
      );
      expect(bone.shape, BoxShape.circle);
      expect(bone, paintsExactlyCountTimes(#drawRRect, 1));
    });

    testWidgets('GtPinInput', (tester) async {
      final bone = await pumpBoned(
        tester,
        const GtPinInput(autoFocus: false),
        GtPinInput,
      );
      expect(bone, paintsExactlyCountTimes(#drawRRect, 1));
    });

    testWidgets('GtSignaturePad', (tester) async {
      final bone = await pumpBoned(
        tester,
        GtSignaturePad(
          title: 'Sign here',
          subtitle: 'Use your finger',
          onSecondaryAction: () {},
          semanticsLabel: 'Signature pad',
          semanticsHint: 'Draw your signature',
          undoSemanticLabel: 'Undo',
          redoSemanticLabel: 'Redo',
          clearSemanticLabel: 'Clear',
        ),
        GtSignaturePad,
      );
      expect(bone, paintsExactlyCountTimes(#drawRRect, 1));
    });
  });
}
