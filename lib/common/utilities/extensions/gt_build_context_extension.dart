import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
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
  GtThemeData get _themeData => locator();

  /// Retrieves the grid configuration from the design system theme.
  GtGrid get grid => _themeData.grid;

  /// Retrieves the typography and font configuration from the design system theme.
  GtFonts get fonts => _themeData.fonts;

  /// Retrieves the corner radii configurations for the current context.
  GtRadii get radii => _themeData.radii(this);

  /// Retrieves the spacing guidelines and dimensions for the current context.
  GtSpacing get spacing => _themeData.spacing;

  /// Retrieves the box shadow configurations for the current context.
  GtShadows get shadows => _themeData.shadows(this);

  /// Retrieves the gradient definitions for the current context.
  GtGradients get gradients => _themeData.gradients(this);

  /// Retrieves the text style properties and variants for the current context.
  GtTextStyles get textStyles => _themeData.textStyles(this);

  /// Retrieves the input field style configurations for the current context.
  GtInputStyles get inputStyles => _themeData.inputStyles(this);

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
