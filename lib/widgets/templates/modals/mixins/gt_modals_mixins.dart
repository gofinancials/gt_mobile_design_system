import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A mixin that provides convenience methods for displaying bottom modals.
mixin GtBottomModalMixin {
  /// Displays a simple bottom modal with a [title], an optional [description], and an optional [icon].
  ///
  /// The modal adapts its alignment based on the platform (bottom center on mobile, center elsewhere).
  void showBottomModal(
    BuildContext context, {
    required String title,
    String? description,
    AppImageData? icon,
  }) {
    _showModal(
      context,
      modal: GtBottomModal(
        key: ValueKey((title, "gt-bottom-modal", description.hashCode)),
        data: GtBottomModalData(
          title: title,
          description: description,
          icon: icon,
        ),
        alignment: context.isMobile ? .bottomCenter : .center,
      ),
    );
  }

  /// Displays a bottom modal that is driven by a [GtBottomModalController].
  ///
  /// This is typically used for modals that reflect the progress or state of an asynchronous task.
  void showTaskBottomModal(
    BuildContext context, {
    required GtBottomModalController controller,
  }) {
    final title = controller.title;
    final description = controller.description;

    _showModal(
      context,
      modal: GtBottomModal.controller(
        key: ValueKey((
          title,
          "gt-controlled-bottom-modal",
          description.hashCode,
        )),
        controller: controller,
        alignment: context.isMobile ? .bottomCenter : .center,
      ),
    );
  }

  /// Internal helper method to display the [modal] widget.
  ///
  /// On non-mobile platforms, it uses [showAdaptiveDialog]. On mobile platforms,
  /// it uses [showModalBottomSheet].
  void _showModal(BuildContext context, {required Widget modal}) {
    GtOverlay.closeCurrentOverlays();
    GtRouter.openedModal();

    if (!context.isMobile) {
      showAdaptiveDialog(
        useRootNavigator: false,
        context: context,
        anchorPoint: Offset(context.width * .5, context.height * .5),
        barrierDismissible: false,
        builder: (context) => modal,
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: false,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) => modal,
    );
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
    bool useRootNavigator = false,
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
    bool useRootNavigator = false,
    double maxHeightFraction = .9,
  }) async {
    return GtBottomSheet<T>.draggable(
      context: context,
      builder: builder,
      minChildSize: minChildSize,
      initialChildSize: initialChildSize,
      maxChildSize: maxChildSize,
      useRootNavigator: useRootNavigator,
    ).present(context);
  }
}
