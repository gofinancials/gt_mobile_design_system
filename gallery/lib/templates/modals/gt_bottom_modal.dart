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

TaskCallResponse<SampleFuture> _getSuccessFuture() async {
  await Future.delayed(2.seconds);
  return TaskSuccess(data: SampleFuture(title: "We fetched data successfully"));
}

TaskCallResponse<SampleFuture> _getFailureFuture({OnPressed? onError}) async {
  await Future.delayed(2.seconds);
  onError?.call();
  return TaskFailure(
    error: TaskError(
      message:
          "Unable to complete request right now, an absolute <e>error</e> occurred.",
    ),
  );
}

Stream<double> _getProgressStream() async* {
  final list = List.generate(100, (index) => (index + 1) / 100);
  for (final i in list) {
    yield i;
    await Future.delayed(100.milliseconds);
  }
}

TaskCallResponse<SampleFuture> _getProgressFuture({
  OnChanged<double>? onProgress,
}) async {
  _getProgressStream().asBroadcastStream().listen(onProgress?.call);
  await Future.delayed(10.seconds);
  return TaskSuccess(
    data: SampleFuture(title: "We fetched downloaded your file successfully"),
  );
}

final GtBottomModalController _controller = GtBottomModalController(
  data: GtBottomModalData(title: "PROCESSING"),
  onComplete: (value) {
    GtRouter.popView();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.reset();
    });
  },
  onCompleteDelay: 2.seconds,
);

class _BottomModalPreviewState extends State<_BottomModalPreview>
    with GtBottomModalMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
                  description: "The system couldn’t find what you asked for",
                  icon: AppImageData(imageData: GtVectors.caution),
                );
              },
            ),
            GtRaisedButton(
              text: 'Open Task bottom modal',
              variant: .success,
              onPressed: () async {
                showTaskBottomModal(context, controller: _controller);
                _controller.complete(await _getSuccessFuture());
              },
            ),
            GtRaisedButton(
              text: 'Open Failing Task bottom modal',
              variant: .destructive,
              onPressed: () async {
                showTaskBottomModal(context, controller: _controller);
                _controller.complete(
                  await _getFailureFuture(
                    onError: () {
                      _controller.title = "Something went wrong";
                    },
                  ),
                );
              },
            ),
            GtRaisedButton(
              text: 'Open Progressive Task bottom modal',
              variant: .highlighted,
              onPressed: () async {
                showTaskBottomModal(context, controller: _controller);
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
          ],
        ),
      ),
    );
  }
}
