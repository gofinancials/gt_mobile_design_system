import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtWelcomeSlide', type: GtWelcomeSlide)
Widget playgroundGtWelcomeSlideUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtWelcomeSlide',
    description: 'Documentation for GtWelcomeSlide',
    code: '''
GtWelcomeSlide(
  slide: GtSlideData(
    title: "Welcome to Sterling",
    subtitle: "Your financial partner",
    image: const AppImageData.asset("assets/images/placeholder.png"),
    backgroundColor: context.palette.primary.base,
    textColor: context.palette.text.white,
  ),
)
''',
    child: GtWelcomeSlide(
      slide: GtSlideData(
        title: "Welcome to Sterling",
        subtitle: "Your financial partner",
        image: const AppImageData.asset("assets/images/placeholder.png"),
        backgroundColor: context.palette.primary.base,
        textColor: context.palette.text.white,
      ),
    ),
  );
}
