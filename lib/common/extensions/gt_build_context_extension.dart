import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

extension ThemeContextExtension on BuildContext {
  GtScaleUtil get _scaler => GtScaleUtil.of(this);
  GtMediaQueryData get mediaQueryData => GtMediaQueryData(this);
  GtFractionalSizer get fracSizer => _scaler.fracSizer;
  GtDpiIndependentSizer get dpSizer => _scaler.dpSizer;
  GtInsets get insets => _scaler.insets;
  Offset get position => _scaler.position;
  Size get size => _scaler.size;

  double dp(double? size) => dpSizer.dp(size);

  double fractionalHeight(double fraction) {
    return fracSizer.getHeightFraction(fraction);
  }

  double fractionalWidth(double fraction) {
    return fracSizer.getWidthFraction(fraction);
  }

  double fractionalLongest(double fraction) {
    return fracSizer.getLongestSideFraction(fraction);
  }

  double fractionalShortest(double fraction) {
    return fracSizer.getShortestSideFraction(fraction);
  }

  GtPalette get palette => Theme.of(this).extension<GtPalette>()!;
  GtThemeData get _themeData => locator();

  GtGrid get grid => _themeData.grid;
  GtFonts get fonts => _themeData.fonts;
  GtRadii get radii => _themeData.radii(this);
  GtShadows get shadows => _themeData.shadows(this);
  GtSpacing get spacing => _themeData.spacing(this);
  GtGradients get gradients => _themeData.gradients(this);
  GtTextStyles get textStyles => _themeData.textStyles(this);
  GtInputStyles get inputStyles => _themeData.inputStyles(this);

  GtScreenType get screenType => GtScreenType(this);
  bool get isMobile => screenType.isMobile;
  bool get isTab => screenType.isTablet;
  bool get isDesktop => screenType.isLaptop;
  bool get isMonitor => screenType.isMonitor;

  bool validateForm(
    GlobalKey<FormState> formKey, {
    VoidCallback? onValidationFailure,
  }) {
    final isValid = (formKey.currentState?.validate() ?? false);
    if (!isValid) onValidationFailure?.call();
    return isValid;
  }

  void clearForm(GlobalKey<FormState> formKey) {
    formKey.currentState?.reset();
  }

  void saveForm(GlobalKey<FormState> formKey) {
    formKey.currentState?.save();
  }
}
