import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A mixin that provides convenience methods for displaying bottom modals.
///
/// Every method returns the [Future] of the route it pushed, which resolves
/// once that modal is gone. Task modals are taken down by their
/// [GtBottomModalController] rather than by the caller — see
/// [showTaskBottomModal].
mixin GtBottomModalMixin {
  /// Displays a simple bottom modal with a [title], an optional [description], and an optional [icon].
  ///
  /// The modal adapts its alignment based on the platform (bottom center on mobile, center elsewhere).
  /// Returns a [Future] that resolves to the value `T` passed when popping the modal.
  Future<T?> showBottomModal<T>(
    BuildContext context, {
    required String title,
    String? description,
    AppImageData? icon,
    bool useRootNavigator = true,
  }) {
    return _showModal<T>(
      context,
      modal: GtBottomModal(
        key: ValueKey((title, "gt-bottom-modal", description)),
        data: GtBottomModalData(
          title: title,
          description: description,
          icon: icon,
        ),
        alignment: context.isMobile ? .bottomCenter : .center,
      ),
      useRootNavigator: useRootNavigator,
    );
  }

  /// Displays a simple bottom modal with a [title], an optional [description], and an optional [icon].
  ///
  /// The modal adapts its alignment based on the platform (bottom center on mobile, center elsewhere).
  /// Returns a [Future] that resolves to the value `T` passed when popping the modal.
  Future<T?> showBottomModalWithChild<T>(
    BuildContext context, {
    required Widget child,
    bool useRootNavigator = true,
  }) {
    return _showModal<T>(
      context,
      modal: GtBottomModal.child(
        key: ValueKey(("gt-bottom-modal-child", child)),
        alignment: context.isMobile ? .bottomCenter : .center,
        child: child,
      ),
      useRootNavigator: useRootNavigator,
    );
  }

  /// Displays a bottom modal that is driven by a [GtBottomModalController].
  ///
  /// This is typically used for modals that reflect the progress or state of an asynchronous task.
  ///
  /// The pushed route is bound to [controller], which takes the modal down when
  /// its task completes and exposes [GtBottomModalController.dismiss] for
  /// closing it on demand. The returned [Future] resolves once the modal is
  /// gone; it carries no value, because a task modal is never popped with one —
  /// the task's result reaches the caller through the controller's completion
  /// callback.
  ///
  /// Calling this with a controller that is already presented returns the
  /// running presentation rather than stacking a second modal over the first.
  Future<void> showTaskBottomModal<T>(
    BuildContext context, {
    required GtBottomModalController<T> controller,
    bool useRootNavigator = true,
  }) {
    if (controller.isPresented) return controller.closed;

    final title = controller.title;
    final description = controller.description;

    final presentation = _showModal<void>(
      context,
      useRootNavigator: useRootNavigator,
      onRoute: controller.attachRoute,
      modal: GtBottomModal.controller(
        key: ValueKey((title, "gt-controlled-bottom-modal", description)),
        controller: controller,
        alignment: context.isMobile ? .bottomCenter : .center,
      ),
    );

    controller.attachPresentation(presentation);

    return presentation;
  }

  /// Internal helper method to display the [modal] widget.
  ///
  /// On non-mobile platforms, it uses [showAdaptiveDialog]. On mobile platforms,
  /// it uses [showModalBottomSheet].
  ///
  /// [onRoute] receives the route that was pushed, read from inside the
  /// modal's own builder. The `show*` helpers return only a [Future], and a
  /// caller that has to close *its* modal — rather than whatever is on top of
  /// the navigator — needs the [Route] itself. Reading it here is exact, where
  /// guessing at the top of a route observer's stack is not. Builders re-run,
  /// so [onRoute] may be called more than once with the same route.
  Future<T?> _showModal<T>(
    BuildContext context, {
    required Widget modal,
    bool useRootNavigator = true,
    OnChanged<Route<dynamic>>? onRoute,
  }) {
    GtOverlay.closeCurrentOverlays();

    if (!context.isMobile) {
      // On iOS and macOS [showAdaptiveDialog] pushes a `CupertinoDialogRoute`,
      // which does not capture the caller's inherited themes the way the
      // Material route does, so a [GtThemedScope] below the navigator would be
      // lost. Carrying them across by hand keeps the modal in the same brand
      // as the screen that opened it.
      final themes = context.capturedThemes(useRootNavigator: useRootNavigator);
      return showAdaptiveDialog<T>(
        useRootNavigator: useRootNavigator,
        context: context,
        anchorPoint: Offset(context.width * .5, context.height * .5),
        barrierDismissible: false,
        builder: (context) {
          _reportRoute<T>(context, onRoute);
          return themes.wrap(modal);
        },
      );
    }

    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: useRootNavigator,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) {
        _reportRoute<T>(context, onRoute);
        return modal;
      },
    );
  }

  /// Hands the modal's own route to [onRoute], if anything asked for it.
  void _reportRoute<T>(
    BuildContext context,
    OnChanged<Route<dynamic>>? onRoute,
  ) {
    if (onRoute == null) return;
    final route = ModalRoute.of<T>(context);
    if (route == null) return;
    onRoute(route);
  }
}

/// A mixin that provides convenience methods for displaying standard and draggable bottom sheets.
mixin GtBottomSheetMixin {
  /// Displays a standard bottom sheet containing the given [child] widget.
  ///
  /// The sheet's behavior can be customized with flags such as [isDismissable],
  /// [canDragToClose], and [isScrollable]. The [maxHeightFraction] determines
  /// the maximum height of the sheet relative to the screen size (defaults to 0.9).
  /// Returns a [Future] that resolves to the value `T` passed when popping the sheet.
  Future<T?> showSheet<T>(
    BuildContext context, {
    required Widget child,
    bool isDismissable = true,
    bool canDragToClose = true,
    bool isScrollable = false,
    bool canPop = true,
    bool floating = false,
    bool useRootNavigator = true,
    double maxHeightFraction = .9,
  }) async {
    return GtBottomSheet<T>(
      context: context,
      modalWidget: child,
      isDismissable: isDismissable,
      canDragToClose: canDragToClose,
      isScrollable: isScrollable,
      canPop: canPop,
      useRootNavigator: useRootNavigator,
      maxHeightFraction: maxHeightFraction,
      floating: floating,
    ).present(context);
  }

  /// Displays a bottom sheet that can be dragged up and down by the user.
  ///
  /// The [builder] provides a [ScrollController] that must be attached to a
  /// scrollable widget within the sheet to enable the drag behavior.
  /// The sheet's size is constrained by [minChildSize], [initialChildSize],
  /// and [maxChildSize], which represent fractions of the screen height.
  Future<T?> showDraggableSheet<T>(
    BuildContext context, {
    required ValueBuilder<ScrollController> builder,
    double minChildSize = .3,
    double initialChildSize = .7,
    double maxChildSize = .9,
    bool useRootNavigator = true,
    bool floating = false,
    double maxHeightFraction = .9,
  }) async {
    return GtBottomSheet<T>.draggable(
      context: context,
      builder: builder,
      minChildSize: minChildSize,
      initialChildSize: initialChildSize,
      maxChildSize: maxChildSize,
      floating: floating,
      useRootNavigator: useRootNavigator,
    ).present(context);
  }
}
