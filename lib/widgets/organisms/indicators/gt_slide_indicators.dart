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
                  child: _SlideIndicator(
                    key: ValueKey('slide_indicator_${index}_${slide.hashCode}'),
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

class _SlideIndicator extends StatefulWidget {
  final GtLessonSlideData slide;
  final GtLessonSlideState state;
  final GtLessonslideController controller;
  final Color? indicatorColor;

  const _SlideIndicator({
    required this.slide,
    required this.state,
    required this.controller,
    required this.indicatorColor,
    super.key,
  });

  @override
  State<_SlideIndicator> createState() => _SlideIndicatorState();
}

class _SlideIndicatorState extends State<_SlideIndicator>
    with TickerProviderStateMixin {
  Future<void>? _setupFuture;

  @override
  void initState() {
    super.initState();
    if (widget.state != .active) return;
    _setupFuture = widget.controller.initialiseProgress(this);
  }

  @override
  void didUpdateWidget(covariant _SlideIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state == .active && oldWidget.state != .active) {
      _setupFuture = widget.controller.initialiseProgress(this);
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final inactiveColor = palette.bg.soft;
    final activeColor = widget.indicatorColor ?? palette.primary.base;

    if (widget.state == .done) {
      return GtProgress(
        value: 1,
        inactiveColor: inactiveColor,
        color: activeColor,
      );
    }
    if (widget.state == .pending) {
      return GtProgress(
        value: 0,
        inactiveColor: inactiveColor,
        color: activeColor,
      );
    }

    return RepaintBoundary(
      child: FutureBuilder(
        future: _setupFuture,
        builder: (context, task) {
          final animationController = widget.controller.animationController;
          final streamController = widget.controller.streamController;
          final hasAnimationController = animationController != null;
          final hasStreamController = streamController != null;

          if (hasAnimationController) {
            return AnimatedBuilder(
              animation: animationController,
              builder: (context, _) {
                return GtProgress(
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
                  value: progress,
                  inactiveColor: inactiveColor,
                  color: activeColor,
                );
              },
            );
          }

          return GtProgress(inactiveColor: inactiveColor, color: activeColor);
        },
      ),
    );
  }
}
