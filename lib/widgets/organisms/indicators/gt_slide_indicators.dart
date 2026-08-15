import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A row of horizontal progress indicators typically used in story-like interfaces.
///
/// It visually represents the sequence of [GtLessonSlideData] managed by the
/// provided [GtLessonslideController], filling up individual indicators as
/// the user progresses through the slides.
class GtSlidesIndicator extends GtStatelessWidget {
  /// The controller that manages the slides and playback state.
  final GtLessonslideController controller;

  /// Optional color for the active and completed indicators.
  ///
  /// If null, it defaults to the primary palette color.
  final Color? indicatorColor;

  /// Creates a [GtSlidesIndicator].
  const GtSlidesIndicator({
    required this.controller,
    this.indicatorColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final activeSlide = controller.currentIndex;

        return RepaintBoundary(
          child: Row(
            spacing: context.spacingXs,
            children: [
              for (final (index, slide) in controller.slides.indexed)
                Flexible(
                  child: GtSlideIndicator(
                    // Position and content both: the position identifies the
                    // indicator, and swapping the slide behind a position has
                    // to restart its progress, which only a fresh state does.
                    key: ValueKey((index, slide)),
                    slide: slide,
                    controller: controller,
                    indicatorColor: indicatorColor,
                    state: GtLessonSlideState.fromIndex(index, activeSlide),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class GtSlideIndicator extends StatefulWidget {
  final GtLessonSlideData slide;
  final GtLessonSlideState state;
  final GtLessonslideController controller;
  final Color? indicatorColor;

  const GtSlideIndicator({
    required this.slide,
    required this.state,
    required this.controller,
    required this.indicatorColor,
    super.key,
  });

  @override
  State<GtSlideIndicator> createState() => _GtSlideIndicatorState();
}

class _GtSlideIndicatorState extends State<GtSlideIndicator>
    with TickerProviderStateMixin {
  Future<void>? _setupFuture;

  /// The progress animation for a timed (non audio-visual) slide.
  ///
  /// Owned here rather than by the controller: it is driven by this state's
  /// ticker, so it has to die with this state. Leaving it on the controller let
  /// it outlive the ticker and trip the active-ticker assertion whenever the
  /// user routed away mid-animation.
  AnimationController? _animation;

  @override
  void initState() {
    super.initState();
    if (widget.state != .active) return;
    _startProgress();
  }

  @override
  void didUpdateWidget(covariant GtSlideIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state == .active && oldWidget.state != .active) {
      _startProgress();
    }
  }

  void _startProgress() {
    final controller = widget.controller;
    _disposeAnimation();

    if (controller.currentSlide.slideType.isAudioVisual) {
      // Audio-visual slides track the player's own stream instead of a timer.
      _setupFuture = controller.initialiseProgress();
      return;
    }

    final animation = AnimationController(
      vsync: this,
      duration: controller.currentSlide.duration,
    );
    _animation = animation;
    // Attach before starting: a zero-duration slide completes synchronously
    // inside `forward()`, and the controller has to hear that to advance.
    controller.attachProgress(animation);
    animation.forward();
  }

  void _disposeAnimation() {
    final animation = _animation;
    if (animation == null) return;

    _animation = null;
    widget.controller.detachProgress(animation);
    animation.dispose();
  }

  @override
  void dispose() {
    _disposeAnimation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final inactiveColor = palette.bg.soft;
    final activeColor = widget.indicatorColor ?? palette.primary.base;

    if (widget.state == .done) {
      return GtProgress(
        value: 1,
        size: 8,
        inactiveColor: inactiveColor,
        color: activeColor,
      );
    }
    if (widget.state == .pending) {
      return GtProgress(
        value: 0,
        size: 8,
        inactiveColor: inactiveColor,
        color: activeColor,
      );
    }

    return RepaintBoundary(
      child: FutureBuilder(
        future: _setupFuture,
        builder: (context, task) {
          final animationController = _animation;
          final streamController = widget.controller.streamController;
          final hasAnimationController = animationController != null;
          final hasStreamController = streamController != null;

          if (hasAnimationController) {
            return AnimatedBuilder(
              animation: animationController,
              builder: (context, _) {
                return GtProgress(
                  size: 8,
                  value: animationController.value,
                  inactiveColor: inactiveColor,
                  color: activeColor,
                );
              },
            );
          }

          if (hasStreamController) {
            return StreamBuilder(
              stream: streamController.stream,
              builder: (context, state) {
                final data = state.data;
                final isReady = data?.state.isLoaded ?? false;
                final isBuffering = data?.isBuffering ?? !isReady;
                final progress = isBuffering ? null : data?.progress;

                return GtProgress(
                  size: 8,
                  value: progress,
                  inactiveColor: inactiveColor,
                  color: activeColor,
                );
              },
            );
          }

          return GtProgress(
            size: 8,
            inactiveColor: inactiveColor,
            color: activeColor,
          );
        },
      ),
    );
  }
}
