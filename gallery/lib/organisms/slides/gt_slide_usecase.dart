import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtWelcomeSlide', type: GtWelcomeSlide)
Widget playgroundGtWelcomeSlideUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtWelcomeSlide',
    description: 'A full-screen slide component typically used inside welcome/onboarding flows.',
    code: '''
GtWelcomeSlide(
  slide: GtSlideData(
    title: "Welcome to Sterling",
    subtitle: "Your financial partner",
    image: const AppImageData.asset("assets/images/placeholder.png"),
    backgroundColor: context.palette.primary.base,
    textColor: context.palette.text.white,
  ),
)''',
    child: Center(
      child: GtCard(
        padding: context.insets.allDp(24.px),
        variant: GtCardVariant.normal,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: context.spacingMd,
          children: [
            const GtIcon(GtIcons.spark, size: 48),
            GtText(
              "Please refer to the visual display page in Widgetbook to preview the onboarding slide widgets in their full-screen/animated context.",
              style: context.textStyles.bodyS(color: context.palette.text.sub),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}
