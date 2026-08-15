import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtActivityState', type: GtActivityState)
Widget playgroundGtActivityStateUseCase(BuildContext context) {
  final timeoutSeconds = context.knobs.int
      .slider(
        label: 'Inactivity Timeout (seconds)',
        initialValue: 10,
        min: 5,
        max: 60,
      )
      .toInt();

  final throttleMs = context.knobs.int
      .slider(
        label: 'Activity Throttle (ms)',
        initialValue: 500,
        min: 0,
        max: 2000,
      )
      .toInt();

  return GtWidgetDocPage(
    title: 'GtActivityState',
    description:
        'Session inactivity tracking. GtBaseWidget listens for pointer and '
        'scroll events and calls registerActivity(), which is throttled and '
        'reschedules the inactivity timer. When the timer elapses, tracking '
        'stops and onInactivity fires with the last recorded RouteSettings. '
        'Interact with the panel below to keep the session alive, or leave it '
        'alone to watch it expire.',
    code:
        '''
// 1. Expose the state above GtBaseWidget.
ChangeNotifierProvider<GtActivityState>.value(
  value: activityState,
  child: const GtBaseWidget(child: MyApp()),
);

// 2. Start tracking once the user authenticates.
activityState.startTracking(
  duration: $timeoutSeconds.seconds,
  initialRouteSettings: const RouteSettings(name: '/dashboard'),
  onInactivity: (lastRouteSettings) {
    GtRouter.navigateAndRemoveUntil(
      '/login',
      arguments: {'redirectRoute': lastRouteSettings},
    );
  },
);

// 3. Stop tracking on logout.
activityState.stopTracking();''',
    child: _ActivityTrackingDemo(
      timeout: timeoutSeconds.seconds,
      throttle: throttleMs.milliseconds,
    ),
  );
}

class _ActivityTrackingDemo extends StatefulWidget {
  final Duration timeout;
  final Duration throttle;

  const _ActivityTrackingDemo({required this.timeout, required this.throttle});

  @override
  State<_ActivityTrackingDemo> createState() => _ActivityTrackingDemoState();
}

class _ActivityTrackingDemoState extends State<_ActivityTrackingDemo> {
  /// Drives the countdown readout. [GtActivityState.remainingInactivityDuration]
  /// is a plain getter rather than a listenable, so the demo samples it on a
  /// ticker and publishes it through a notifier.
  final remaining = ValueNotifier<Duration>(Duration.zero);

  /// The most recent lifecycle events, newest first.
  final events = ValueNotifier<List<String>>(const []);

  late GtActivityState activityState;
  Timer? ticker;

  @override
  void initState() {
    super.initState();
    activityState = _createState();
  }

  @override
  void didUpdateWidget(covariant _ActivityTrackingDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.timeout == oldWidget.timeout &&
        widget.throttle == oldWidget.throttle) {
      return;
    }
    // Knob changed: rebuild the state so the new durations take effect.
    _stop();

    // Disposed after the frame, not inline: the ListenableBuilder below is
    // still subscribed to the old instance until it rebuilds, and removing a
    // listener from a disposed ChangeNotifier throws.
    final previous = activityState;
    activityState = _createState();
    WidgetsBinding.instance.addPostFrameCallback((_) => previous.dispose());
  }

  @override
  void dispose() {
    ticker?.cancel();
    remaining.dispose();
    events.dispose();
    activityState.dispose();
    super.dispose();
  }

  GtActivityState _createState() {
    return GtActivityState(
      defaultDuration: widget.timeout,
      throttleDuration: widget.throttle,
    );
  }

  void _log(String message) {
    final stamp = DateTime.now().toIso8601String().substring(11, 19);
    events.value = ["$stamp  $message", ...events.value.take(5)];
  }

  void _start() {
    if (activityState.isTrackingActive) return;

    activityState.startTracking(
      duration: widget.timeout,
      initialRouteSettings: const RouteSettings(name: '/gallery/activity'),
      onInactivity: (settings) {
        _log("Session expired on ${settings?.name}");
        remaining.value = Duration.zero;
        ticker?.cancel();
        if (!mounted) return;
        GtToast.of(context).show("Session expired — tracking stopped");
      },
    );

    _log("Tracking started (${widget.timeout.inSeconds}s timeout)");
    ticker?.cancel();
    ticker = Timer.periodic(200.milliseconds, (_) {
      remaining.value = activityState.remainingInactivityDuration;
    });
  }

  void _stop() {
    if (!activityState.isTrackingActive) return;
    activityState.stopTracking();
    ticker?.cancel();
    remaining.value = Duration.zero;
    _log("Tracking stopped");
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GtActivityState>.value(
      value: activityState,
      // GtBaseWidget is what actually wires pointer and scroll events to
      // registerActivity(); it resolves the state via context.activityState.
      child: GtBaseWidget(
        child: ListenableBuilder(
          listenable: activityState,
          builder: (context, _) {
            final isTracking = activityState.isTrackingActive;

            return Column(
              crossAxisAlignment: .stretch,
              spacing: context.spacingLg,
              children: [
                _CountdownCard(
                  remaining: remaining,
                  isTracking: isTracking,
                  timeout: widget.timeout,
                ),
                Row(
                  spacing: context.spacingBase,
                  children: [
                    Expanded(
                      child: GtRaisedButton(
                        text: isTracking ? 'Tracking…' : 'Start Tracking',
                        size: .small,
                        isDisabled: isTracking,
                        onPressed: _start,
                      ),
                    ),
                    Expanded(
                      child: GtRaisedButton(
                        text: 'Stop',
                        size: .small,
                        variant: .neutral,
                        isDisabled: !isTracking,
                        onPressed: _stop,
                      ),
                    ),
                  ],
                ),
                _ActivitySurface(isTracking: isTracking),
                _EventLog(events: events),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Live countdown to session expiry.
class _CountdownCard extends GtStatelessWidget {
  final ValueListenable<Duration> remaining;
  final bool isTracking;
  final Duration timeout;

  const _CountdownCard({
    required this.remaining,
    required this.isTracking,
    required this.timeout,
  });

  @override
  Widget build(BuildContext context) {
    return GenericListener<Duration>(
      valueListenable: remaining,
      builder: (value) {
        final seconds = value.inMilliseconds / 1000;
        final progress = timeout.inMilliseconds == 0
            ? 0.0
            : (value.inMilliseconds / timeout.inMilliseconds).clamp(0.0, 1.0);

        final status = isTracking
            ? const GtReceiptStatusData(
                status: GtReceiptStatus.success,
                title: 'Tracking',
              )
            : const GtReceiptStatusData(
                status: GtReceiptStatus.failed,
                title: 'Idle',
              );

        return GtCard(
          padding: context.insets.allDp(16.px),
          child: Column(
            crossAxisAlignment: .stretch,
            spacing: context.spacingBase,
            children: [
              Row(
                children: [
                  GtReceiptStatusPill(status: status),
                  const Spacer(),
                  GtText(
                    isTracking ? "${seconds.toStringAsFixed(1)}s" : "—",
                    style: context.textStyles.h5(),
                  ),
                ],
              ),
              LinearProgressIndicator(
                value: progress,
                minHeight: context.dp(6.px),
                borderRadius: context.borderRadiusFull,
                backgroundColor: context.palette.bg.weak,
              ),
              GtText(
                isTracking
                    ? "Time left before the session expires."
                    : "Start tracking to arm the inactivity timer.",
                style: context.textStyles.body2Xs(
                  color: context.palette.text.sub,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// A tappable and scrollable surface. Every pointer down and scroll here is
/// picked up by the enclosing [GtBaseWidget] and resets the timer.
class _ActivitySurface extends GtStatelessWidget {
  final bool isTracking;

  const _ActivitySurface({required this.isTracking});

  @override
  Widget build(BuildContext context) {
    return GtCard(
      variant: .info,
      padding: context.insets.allDp(12.px),
      child: Column(
        crossAxisAlignment: .stretch,
        spacing: context.spacingBase,
        children: [
          GtText(
            isTracking
                ? "Tap or scroll here to reset the countdown"
                : "Interaction is ignored while tracking is off",
            style: context.textStyles.subHeadXs(),
          ),
          GtSizedBox(
            height: 96,
            child: ListView.builder(
              itemCount: 20,
              itemBuilder: (context, index) => Padding(
                padding: context.insets.symmetricDp(vertical: 4.px),
                child: GtText(
                  "Scrollable row $index",
                  style: context.textStyles.body2Xs(
                    color: context.palette.text.sub,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Rolling log of tracking lifecycle events.
class _EventLog extends GtStatelessWidget {
  final ValueListenable<List<String>> events;

  const _EventLog({required this.events});

  @override
  Widget build(BuildContext context) {
    return ListListener<String>(
      valueListenable: events,
      builder: (entries) {
        if (!entries.hasValue) return const Offstage();

        return GtCard(
          padding: context.insets.allDp(12.px),
          child: Column(
            crossAxisAlignment: .stretch,
            spacing: context.spacingSm,
            children: [
              const GtSectionHeader("Event log"),
              for (final entry in entries)
                GtText(
                  entry,
                  style: context.textStyles.body3Xs(
                    color: context.palette.text.sub,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
