import 'package:flutter/material.dart';
import 'package:gallery/widgets/gallery_page_header.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Widgetbook playground for [GtLoaderBottomModal].
@widgetbook.UseCase(name: 'GtBottomModal', type: GtBottomModal)
Widget buildGtBottomModalUsecase(BuildContext context) {
  return const _BottomModalPreview();
}

class _BottomModalPreview extends StatefulWidget {
  const _BottomModalPreview();

  @override
  State<_BottomModalPreview> createState() => _BottomModalPreviewState();
}

class SampleFuture extends AppEquatable {
  final String title;

  const SampleFuture({required this.title});

  @override
  List<Object?> get props => [title];
}

final ValueNotifier<FutureData<SampleFuture>> _taskNotifier = ValueNotifier(
  FutureData.pristine(),
);

void _getSuccessFuture() async {
  final state = _taskNotifier.value;
  if (state.isLoading) return;
  _taskNotifier.value = state.copyWith(isLoading: true);
  await Future.delayed(2.seconds);
  _taskNotifier.value = state.copyWith(
    data: SampleFuture(title: "We fetched data successfully"),
    isLoading: false,
  );
}

void _getFailureFuture({OnPressed? onError}) async {
  final state = _taskNotifier.value;
  if (state.isLoading) return;
  _taskNotifier.value = state.copyWith(isLoading: true);
  await Future.delayed(2.seconds);
  onError?.call();
  _taskNotifier.value = state.copyWith(
    error: TaskError(message: "An error occured while fetching your request"),
    data: null,
    isLoading: false,
  );
}

Stream<double> _getProgressStream() async* {
  final list = List.generate(10, (index) => (index + 1) / 10);
  for (final i in list) {
    yield i;
    await Future.delayed(1.seconds);
  }
}

void _getProgressFuture({OnChanged<double>? onProgress}) async {
  final state = _taskNotifier.value;
  if (state.isLoading) return;
  _taskNotifier.value = state.copyWith(isLoading: true);
  _getProgressStream().asBroadcastStream().listen(onProgress?.call);
  await Future.delayed(10.seconds);
  _taskNotifier.value = state.copyWith(
    data: SampleFuture(title: "We fetched data successfully"),
    isLoading: false,
  );
}

final GtBottomModalController _controller = GtBottomModalController(
  data: GtBottomModalData(title: "PROCESSING"),
  taskNotifier: _taskNotifier,
  onComplete: (value) {
    GtRouter.popView();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _taskNotifier.value = FutureData.pristine();
    });
  },
  onCompleteDelay: 1.seconds,
);

class _BottomModalPreviewState extends State<_BottomModalPreview>
    with GtBottomModalMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: context.insets.defaultHorizontalInsets,
            child: Column(
              mainAxisAlignment: .start,
              crossAxisAlignment: .stretch,
              spacing: context.spacingLg,
              children: [
                GalleryPageHeader(
                  title: 'Bottom Modal',
                  rider:
                      'Representation of the static, loading, success, and error states',
                ),
                GtRaisedButton(
                  text: 'Open Simple modal',
                  onPressed: () {
                    showBottomModal(
                      context,
                      title: "NOT FOUND",
                      description:
                          "The system couldn’t find what you asked for",
                      icon: AppImageData(imageData: GtVectors.caution),
                    );
                  },
                ),
                GtRaisedButton(
                  text: 'Open Task bottom modal',
                  variant: .success,
                  onPressed: () {
                    _getSuccessFuture();
                    showTaskBottomModal(context, controller: _controller);
                  },
                ),
                GtRaisedButton(
                  text: 'Open Failing Task bottom modal',
                  variant: .destructive,
                  onPressed: () {
                    _getFailureFuture(
                      onError: () {
                        _controller.errorTitle = "Something went wrong";
                        _controller.description =
                            "Unable to complete request right now.";
                      },
                    );
                    showTaskBottomModal(context, controller: _controller);
                  },
                ),
                GtRaisedButton(
                  text: 'Open Progressive Task bottom modal',
                  variant: .highlighted,
                  onPressed: () {
                    _getProgressFuture(
                      onProgress: (value) {
                        if (value == 1.0) {
                          _controller.successTitle = "Completed";
                          _controller.description = "Data has been downloaded";
                          _controller.progress = null;
                          return;
                        }
                        _controller.title = "Downloading...";
                        _controller.progress = value;
                      },
                    );
                    showTaskBottomModal(context, controller: _controller);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
