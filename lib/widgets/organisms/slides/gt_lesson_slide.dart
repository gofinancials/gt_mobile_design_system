import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A primary slide widget used to display content in a story-like lesson viewer.
///
/// It supports rendering different types of content (text, images, audio/visual)
/// based on the provided [GtLessonSlideData], and handles user interactions
/// for navigating between slides.
class GtLessonSlide extends GtStatefulWidget {
  /// Callback triggered when the user taps on the right side of the slide.
  final OnPressed onTapNext;

  /// Callback triggered when the user taps on the left side of the slide.
  final OnPressed onTapPrev;

  /// Callback triggered when the user presses and holds on the slide.
  final OnPressed onLongPressDown;

  /// Callback triggered when the user releases a long press.
  final OnPressed onLongPressUp;

  /// Optional callback triggered when the user swipes down on the slide.
  final OnPressed? onSwipeDown;

  /// The controller managing slide navigation and media playback for audio-visual slides.
  final GtLessonslideController controller;

  /// The color of the slide indicator.
  final Color? indicatorColor;

  /// Creates a [GtLessonSlide].
  const GtLessonSlide({
    super.key,
    required this.onTapNext,
    required this.onTapPrev,
    required this.onLongPressDown,
    required this.onLongPressUp,
    required this.controller,
    this.onSwipeDown,
    this.indicatorColor,
  });

  @override
  State<GtLessonSlide> createState() => _GtLessonSlideState();
}

class _GtLessonSlideState extends State<GtLessonSlide> {
  late final GtLessonSlideData data;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    data = widget.controller.currentSlide;
    _focusNode = FocusNode();
  }

  void _handleKeyDown(KeyEvent event) {
    final key = event.logicalKey;
    if (key != LogicalKeyboardKey.space) return;
    widget.onLongPressDown();
  }

  void _handleKeyUp(KeyEvent event) {
    final key = event.logicalKey;
    switch (key) {
      case LogicalKeyboardKey.arrowLeft:
        widget.onTapPrev();
        break;
      case LogicalKeyboardKey.arrowRight:
        widget.onTapNext();
        break;
      case LogicalKeyboardKey.space:
        widget.onLongPressUp();
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (event) {
        if (event is KeyDownEvent) _handleKeyDown(event);
        if (event is KeyUpEvent) _handleKeyUp(event);
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            behavior: .opaque,
            onLongPressDown: (details) => widget.onLongPressDown(),
            onLongPressUp: widget.onLongPressUp,
            onTapDown: (details) {
              final x = details.localPosition.dx;
              final isLeft = x < (constraints.maxWidth * .45);
              if (isLeft) return widget.onTapPrev();
              widget.onTapNext();
            },
            onVerticalDragEnd: (details) {
              final velocity = details.primaryVelocity ?? 0;
              if (velocity > 100) {
                widget.onSwipeDown?.call();
              }
            },
            child: Column(
              crossAxisAlignment: .stretch,
              children: [
                const GtGap.ySectionLg(),
                GtLessonSlideTitle(
                  data.header,
                  key: ValueKey('title_${data.header.hashCode}'),
                ),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      return switch (data.slideType) {
                        .image => GtImage(
                          key: ValueKey('img_${data.media.hashCode}'),
                          fit: .contain,
                          useDefaultSize: false,
                          alignment: data.imageAlignment ?? .center,
                          width: data.imageSize,
                          height: data.imageSize,
                          image: data.media as AppImageData,
                        ),
                        .text => SingleChildScrollView(
                          padding: context.insets.symmetricDp(
                            vertical: 20.px,
                            horizontal: 16.px,
                          ),
                          child: Center(
                            child: GtRichText(
                              data.text,
                              key: ValueKey('txt_${data.text.hashCode}'),
                              textAlign: .center,
                              style: context.textStyles.bodyM(),
                            ),
                          ),
                        ),
                        .audioVisual => GtLessonSlideMedia(
                          data.media as AppAvData,
                          key: ValueKey('media_${data.media.hashCode}'),
                          controller: widget.controller,
                        ),
                      };
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// A widget responsible for rendering a slide's background image with optional animations.
class GtLessonSlideBackground extends GtStatelessWidget {
  /// The background image configuration data.
  final GtLessonSlideImage data;

  /// Creates a [GtLessonSlideBackground].
  const GtLessonSlideBackground(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<Offset>(
        begin: data.animate ? .zero : data.offset,
        end: data.offset,
      ),
      duration: 500.milliseconds,
      builder: (_, offset, child) {
        final matrix = Matrix4.diagonal3Values(1, 1, 1)
          ..translateByDouble(offset.dx, offset.dy, 0, 1)
          ..rotateZ(data.rotation);
        return Transform(
          transform: matrix,
          alignment: Alignment.center,
          child: GtImage(
            image: data.image,
            alignment: data.alignment,
            fit: data.fit,
            width: data.width,
            height: data.height,
            useDefaultSize: false,
          ),
        );
      },
    );
  }
}

/// A widget responsible for rendering and controlling audio or video media on a slide.
///
/// It integrates with [MediaPlayerService] and automatically plays/pauses media
/// based on the slide's [isActive] state and the app's lifecycle.
class GtLessonSlideMedia extends GtStatefulWidget {
  /// The audio/visual media data to display.
  final AppAvData data;

  /// The controller managing slide navigation and media playback for audio-visual slides.
  final GtLessonslideController controller;

  /// Creates a [GtLessonSlideMedia].
  const GtLessonSlideMedia(this.data, {super.key, required this.controller});

  @override
  State<GtLessonSlideMedia> createState() => _GtLessonSlideMediaState();
}

class _GtLessonSlideMediaState extends State<GtLessonSlideMedia>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        widget.controller.play();
        break;
      default:
        widget.controller.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    final source = widget.controller.mediaSource;
    if (source == null) return const Offstage();

    return Center(
      child: IgnorePointer(
        key: ValueKey(source.hashCode),
        child: Builder(
          builder: (context) {
            if (source.isVideo) return GtVideoPlayer(source.video!);
            if (source.isYoutube) return GtYoutubePlayer(source.youtube!);
            if (source.isAudio) return GtLottie(GtNetworkLotties.waveForm);

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

/// A widget responsible for rendering the slide's header/title section.
///
/// Includes support for a main title and subtitle, with optional embedded card styling
/// and entry animations based on the [GtLessonSlideHeader] configuration.
class GtLessonSlideTitle extends GtStatelessWidget {
  /// The header configuration data for the slide.
  final GtLessonSlideHeader data;

  /// Creates a [GtLessonSlideTitle].
  const GtLessonSlideTitle(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    final styles = context.textStyles;
    final titleStyle = styles.h5();
    final subStyle = styles.subHeadS();

    return Padding(
      padding: context.insets.defaultHorizontalInsets,
      child: Column(
        crossAxisAlignment: .start,
        spacing: context.spacingMd,
        children: [
          GtText(
            data.title,
            style: titleStyle,
            maxLines: 2,
            overflow: .ellipsis,
          ),
          GtText(
            data.subTitle,
            style: subStyle,
            maxLines: 4,
            overflow: .ellipsis,
          ),
        ],
      ),
    );
  }
}
