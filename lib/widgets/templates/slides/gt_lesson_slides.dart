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
  void didUpdateWidget(covariant GtLessonSlides oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!identical(widget.controller, _controller)) {
      _releaseController();
      _controller = widget.controller;
    }

    _controller.onStoryCompleted = widget.onCompleted;
  }

  @override
  void deactivate() {
    // Stops playback the moment this leaves the tree, before any descendant is
    // torn down, so nothing keeps ticking on the way out.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _releaseController();
    super.dispose();
  }

  /// Hands the caller's controller back in a clean state.
  ///
  /// Clearing [GtLessonslideController.onStoryCompleted] matters because the
  /// controller usually outlives this widget: leaving the callback in place
  /// retains this state, and a later completion would fire into a dead screen.
  void _releaseController() {
    _controller.onStoryCompleted = null;
    _controller.reset(notify: false);
  }

  void _cancel() {
    _controller.reset(notify: false);
    widget.onCancel();
  }

  Gradient? _getGradient(BuildContext context, GtLessonSlideData data) {
    if (data.color == null && data.gradient == null) {
      return context.gradients.slideGradient();
    }

    return data.gradient;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      child: GtSlidesIndicator(
        key: ObjectKey(_controller),
        controller: _controller,
        indicatorColor: widget.indicatorColor,
      ),
      builder: (_, child) {
        if (!_controller.slides.hasValue) {
          return const Offstage();
        }

        final data = _controller.currentSlide;
        final bgColor = data.color ?? context.palette.bg.soft;

        return Scaffold(
          // Keyed on the index, not the slide: `GtLessonSlideData` is value
          // equatable, so two slides with identical content hash the same and
          // would not re-inflate, leaving the deck stuck on the first of them.
          key: ValueKey(_controller.currentIndex),
          backgroundColor: bgColor,
          extendBody: true,
          appBar: GtAppBar(
            trailing: GtCancelButton(
              onTap: _cancel,
              color: data.foregroundColor,
            ),
            title: data.title,
            // The app bar sits on `bgColor`, which the slide supplies, so its
            // foreground has to come from the slide too.
            titleColor: data.foregroundColor,
          ),
          body: DecoratedBox(
            decoration: BoxDecoration(
              color: bgColor,
              gradient: _getGradient(context, data),
            ),
            child: Container(
              margin: context.insets.onlyDp(
                top: 24.px,
                left: 16.px,
                right: 16.px,
              ),
              padding: context.insets.onlyDp(top: 32.px),
              decoration: BoxDecoration(
                gradient: data.gradient,
                color: context.palette.bg.weak,
                borderRadius: BorderRadius.vertical(top: context.radius4Xl),
              ),
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  Padding(
                    padding: context.insets.defaultHorizontalInsets,
                    child: child,
                  ),
                  Expanded(
                    child: GtLessonSlide(
                      key: ValueKey(_controller.currentIndex),
                      controller: _controller,
                      onTapNext: _controller.next,
                      onTapPrev: _controller.prev,
                      onLongPressDown: _controller.onLongPressDown,
                      onLongPressUp: _controller.onLongPressUp,
                      onSwipeDown: _cancel,
                      indicatorColor: widget.indicatorColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
