import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A stateful widget that orchestrates a WhatsApp-style story viewing experience.
///
/// It combines a top progress indicator ([GtSlidesIndicator]), an app bar with a
/// cancel button, and a main body displaying the current slide ([GtLessonSlide]).
class GtLessonSlides extends GtStatefulWidget {
  /// Callback triggered when the user explicitly cancels or swipes down to dismiss the story.
  final OnPressed onCancel;

  /// Callback triggered when the final slide completes or the user advances past it.
  final OnPressed onCompleted;

  /// The controller that manages the state, navigation, and media of the slides.
  final GtLessonslideController controller;

  /// Optional color used to tint the active progress indicator.
  final Color? indicatorColor;

  /// Creates a [GtLessonSlides] viewer.
  const GtLessonSlides({
    super.key,
    required this.controller,
    required this.onCancel,
    required this.onCompleted,
    this.indicatorColor,
  });

  @override
  State<GtLessonSlides> createState() => _GtLessonSlidesState();
}

class _GtLessonSlidesState extends State<GtLessonSlides> {
  late GtLessonslideController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _controller.onStoryCompleted = widget.onCompleted;
  }

  @override
  void dispose() {
    _controller.reset(notify: false);
    super.dispose();
  }

  void _cancel() {
    _controller.reset(notify: false);
    widget.onCancel();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      child: GtSlidesIndicator(
        key: ValueKey(_controller.hashCode),
        controller: _controller,
        indicatorColor: widget.indicatorColor,
      ),
      builder: (_, child) {
        if (!_controller.slides.hasValue) {
          return const Offstage();
        }

        final data = _controller.currentSlide;

        return Scaffold(
          key: ValueKey(data.hashCode),
          backgroundColor: data.color,
          extendBody: true,
          extendBodyBehindAppBar: true,
          appBar: GtAppBar(
            trailing: GtCancelButton(onTap: _cancel),
            title: data.title,
          ),
          body: Stack(
            children: [
              GtLessonSlide(
                key: ValueKey(_controller.currentSlide.hashCode),
                controller: _controller,
                onTapNext: _controller.next,
                onTapPrev: _controller.prev,
                onLongPressDown: _controller.onLongPressDown,
                onLongPressUp: _controller.onLongPressUp,
                onSwipeDown: _cancel,
              ),
              Positioned(
                top: context.spacingSectionSm,
                left: 0,
                right: 0,
                child: SafeArea(child: child!),
              ),
            ],
          ),
        );
      },
    );
  }
}
