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
