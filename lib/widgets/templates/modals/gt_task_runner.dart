import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Runs an asynchronous task behind a blocking task modal.
///
/// Controller construction, presentation, the completion delay, dismissal and
/// the typed success/failure branch are a fixed sequence, and writing it by
/// hand is where flows drift — on the delay, or on forgetting the dismissal and
/// leaving the customer with a modal they cannot take down. [run] is that
/// sequence:
///
/// ```dart
/// GtTaskRunner.run<Receipt>(
///   context,
///   loadingTitle: "Sending",
///   task: (controller) => repository.transfer(amount),
///   onSuccess: (receipt) => context.push(ReceiptScreen(receipt)),
///   onError: (error) => showError(error.message),
/// );
/// ```
///
/// The task receives the [GtBottomModalController] driving the modal, so it can
/// report progress or retitle the modal as it goes.
final class GtTaskRunner with GtBottomModalMixin {
  const GtTaskRunner._();

  /// The mixin instance the static [run] presents through.
  static const GtTaskRunner _presenter = GtTaskRunner._();

  /// Shows a task modal, runs [task] behind it, closes the modal, and then
  /// reports the outcome to [onSuccess] or [onError].
  ///
  /// * [loadingTitle] and [description] configure the modal while the task runs.
  /// * [completeDelay] is how long the finished state stays on screen before the
  ///   modal is taken down.
  /// * [keepOpenOnFailure] leaves a failed task's modal on screen, showing the
  ///   error inside it. The controller passed to [task] is the handle that
  ///   closes it — call [GtBottomModalController.dismiss] on it. The callbacks
  ///   still run while that modal is up, so the screen underneath can mark the
  ///   input the task rejected.
  /// * [onlyWhenVisible] skips the callbacks when the screen that started the
  ///   task is no longer where the customer is — it has been closed, or a route
  ///   the customer navigated to now covers it. This runner's own modal does
  ///   not count as covering it, so it composes with [keepOpenOnFailure].
  ///   Flows that must report their outcome wherever the customer ended up turn
  ///   this off.
  ///
  /// The modal is removed in place when something was pushed over it while the
  /// task ran, so a confirmation or re-authentication route opened mid-task is
  /// never the thing that closes.
  ///
  /// Returns the task's [TaskResponse], resolving once the modal is gone and
  /// the callbacks have run. A [task] that throws is reported as a
  /// [TaskFailure] rather than propagating.
  static Future<TaskResponse<T>> run<T>(
    BuildContext context, {
    required Future<TaskResponse<T>> Function(
      GtBottomModalController<T> controller,
    )
    task,
    required OnChanged<T> onSuccess,
    OnChanged<TaskError>? onError,
    required String loadingTitle,
    String? description,
    AppImageData? icon,
    Duration completeDelay = const Duration(seconds: 2),
    bool keepOpenOnFailure = false,
    bool onlyWhenVisible = true,
    bool useRootNavigator = true,
  }) async {
    final owner = ModalRoute.of(context);
    final settled = Completer<TaskResponse<T>>();

    late final GtBottomModalController<T> controller;
    controller = GtBottomModalController<T>(
      data: GtBottomModalData(
        title: loadingTitle,
        description: description,
        icon: icon,
      ),
      onCompleteDelay: completeDelay,
      keepOpenOnFailure: keepOpenOnFailure,
      onComplete: (result) {
        if (!settled.isCompleted) settled.complete(result);
        // The modal is already gone by the time this runs, so the screen
        // underneath is the one that acts on the result — and only if it is
        // still the screen the customer is looking at.
        if (!context.mounted) return;
        // The runner's own modal counts as part of the screen that started the
        // task: [keepOpenOnFailure] holds it on top of [owner], which makes
        // owner.isCurrent false, and testing that alone would read this modal
        // as the customer having navigated away — silently dropping the very
        // failure the modal is displaying.
        final isVisible =
            owner?.isCurrent != false || controller.isModalCurrent;
        if (onlyWhenVisible && !isVisible) return;
        switch (result) {
          case TaskSuccess<T>(data: final data):
            onSuccess(data);
          case TaskFailure<T>(error: final error):
            onError?.call(error);
        }
      },
    );

    unawaited(
      _presenter.showTaskBottomModal<T>(
        context,
        controller: controller,
        useRootNavigator: useRootNavigator,
      ),
    );

    try {
      final result = await task(controller);
      controller.complete(result, breakIfAlreadyCompleted: false);
    } catch (error, stack) {
      debugPrint("GtTaskRunner task failed: $error\n$stack");
      controller.complete(
        TaskFailure<T>(
          error: TaskError(message: "$error", error: error),
        ),
        breakIfAlreadyCompleted: false,
      );
    }

    final result = await settled.future;
    // A modal kept open on failure outlives the completion callback, and
    // disposing the controller it is still listening to would break it.
    await controller.closed;
    controller.dispose();

    return result;
  }
}
