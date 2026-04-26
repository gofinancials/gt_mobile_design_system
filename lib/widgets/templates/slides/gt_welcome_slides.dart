import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtWelcomeSlides extends GtStatelessWidget {
  final List<GtSlideData> slides;
  final bool showLogo;
  final Color? iconColor;
  final Color? activeDotColor;
  final Color? inActiveDotColor;

  const GtWelcomeSlides({
    super.key,
    required this.slides,
    this.showLogo = true,
    this.iconColor,
    this.activeDotColor,
    this.inActiveDotColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}
