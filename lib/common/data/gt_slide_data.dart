import 'package:flutter/widgets.dart';
import 'package:gt_mobile_foundation/foundation.dart';

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
