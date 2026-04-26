import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/extensions/extensions.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtWelcomeSlide extends GtStatelessWidget {
  final GtSlideData slide;

  const GtWelcomeSlide({super.key, required this.slide});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: context.insets.defaultAllInsets,
      alignment: .center,
      decoration: BoxDecoration(
        color: slide.backgroundColor,
        image: slide.backgroundImage,
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          children: [
            GtSquareConstrainedBox(
              240,
              child: GtImage(image: slide.image, height: context.dp(165.px)),
            ),
            const GtGap.ySectionXl(),
            GtText(
              slide.title.upper,
              style: context.textStyles.h2(color: slide.textColor),
              textAlign: .center,
            ),
            const GtGap.yMd(),
            GtText(
              slide.subtitle,
              style: context.textStyles.subHeadM(color: slide.textColor),
              textAlign: .center,
            ),
          ],
        ),
      ),
    );
  }
}
