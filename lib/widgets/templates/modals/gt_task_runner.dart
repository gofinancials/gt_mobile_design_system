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
  /// * [loadingTitle] and [description] configure the modal while the task
  ///   runs. Required unless a [controller] carrying its own title is passed.
  /// * [completeDelay] is how long the finished state stays on screen before the
  ///   modal is taken down.
  /// * [keepOpenOnFailure] leaves a failed task's modal on screen, showing the
  ///   error inside it. The controller passed to [task] is the handle that
  ///   closes it — call [GtBottomModalController.dismiss] on it. The callbacks
  ///   still run while that modal is up, so the screen underneath can mark the
  ///   input the task rejected.
  /// * [controller] hands ownership of the modal to the caller. A screen whose
  ///   task can outlive it creates the controller, passes it here, and disposes
  ///   it in its own `dispose` — which takes the modal down with the screen
  ///   rather than leaving a blocking spinner over whatever replaced it. The
  ///   Disposing it also stops the outcome being reported, so a screen that
  ///   has moved on is not driven by a task it no longer wants. The
  ///   runner disposes only a controller it created itself, and reads the
  ///   title, delay and [GtBottomModalController.keepOpenOnFailure] from a
  ///   supplied one, ignoring [loadingTitle], [description], [icon],
  ///   [completeDelay] and [keepOpenOnFailure]. A supplied controller's own
  ///   `onComplete` runs in addition to [onSuccess] and [onError], so leave it
  ///   unset unless both are wanted.
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
    GtBottomModalController<T>? controller,
    String? loadingTitle,
    String? description,
    AppImageData? icon,
    Duration completeDelay = const Duration(seconds: 2),
    bool keepOpenOnFailure = false,
    bool onlyWhenVisible = true,
    bool useRootNavigator = true,
  }) async {
    assert(
      controller != null || loadingTitle != null,
      "Pass a loadingTitle, or a controller carrying its own title.",
    );

    final owner = ModalRoute.of(context);
    // A controller the caller owns is the caller's to dispose; disposing it
    // here would take a modal down that the caller may still be driving.
    final ownsController = controller == null;
    final resolved =
        controller ??
        GtBottomModalController<T>(
          data: GtBottomModalData(
            title: loadingTitle ?? "",
            description: description,
            icon: icon,
          ),
          onCompleteDelay: completeDelay,
          keepOpenOnFailure: keepOpenOnFailure,
        );

    unawaited(
      _presenter.showTaskBottomModal<T>(
        context,
        controller: resolved,
        useRootNavigator: useRootNavigator,
      ),
    );

    TaskResponse<T> result;
    try {
      result = await task(resolved);
    } catch (error, stack) {
      debugPrint("GtTaskRunner task failed: $error\n$stack");
      result = TaskFailure<T>(
        error: TaskError(message: "$error", error: error),
      );
    }

    resolved.complete(result, breakIfAlreadyCompleted: false);
    // Released by the completion delay and dismissal, or straight away if the
    // caller disposed the controller because its screen went away.
    await resolved.settled;

    if (context.mounted &&
        _shouldReport(
          owner: owner,
          controller: resolved,
          onlyWhenVisible: onlyWhenVisible,
        )) {
      switch (result) {
        case TaskSuccess<T>(data: final data):
          onSuccess(data);
        case TaskFailure<T>(error: final error):
          onError?.call(error);
      }
    }

    if (ownsController) {
      // A modal kept open on failure outlives the completion, and disposing
      // the controller it is still listening to would break it.
      await resolved.closed;
      resolved.dispose();
    }

    return result;
  }

  /// Whether the task's outcome should still be reported to the caller.
  ///
  /// The runner's own modal counts as part of the screen that started the
  /// task: [GtBottomModalController.keepOpenOnFailure] holds it on top of
  /// [owner], which makes `owner.isCurrent` false, and testing that alone
  /// would read this modal as the customer having navigated away — silently
  /// dropping the very failure the modal is displaying.
  static bool _shouldReport<T>({
    required ModalRoute<dynamic>? owner,
    required GtBottomModalController<T> controller,
    required bool onlyWhenVisible,
  }) {
    // A caller that disposed its own controller has said it is finished with
    // this task, and its screen may still be mounted — a rebuild that replaced
    // the form rather than a pop. Reporting into it anyway would drive a screen
    // that has already moved on.
    if (controller.isDisposed) return false;
    if (!onlyWhenVisible) return true;
    return owner?.isCurrent != false || controller.isModalCurrent;
  }
}
