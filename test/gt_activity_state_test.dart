import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:provider/provider.dart';

import 'helpers/test_app_config.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // GtBaseWidget resolves AppConfig from the service locator during build.
  setUpAll(registerTestAppConfig);

  group('GtActivityState Unit Tests', () {
    late GtActivityState activityState;

    setUp(() {
      activityState = GtActivityState(
        defaultDuration: 200.milliseconds,
        throttleDuration: 50.milliseconds,
      );
    });

    tearDown(() {
      activityState.dispose();
    });

    test('Initial state is disabled until startTracking is called', () {
      expect(activityState.isTrackingActive, isFalse);
      expect(activityState.lastActivityTime, isNull);
      expect(activityState.currentRouteSettings, isNull);
    });

    test('startTracking enables tracking and sets initial activity time', () {
      activityState.startTracking(
        onInactivity: (_) {},
        initialRouteSettings: const RouteSettings(name: '/dashboard'),
      );

      expect(activityState.isTrackingActive, isTrue);
      expect(activityState.lastActivityTime, isNotNull);
      expect(activityState.currentRouteSettings?.name, equals('/dashboard'));
    });

    test('stopTracking disables tracking and clears activity timestamp', () {
      activityState.startTracking(onInactivity: (_) {});
      expect(activityState.isTrackingActive, isTrue);

      activityState.stopTracking();
      expect(activityState.isTrackingActive, isFalse);
      expect(activityState.lastActivityTime, isNull);
    });

    test(
      'registerActivity throttles frequent activity registrations',
      () async {
        activityState.startTracking(onInactivity: (_) {});
        final firstTime = activityState.lastActivityTime;

        // Immediate second call should be throttled
        activityState.registerActivity();
        expect(activityState.lastActivityTime, equals(firstTime));

        // Wait longer than throttle duration
        await Future.delayed(70.milliseconds);
        activityState.registerActivity();
        expect(activityState.lastActivityTime!.isAfter(firstTime!), isTrue);
      },
    );

    test('registerActivity with force=true bypasses throttling', () {
      activityState.startTracking(onInactivity: (_) {});
      final firstTime = activityState.lastActivityTime;

      activityState.registerActivity(force: true);
      expect(activityState.lastActivityTime, isNot(equals(firstTime)));
    });

    test(
      'Inactivity timeout triggers onInactivityDetected callback with RouteSettings',
      () async {
        RouteSettings? capturedSettings;
        bool callbackFired = false;

        activityState.startTracking(
          duration: 150.milliseconds,
          initialRouteSettings: const RouteSettings(
            name: '/transfer',
            arguments: {'amount': 5000},
          ),
          onInactivity: (settings) {
            callbackFired = true;
            capturedSettings = settings;
          },
        );

        // Wait for debouncer to trigger inactivity
        await Future.delayed(300.milliseconds);

        expect(callbackFired, isTrue);
        expect(capturedSettings?.name, equals('/transfer'));
        expect(activityState.isTrackingActive, isFalse);
      },
    );

    test(
      'AppLifecycleState.paused stops debouncer and resumed evaluates elapsed time',
      () async {
        RouteSettings? capturedSettings;
        bool callbackFired = false;

        activityState.startTracking(
          duration: 100.milliseconds,
          initialRouteSettings: const RouteSettings(name: '/accounts'),
          onInactivity: (settings) {
            callbackFired = true;
            capturedSettings = settings;
          },
        );

        // Simulate app paused (going to background)
        activityState.didChangeAppLifecycleState(AppLifecycleState.paused);

        // Wait for duration that exceeds timeout while backgrounded
        await Future.delayed(200.milliseconds);
        expect(callbackFired, isFalse); // Debouncer was paused

        // Simulate app resumed (returning to foreground)
        activityState.didChangeAppLifecycleState(AppLifecycleState.resumed);

        expect(callbackFired, isTrue);
        expect(capturedSettings?.name, equals('/accounts'));
      },
    );
  });

  group('GtActivityRouteObserver Tests', () {
    late GtActivityState activityState;
    late GtActivityRouteObserver routeObserver;

    setUp(() {
      activityState = GtActivityState();
      routeObserver = GtActivityRouteObserver(activityState);
      activityState.startTracking(onInactivity: (_) {});
    });

    tearDown(() {
      activityState.dispose();
    });

    testWidgets('didPush registers route settings with GtActivityState', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          navigatorObservers: [routeObserver],
          initialRoute: '/home',
          routes: {
            '/home': (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).pushNamed('/details', arguments: {'id': 123});
                },
                child: const Text('Go to Details'),
              ),
            ),
            '/details': (context) => const Scaffold(body: Text('Details')),
          },
        ),
      );

      expect(activityState.currentRouteSettings?.name, equals('/home'));

      await tester.tap(find.text('Go to Details'));
      await tester.pumpAndSettle();

      expect(activityState.currentRouteSettings?.name, equals('/details'));
      expect(
        (activityState.currentRouteSettings?.arguments as Map)['id'],
        equals(123),
      );

      activityState.stopTracking();
      await tester.pumpWidget(const SizedBox());
    });
  });

  group('GtBaseWidget Activity Interaction Tests', () {
    late GtActivityState activityState;

    setUp(() {
      activityState = GtActivityState(throttleDuration: 10.milliseconds);
      activityState.startTracking(onInactivity: (_) {});
    });

    tearDown(() {
      activityState.dispose();
    });

    testWidgets('Pointer touches inside GtBaseWidget register user activity', (
      tester,
    ) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<GtActivityState>.value(
          value: activityState,
          child: const MaterialApp(
            home: GtBaseWidget(
              child: Scaffold(body: Center(child: Text('Interactive Content'))),
            ),
          ),
        ),
      );

      final initialTime = activityState.lastActivityTime;

      // GtActivityState throttles on the real wall clock via DateTime.now(),
      // but testWidgets runs inside a fake-async zone where Future.delayed
      // never completes and the clock does not advance. runAsync escapes that
      // zone so real time passes and the throttle window actually elapses.
      await tester.runAsync(() => Future.delayed(20.milliseconds));

      await tester.tap(find.text('Interactive Content'));
      await tester.pump();

      expect(activityState.lastActivityTime!.isAfter(initialTime!), isTrue);

      activityState.stopTracking();
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('Scroll events inside GtBaseWidget register user activity', (
      tester,
    ) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<GtActivityState>.value(
          value: activityState,
          child: MaterialApp(
            home: GtBaseWidget(
              child: Scaffold(
                body: ListView.builder(
                  itemCount: 50,
                  itemBuilder: (context, index) =>
                      ListTile(title: Text('Item $index')),
                ),
              ),
            ),
          ),
        ),
      );

      final initialTime = activityState.lastActivityTime;

      // See the note in the pointer test: real time must elapse for the
      // DateTime.now()-based throttle to admit the next activity registration.
      await tester.runAsync(() => Future.delayed(20.milliseconds));

      await tester.drag(find.text('Item 0'), const Offset(0, -300));
      await tester.pump();

      expect(activityState.lastActivityTime!.isAfter(initialTime!), isTrue);

      activityState.stopTracking();
      await tester.pumpWidget(const SizedBox());
    });
  });
}
