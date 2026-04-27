import 'package:flutter/material.dart';
import 'package:gallery/widgets/gallery_page_header.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Widgetbook playground for [GtLoaderBottomModal].
@widgetbook.UseCase(
  name: 'GtBottomModal (Loader)',
  type: GtLoaderBottomModal,
  path: '[Templates]/Modals',
)
Widget buildGtBottomModalUsecase(BuildContext context) {
  return const _BottomModalPreview();
}

class _BottomModalPreview extends StatefulWidget {
  const _BottomModalPreview();

  @override
  State<_BottomModalPreview> createState() => _BottomModalPreviewState();
}

class _BottomModalPreviewState extends State<_BottomModalPreview> {
  late final GtBottomModalController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GtBottomModalController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                  title: 'Bottom Loader',
                  rider: 'Representation of the loading, success, and error states',
                ),
                GtRaisedButton(
                  text: 'Open loading modal',
                  onPressed: () {
                    _controller.showMessageOverlay(
                      'Processing request...',
                      description:
                          'Please wait while we complete your transaction.',
                      animate: true,
                    );
                  },
                ),
                GtRaisedButton(
                  text: 'Loading -> success',
                  variant: GtButtonVariant.success,
                  onPressed: () {
                    _controller.showMessageOverlay('Processing...');
                    Future.delayed(const Duration(seconds: 2), () {
                      _controller.hideLoaderOverLay(
                        'Personal Details Updated',
                        durationInSec: 2,
                      );
                    });
                  },
                ),
                GtRaisedButton(
                  text: 'Loading -> error',
                  variant: GtButtonVariant.destructive,
                  onPressed: () {
                    _controller.showMessageOverlay('Processing...');
                    Future.delayed(const Duration(seconds: 2), () {
                      _controller.hideLoaderOverLay(
                        'Something went wrong',
                        description: 'Unable to complete request right now.',
                        showError: true,
                      );
                    });
                  },
                ),
                GtRaisedButton(
                  text: 'Hide modal',
                  variant: GtButtonVariant.neutral,
                  onPressed: _controller.hideOverlay,
                ),
              ],
            ),
          ),
          // Floating bottom modal rendered in-place (no route/overlay).
          GtLoaderBottomModal(controller: _controller),
        ],
      ),
    );
  }
}
