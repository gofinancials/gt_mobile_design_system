import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class _KeypadTestApp extends GtStatelessWidget {
  final Widget child;

  const _KeypadTestApp({required this.child});

  @override
  Widget build(BuildContext context) {
    return GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(
        theme: kPersonalTheme.materialLight,
        home: Scaffold(body: child),
      ),
    );
  }
}

GtKeyPadGrid _grid({IconData? bioIcon, VoidCallback? onBioAuth}) {
  return GtKeyPadGrid(
    controller: TextEditingController(),
    limit: 4,
    onBioAuth: onBioAuth ?? () {},
    bioIcon: bioIcon,
  );
}

void main() {
  test('biometricFor picks Face ID on iOS and a fingerprint elsewhere', () {
    expect(GtIcons.biometricFor(TargetPlatform.iOS), GtIcons.faceId);
    for (final platform in TargetPlatform.values) {
      if (platform == TargetPlatform.iOS) continue;
      expect(GtIcons.biometricFor(platform), GtIcons.fingerprint);
    }
  });

  testWidgets('bio key draws Face ID on iOS', (tester) async {
    await tester.pumpWidget(_KeypadTestApp(child: _grid()));

    expect(find.byIcon(GtIcons.faceId), findsOneWidget);
    expect(find.byIcon(GtIcons.fingerprint), findsNothing);
  }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));

  testWidgets('bio key draws a fingerprint on Android', (tester) async {
    await tester.pumpWidget(_KeypadTestApp(child: _grid()));

    expect(find.byIcon(GtIcons.fingerprint), findsOneWidget);
    expect(find.byIcon(GtIcons.faceId), findsNothing);
  }, variant: TargetPlatformVariant.only(TargetPlatform.android));

  testWidgets('an explicit bioIcon overrides the platform default', (
    tester,
  ) async {
    await tester.pumpWidget(
      _KeypadTestApp(child: _grid(bioIcon: GtIcons.fingerprint)),
    );

    expect(find.byIcon(GtIcons.fingerprint), findsOneWidget);
    expect(find.byIcon(GtIcons.faceId), findsNothing);
  }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));

  testWidgets('bio key taps call onBioAuth', (tester) async {
    var calls = 0;
    await tester.pumpWidget(
      _KeypadTestApp(child: _grid(onBioAuth: () => calls++)),
    );

    await tester.tap(find.byIcon(GtIcons.fingerprint));
    expect(calls, 1);
  });

  testWidgets('GtVirtualKeypadForm passes bioIcon to its keypad', (
    tester,
  ) async {
    await tester.pumpWidget(
      _KeypadTestApp(
        child: GtVirtualKeypadForm(
          title: 'Enter PIN',
          subtitle: 'Confirm this transfer',
          maxLength: 4,
          controller: TextEditingController(),
          formKey: GlobalKey<FormState>(),
          onBioAuth: () {},
          bioIcon: GtIcons.faceId,
        ),
      ),
    );

    expect(
      tester.widget<GtKeyPadGrid>(find.byType(GtKeyPadGrid)).bioIcon,
      GtIcons.faceId,
    );
    expect(find.byIcon(GtIcons.faceId), findsOneWidget);
  });

  Future<void> pushLockForm(
    WidgetTester tester, {
    bool implyLeading = true,
  }) async {
    final navigatorKey = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      GtThemeProvider(
        theme: kPersonalTheme,
        child: MaterialApp(
          navigatorKey: navigatorKey,
          theme: kPersonalTheme.materialLight,
          home: const SizedBox.shrink(),
        ),
      ),
    );

    final form = GtVirtualKeypadForm.withAvatar(
      name: 'Ada',
      maxLength: 4,
      controller: TextEditingController(),
      formKey: GlobalKey<FormState>(),
      initials: 'A',
      implyLeading: implyLeading,
    );
    navigatorKey.currentState!.push(MaterialPageRoute(builder: (_) => form));
    await tester.pumpAndSettle();
  }

  testWidgets('GtVirtualKeypadForm implies a back button on a pushed route', (
    tester,
  ) async {
    await pushLockForm(tester);

    expect(find.byType(GtBackButton), findsOneWidget);
  });

  testWidgets('GtVirtualKeypadForm drops the back button when implyLeading '
      'is false', (tester) async {
    await pushLockForm(tester, implyLeading: false);

    expect(find.byType(GtBackButton), findsNothing);
  });
}
