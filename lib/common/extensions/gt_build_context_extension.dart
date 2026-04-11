import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

extension BuildContextExtension on BuildContext {
  GtScaleUtil get _scaler => GtScaleUtil.of(this);
  GtMediaQueryData get mediaQueryData => GtMediaQueryData(this);
  GtFractionalSizer get fracSizer => _scaler.fracSizer;
  GtDpiIndependentSizer get dpSizer => _scaler.dpSizer;
  GtInsets get insets => _scaler.insets;
  GtPalette get palette => Theme.of(this).extension<GtPalette>()!;
  GtShadows get shadows => GtShadows(this);

  double dp(double? size) => dpSizer.dp(size);

  double fractionalHeight(double fraction) {
    return fracSizer.getHeightFraction(fraction);
  }

  double fractionalWidth(double fraction) {
    return fracSizer.getWidthFraction(fraction);
  }

  double fractionalLongSide(double fraction) {
    return fracSizer.getLongestSideFraction(fraction);
  }

  double fractionalShortSide(double fraction) {
    return fracSizer.getShortestSideFraction(fraction);
  }

  GtRadii get radii => locator();

  GtGrid get grid => locator();

  GtScreenType get screenType => GtScreenType(this);

  bool get isMobile => screenType.isMobile;

  bool get isTab => screenType.isTablet;

  bool get isDesktop => screenType.isLaptop;

  bool get isMonitor => screenType.isMonitor;

  BorderRadius get zeroBorderRadius {
    return BorderRadius.zero;
  }

  Size get size => _scaler.size;

  Offset get offset => _scaler.position;

  bool validateForm(
    GlobalKey<FormState> formKey, {
    bool notifyOnFailure = true,
  }) {
    final isValid = (formKey.currentState?.validate() ?? false);
    return isValid;
  }
}
