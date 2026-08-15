import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtBaseWidget extends GtStatelessWidget {
  final Widget? child;

  const GtBaseWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    final windowSize = mediaQuery.size;

    // Published as a side channel for host apps that read AppConfig.windowSize.
    // Guarded because the locator may have no AppConfig registered (widget
    // tests, embedded previews), and a missing optional config should not tear
    // down the entire widget tree.
    if (locator.isRegistered<AppConfig>()) config.windowSize = windowSize;

    mediaQuery = mediaQuery.copyWith(
      textScaler: mediaQuery.textScaler.clamp(
        minScaleFactor: 0.8,
        maxScaleFactor: 1.1,
      ),
    );

    final targetActivityState = context.activityState;

    return Material(
      type: MaterialType.transparency,
      child: MediaQuery(
        key: ValueKey(windowSize),
        data: mediaQuery,
        child: Listener(
          behavior: .translucent,
          onPointerDown: (_) => targetActivityState?.registerActivity(),
          onPointerSignal: (event) {
            if (event is! PointerScrollEvent) return;
            targetActivityState?.registerActivity();
          },
          child: GestureDetector(
            onTap: context.resetFocus,
            // Dismisses the keyboard on a background tap. Screen reader users
            // dismiss it their own way, and announcing the whole app as
            // tappable would be actively harmful.
            excludeFromSemantics: true,
            child: child ?? const Offstage(),
          ),
        ),
      ),
    );
  }
}
