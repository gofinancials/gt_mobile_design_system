import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

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
    // Walked backwards because closing an overlay removes it: counting forwards
    // over a shrinking list skips the entry that slides into the freed index,
    // leaving every other overlay open.
    for (int index = _curentOverlays.length - 1; index >= 0; index--) {
      final overlay = _curentOverlays[index];
      if (!overlay.closableOnNavigation) continue;
      try {
        overlay.close();
      } catch (_) {}
      _curentOverlays.removeAt(index);
    }
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

  /// Creates an overlay entry whose content keeps the styling of the subtree
  /// this overlay was created from.
  ///
  /// An [OverlayEntry] is built from the navigator's overlay, which sits above
  /// any [GtThemedScope] installed inside a route, so the entry would
  /// otherwise fall back to the app-wide brand. The themes between the two are
  /// captured and reinstalled around [builder], and the [Builder] puts the
  /// content's own styling reads beneath them rather than beside them.
  @protected
  OverlayEntry buildEntry(WidgetBuilder builder) {
    final themes = context.capturedThemes(useRootNavigator: false);
    return OverlayEntry(
      opaque: false,
      builder: (context) => themes.wrap(Builder(builder: builder)),
    );
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
