import 'package:flutter/widgets.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/common/common.dart';

class GtSlideData {
  final String title;
  final String subtitle;
  final AppImageData image;
  final Color backgroundColor;
  final DecorationImage? backgroundImage;
  final Color? textColor;

  const GtSlideData({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.backgroundColor,
    this.backgroundImage,
    this.textColor,
  });
}

extension GtSlideDataExtension on GtSlideData {
  List<GtSlideData> getPersonalAppSlides(BuildContext context) {
    final palette = context.palette;
    return [
      GtSlideData(
        title: "And more...",
        subtitle: "Buy, sell, save or schedule with peace of mind",
        image: AppImageData(imageData: GtVectorIllustrations.date),
        backgroundColor: palette.success.darker,
        textColor: palette.text.white,
      ),
      GtSlideData(
        title: "BLAZING FAST",
        subtitle: "Pay someone, buy something, or sort your bills",
        image: AppImageData(imageData: GtVectorIllustrations.bolt),
        backgroundColor: palette.primary.base,
        textColor: palette.text.white,
      ),
      GtSlideData(
        title: "we’ve got deals!",
        subtitle: "Saving big on everything, stress, subscriptions etc",
        image: AppImageData(imageData: GtVectorIllustrations.celebration),
        backgroundColor: palette.away.base,
        textColor: palette.text.white,
      ),
      GtSlideData(
        title: "SEND MONEY",
        subtitle: "Pay someone, buy something, or sort your bills",
        image: AppImageData(imageData: GtVectorIllustrations.date),
        backgroundColor: palette.feature.base,
        textColor: palette.text.white,
      ),
    ];
  }
}
