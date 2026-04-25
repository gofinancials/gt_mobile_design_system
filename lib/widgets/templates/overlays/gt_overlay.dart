import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';

/// An abstract base class for creating and managing overlay components (like toasts or alerts).
///
/// Provides lifecycle management capabilities, such as keeping track of active
/// overlays and allowing them to be dismissed either manually or automatically on navigation.
abstract class GtOverlay with AppTaskMixin, RouteAware {
  /// The [BuildContext] associated with this overlay.
  final BuildContext context;

  /// Whether this overlay should be automatically closed when navigating between routes.
  final bool closableOnNavigation;

  /// Creates a [GtOverlay] with the given [context].
  ///
  /// By default, [closableOnNavigation] is set to `true`.
  GtOverlay(this.context, {this.closableOnNavigation = true});

  static final List<GtOverlay> _curentOverlays = [];

  /// Closes all currently active overlays that are marked as [closableOnNavigation].
  static void closeCurrentOverlays() {
    try {
      for (int index = 0; index < _curentOverlays.length; index++) {
        final overlay = _curentOverlays[index];
        if (!overlay.closableOnNavigation) continue;
        overlay.close();
        _curentOverlays.removeAt(index);
      }
    } catch (_) {}
  }

  /// Convenience method to close all currently active overlays.
  void closeExistingOverlays() => closeCurrentOverlays();

  /// Closes this specific overlay instance. Must be implemented by subclasses.
  void close();

  @override
  void didPop() {
    close();
    super.didPop();
  }

  @override
  void didPushNext() {
    close();
    super.didPushNext();
  }

  @override
  void didPopNext() {
    close();
    super.didPopNext();
  }

  /// Inserts the given [entry] into the navigator's overlay and registers
  /// the provided [instance] in the internal list of active overlays.
  void present({required OverlayEntry entry, required GtOverlay instance}) {
    tryRunThrowableTask(() {
      Navigator.of(context).overlay?.insert(entry);
      _curentOverlays.tryAdd(instance);
    });
  }
}
