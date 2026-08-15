import 'dart:async';

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A data class that represents the content and styling for a single slide
/// within a carousel or welcome screen, such as `GtWelcomeSlides`.
class GtSlideData {
  /// The primary heading text displayed on the slide.
  final String title;

  /// The secondary descriptive text or subheading displayed on the slide.
  final String subtitle;

  /// The main image or illustration to display on the slide.
  final AppImageData image;

  /// The primary background color of the slide.
  final Color backgroundColor;

  /// An optional background image decoration that covers the slide.
  final DecorationImage? backgroundImage;

  /// The color of the text (both [title] and [subtitle]).
  ///
  /// If null, the text color typically falls back to a default theme color.
  final Color? textColor;

  /// Creates a [GtSlideData] instance.
  const GtSlideData({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.backgroundColor,
    this.backgroundImage,
    this.textColor,
  });
}

/// A data class that represents the content and styling for a single slide
/// within a carousel or onboarding screen, such as `GtOnboardingSlides`.
class GtOnboardingSlideData {
  /// The primary heading text displayed on the slide.
  final String title;

  /// The alignment of the [title].
  ///
  /// Defaults to `.center`.
  final TextAlign? titleTextAlign;

  /// The main image or illustration to display on the slide.
  final ImageProvider image;

  /// An optional image that covers the content area.
  final AppImageData? contentImage;

  /// An optional background image that covers the slide.
  final double? contentImageWidth;

  final Widget? contentImageSpacer;

  /// The color of the text (both [title] and [subtitle]).
  ///
  /// If null, the text color typically falls back to a default theme color.
  final Color? textColor;

  /// Creates a [GtOnboardingSlideData] instance.
  const GtOnboardingSlideData({
    required this.title,
    required this.image,
    this.contentImage,
    this.textColor,
    this.titleTextAlign = .center,
    this.contentImageWidth,
    this.contentImageSpacer,
  });
}

/// Represents the current playback or display state of a slide.
enum GtLessonSlideState {
  /// The slide is currently being displayed or played.
  active,

  /// The slide has finished its display duration.
  done,

  /// The slide has not yet been displayed.
  pending;

  /// Determines the slide state based on its [index] relative to the [currentIndex].
  factory GtLessonSlideState.fromIndex(int index, int currentIndex) {
    if (index == currentIndex) return active;
    if (index > currentIndex) return pending;
    return done;
  }
}

/// Defines the type of content a lesson slide contains.
enum GtLessonSlideType {
  /// A slide that primarily contains text content.
  text,

  /// A slide that primarily displays a static image.
  image,

  /// A slide that contains audio or video media.
  audioVisual;

  /// Returns `true` if the slide is a text slide.
  bool get isText => this == text;

  /// Returns `true` if the slide is an image slide.
  bool get isImage => this == image;

  /// Returns `true` if the slide is an audio-visual slide.
  bool get isAudioVisual => this == audioVisual;
}

/// Abstract representation of a header displayed over a slide.
///
/// Typically used to show context like the lesson title, author, or a brief subtitle.
class GtLessonSlideHeader extends AppEquatable {
  /// The primary title text of the header.
  final String title;

  /// The secondary subtitle text of the header.
  final String subTitle;

  /// Creates a [GtLessonSlideHeader] instance.
  const GtLessonSlideHeader({required this.title, required this.subTitle});

  @override
  List<Object?> get props => [title, subTitle];
}

/// Defines a background image to be rendered behind the slide content.
class GtLessonSlideImage extends AppEquatable {
  /// The image data to display.
  final AppImageData image;

  /// How the image should be inscribed into the available space.
  final BoxFit? fit;

  /// How to align the image within its bounds.
  final Alignment alignment;

  /// The positional offset for the background image.
  final Offset offset;

  /// Whether the background image should have an animation applied.
  final bool animate;

  /// Optional fixed width for the background image.
  final double? width;

  /// Optional fixed height for the background image.
  final double? height;

  /// The rotation of the background image in radians.
  final double rotation;

  /// Creates a [GtLessonSlideImage] instance.
  const GtLessonSlideImage({
    required this.image,
    this.fit,
    this.alignment = .center,
    required this.offset,
    this.animate = true,
    this.width,
    this.height,
    this.rotation = 0,
  });

  @override
  List<Object?> get props => [
    image,
    fit,
    alignment,
    offset,
    animate,
    width,
    height,
    rotation,
  ];
}

/// A comprehensive data model representing the content, styling, and behavior
/// of a single lesson slide (e.g., in a story-style format).
class GtLessonSlideData extends AppEquatable {
  /// The header information displayed over the slide content.
  final GtLessonSlideHeader header;

  /// The main title of the slide.
  final String title;

  /// The primary text content for text-based slides.
  final String? text;

  /// The background color of the slide.
  final Color? color;

  /// A gradient applied to the background of the slide.
  final Gradient? gradient;

  /// The color of content drawn directly on the slide background, namely the
  /// app bar [title] and the cancel button.
  ///
  /// Pair this with [color]: that background is caller-supplied while the
  /// default foreground comes from the active palette, so the two are only
  /// guaranteed to contrast when the caller states both. Leave it null to keep
  /// the palette default.
  final Color? foregroundColor;

  /// The color of text drawn on the slide's content card, namely the [header]
  /// and the body [text].
  ///
  /// Pair this with [gradient], which paints that card. Distinct from
  /// [foregroundColor] because the card and the slide background are different
  /// surfaces: the card falls back to a palette color, so a foreground chosen
  /// for a dark [color] would be unreadable on it. Null keeps the palette
  /// default.
  final Color? contentColor;

  /// The media content (image, video, or audio) for the slide.
  final AppMediaData? media;

  /// The explicit type of the slide.
  final GtLessonSlideType slideType;

  /// Optional alignment for the media content.
  final Alignment? imageAlignment;

  /// Optional alignment for the media content.
  final double? imageSize;

  /// Creates a [GtLessonSlideData] instance.
  const GtLessonSlideData({
    required this.title,
    this.color,
    required this.header,
    this.gradient,
    required this.slideType,
    this.media,
    this.imageAlignment,
    this.text,
    this.imageSize,
    this.foregroundColor,
    this.contentColor,
  });

  /// Creates a slide that primarily displays an image.
  const GtLessonSlideData.withImage({
    required AppImageData data,
    required Alignment alignment,
    required this.title,
    this.color,
    required this.header,
    this.gradient,
    this.imageSize = 240,
    this.foregroundColor,
    this.contentColor,
  }) : slideType = .image,
       imageAlignment = alignment,
       media = data,
       text = null;

  /// Creates a slide that primarily displays text.
  const GtLessonSlideData.withText({
    required this.header,
    required String data,
    required this.title,
    this.color,
    this.gradient,
    this.foregroundColor,
    this.contentColor,
  }) : slideType = .text,
       media = null,
       imageSize = null,
       imageAlignment = null,
       text = data;

  /// Creates a slide that primarily displays text.
  const GtLessonSlideData.withHeader({
    required GtLessonSlideHeader data,
    required this.title,
    this.color,
    this.gradient,
    this.foregroundColor,
    this.contentColor,
  }) : slideType = .text,
       media = null,
       header = data,
       imageSize = null,
       imageAlignment = null,
       text = null;

  /// Creates a slide that displays audio or video media.
  const GtLessonSlideData.withAV({
    required AppAvData data,
    required this.title,
    required this.header,
    this.color,
    this.gradient,
    this.foregroundColor,
    this.contentColor,
  }) : media = data,
       slideType = .audioVisual,
       imageAlignment = null,
       imageSize = null,
       text = null;

  /// Calculates the display duration of the slide based on its content.
  ///
  /// Text slides calculate reading time, audio-visual slides use the media duration,
  /// and image slides default to 20 seconds.
  Duration get duration {
    if (slideType.isText) return _getTextDuration;
    if (slideType.isAudioVisual) return _getAvDuration;
    return 10.seconds;
  }

  /// Extracts the duration from the underlying video or YouTube controller.
  Duration get _getAvDuration {
    try {
      if (media is! AppAvData) return 0.seconds;
      final data = media as AppAvData;
      Duration? duration;

      if (data.isYoutube) {
        duration = data.youtubeController?.value.metaData.duration;
      }
      if (data.isVideo) {
        duration = data.videoController?.value.duration;
      }

      return duration ?? 90.seconds;
    } catch (e, t) {
      AppLogger.severe("$e", error: e, stackTrace: t);
      return 90.seconds;
    }
  }

  /// Calculates the duration required to read the text content of the slide.
  ///
  /// Assumes an average reading speed of 200 words per minute.
  Duration get _getTextDuration {
    try {
      final title = header.title;
      final sub = header.subTitle;
      final content = "${text ?? ''} $title $sub";

      if (!content.hasValue) return 0.seconds;

      final words = content.split(" ");
      final factor = words.length / 200;
      return ((factor * 60).round()).seconds;
    } catch (e, t) {
      AppLogger.severe("$e", error: e, stackTrace: t);
      return 0.seconds;
    }
  }

  @override
  List<Object?> get props => [
    header,
    title,
    text,
    color,
    gradient,
    media,
    slideType,
    imageAlignment,
    foregroundColor,
    contentColor,
  ];
}

/// Provides helpful getters for calculating progress and buffering state
/// from [MediaPlayStreamData].
extension MediaPlayStreamDataExtension on MediaPlayStreamData {
  /// Returns the current playback progress as a fraction between 0.0 and 1.0.
  ///
  /// Returns `null` if the duration or position is 0, which usually indicates
  /// that the media hasn't loaded properly yet.
  double? get progress {
    if (duration.inMilliseconds == 0 || position.inMilliseconds == 0) {
      return null;
    }
    return position.inMilliseconds / duration.inMilliseconds;
  }

  /// Indicates whether the media is currently buffering.
  bool get isBuffering => state == .buffering;
}

/// Manages the state and playback of a sequence of [GtLessonSlideData] objects.
///
/// This controller handles automatic progression between slides, media initialization,
/// animation controllers for timed slides, and pausing/resuming based on user interactions.
final class GtLessonslideController extends ChangeNotifier {
  int _currentIndex = 0;
  MediaSource? _mediaSource;
  AppMediaPlayer? _mediaPlayer;

  /// The list of slides to display.
  List<GtLessonSlideData> slides;

  /// The progress animation for the active slide.
  ///
  /// This controller only *borrows* the animation: it is created, and must be
  /// disposed, by the widget that supplies the [TickerProvider] (see
  /// [attachProgress]). Owning it here would outlive that widget's ticker and
  /// trip `TickerProviderStateMixin`'s active-ticker assertion on teardown.
  AnimationController? _animationController;
  StreamSubscription<MediaPlayStreamData>? _streamSubscription;
  StreamController<MediaPlayStreamData>? _streamController;

  /// Optional callback invoked when the user tries to advance past the final slide.
  VoidCallback? onStoryCompleted;

  int _generation = 0;
  bool _disposed = false;

  /// Creates a new [GtLessonslideController] with an optional initial list of [slides].
  GtLessonslideController({this.slides = const [], this.onStoryCompleted});

  /// The index of the currently active slide.
  int get currentIndex => _currentIndex;

  /// The loaded [MediaSource] for the current audio/visual slide, if any.
  MediaSource? get mediaSource => _mediaSource;

  /// Returns the current [GtLessonSlideData] being displayed.
  GtLessonSlideData get currentSlide => slides[_currentIndex];

  /// The animation controller used to track progress for non-media slides.
  AnimationController? get animationController => _animationController;

  /// A stream of [MediaPlayStreamData] events broadcasted from the underlying media player.
  StreamController<MediaPlayStreamData>? get streamController =>
      _streamController;

  /// Navigates to the previous slide.
  void prev() => currentIndex = _currentIndex - 1;

  /// Navigates to the next slide.
  void next() => currentIndex = _currentIndex + 1;

  void jumpTo(int index) => currentIndex = index;

  /// Sets the current slide index.
  ///
  /// If the new index is out of bounds or unchanged, it will be ignored.
  /// Changing the index will automatically stop and reset any active media or animations.
  set currentIndex(int value) {
    final maxIndex = (slides.length - 1);

    if (value == currentIndex) return;
    if (value < 0) return;

    if (value > maxIndex) {
      onStoryCompleted?.call();
      return;
    }

    reset(resetIndex: false, notify: false);
    _currentIndex = value.clamp(0, maxIndex);
    notifyListeners();
  }

  @override
  void notifyListeners([bool defer = false]) {
    if (_disposed) return;

    if (defer) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // The owner may have disposed us between scheduling this callback and
        // the end of the frame, e.g. when the user routes away mid-animation.
        if (_disposed) return;
        super.notifyListeners();
      });
      return;
    }

    super.notifyListeners();
  }

  /// Pauses the current slide progression and media playback when the user presses down.
  void onLongPressDown() => pause();

  /// Resumes slide progression and media playback when the user lifts their press.
  void onLongPressUp() => play();

  /// Starts or resumes media playback and slide animations.
  void play() {
    _mediaPlayer?.play();
    _animationController?.forward(from: _animationController?.value);
  }

  /// Starts or resumes media playback and slide animations.
  void seekTo(Duration duration) => _mediaPlayer?.seekTo(duration);

  /// Pauses active media playback and stops slide animations.
  void pause() {
    _mediaPlayer?.pause();
    _animationController?.stop();
  }

  /// Toggles the mute state of the media player.
  void toggleMute() {
    _mediaPlayer?.toggleMute();
  }

  void _statusListener(AnimationStatus status) {
    if (status != .completed) return;

    // A zero-duration slide completes synchronously inside `forward()`, which
    // runs during the indicator's `initState`. Advancing there would call
    // `notifyListeners` mid-build, so defer until the frame is done.
    final phase = SchedulerBinding.instance.schedulerPhase;
    final isBuilding =
        phase == SchedulerPhase.persistentCallbacks ||
        phase == SchedulerPhase.midFrameMicrotasks;

    if (isBuilding) {
      final index = _currentIndex;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Skip if something else already advanced us, so a tap in the same
        // frame does not compound with this into a two-slide jump.
        if (_disposed || _currentIndex != index) return;
        next();
      });
      return;
    }

    next();
  }

  /// Binds a widget-owned progress [animation] to this controller.
  ///
  /// The caller keeps ownership and must dispose the animation itself, calling
  /// [detachProgress] first. This controller only drives it via [play] and
  /// [pause] and listens for completion to advance to the next slide.
  void attachProgress(AnimationController animation) {
    if (identical(_animationController, animation)) return;

    _animationController?.removeStatusListener(_statusListener);
    _animationController = animation;
    animation.addStatusListener(_statusListener);
  }

  /// Unbinds a previously [attachProgress]ed [animation].
  ///
  /// Ignored when [animation] is not the currently attached one, so a stale
  /// indicator tearing down cannot detach the active slide's progress.
  void detachProgress(AnimationController animation) {
    if (!identical(_animationController, animation)) return;

    animation.removeStatusListener(_statusListener);
    _animationController = null;
  }

  /// Loads the media for the current slide when it is audio-visual.
  ///
  /// Non audio-visual slides track progress through [attachProgress] instead,
  /// so this is a no-op for them.
  Future<void> initialiseProgress() async {
    try {
      if (currentSlide.slideType != .audioVisual) return;
      await _initialisePlayer();
    } catch (e, t) {
      AppLogger.severe("$e", stackTrace: t, error: e);
      next();
    }
  }

  Future<void> _initialisePlayer() async {
    if (currentSlide.media is! AppAvData) return;

    final generation = _generation;
    final player = AppMediaPlayer();
    _mediaPlayer = player;

    final source = await player.createSource(currentSlide.media as AppAvData);

    if (generation != _generation || _disposed) {
      // The user navigated away while we were loading. Abort.
      await player.dispose();
      return;
    }

    final streamController = StreamController<MediaPlayStreamData>.broadcast();
    _mediaSource = source;
    _streamController = streamController;
    notifyListeners();

    _streamSubscription = player.getSourceEvents().listen((data) {
      // `next()` below tears this stream down, and the player can emit again
      // before the cancellation lands, so re-check before touching either.
      if (generation != _generation || _disposed) return;
      if (!streamController.isClosed) streamController.add(data);

      final limit = (source?.isYoutube ?? false) ? .99 : 1;
      if ((data.progress ?? 0) >= limit) next();
    });
  }

  /// Replaces the current [slides] with a new list and resets playback to the first slide.
  void updateSlides(List<GtLessonSlideData> slides) {
    reset(notify: false);
    this.slides = slides;
    notifyListeners();
  }

  /// Resets the internal state, stopping media and animations.
  ///
  /// If [resetIndex] is true, it also returns the current slide index to 0.
  /// If [notify] is true, it notifies listeners to rebuild the UI.
  void reset({bool notify = true, bool resetIndex = true}) {
    if (resetIndex) _currentIndex = 0;

    // Invalidates any media load still in flight so it cannot attach itself to
    // the state we are about to rebuild.
    _generation++;

    // Only stop and detach: the animation belongs to the widget that supplied
    // the ticker, which disposes it in its own `dispose`. `isAnimating` is
    // false once that has happened, which keeps this safe if the owner tears
    // down before the controller does.
    final animation = _animationController;
    if (animation != null) {
      if (animation.isAnimating) animation.stop();
      detachProgress(animation);
    }

    // Clear the fields synchronously so the next slide starts from a clean
    // slate, then tear the captured instances down off the critical path.
    final player = _mediaPlayer;
    final subscription = _streamSubscription;
    final streamController = _streamController;
    _mediaSource = null;
    _mediaPlayer = null;
    _streamSubscription = null;
    _streamController = null;

    unawaited(_teardownMedia(player, subscription, streamController));

    if (notify) notifyListeners(true);
  }

  /// Releases a detached media player and its stream plumbing.
  ///
  /// [AppMediaPlayer.dispose] unloads the active source, so it covers what
  /// `unloadSource` did and additionally drops the player's own reference.
  Future<void> _teardownMedia(
    AppMediaPlayer? player,
    StreamSubscription<MediaPlayStreamData>? subscription,
    StreamController<MediaPlayStreamData>? streamController,
  ) async {
    try {
      await subscription?.cancel();
      await player?.dispose();
      if (streamController != null && !streamController.isClosed) {
        await streamController.close();
      }
    } catch (e, t) {
      AppLogger.severe("$e", stackTrace: t, error: e);
    }
  }

  @override
  void dispose() {
    reset(notify: false);
    _disposed = true;

    super.dispose();
  }
}
