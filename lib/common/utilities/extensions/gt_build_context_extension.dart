import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// An extension on [BuildContext] providing convenient access to the design system's
/// theming, typography, sizing utilities, and responsive breakpoints.
extension ThemeContextExtension on BuildContext {
  GtScaleUtil get _scaler => GtScaleUtil.of(this);

  /// Retrieves custom media query data for the current context.
  GtMediaQueryData get mediaQueryData => GtMediaQueryData(this);

  /// Retrieves the fractional sizer for responsive dimensions based on screen percentages.
  GtFractionalSizer get fracSizer => _scaler.fracSizer;

  /// Retrieves the context-sensitive device-independent pixel (DP) calculator.
  GtContextSensitiveDpComputer get dpSizer => _scaler.dpSizer;

  /// Retrieves screen insets, such as padding for safe areas.
  GtInsets get insets => _scaler.insets;

  /// Retrieves the current global offset position.
  Offset get position => _scaler.position;

  /// Retrieves the current local offset position.
  Offset get localPosition => _scaler.localPosition;

  /// Retrieves the total size of the current screen.
  Size get size => _scaler.size;

  /// Converts a given [size] into device-independent pixels (DP) based on the screen's density.
  double dp(double? size) => dpSizer.dp(size);

  /// Calculates a specific height based on a [fraction] of the total screen height.
  double fractionalHeight(double fraction) {
    return fracSizer.getHeightFraction(fraction);
  }

  /// Calculates a specific width based on a [fraction] of the total screen width.
  double fractionalWidth(double fraction) {
    return fracSizer.getWidthFraction(fraction);
  }

  /// Calculates a dimension based on a [fraction] of the screen's longest side.
  double fractionalLongest(double fraction) {
    return fracSizer.getLongestSideFraction(fraction);
  }

  /// Calculates a dimension based on a [fraction] of the screen's shortest side.
  double fractionalShortest(double fraction) {
    return fracSizer.getShortestSideFraction(fraction);
  }

  /// Retrieves the color palette defined in the current theme.
  GtPalette get palette => Theme.of(this).extension<GtPalette>()!;
  GtTheme get themeData => GtThemeProvider.of(this);

  /// Retrieves the grid configuration from the design system theme.
  GtGrid get grid => themeData.grid;

  /// Retrieves the typography and font configuration from the design system theme.
  GtFonts get fonts => themeData.fonts;

  /// Retrieves the corner radii configurations for the current context.
  GtRadii get radii => themeData.radii;

  Radius get radiusXxs => dp(radii.xxs.px).radius;
  Radius get radiusXs => dp(radii.xs.px).radius;
  Radius get radiusSm => dp(radii.sm.px).radius;
  Radius get radiusMd => dp(radii.md.px).radius;
  Radius get radiusLg => dp(radii.lg.px).radius;
  Radius get radiusXl => dp(radii.xl.px).radius;
  Radius get radius2Xl => dp(radii.xxl.px).radius;
  Radius get radius3Xl => dp(radii.xxxl.px).radius;
  Radius get radius4Xl => dp(radii.xxxxl.px).radius;
  Radius get radius5Xl => dp(radii.xxl.px).radius;
  Radius get radiusFull => dp(radii.full.px).radius;

  BorderRadius get borderRadiusXxs => BorderRadius.all(radiusXxs);
  BorderRadius get borderRadiusXs => BorderRadius.all(radiusXs);
  BorderRadius get borderRadiusSm => BorderRadius.all(radiusSm);
  BorderRadius get borderRadiusMd => BorderRadius.all(radiusMd);
  BorderRadius get borderRadiusLg => BorderRadius.all(radiusLg);
  BorderRadius get borderRadiusXl => BorderRadius.all(radiusXl);
  BorderRadius get borderRadius2Xl => BorderRadius.all(radius2Xl);
  BorderRadius get borderRadius3Xl => BorderRadius.all(radius3Xl);
  BorderRadius get borderRadius4Xl => BorderRadius.all(radius4Xl);
  BorderRadius get borderRadius5Xl => BorderRadius.all(radius5Xl);
  BorderRadius get borderRadiusFull => BorderRadius.all(radiusFull);

  /// Retrieves the spacing guidelines and dimensions for the current context.
  GtSpacing get spacing => themeData.spacing;

  double get spacingXs => dp(spacing.xs.px);
  double get spacingSm => dp(spacing.sm.px);
  double get spacingBase => dp(spacing.base.px);
  double get spacingMd => dp(spacing.md.px);
  double get spacingLg => dp(spacing.lg.px);
  double get spacingXl => dp(spacing.xl.px);
  double get spacingSectionSm => dp(spacing.sectionSm.px);
  double get spacingsectionMd => dp(spacing.sectionMd.px);
  double get spacingSectionLg => dp(spacing.sectionLg.px);
  double get spacingsectionXl => dp(spacing.sectionXl.px);
  double get spacingsection2xl => dp(spacing.section2xl.px);
  double get spacingsection3xl => dp(spacing.section3xl.px);
  double get spacingsection4xl => dp(spacing.section4xl.px);

  /// Retrieves the box shadow configurations for the current context.
  GtShadows get shadows => themeData.shadows(this);

  /// Retrieves the gradient definitions for the current context.
  GtGradients get gradients => themeData.gradients(this);

  /// Retrieves the text style properties and variants for the current context.
  GtTextStyles get textStyles => themeData.textStyles(this);

  /// Retrieves the input field style configurations for the current context.
  GtInputStyles get inputStyles => themeData.inputStyles(this);

  /// Determines the current screen type category (e.g., mobile, tablet, desktop).
  GtScreenType get screenType => GtScreenType(this);

  /// Returns `true` if the current screen is classified as a mobile device.
  bool get isMobile => screenType.isMobile;

  /// Returns `true` if the current screen is classified as a tablet device.
  bool get isTab => screenType.isTablet;

  /// Returns `true` if the current screen is classified as a laptop or desktop.
  bool get isDesktop => screenType.isLaptop;

  /// Returns `true` if the current screen is classified as a large monitor.
  bool get isMonitor => screenType.isMonitor;

  /// Validates a form associated with the provided [formKey].
  ///
  /// Triggers the [onValidationFailure] callback if the validation fails.
  /// Returns `true` if the form is valid, or `false` otherwise.
  bool validateForm(
    GlobalKey<FormState> formKey, {
    VoidCallback? onValidationFailure,
  }) {
    final isValid = (formKey.currentState?.validate() ?? false);
    if (!isValid) onValidationFailure?.call();
    return isValid;
  }

  /// Resets the state of the form associated with the provided [formKey].
  void clearForm(GlobalKey<FormState> formKey) {
    formKey.currentState?.reset();
  }

  /// Triggers the `save` method on all form fields within the form associated with the [formKey].
  void saveForm(GlobalKey<FormState> formKey) {
    formKey.currentState?.save();
  }
}

extension NavigatorExtension on BuildContext {
  bool get canPop => Navigator.of(this).canPop();
  Future pop() async => Navigator.of(this).pop();
}
