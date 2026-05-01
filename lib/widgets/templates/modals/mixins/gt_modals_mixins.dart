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
