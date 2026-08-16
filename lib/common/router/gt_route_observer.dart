import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:gt_mobile_foundation/foundation.dart';

/// A [NavigatorObserver] that derives the route history from the [Navigator]
/// it is installed on, and backs [GtRouter]'s history getters.
///
/// Unlike a [GlobalKey], an observer's attachment follows the tree: Flutter
/// installs it in the navigator's `initState` and detaches it in `deactivate`.
/// A remounted app root therefore gets a live navigator and a history rebuilt
/// from its own pushes, with nothing to reset by hand.
///
/// Because the history is *derived* rather than recorded by callers, it cannot
/// drift from the navigator: routes pushed without going through [GtRouter],
/// modal sheets, dialogs and multi-route pops are all accounted for.
///
/// Install it on the app's root navigator:
///
/// ```dart
/// MaterialApp(
///   navigatorObservers: [GtRouter.observer],
/// );
/// ```
///
/// Only one navigator may host a given observer instance at a time — Flutter
/// asserts this on install — so do not pass [GtRouter.observer] to a nested
/// [Navigator] as well.
class GtRouteObserver extends NavigatorObserver with AppAnalyticsMixin {
  /// Creates a route-history observer.
  ///
  /// Prefer the shared [GtRouter.observer] over constructing your own; a second
  /// instance tracks its own history that [GtRouter] does not read.
  GtRouteObserver();

  final List<Route<dynamic>> _stack = [];

  /// The navigator whose routes are currently in [_stack].
  ///
  /// Detaching does not pop anything, so the history has to be discarded
  /// explicitly when the observer changes hands — otherwise a long-lived
  /// instance carries the old tree's routes into the new one, which is the very
  /// staleness this observer exists to avoid.
  NavigatorState? _observed;

  /// The route path most recently reported to analytics.
  String? _trackedRoute;

  void _syncAttachment() {
    final current = navigator;
    if (identical(current, _observed)) return;
    _observed = current;
    _stack.clear();
    // A remounted tree navigates to its initial route again; that is a real
    // screen view and must not be suppressed as a duplicate.
    _trackedRoute = null;
  }

  /// Whether a report has been scheduled for the end of the current microtask.
  bool _trackScheduled = false;

  /// Reports the route now on top to analytics, if it changed.
  ///
  /// Called after every stack mutation rather than from [didPush] alone, so
  /// that pops, replacements and removals — which reveal a different screen
  /// without pushing anything — are tracked too.
  ///
  /// The report is deferred to a microtask so that a batch of synchronous
  /// changes reports once, for the screen the user actually lands on. Otherwise
  /// `popUntil` and `pushNamedAndRemoveUntil`, which report each removed route
  /// individually, would log a screen view for every route they unwind past.
  void _trackCurrentRoute() {
    if (_trackScheduled) return;
    _trackScheduled = true;
    scheduleMicrotask(() {
      _trackScheduled = false;
      final route = currentRoute;
      if (route == null || route == _trackedRoute) return;
      _trackedRoute = route;
      unawaited(trackNavigation(route));
    });
  }

  /// The routes currently on the observed navigator, oldest first.
  ///
  /// Empty while the observer is not installed on a navigator.
  List<Route<dynamic>> get stack {
    _syncAttachment();
    return List.unmodifiable(_stack);
  }

  /// The name of the route at the top of the observed navigator, if any.
  ///
  /// Routes pushed without a [RouteSettings.name] report `null`, except for
  /// [PopupRoute]s — sheets and dialogs — which are reported against the route
  /// they were opened over.
  String? get currentRoute {
    _syncAttachment();
    return _stack.isEmpty ? null : _nameAt(_stack.length - 1);
  }

  /// Whether there is a route beneath the current one on the observed navigator.
  bool get hasPreviousRoute {
    _syncAttachment();
    return _stack.length >= 2;
  }

  String? _nameAt(int index) {
    final route = _stack[index];
    final name = route.settings.name;
    if (name.hasValue) return name;
    // Sheets and dialogs are pushed without a name. Most are [PopupRoute]s, but
    // `showCupertinoSheet` pushes a [CupertinoSheetRoute], which is a
    // [PageRoute], so it has to be matched separately.
    if ((route is PopupRoute || route is CupertinoSheetRoute) && index > 0) {
      return "${_nameAt(index - 1)}?withmodal=true";
    }
    return null;
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _syncAttachment();
    _stack.add(route);
    _trackCurrentRoute();
  }

  // Pops and removals can target a route that is not on top — `popUntil` and
  // `pushNamedAndRemoveUntil` both report each removed route individually — so
  // entries are dropped by identity rather than from the end.
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _syncAttachment();
    _stack.remove(route);
    _trackCurrentRoute();
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _syncAttachment();
    _stack.remove(route);
    _trackCurrentRoute();
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _syncAttachment();
    final index = oldRoute == null ? -1 : _stack.indexOf(oldRoute);
    if (index < 0) {
      if (newRoute != null) _stack.add(newRoute);
    } else if (newRoute == null) {
      _stack.removeAt(index);
    } else {
      _stack[index] = newRoute;
    }
    _trackCurrentRoute();
  }
}
