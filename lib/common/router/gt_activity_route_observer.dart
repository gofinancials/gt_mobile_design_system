import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A [NavigatorObserver] that monitors navigation transitions and registers user
/// activity with [GtActivityState].
///
/// Automatically captures route transitions (`didPush`, `didPop`, `didReplace`, `didRemove`)
/// and updates the current active [RouteSettings] on [GtActivityState].
///
/// This observer tracks activity only; the route history behind
/// [GtRouter.currentRoute] is owned by [GtRouter.observer], which needs its own
/// entry in the list.
///
/// ### Example:
/// ```dart
/// MaterialApp(
///   navigatorObservers: [
///     GtRouter.observer,
///     GtActivityRouteObserver(activityState),
///   ],
/// );
/// ```
class GtActivityRouteObserver extends NavigatorObserver {
  final GtActivityState _activityState;

  /// Creates a [GtActivityRouteObserver].
  ///
  /// [activityState] is the target state model to register route transitions with.
  GtActivityRouteObserver(this._activityState);

  GtActivityState? get _targetState => _activityState;

  void _onRouteActivity(Route<dynamic>? route) {
    bool hasName = route?.settings.name?.hasValue ?? false;
    if (!hasName) return;
    _targetState?.registerActivity(routeSettings: route?.settings);
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
