import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/common/router/gt_route_observer.dart';

/// A centralized utility class for managing application routing and navigation.
///
/// It provides convenience methods for common navigation actions, and reads the
/// user's navigation history from [observer] — install that on the app's root
/// navigator for [currentRoute], [hasPreviousRoute] and [canPop] to work:
///
/// ```dart
/// MaterialApp(
///   navigatorObservers: [GtRouter.observer],
/// );
/// ```
class GtRouter {
  GtRouter._();

  /// Observes the app's root navigator and owns the route history that
  /// [currentRoute] and [hasPreviousRoute] read from.
  ///
  /// Because the observer is attached and detached by the navigator itself, the
  /// history follows the tree's lifecycle: a remounted app root starts from an
  /// empty history rather than inheriting the previous tree's.
  static final GtRouteObserver observer = GtRouteObserver();

  /// A global key used to access the root [NavigatorState] without a [BuildContext].
  @Deprecated(
    'Install GtRouter.observer via MaterialApp.navigatorObservers instead. '
    'A static GlobalKey reattaches the same NavigatorState when an app root is '
    'remounted, so the new tree inherits the previous tree\'s route stack. '
    'This key is only consulted when no observer is installed and will be '
    'removed in a future release.',
  )
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  /// Detaches the router from the tree that owned it: a fresh navigator key and
  /// an empty route stack.
  @Deprecated(
    'Unnecessary once GtRouter.observer is installed — the observer detaches '
    'itself with the tree, so there is nothing to reset. Will be removed '
    'alongside navigatorKey.',
  )
  static void reset() {
    navigatorKey = GlobalKey<NavigatorState>();
    _legacyRouteStack.clear();
  }

  /// Returns the name of the route at the top of the navigator, if any.
  static String? get currentRoute =>
      observer.navigator == null ? _legacyRouteStack.tryLast : observer.currentRoute;

  /// Whether there is a route beneath the current one.
  static bool get hasPreviousRoute => observer.navigator == null
      ? _legacyRouteStack.length >= 2
      : observer.hasPreviousRoute;

  static final List<String> _legacyRouteStack = [];

  /// Adds the given [route] name to the internal route stack.
  @Deprecated(
    'The route history is derived from GtRouter.observer; recording routes by '
    'hand lets it drift from the navigator. This is a no-op once the observer '
    'is installed.',
  )
  static void setCurrentRoute(String route) {
    if (observer.navigator != null) return;
    _legacyRouteStack.add(route);
  }

  /// Records that a modal has been opened on top of the current route.
  ///
  /// Optionally takes a [title] to provide more context in the route stack logging.
  @Deprecated(
    'GtRouter.observer records modal routes as they are pushed. This is a '
    'no-op once the observer is installed.',
  )
  static void openedModal([String? title]) {
    AppLogger.info("OPENING A MODAL IN: $currentRoute");
    if (observer.navigator != null) return;
    _legacyRouteStack.add(
      "${title.hasValue ? "$title->" : ''}$currentRoute?withmodal=true",
    );
  }

  /// Removes the last recorded route or modal entry from the internal route stack.
  @Deprecated(
    'GtRouter.observer records pops as they happen. This is a no-op once the '
    'observer is installed.',
  )
  static void removeLastRoute() {
    if (observer.navigator != null) return;
    if (_legacyRouteStack.isEmpty) return;
    _legacyRouteStack.removeLast();
  }

  /// Helper to get the [NavigatorState] either from the given [context] or the
  /// installed [observer], falling back to the deprecated [navigatorKey].
  static NavigatorState? _navigator(BuildContext? context) {
    if (context != null) return Navigator.of(context);
    // ignore: deprecated_member_use_from_same_package
    return observer.navigator ?? navigatorKey.currentState;
  }

  /// Returns whether there is a valid route to pop to.
  ///
  /// If a [context] is provided, it checks `Navigator.of(context).canPop()`.
  /// Otherwise, it checks using the global [navigatorKey].
  static bool canPop([BuildContext? context]) {
    if (!hasPreviousRoute) return false;
    return _navigator(context)?.canPop() ?? false;
  }

  /// Exits the application gracefully using [SystemNavigator.pop].
  static void closeApp() {
    SystemNavigator.pop(animated: true);
  }

  /// Pops all routes until the first (root) route in the navigator is reached.
  static void popToFirst({BuildContext? context}) {
    _navigator(context)?.popUntil((route) => route.isFirst);
  }

  /// Pops routes until a route with the specified [routeName] is reached.
  static void popUntil(String routeName, {BuildContext? context}) {
    _navigator(context)?.popUntil(ModalRoute.withName(routeName));
  }

  /// Safely pops the current route if possible.
  ///
  /// An optional [result] can be returned to the previous route.
  static void popView({BuildContext? context, Object? result}) {
    _navigator(context)?.maybePop(result);
  }

  /// Forcibly pops the current route without checking if it's safe to do so.
  ///
  /// An optional [result] can be returned to the previous route.
  static void forcePopView({BuildContext? context, Object? result}) {
    _navigator(context)?.pop(result);
  }

  /// Replaces the current route with a new route named [routeName].
  ///
  /// An optional [arguments] object can be passed to the new route.
  static void pushReplacementNamed(
    String routeName, {
    BuildContext? context,
    Object? arguments,
  }) {
    _navigator(context)?.pushReplacementNamed(routeName, arguments: arguments);
  }

  /// Pushes a new route named [routeName] onto the navigator.
  ///
  /// Returns a [Future] that completes to the `result` value passed to `pop`
  /// when the pushed route is popped off the navigator.
  static Future<dynamic> pushNamed(
    String routeName, {
    BuildContext? context,
    Object? arguments,
  }) async {
    return _navigator(context)?.pushNamed(routeName, arguments: arguments);
  }

  /// Pops the current route and pushes a new route named [routeName].
  static void popAndPushNamed(
    String routeName, {
    BuildContext? context,
    Object? arguments,
  }) {
    _navigator(context)?.popAndPushNamed(routeName, arguments: arguments);
  }

  /// Pushes the route named [routeName] and removes all previous routes until
  /// the route named [removeUntilRoute] is reached.
  ///
  /// If [removeUntilRoute] is not provided, it removes routes until it finds
  /// a route with the same name as [routeName].
  static void navigateAndRemoveUntil(
    String routeName, {
    Object? arguments,
    String? removeUntilRoute,
    BuildContext? context,
  }) {
    _navigator(context)?.pushNamedAndRemoveUntil(
      routeName,
      ModalRoute.withName(removeUntilRoute ?? routeName),
      arguments: arguments,
    );
  }
}
