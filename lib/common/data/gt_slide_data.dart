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

enum GtLessonSlideState {
  active,
  done,
  pending;

  factory GtLessonSlideState.fromIndex(int index, int currentIndex) {
    if (index == currentIndex) return active;
    if (index > currentIndex) return pending;
    return done;
  }
}

enum GtLessonSlideType {
  text,
  image,
  audioVisual;

  bool get isText => this == text;
  bool get isImage => this == image;
  bool get isAudioVisual => this == audioVisual;
}

abstract class GtLessonSlideHeader {
  final String title;
  final String subTitle;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final bool embedSubtitleInCard;
  final Offset offset;

  const GtLessonSlideHeader({
    required this.title,
    required this.subTitle,
    this.titleStyle,
    this.subtitleStyle,
    this.embedSubtitleInCard = false,
    this.offset = Offset.zero,
  });
}

abstract class GtLessonSlideBackgroundImage {
  final AppImageData image;
  final BoxFit? fit;
  final Alignment alignment;
  final Offset offset;

  const GtLessonSlideBackgroundImage({
    required this.image,
    this.fit,
    this.alignment = Alignment.center,
    required this.offset,
  });
}

class GtLessonSlideData {
  final GtLessonSlideHeader? header;
  final String title;
  final String? text;
  final Color? color;
  final Gradient? gradient;
  final AppMediaData? media;
  final List<GtLessonSlideBackgroundImage>? backgroundImages;
  final GtLessonSlideType slideType;
  const GtLessonSlideData.withImage({
    required AppImageData image,
    required this.title,
    this.color,
    this.header,
    this.gradient,
  }) : slideType = .image,
       media = image,
       backgroundImages = null,
       text = null;

  const GtLessonSlideData.withText({
    required this.header,
    required this.text,
    required this.title,
    this.color,
    this.gradient,
    this.backgroundImages,
  }) : slideType = .text,
       media = null;

  const GtLessonSlideData.withAV({
    required AppAvData data,
    required this.title,
    this.header,
    this.color,
    this.gradient,
  }) : media = data,
       slideType = .audioVisual,
       backgroundImages = null,
       text = null;

  Duration get duration {
    if (slideType.isText) return _getTextDuration;
    if (slideType.isAudioVisual) return _getAvDuration;
    return 20.seconds;
  }

  Duration get _getAvDuration {
    try {
      if (media is! AppAvData) return 0.seconds;
      final data = media as AppAvData;
      Duration? duration;

      if (data.isYoutube) {
        duration = data.youtubeController?.metadata.duration;
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
}
