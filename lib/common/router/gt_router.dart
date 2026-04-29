import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_foundation/foundation.dart';

/// A centralized utility class for managing application routing and navigation.
///
/// It provides convenience methods for common navigation actions and maintains
/// an internal stack of route names to track the user's navigation history.
class GtRouter {
  GtRouter._();

  static final List<String> _routeStack = [];

  /// A global key used to access the root [NavigatorState] without a [BuildContext].
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  /// Returns the name of the current route at the top of the internal stack, if any.
  static String? get currentRoute => _routeStack.tryLast;

  /// Whether there is a previous route in the internal navigation stack.
  static bool get hasPreviousRoute => _routeStack.length >= 2;

  /// Adds the given [route] name to the internal route stack.
  static void setCurrentRoute(String route) {
    _routeStack.add(route);
  }

  /// Records that a modal has been opened on top of the current route.
  ///
  /// Optionally takes a [title] to provide more context in the route stack logging.
  static void openedModal([String? title]) {
    AppLogger.info("OPENING A MODAL IN: $currentRoute");
    _routeStack.add(
      "${title.hasValue ? "$title->" : ''}$currentRoute?withmodal=true",
    );
  }

  /// Removes the last recorded route or modal entry from the internal route stack.
  static void removeLastRoute() {
    if (_routeStack.isEmpty) return;
    _routeStack.removeLast();
  }

  /// Helper to get the [NavigatorState] either from the given [context] or the [navigatorKey].
  static NavigatorState? _navigator(BuildContext? context) {
    return context == null ? navigatorKey.currentState : Navigator.of(context);
  }

  /// Returns whether there is a valid route to pop to.
  ///
  /// If a [context] is provided, it checks `Navigator.of(context).canPop()`.
  /// Otherwise, it checks using the global [navigatorKey].
  static bool canPop([BuildContext? context]) {
    if (!hasPreviousRoute) return false;
    if (context == null) {
      return navigatorKey.currentState?.canPop() ?? false;
    }
    return _navigator(context)?.canPop() ?? false;
  }

  /// Exits the application gracefully using [SystemNavigator.pop].
  static void closeGt() {
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
