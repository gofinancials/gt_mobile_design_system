import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtBottomModal', type: GtBottomModal)
Widget playgroundGtBottomModalUseCase(BuildContext context) {
  return const _BottomModalPreview();
}

class _BottomModalPreview extends StatefulWidget {
  const _BottomModalPreview();

  @override
  State<_BottomModalPreview> createState() => _BottomModalPreviewState();
}

Stream<double> _getProgressStream() async* {
  final list = List.generate(100, (index) => (index + 1) / 100);
  for (final i in list) {
    yield i;
    await Future.delayed(const Duration(milliseconds: 100));
  }
}

class _BottomModalPreviewState extends State<_BottomModalPreview>
    with GtBottomModalMixin {
  final GtBottomModalController<String> _controller =
      GtBottomModalController<String>(
        data: GtBottomModalData(title: "PROCESSING"),
        onComplete: (value) {},
        onCompleteDelay: const Duration(seconds: 2),
      );

  Future<TaskResponse<String>> _getSuccessFuture() async {
    await Future.delayed(const Duration(seconds: 2));
    return TaskSuccess(data: "Success");
  }

  Future<TaskResponse<String>> _getFailureFuture() async {
    await Future.delayed(const Duration(seconds: 2));
    return TaskFailure(
      error: TaskError(message: "An absolute error occurred."),
    );
  }

  Future<TaskResponse<String>> _getProgressFuture({
    OnChanged<double>? onProgress,
  }) async {
    _getProgressStream().asBroadcastStream().listen(onProgress?.call);
    await Future.delayed(const Duration(seconds: 10));
    return TaskSuccess(data: "Success");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final modalTitle = context.knobs.string(
      label: 'Modal Title',
      initialValue: 'NOT FOUND',
    );
    final modalDesc = context.knobs.string(
      label: 'Modal Description',
      initialValue: 'The system couldn’t find what you asked for',
    );

    return GtWidgetDocPage(
      title: 'GtBottomModal',
      description:
          'Modal overlays designed to block user interaction during processing, success, or failure flows. Access these helper methods by mixing GtBottomModalMixin into your State class.',
      code: '''
// 1. Add GtBottomModalMixin to your State class
class MyState extends State<MyWidget> with GtBottomModalMixin {
  
  // 2. Define a persistent modal controller to drive task state transitions (dislocated controller)
  // The controller closes its own modal once the task completes, so onComplete
  // only handles the result.
  final GtBottomModalController<Receipt> _controller = GtBottomModalController(
    data: GtBottomModalData(title: "PROCESSING"),
    onComplete: (value) {
      switch (value) {
        case TaskSuccess<Receipt>(data: final receipt):
          showReceipt(receipt);
        case TaskFailure<Receipt>(error: final error):
          showError(error.message);
      }
    },
  );

  // A. Present a Simple Modal (None-Task Bound)
  void openSimpleModal() {
    showBottomModal(
      context,
      title: "NOT FOUND",
      description: "The system couldn't find what you asked for.",
      icon: AppImageData.asset(GtVectors.caution),
    );
  }

  // B. Present a Task-bound Modal (Success/Failure Flow)
  void startAsyncWork() async {
    // The returned Future resolves once the modal is gone.
    showTaskBottomModal(context, controller: _controller);

    // Simulate async operation
    final result = await performApiCall();

    // Complete the controller to transition to Success or Failure state.
    // After the completion delay the controller takes its own modal down —
    // removing that route in place, so a route pushed over the modal while the
    // task ran is never the one that closes.
    _controller.complete(result);
  }

  // D. Or let GtTaskRunner do all of B for you
  void runTask() {
    GtTaskRunner.run<Receipt>(
      context,
      loadingTitle: "PROCESSING",
      task: (controller) => performApiCall(),
      onSuccess: showReceipt,
      onError: (error) => showError(error.message),
    );
  }

  // C. Present a Progressive Task Modal (Progress Updating Flow)
  void startProgressiveWork() async {
    showTaskBottomModal(context, controller: _controller);

    // Update title and progress value dynamically as work proceeds
    doWork(
      onProgress: (value) {
        if (value == 1.0) {
          _controller.title = "Completed";
          _controller.progress = null;
        } else {
          _controller.title = "Downloading...";
          _controller.progress = value;
        }
      },
    );
  }
}
''',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: context.spacingLg,
        children: [
          GtRaisedButton(
            text: 'Open Simple Modal',
            onPressed: () {
              showBottomModal(
                context,
                title: modalTitle,
                description: modalDesc,
                icon: AppImageData.asset(GtVectors.caution),
                useRootNavigator: false,
              );
            },
          ),
          GtRaisedButton(
            text: 'Open Task Modal (Success Flow)',
            variant: GtButtonVariant.success,
            onPressed: () async {
              _controller.reset();
              showTaskBottomModal(
                context,
                controller: _controller,
                useRootNavigator: false,
              );
              _controller.complete(await _getSuccessFuture());
            },
          ),
          GtRaisedButton(
            text: 'Open Task Modal (Failure Flow)',
            variant: GtButtonVariant.destructive,
            onPressed: () async {
              _controller.reset();
              showTaskBottomModal(
                context,
                controller: _controller,
                useRootNavigator: false,
              );
              _controller.complete(await _getFailureFuture());
            },
          ),
          GtRaisedButton(
            text: 'Open Progressive Task Bottom Modal',
            variant: GtButtonVariant.secondary,
            onPressed: () async {
              _controller.reset();
              showTaskBottomModal(
                context,
                controller: _controller,
                useRootNavigator: false,
              );
              _controller.complete(
                await _getProgressFuture(
                  onProgress: (value) {
                    if (value == 1.0) {
                      _controller.title = "Completed";
                      _controller.description = "Data has been downloaded";
                      _controller.progress = null;
                      return;
                    }
                    _controller.title = "Downloading...";
                    _controller.progress = value;
                  },
                ),
              );
            },
          ),
          GtRaisedButton(
            text: 'Run A Task With GtTaskRunner',
            variant: GtButtonVariant.primary,
            onPressed: () {
              GtTaskRunner.run<String>(
                context,
                loadingTitle: "PROCESSING",
                useRootNavigator: false,
                task: (controller) => _getSuccessFuture(),
                onSuccess: (data) {
                  showBottomModal(
                    context,
                    title: data,
                    description: 'The runner closed its own modal first.',
                    useRootNavigator: false,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
