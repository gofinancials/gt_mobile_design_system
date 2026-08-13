import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';

/// Callback signature invoked when user inactivity reaches [maxInactivityDuration].
///
/// Passes the last recorded [RouteSettings] at the moment inactivity was detected.
typedef GtInactivityCallback = OnChanged<RouteSettings?>;

/// Manages application-wide user activity tracking and inactivity timeout detection.
///
/// Designed for security-sensitive applications (such as banking apps) that require
/// automatic session termination after a period of user inactivity.
///
/// ### Features:
/// - Uses [AppDebouncer] to efficiently schedule and debounce inactivity timers.
/// - Leverages duration extension getters (e.g., `5.minutes`, `500.milliseconds`).
/// - Throttled activity registration (`registerActivity`) for minimal overhead.
/// - Lifecycle-aware: pauses debouncer when app enters background and evaluates elapsed
///   inactivity duration immediately on app resume before rendering sensitive content.
/// - Route-aware: tracks active [RouteSettings] to pass location details back to the
///   host app when triggering [onInactivityDetected].
///
/// ### Typical Usage:
/// ```dart
/// final activityState = locator<GtActivityState>();
///
/// // Start tracking post-authentication:
/// activityState.startTracking(
///   duration: 5.minutes,
///   onInactivity: (lastRouteSettings) {
///     // Navigate to lock/login screen preserving route settings
///     GtRouter.navigateAndRemoveUntil(
///       '/login',
///       arguments: {'redirectRoute': lastRouteSettings},
///     );
///   },
/// );
///
/// // Stop tracking on user logout:
/// activityState.stopTracking();
/// ```
class GtActivityState extends StateModel with WidgetsBindingObserver {
  Duration _maxInactivityDuration;
  final Duration _throttleDuration;

  DateTime? _lastActivityTime;
  bool _isTrackingActive = false;
  RouteSettings? _currentRouteSettings;
  GtInactivityCallback? _onInactivityDetected;
  AppDebouncer? _debouncer;

  /// Creates a [GtActivityState] instance.
  ///
  /// [defaultDuration] defaults to `5.minutes` if unspecified.
  /// [throttleDuration] throttles touch/event registration to prevent excess CPU work (defaults to `500.milliseconds`).
  GtActivityState({Duration? defaultDuration, Duration? throttleDuration})
    : _maxInactivityDuration = defaultDuration ?? 3.minutes,
      _throttleDuration = throttleDuration ?? 500.milliseconds;

  /// Maximum allowed duration of inactivity before triggering auto-logout.
  Duration get maxInactivityDuration => _maxInactivityDuration;

  /// Minimum interval between processed activity timestamps.
  Duration get throttleDuration => _throttleDuration;

  /// Timestamp of the last registered user activity.
  DateTime? get lastActivityTime => _lastActivityTime;

  /// Whether activity tracking is currently active.
  bool get isTrackingActive => _isTrackingActive;

  /// Most recently recorded native [RouteSettings].
  RouteSettings? get currentRouteSettings => _currentRouteSettings;

  /// Remaining duration before inactivity timeout occurs, or [Duration.zero] if inactive.
  Duration get remainingInactivityDuration {
    if (!_isTrackingActive || _lastActivityTime == null) {
      return Duration.zero;
    }
    final elapsed = DateTime.now().difference(_lastActivityTime!);
    final remaining = _maxInactivityDuration - elapsed;
    return remaining.isNegative ? Duration.zero : remaining;
  }

  /// Starts activity tracking session.
  ///
  /// Must be called when the user successfully authenticates.
  /// - [onInactivity]: Callback triggered when inactivity timeout is reached.
  /// - [duration]: Optional override for [maxInactivityDuration].
  /// - [initialRouteSettings]: Optional initial route settings.
  void startTracking({
    required GtInactivityCallback onInactivity,
    Duration? duration,
    RouteSettings? initialRouteSettings,
  }) {
    _onInactivityDetected = onInactivity;
    if (duration != null) {
      _maxInactivityDuration = duration;
    }
    if (initialRouteSettings != null) {
      _currentRouteSettings = initialRouteSettings;
    }

    _isTrackingActive = true;
    _lastActivityTime = DateTime.now();

    WidgetsBinding.instance.addObserver(this);
    _scheduleInactivityCheck();
    notifyListeners();
  }


  /// Stops tracking activity and resets state.
  ///
  /// Call this when user logs out or session ends.
  void stopTracking() {
    _cancelInactivityCheck();
    WidgetsBinding.instance.removeObserver(this);

    _isTrackingActive = false;
    _lastActivityTime = null;
    notifyListeners();
  }

  /// Registers user activity.
  ///
  /// Updates [_lastActivityTime] if the elapsed time since last activity
  /// exceeds [_throttleDuration] or if [force] is true.
  /// Optionally updates [_currentRouteSettings] if provided.
  void registerActivity({RouteSettings? routeSettings, bool force = false}) {
    if (!_isTrackingActive) return;

    if (routeSettings != null) _currentRouteSettings = routeSettings;

    final now = DateTime.now();
    if (!force && _lastActivityTime != null) {
      final elapsed = now.difference(_lastActivityTime!);
      if (elapsed < _throttleDuration) return;
    }

    _lastActivityTime = now;
    _scheduleInactivityCheck();
  }

  /// Manually updates current route settings without necessarily triggering a timer reset.
  void updateRouteSettings(RouteSettings? settings) {
    if (settings == null) return;
    _currentRouteSettings = settings;
    registerActivity(routeSettings: settings);
  }

  /// Resets the activity timestamp to [DateTime.now()].
  void resetActivityTimer() {
    registerActivity(force: true);
  }

  void _scheduleInactivityCheck([Duration? delay]) {
    _cancelInactivityCheck();
    final duration = delay ?? _maxInactivityDuration;
    _debouncer = AppDebouncer(duration);
    _debouncer?.run(_handleInactivityTimeout);
  }

  void _cancelInactivityCheck() {
    _debouncer?.abort();
    _debouncer = null;
  }

  void _handleInactivityTimeout() {
    final routeSettings = _currentRouteSettings;
    stopTracking();
    _onInactivityDetected?.call(routeSettings);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_isTrackingActive) return;

    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        _cancelInactivityCheck();
        break;
      case AppLifecycleState.resumed:
        if (_lastActivityTime != null) {
          final elapsed = DateTime.now().difference(_lastActivityTime!);
          if (elapsed >= _maxInactivityDuration) {
            _handleInactivityTimeout();
            return;
          }
          final remaining = _maxInactivityDuration - elapsed;
          _scheduleInactivityCheck(remaining);
        } else {
          _scheduleInactivityCheck();
        }
        break;
    }
  }

  @override
  void dispose() {
    stopTracking();
    super.dispose();
  }
}
