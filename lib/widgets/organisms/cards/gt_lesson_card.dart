import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A card widget specifically designed to display lesson or course information.
///
/// Includes an illustration, title, description, and progress indicators
/// such as completed lessons and watched duration.
class GtLessonCard extends GtStatelessWidget {
  /// The primary illustration or image displayed at the top of the card.
  final AppImageData illustration;

  /// The title of the lesson or course.
  final String title;

  /// A brief description of the lesson content.
  final String description;

  /// The total number of sub-lessons or modules contained within this lesson.
  final int totalLessons;

  /// The number of sub-lessons that have already been completed or watched.
  final int watchedLessons;

  /// The total duration of the lesson.
  final Duration duration;

  /// The amount of time that has already been spent watching the lesson.
  final Duration? watchedDuration;

  /// The visual variant of the card, determining its color scheme and gradient.
  final GtCardVariant variant;

  /// The callback triggered when the user taps on the lesson card.
  final OnPressed onTap;

  /// Creates a [GtLessonCard].
  const GtLessonCard({
    super.key,
    required this.title,
    required this.description,
    required this.totalLessons,
    required this.duration,
    required this.illustration,
    this.watchedLessons = 0,
    this.watchedDuration,
    this.variant = .featured,
    required this.onTap,
  }) : assert(watchedLessons <= totalLessons),
       assert(watchedDuration == null || watchedDuration < duration);

  /// Formatted string representing the lesson completion progress (e.g., "5/10").
  String get progress => "${watchedLessons.toString()}/$totalLessons";

  /// Formatted string representing the watched duration versus total duration (e.g., "05:00/20:00").
  String get progressDuration {
    final totalDuration = duration.inSeconds.timeCode;
    if (watchedDuration == null) return totalDuration;
    final watchDuration = watchedDuration?.inSeconds.timeCode ?? "00:00";
    return "$watchDuration/$totalDuration";
  }

  /// Indicates whether the user has started watching any lessons.
  bool get hasWatchedLessons => watchedLessons > 0;

  /// Calculates the completion fraction based on watched versus total lessons, clamped between 0.0 and 1.0.
  double get watchFraction => (watchedLessons / totalLessons).clamp(0, 1);

  @override
  Widget build(BuildContext context) {
    final gradient = variant.getGradient(context);

    return GtCard(
      key: ValueKey('gt-lesson-card-$title-$watchFraction-$progressDuration'),
      onPressed: context.scrollIntoViewNow,
      constraints: BoxConstraints(maxWidth: context.fractionalShortest(.55)),
      color: context.palette.bg.white,
      padding: .zero,
      borderRadius: context.borderRadiusXl,
      shadows: context.shadows.lg(),
      child: Column(
        crossAxisAlignment: .start,
        mainAxisSize: .min,
        children: [
          Expanded(
            child: Container(
              constraints: BoxConstraints(minHeight: context.dp(126)),
              padding: context.insets.symmetricDp(vertical: 2.px),
              decoration: BoxDecoration(gradient: gradient),
              child: GtImage(
                image: illustration,
                height: context.dp(150.px),
                alignment: .center,
              ),
            ),
          ),
          Flexible(
            child: GtCard(
              padding: context.insets.symmetricDp(
                vertical: 16.px,
                horizontal: 12.px,
              ),
              onPressed: onTap,
              borderRadius: .zero,
              child: Column(
                spacing: context.spacingSm,
                crossAxisAlignment: .start,
                mainAxisAlignment: .start,
                children: [
                  if (hasWatchedLessons) ...[
                    const GtGap.yBase(),
                    GtAnimatedProgress(value: watchFraction),
                    const GtGap.yBase(),
                  ],
                  GtText(
                    title.upper,
                    style: context.textStyles.h6(),
                    overflow: .ellipsis,
                    maxLines: 1,
                  ),
                  Flexible(
                    child: GtText(
                      description,
                      maxLines: hasWatchedLessons ? 1 : 2,
                      overflow: .ellipsis,
                      style: context.textStyles.bodyS(
                        color: context.palette.text.darkerSub,
                      ),
                    ),
                  ),
                  const GtGap.yBase(),
                  GtLessonInfoTile(
                    progress: progress,
                    progressDuration: progressDuration,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A supporting widget for [GtLessonCard] that displays the lesson's progress
/// and duration side-by-side using icons and text.
class GtLessonInfoTile extends GtStatelessWidget {
  /// The formatted string representing the lesson completion progress.
  final String progress;

  /// The formatted string representing the watched duration versus total duration.
  final String progressDuration;

  /// How the information tiles should be placed along the main axis.
  final WrapAlignment? alignment;

  /// How the information tiles should be aligned relative to each other in the cross axis.
  final WrapCrossAlignment? crossAlignment;

  /// Creates a [GtLessonInfoTile].
  const GtLessonInfoTile({
    super.key,
    required this.progress,
    required this.progressDuration,
    this.alignment,
    this.crossAlignment,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: context.spacingMd,
      runSpacing: context.spacingBase,
      alignment: alignment ?? .start,
      crossAxisAlignment: crossAlignment ?? .start,
      children: [
        GtSimpleInfoTile(
          leading: GtSvg(GtVectors.coin, width: 16, height: 16),
          text: progress,
        ),
        GtSimpleInfoTile(
          leading: GtSvg(
            GtVectors.clock,
            width: 16,
            height: 16,
            color: context.palette.feature.dark,
          ),
          text: progressDuration,
        ),
      ],
    );
  }
}
