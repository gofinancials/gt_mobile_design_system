import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A template screen displayed when a user successfully completes a lesson.
///
/// This screen uses a view state layout to show an illustration, a [title],
/// and a [subtitle]. It also includes a bottom navigation area with a
/// [primaryButton] and a [secondaryButton] for the next actions.
class GtLessonCompleteScreen extends GtStatelessWidget {
  /// An optional custom image to display above the title.
  ///
  /// If null, defaults to a celebration illustration.
  final AppImageData? image;

  /// The primary headline text displayed on the screen.
  final String title;

  /// The descriptive text displayed beneath the title.
  final String subtitle;

  /// The primary call-to-action button (e.g., "Start Saving").
  final GtButton primaryButton;

  /// The secondary action button (e.g., "back to learn").
  final GtButton secondaryButton;

  /// Creates a [GtLessonCompleteScreen].
  const GtLessonCompleteScreen({
    super.key,
    this.image,
    required this.title,
    required this.subtitle,
    required this.primaryButton,
    required this.secondaryButton,
  });

  @override
  Widget build(BuildContext context) {
    final styles = context.textStyles;

    return Scaffold(
      bottomNavigationBar: GtButtonBottomNavBar(
        heading: primaryButton,
        button: secondaryButton,
        spacing: context.spacingMd,
      ),
      appBar: const GtAppBar(),
      body: Padding(
        padding: context.insets.defaultAllInsets,
        child: GtViewStateWidget(
          title: title,
          description: subtitle,
          gapToTitle: const GtViewStateGapSpacer(GtGap.ySectionSm()),
          icon: image ?? AppImageData(GtVectorIllustrations.celebration),
          titleStyle: styles.h4(),
          descriptionStyle: styles.bodyS(),
        ),
      ),
    );
  }
}
