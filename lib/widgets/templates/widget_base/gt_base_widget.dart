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
    config.windowSize = mediaQuery.size;

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
        key: ValueKey(config.windowSize),
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
            child: child ?? const Offstage(),
          ),
        ),
      ),
    );
  }
}
