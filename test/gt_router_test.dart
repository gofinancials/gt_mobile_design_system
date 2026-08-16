import 'dart:async';

import 'package:flutter/cupertino.dart' show showCupertinoSheet;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/common/router/gt_route_observer.dart';
import 'package:gt_mobile_ui/common/router/gt_router.dart';

/// Mounts a root wired the way a consuming app is, using the shared observer.
Widget _app({String initialRoute = '/home'}) {
  return MaterialApp(
    navigatorObservers: [GtRouter.observer],
    initialRoute: initialRoute,
    routes: {
      '/home': (_) => const Scaffold(body: Text('home')),
      '/details': (_) => const Scaffold(body: Text('details')),
      '/summary': (_) => const Scaffold(body: Text('summary')),
    },
  );
}

/// Captures the navigation paths the observer reports through [AppAnalyticsMixin].
class _FakeAnalyticsService implements AppAnalyticsService {
  final List<String> navigations = [];

  @override
  Future<void> trackNavigation(String path, {String? widgetClass}) async {
    navigations.add(path);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('GtRouteObserver analytics', () {
    late _FakeAnalyticsService analytics;

    setUp(() {
      analytics = _FakeAnalyticsService();
      if (locator.isRegistered<AppAnalyticsService>()) {
        locator.unregister<AppAnalyticsService>();
      }
      locator.registerSingleton<AppAnalyticsService>(analytics);
    });

    tearDown(() => locator.unregister<AppAnalyticsService>());

    testWidgets('reports the initial route and each subsequent screen', (
      tester,
    ) async {
      await tester.pumpWidget(_app());
      expect(analytics.navigations, ['/home']);

      unawaited(GtRouter.pushNamed('/details'));
      await tester.pumpAndSettle();
      expect(analytics.navigations, ['/home', '/details']);

      // A pop reveals a screen without pushing one; it still counts as a view.
      GtRouter.forcePopView();
      await tester.pumpAndSettle();
      expect(analytics.navigations, ['/home', '/details', '/home']);
    });

    testWidgets('reports a modal as its own screen', (tester) async {
      await tester.pumpWidget(_app());

      showModalBottomSheet<void>(
        context: GtRouter.observer.navigator!.context,
        builder: (_) => const SizedBox(height: 100),
      );
      await tester.pumpAndSettle();

      expect(analytics.navigations, ['/home', '/home?withmodal=true']);
    });

    testWidgets('reports once for a multi-route pop', (tester) async {
      await tester.pumpWidget(_app());
      unawaited(GtRouter.pushNamed('/details'));
      await tester.pumpAndSettle();
      unawaited(GtRouter.pushNamed('/summary'));
      await tester.pumpAndSettle();
      analytics.navigations.clear();

      // popToFirst removes /summary and /details; only /home becomes visible,
      // so the intermediate removal must not be reported as a screen view.
      GtRouter.popToFirst();
      await tester.pumpAndSettle();

      expect(analytics.navigations, ['/home']);
    });

    testWidgets('reports the initial route again after a remount', (
      tester,
    ) async {
      await tester.pumpWidget(_app());
      expect(analytics.navigations, ['/home']);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpWidget(_app());

      expect(analytics.navigations, ['/home', '/home']);
    });
  });

  group('GtRouteObserver', () {
    testWidgets('derives the history from the navigator', (tester) async {
      await tester.pumpWidget(_app());

      expect(GtRouter.currentRoute, '/home');
      expect(GtRouter.hasPreviousRoute, isFalse);
      expect(GtRouter.canPop(), isFalse);

      unawaited(GtRouter.pushNamed('/details'));
      await tester.pumpAndSettle();

      expect(GtRouter.currentRoute, '/details');
      expect(GtRouter.hasPreviousRoute, isTrue);
      expect(GtRouter.canPop(), isTrue);

      GtRouter.forcePopView();
      await tester.pumpAndSettle();

      expect(GtRouter.currentRoute, '/home');
      expect(GtRouter.hasPreviousRoute, isFalse);
    });

    testWidgets('tracks routes pushed without going through GtRouter', (
      tester,
    ) async {
      await tester.pumpWidget(_app());
      final navigator = GtRouter.observer.navigator!;

      navigator.push(
        MaterialPageRoute(
          settings: const RouteSettings(name: '/adhoc'),
          builder: (_) => const Scaffold(body: Text('adhoc')),
        ),
      );
      await tester.pumpAndSettle();

      expect(GtRouter.currentRoute, '/adhoc');
      expect(GtRouter.hasPreviousRoute, isTrue);
    });

    testWidgets('reports a modal against the route it was opened over', (
      tester,
    ) async {
      await tester.pumpWidget(_app());

      showModalBottomSheet<void>(
        context: GtRouter.observer.navigator!.context,
        builder: (_) => const SizedBox(height: 100),
      );
      await tester.pumpAndSettle();

      expect(GtRouter.currentRoute, '/home?withmodal=true');
      expect(GtRouter.hasPreviousRoute, isTrue);

      GtRouter.forcePopView();
      await tester.pumpAndSettle();

      expect(GtRouter.currentRoute, '/home');
      expect(GtRouter.hasPreviousRoute, isFalse);
    });

    testWidgets('reports a cupertino sheet as a modal', (tester) async {
      // CupertinoSheetRoute is a PageRoute, not a PopupRoute, so it needs its
      // own case in the naming fallback.
      await tester.pumpWidget(_app());

      unawaited(
        showCupertinoSheet<void>(
          context: GtRouter.observer.navigator!.context,
          builder: (_) => const SizedBox(height: 100),
        ),
      );
      await tester.pumpAndSettle();

      expect(GtRouter.currentRoute, '/home?withmodal=true');
      expect(GtRouter.hasPreviousRoute, isTrue);
    });

    testWidgets('drops every route removed by a multi-route pop', (
      tester,
    ) async {
      await tester.pumpWidget(_app());

      unawaited(GtRouter.pushNamed('/details'));
      await tester.pumpAndSettle();
      unawaited(GtRouter.pushNamed('/summary'));
      await tester.pumpAndSettle();
      expect(GtRouter.observer.stack, hasLength(3));

      GtRouter.popToFirst();
      await tester.pumpAndSettle();

      expect(GtRouter.observer.stack, hasLength(1));
      expect(GtRouter.currentRoute, '/home');
      expect(GtRouter.hasPreviousRoute, isFalse);
    });

    testWidgets('follows a replacement in place', (tester) async {
      await tester.pumpWidget(_app());
      unawaited(GtRouter.pushNamed('/details'));
      await tester.pumpAndSettle();

      GtRouter.pushReplacementNamed('/summary');
      await tester.pumpAndSettle();

      expect(GtRouter.observer.stack, hasLength(2));
      expect(GtRouter.currentRoute, '/summary');
    });

    testWidgets('a remounted root does not inherit the previous history', (
      tester,
    ) async {
      await tester.pumpWidget(_app());
      unawaited(GtRouter.pushNamed('/details'));
      await tester.pumpAndSettle();

      showModalBottomSheet<void>(
        context: GtRouter.observer.navigator!.context,
        builder: (_) => const SizedBox(height: 100),
      );
      await tester.pumpAndSettle();

      final firstNavigator = GtRouter.observer.navigator;
      expect(GtRouter.observer.stack, hasLength(3));

      // Unmount and mount a fresh root, the way a per-journey E2E suite does.
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpWidget(_app());

      expect(GtRouter.observer.navigator, isNotNull);
      expect(GtRouter.observer.navigator, isNot(same(firstNavigator)));
      expect(GtRouter.observer.stack, hasLength(1));
      expect(GtRouter.currentRoute, '/home');
      expect(GtRouter.hasPreviousRoute, isFalse);
      expect(GtRouter.canPop(), isFalse);
    });

    testWidgets('detaches from the tree when the navigator goes away', (
      tester,
    ) async {
      await tester.pumpWidget(_app());
      expect(GtRouter.observer.navigator, isNotNull);

      await tester.pumpWidget(const SizedBox.shrink());

      expect(GtRouter.observer.navigator, isNull);
      expect(GtRouter.currentRoute, isNull);
      expect(GtRouter.hasPreviousRoute, isFalse);
    });

    test('a fresh observer starts empty', () {
      final observer = GtRouteObserver();

      expect(observer.navigator, isNull);
      expect(observer.stack, isEmpty);
      expect(observer.currentRoute, isNull);
      expect(observer.hasPreviousRoute, isFalse);
    });
  });
}
