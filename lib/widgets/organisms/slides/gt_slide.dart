import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/extensions/extensions.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A stateless widget that displays a single welcome slide.
///
/// This widget is typically used within a carousel or page view, such as
/// [GtWelcomeSlides]. It renders the content defined in a [GtSlideData]
/// object, including an image, title, subtitle, and background styling.
class GtWelcomeSlide extends GtStatelessWidget {
  /// The data defining the content and styling of this slide.
  final GtSlideData slide;

  /// Creates a [GtWelcomeSlide] widget.
  const GtWelcomeSlide({super.key, required this.slide});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: context.insets.defaultHorizontalInsets,
      alignment: .center,
      decoration: BoxDecoration(
        color: slide.backgroundColor,
        image: slide.backgroundImage,
      ),
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
            style: context.textStyles.h4(color: slide.textColor),
            textAlign: .center,
            maxLines: 1,
          ),
          const GtGap.yMd(),
          GtText(
            slide.subtitle,
            style: context.textStyles.subHeadM(color: slide.textColor),
            textAlign: .center,
          ),
        ],
      ),
    );
  }
}
