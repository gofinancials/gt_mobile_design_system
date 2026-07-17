import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/data/models/media_data.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtWelcomeSlide', type: GtWelcomeSlide)
Widget playgroundGtWelcomeSlideUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtWelcomeSlide',
    description:
        'A full-screen slide component typically used inside welcome/onboarding flows.',
    code: '''
GtWelcomeSlide(
  slide: GtSlideData(
    title: "Welcome to Sterling",
    subtitle: "Your financial partner",
    image: const AppImageData(GtVectorIllustrations.announcement),
    backgroundColor: context.palette.primary.base,
    textColor: context.palette.text.white,
  ),
)''',
    child: GtWelcomeSlide(
      slide: GtSlideData(
        title: "Welcome to Sterling",
        subtitle: "Your financial partner",
        image: const AppImageData(GtVectorIllustrations.announcement),
        backgroundColor: context.palette.primary.base,
        textColor: context.palette.text.white,
      ),
    ),
  );
}
