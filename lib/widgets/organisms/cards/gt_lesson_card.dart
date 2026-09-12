import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A card widget specifically designed to display lesson or course information.
///
/// Includes an illustration, title, description, and progress indicators
/// such as completed lessons and watched duration.
class GtLessonCard extends GtStatelessWidget {
  /// Overrides gradient. Null preserves the current default.
  final Gradient? gradient;

  /// Overrides background color. Null preserves the current default.
  final Color? backgroundColor;

  /// Overrides illustration padding. Null preserves the current default.
  final EdgeInsetsGeometry? illustrationPadding;

  /// Overrides padding. Null preserves the current default.
  final EdgeInsetsGeometry? padding;

  /// Overrides title style. Null preserves the current default.
  final TextStyle? titleStyle;

  /// Overrides title color. Null preserves the current default.
  final Color? titleColor;

  /// Overrides description style. Null preserves the current default.
  final TextStyle? descriptionStyle;

  /// Overrides description color. Null preserves the current default.
  final Color? descriptionColor;

  /// Overrides vertical spacing in logical pixels. Null preserves the current default.
  final double? verticalSpacing;

  /// Overrides section spacing in logical pixels. Null preserves the current default.
  final double? sectionSpacing;

  /// Overrides info style. Null preserves the current default.
  final TextStyle? infoStyle;

  /// Overrides info color. Null preserves the current default.
  final Color? infoColor;

  /// Overrides info spacing in logical pixels. Null preserves the current default.
  final double? infoSpacing;

  /// Overrides info run spacing in logical pixels. Null preserves the current default.
  final double? infoRunSpacing;

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

  /// The background color of the card.
  final Color? cardBackgroundColor;

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
    this.cardBackgroundColor,
    required this.onTap,
    this.gradient,
    this.backgroundColor,
    this.illustrationPadding,
    this.padding,
    this.titleStyle,
    this.titleColor,
    this.descriptionStyle,
    this.descriptionColor,
    this.verticalSpacing,
    this.sectionSpacing,
    this.infoStyle,
    this.infoColor,
    this.infoSpacing,
    this.infoRunSpacing,
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
    final gradient = this.gradient ?? variant.getGradient(context);

    return GtCard(
      // Identity only. Folding the watch progress in here rebuilt the card
      // from scratch every time the lesson advanced, which restarted the
      // progress fill; the bar animates to its new value on its own.
      key: ValueKey(('gt-lesson-card', title)),
      onPressed: context.scrollIntoViewNow,
      constraints: BoxConstraints(maxWidth: context.fractionalShortest(.55)),
      color: backgroundColor ?? context.palette.bg.white,
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
              padding:
                  illustrationPadding ??
                  context.insets.symmetricDp(vertical: 2.px),
              decoration: BoxDecoration(gradient: gradient),
              child: GtImage(
                image: illustration,
                height: context.dp(150.px),
                alignment: .center,
                isDecorative: true,
              ),
            ),
          ),
          Flexible(
            child: GtCard(
              padding:
                  padding ??
                  context.insets.symmetricDp(
                    vertical: 16.px,
                    horizontal: 12.px,
                  ),
              color: cardBackgroundColor,
              onPressed: onTap,
              borderRadius: .zero,
              child: Column(
                spacing: verticalSpacing ?? context.spacingSm,
                crossAxisAlignment: .start,
                mainAxisAlignment: .start,
                children: [
                  if (hasWatchedLessons) ...[
                    (sectionSpacing == null
                        ? const GtGap.yBase()
                        : SizedBox(height: sectionSpacing)),
                    GtAnimatedProgress(value: watchFraction),
                    (sectionSpacing == null
                        ? const GtGap.yBase()
                        : SizedBox(height: sectionSpacing)),
                  ],
                  GtText(
                    title.upper,
                    style: GtTextStyleOverrides.resolve(
                      titleStyle,
                      context.textStyles.button(),
                      titleColor,
                    ),
                    overflow: .ellipsis,
                    maxLines: 1,
                  ),
                  Flexible(
                    child: GtText(
                      description,
                      maxLines: hasWatchedLessons ? 1 : 2,
                      overflow: .ellipsis,
                      style: GtTextStyleOverrides.resolve(
                        descriptionStyle,
                        context.textStyles.body2s(
                          color: context.palette.text.darkerSub,
                        ),
                        descriptionColor,
                      ),
                    ),
                  ),
                  (sectionSpacing == null
                      ? const GtGap.yBase()
                      : SizedBox(height: sectionSpacing)),
                  GtLessonInfoTile(
                    style: infoStyle,
                    textColor: infoColor,
                    spacing: infoSpacing,
                    runSpacing: infoRunSpacing,
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
  /// Overrides spacing in logical pixels. Null preserves the current default.
  final double? spacing;

  /// Overrides run spacing in logical pixels. Null preserves the current default.
  final double? runSpacing;

  /// Overrides style. Null preserves the current default.
  final TextStyle? style;

  /// Overrides text color. Null preserves the current default.
  final Color? textColor;

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
    this.spacing,
    this.runSpacing,
    this.style,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing ?? context.spacingMd,
      runSpacing: runSpacing ?? context.spacingBase,
      alignment: alignment ?? .start,
      crossAxisAlignment: crossAlignment ?? .start,
      children: [
        GtSimpleInfoTile(
          style: style,
          textColor: textColor,
          leading: GtSvg(
            GtVectors.coin,
            width: 16,
            height: 16,
            isDecorative: true,
          ),
          text: progress,
        ),
        GtSimpleInfoTile(
          style: style,
          textColor: textColor,
          leading: GtSvg(
            GtVectors.clock,
            width: 16,
            height: 16,
            color: context.palette.feature.dark,
            isDecorative: true,
          ),
          text: progressDuration,
        ),
      ],
    );
  }
}
