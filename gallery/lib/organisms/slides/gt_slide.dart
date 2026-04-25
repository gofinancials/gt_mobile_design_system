import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/data/models/media_data.dart';
import 'package:gt_mobile_foundation/extensions/extensions.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

@widgetbook.UseCase(name: 'GtSectionSlide', type: GtSectionSlide)
Widget buildGtSectionSlideUsecase(BuildContext context) {
  void showToast() {
    context.showToast("Clicked Lesson Card", type: .highlighted);
  }

  final featured = [
    GtLessonCard(
      title: 'Saving Smart',
      description: 'Why saving matters and how to build good habits.',
      totalLessons: 10,
      duration: 5.minutes,
      illustration: AppImageData(imageData: GtVectorIllustrations.grow),
      variant: .featured,
      onTap: showToast,
    ),
    GtLessonCard(
      title: 'spending Wisely',
      description: 'Learn to choose between needs and wants.',
      totalLessons: 8,
      duration: 4.minutes,
      illustration: AppImageData(imageData: GtVectorIllustrations.moneyPhone),
      variant: .verified,
      onTap: showToast,
    ),
    GtLessonCard(
      title: 'Resource Management',
      description:
          'Learn to manage your resources effectively, and cope with scarcity.',
      totalLessons: 15,
      duration: 20.minutes,
      illustration: AppImageData(imageData: GtVectorIllustrations.fuel),
      variant: .normal,
      onTap: showToast,
    ),
  ];
  final completed = [
    GtLessonCard(
      title: 'money & safety',
      description: 'How to keep your money and PIN safe.',
      totalLessons: 10,
      watchedLessons: 5,
      duration: 5.minutes,
      watchedDuration: 4.minutes,
      illustration: AppImageData(imageData: GtVectorIllustrations.security),
      variant: .warning,
      onTap: showToast,
    ),
  ];

  return Scaffold(
    appBar: GtTitleAppBar(title: "LEARN"),
    body: CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: context.insets.fromLTRBDp(16.px, 12.px, 16.px, 24.px),
            child: GtText(
              "This showcases our standardised GtSectionSlide Widget using our GtLessonCard Widget as slides",
              style: context.textStyles.subHeadM(
                color: context.palette.text.darkerSub,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: GtSectionSlide(title: "Featured", children: featured),
        ),
        SliverToBoxAdapter(
          child: GtSectionSlide(title: "Completed", children: completed),
        ),
        SliverToBoxAdapter(
          child: GtSectionSlide(
            title: "Savings & Investments",
            children: [...featured, ...completed],
          ),
        ),
      ],
    ),
  );
}
