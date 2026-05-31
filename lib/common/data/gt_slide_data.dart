import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:gt_mobile_foundation/foundation.dart';

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

  /// The text style for the [title].
  final TextStyle? titleStyle;

  /// The text style for the [subTitle].
  final TextStyle? subtitleStyle;

  /// Whether the subtitle should be visually embedded within a card-like container.
  final bool embedSubtitleInCard;

  /// The positional offset of the header on the slide.
  final Offset offset;

  /// Creates a [GtLessonSlideHeader] instance.
  const GtLessonSlideHeader({
    required this.title,
    required this.subTitle,
    this.titleStyle,
    this.subtitleStyle,
    this.embedSubtitleInCard = false,
    this.offset = Offset.zero,
  });

  @override
  List<Object?> get props => [
    title,
    subTitle,
    titleStyle,
    subtitleStyle,
    embedSubtitleInCard,
    offset,
  ];
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
  final GtLessonSlideHeader? header;

  /// The main title of the slide.
  final String title;

  /// The primary text content for text-based slides.
  final String? text;

  /// The background color of the slide.
  final Color? color;

  /// The color of the text on the slide.
  final Color? textColor;

  /// A gradient applied to the background of the slide.
  final Gradient? gradient;

  /// The media content (image, video, or audio) for the slide.
  final AppMediaData? media;

  /// A list of background images to layer behind the slide content.
  final List<GtLessonSlideImage>? backgroundImages;

  /// The explicit type of the slide.
  final GtLessonSlideType slideType;

  /// Optional alignment for the media content.
  final Alignment? imageAlignment;

  /// Creates a slide that primarily displays an image.
  const GtLessonSlideData.withImage({
    required AppImageData data,
    required Alignment alignment,
    required this.title,
    this.color,
    this.header,
    this.gradient,
  }) : slideType = .image,
       imageAlignment = alignment,
       media = data,
       backgroundImages = null,
       text = null,
       textColor = null;

  /// Creates a slide that primarily displays text.
  const GtLessonSlideData.withText({
    this.header,
    required String data,
    required this.title,
    required this.textColor,
    this.color,
    this.gradient,
    this.backgroundImages,
  }) : slideType = .text,
       media = null,
       imageAlignment = null,
       text = data;

  /// Creates a slide that primarily displays text.
  const GtLessonSlideData.withHeader({
    required GtLessonSlideHeader data,
    required this.title,
    this.color,
    this.gradient,
    this.backgroundImages,
  }) : slideType = .text,
       media = null,
       header = data,
       imageAlignment = null,
       text = null,
       textColor = null;

  /// Creates a slide that displays audio or video media.
  const GtLessonSlideData.withAV({
    required AppAvData data,
    required this.title,
    this.header,
    this.color,
    this.gradient,
  }) : media = data,
       slideType = .audioVisual,
       backgroundImages = null,
       imageAlignment = null,
       text = null,
       textColor = null;

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
      final title = header?.title ?? "";
      final sub = header?.subTitle ?? "";
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
    textColor,
    gradient,
    media,
    backgroundImages,
    slideType,
    imageAlignment,
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
  AnimationController? _animationController;
  StreamSubscription<MediaPlayStreamData>? _streamSubscription;
  StreamController<MediaPlayStreamData>? _streamController;

  /// Optional callback invoked when the user tries to advance past the final slide.
  VoidCallback? onStoryCompleted;

  int _generation = 0;

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

    _generation++;
    reset(resetIndex: false, notify: false);
    _currentIndex = value.clamp(0, maxIndex);
    notifyListeners();
  }

  @override
  void notifyListeners([bool defer = false]) {
    if (defer) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => super.notifyListeners(),
      );
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
    next();
  }

  /// Initializes the progress tracking for the current slide.
  ///
  /// For text/image slides, it initializes a timed [AnimationController].
  /// For audio-visual slides, it delegates to internal initializers to load the media.
  Future<void> initialiseProgress(TickerProvider tickerProvider) async {
    if (currentSlide.slideType != .audioVisual) {
      await _initialiseAnimation(tickerProvider);
      return;
    }
    await _initialisePlayer(tickerProvider);
  }

  Future<void> _initialiseAnimation(TickerProvider tickerProvider) async {
    _animationController = AnimationController(
      vsync: tickerProvider,
      duration: currentSlide.duration,
    )..forward();
    _animationController?.addStatusListener(_statusListener);
    notifyListeners(true);
  }

  Future<void> _initialisePlayer(TickerProvider tickerProvider) async {
    if (currentSlide.media is! AppAvData) return;

    final generation = _generation;
    _mediaPlayer = AppMediaPlayer();

    final source = await _mediaPlayer?.createSource(
      currentSlide.media as AppAvData,
    );

    if (generation != _generation) {
      // The user navigated away while we were loading. Abort.
      await _mediaPlayer?.dispose();
      return;
    }

    _mediaSource = source;
    _streamController = StreamController<MediaPlayStreamData>.broadcast();
    notifyListeners();

    _streamSubscription = _mediaPlayer?.getSourceEvents().listen((data) {
      _streamController?.add(data);
      final limit = (source?.isYoutube ?? false) ? .99 : 1;
      if ((data.progress ?? 0) >= limit) next();
    });
  }

  /// Replaces the current [slides] with a new list and resets playback to the first slide.
  void updateSlides(List<GtLessonSlideData> slides) {
    _currentIndex = 0;
    this.slides = slides;
    notifyListeners();
  }

  /// Resets the internal state, stopping media and animations.
  ///
  /// If [resetIndex] is true, it also returns the current slide index to 0.
  /// If [notify] is true, it notifies listeners to rebuild the UI.
  void reset({bool notify = true, bool resetIndex = true}) {
    if (resetIndex) _currentIndex = 0;
    _animationController?.removeStatusListener(_statusListener);
    _animationController?.stop();
    _animationController?.dispose();
    _animationController = null;
    if (_mediaSource != null) _mediaPlayer?.unloadSource(_mediaSource!);
    _mediaSource = null;
    _mediaPlayer = null;
    _streamSubscription?.cancel();
    _streamSubscription = null;
    _streamController?.close();
    _streamController = null;
    if (notify) notifyListeners(true);
  }

  @override
  void dispose() {
    reset(notify: false);
    _mediaPlayer?.dispose();
    super.dispose();
  }
}
