import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A widget that displays a customizable slider for media playback.
///
/// It visualizes the current playback progress, total duration, and allows
/// the user to seek to a specific position within the media.
class GtMediaPlayerSlider extends GtStatelessWidget {
  /// The current state of the media player (e.g., playing, paused, loading).
  final MediaPlayerState state;

  /// The current playback position.
  final Duration? position;

  /// The total duration of the media.
  final Duration? duration;

  /// Callback triggered when the user seeks to a new position using the slider.
  final OnChanged<Duration> onSeek;

  /// Creates a [GtMediaPlayerSlider].
  const GtMediaPlayerSlider({
    super.key,
    required this.state,
    required this.position,
    required this.duration,
    required this.onSeek,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Slider(
          position,
          duration: duration,
          state: state,
          onSeek: onSeek,
          key: ValueKey(("slider", position)),
        ),
        const GtGap.yBase(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _DurationText(
              position?.inSeconds ?? 0,
              key: ValueKey(("back", position)),
            ),
            _DurationText(
              duration?.inSeconds ?? 0,
              key: ValueKey(("fore", duration)),
            ),
          ],
        ),
      ],
    );
  }
}

/// A private helper widget that renders a formatted duration string.
class _DurationText extends GtStatelessWidget {
  /// The duration value in seconds.
  final num value;

  /// Creates a [_DurationText] instance.
  const _DurationText(this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return GtText(value.asDurationString, style: context.textStyles.body2Xs());
  }
}

/// A private helper widget that renders the interactive progress bar.
class _Slider extends GtStatelessWidget {
  /// Callback triggered when the user scrubs the slider.
  final OnChanged<Duration> onSeek;

  /// The current playback position.
  final Duration? position;

  /// The total duration of the media.
  final Duration? duration;

  /// The current state of the media player.
  final MediaPlayerState state;

  /// Creates a [_Slider] instance.
  const _Slider(
    this.position, {
    required this.state,
    required this.onSeek,
    required this.duration,
    super.key,
  });

  void _handleDrag(PositionedGestureDetails details, BuildContext context) {
    HapticFeedback.lightImpact();
    final offset = details.localPosition.dx;
    final width = context.size?.width ?? 0.1;
    final fraction = offset / width;

    if (fraction < 0 || fraction > 1) return;
    onSeek((max * fraction).seconds);
  }

  num get extent => (position?.inSeconds ?? 0);
  num get max => (duration?.inSeconds ?? 0);
  double get progress {
    if (extent > 0 && max > 0) return (extent / max);
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    if (state != MediaPlayerState.loading && state != MediaPlayerState.idle) {
      return GestureDetector(
        dragStartBehavior: DragStartBehavior.down,
        behavior: HitTestBehavior.opaque,
        onHorizontalDragDown: (details) => _handleDrag(details, context),
        child: GtAnimatedProgress(
          value: progress,
          isBuffering: state.isBuffering,
        ),
      );
    }

    return GtProgress();
  }
}
