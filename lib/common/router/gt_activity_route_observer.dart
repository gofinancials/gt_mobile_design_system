import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A [NavigatorObserver] that monitors navigation transitions and registers user
/// activity with [GtActivityState].
///
/// Automatically captures route transitions (`didPush`, `didPop`, `didReplace`, `didRemove`)
/// and updates the current active [RouteSettings] on [GtActivityState].
///
/// ### Example:
/// ```dart
/// MaterialApp(
///   navigatorObservers: [
///     GtActivityRouteObserver(activityState),
///   ],
/// );
/// ```
class GtActivityRouteObserver extends NavigatorObserver {
  final GtActivityState? _activityState;

  /// Creates a [GtActivityRouteObserver].
  ///
  /// [activityState] is the target state model to register route transitions with.
  GtActivityRouteObserver([this._activityState]);

  GtActivityState? get _targetState => _activityState;

  void _onRouteActivity(Route<dynamic>? route) {
    if (route == null) return;
    final settings = route.settings;
    if (settings.name != null) {
      GtRouter.setCurrentRoute(settings.name!);
    }
    _targetState?.registerActivity(routeSettings: settings);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _onRouteActivity(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _onRouteActivity(previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _onRouteActivity(newRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _onRouteActivity(previousRoute);
  }
}
