import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A centralized styling class that provides access to the application's
/// form input styles and decorations.
///
/// This class uses the provided [BuildContext] to resolve theme-dependent
/// colors, border radii, padding, and typography for various input components
/// (e.g., text fields, dropdowns) as defined in the design system.
///
/// Every style method accepts optional overrides for the icon color, the
/// hint, error and helper max lines, and each text style the method sets.
/// A null override falls back to the style's token value. Styles derived from
/// the main text style (hint, disabled, and the search styles' error) follow
/// an overridden `textStyle` unless they are overridden as well.
///
/// {@category Styling}
class GtInputStyles {
  /// The [BuildContext] used to access the current theme and adaptive sizing utilities.
  final BuildContext context;

  /// Creates an instance of [GtInputStyles].
  ///
  /// Requires a [BuildContext] to accurately resolve context-dependent input styles.
  const GtInputStyles(this.context);

  /// Returns a completely unstyled [InputDecoration].
  ///
  /// Useful as a base for custom input fields where all default Material
  /// borders, padding, and background colors need to be stripped away.
  /// The icon color defaults to transparent and the max lines to 0.
  InputDecoration inputStyle({
    Color? iconColor,
    int? hintMaxLines,
    int? errorMaxLines,
    int? helperMaxLines,
  }) {
    return InputDecoration(
      iconColor: iconColor ?? Colors.transparent,
      errorMaxLines: errorMaxLines ?? 0,
      helperMaxLines: helperMaxLines ?? 0,
      hintMaxLines: hintMaxLines ?? 0,
      isDense: true,
      filled: false,
      alignLabelWithHint: true,
      contentPadding: .zero,
      isCollapsed: true,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: .zero,
        gapPadding: 0,
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: .zero,
        gapPadding: 0,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: .zero,
        gapPadding: 0,
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: .zero,
        gapPadding: 0,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: .zero,
        gapPadding: 0,
      ),
    );
  }

  /// The style configuration used for large, emphasis-heavy inputs,
  /// typically seen in money transfer screens.
  ///
  /// The hint shares the disabled style.
  GtInputDecoration transferInputStyle({
    Color? iconColor,
    int? hintMaxLines,
    int? errorMaxLines,
    int? helperMaxLines,
    TextStyle? textStyle,
    TextStyle? hintStyle,
    TextStyle? errorStyle,
    TextStyle? helperStyle,
    TextStyle? disabledStyle,
  }) {
    final computedTextStyle = textStyle ?? context.textStyles.h3();
    final computedDisabledStyle =
        disabledStyle ??
        computedTextStyle.copyWith(color: context.palette.text.disabled);
    return GtInputDecoration(
      iconColor: iconColor,
      hintMaxLines: hintMaxLines ?? 1,
      errorMaxLines: errorMaxLines ?? 1,
      helperMaxLines: helperMaxLines ?? 1,
      size: Size(.infinity, 70),
      textStyle: computedTextStyle,
      disabledStyle: computedDisabledStyle,
      hintStyle: hintStyle ?? computedDisabledStyle,
      errorStyle:
          errorStyle ??
          context.textStyles.body2s(color: context.palette.error.base),
      helperStyle: helperStyle ?? context.textStyles.body2s(),
      decoration: BoxDecoration(),
      padding: context.insets.allDp(8.px),
    );
  }

  /// The style configuration used for the large amount input on FX transfer
  /// screens, set in the FX input type at a shorter height than
  /// [transferInputStyle].
  ///
  /// The hint shares the disabled style.
  GtInputDecoration fxTransferInputStyle({
    Color? iconColor,
    int? hintMaxLines,
    int? errorMaxLines,
    int? helperMaxLines,
    TextStyle? textStyle,
    TextStyle? hintStyle,
    TextStyle? errorStyle,
    TextStyle? helperStyle,
    TextStyle? disabledStyle,
  }) {
    final computedTextStyle = textStyle ?? context.textStyles.fxInput();
    final computedDisabledStyle =
        disabledStyle ??
        computedTextStyle.copyWith(color: context.palette.text.disabled);
    return GtInputDecoration(
      iconColor: iconColor,
      hintMaxLines: hintMaxLines ?? 1,
      errorMaxLines: errorMaxLines ?? 1,
      helperMaxLines: helperMaxLines ?? 1,
      size: Size(.infinity, 48),
      textStyle: computedTextStyle,
      disabledStyle: computedDisabledStyle,
      hintStyle: hintStyle ?? computedDisabledStyle,
      errorStyle:
          errorStyle ??
          context.textStyles.body2s(color: context.palette.error.base),
      helperStyle: helperStyle ?? context.textStyles.body2s(),
      decoration: BoxDecoration(),
      padding: context.insets.allDp(8.px),
    );
  }

  /// The default style configuration for standard form text fields,
  /// featuring a weak background and standard height.
  GtInputDecoration defaultDecoration({
    Color? iconColor,
    int? hintMaxLines,
    int? errorMaxLines,
    int? helperMaxLines,
    TextStyle? textStyle,
    TextStyle? hintStyle,
    TextStyle? errorStyle,
    TextStyle? labelStyle,
    TextStyle? helperStyle,
    TextStyle? disabledStyle,
  }) {
    final computedTextStyle = textStyle ?? context.textStyles.input();

    return GtInputDecoration(
      iconColor: iconColor,
      hintMaxLines: hintMaxLines ?? 1,
      errorMaxLines: errorMaxLines ?? 1,
      helperMaxLines: helperMaxLines ?? 1,
      size: Size(.infinity, 64),
      textStyle: computedTextStyle,
      disabledStyle:
          disabledStyle ??
          computedTextStyle.copyWith(color: context.palette.text.disabled),
      hintStyle:
          hintStyle ??
          computedTextStyle.copyWith(color: context.palette.text.soft),
      labelStyle:
          labelStyle ??
          context.textStyles.body2s(color: context.palette.text.soft),
      errorStyle:
          errorStyle ??
          context.textStyles.body2s(color: context.palette.error.base),
      helperStyle: helperStyle ?? context.textStyles.body2s(),
      decoration: BoxDecoration(
        borderRadius: context.borderRadiusXl,
        color: context.palette.bg.weak,
      ),
      focusedDecoration: BoxDecoration(
        borderRadius: context.borderRadiusXl,
        color: context.palette.bg.white,
        border: Border.all(color: context.palette.stroke.strong, width: 2),
      ),
      errorDecoration: BoxDecoration(
        borderRadius: context.borderRadiusXl,
        color: context.palette.bg.weak,
        border: Border.all(color: context.palette.error.base, width: 1.5),
      ),
      focusedErrorDecoration: BoxDecoration(
        borderRadius: context.borderRadiusXl,
        color: context.palette.bg.white,
        border: Border.all(color: context.palette.error.base, width: 2),
      ),
      disabledDecoration: BoxDecoration(
        borderRadius: context.borderRadiusXl,
        color: context.palette.bg.weaker,
      ),
      padding: context.insets.symmetricDp(horizontal: 16.px),
    );
  }

  /// The style configuration specifically tailored for phone number input fields,
  /// matching the default decoration but optimizing padding for phone numbers.
  GtInputDecoration phoneInputDecoration({
    Color? iconColor,
    int? hintMaxLines,
    int? errorMaxLines,
    int? helperMaxLines,
    TextStyle? textStyle,
    TextStyle? hintStyle,
    TextStyle? errorStyle,
    TextStyle? labelStyle,
    TextStyle? helperStyle,
    TextStyle? disabledStyle,
  }) {
    return defaultDecoration(
      iconColor: iconColor,
      hintMaxLines: hintMaxLines,
      errorMaxLines: errorMaxLines,
      helperMaxLines: helperMaxLines,
      textStyle: textStyle,
      hintStyle: hintStyle,
      errorStyle: errorStyle,
      labelStyle: labelStyle,
      helperStyle: helperStyle,
      disabledStyle: disabledStyle,
    ).copyWith(padding: context.insets.symmetricDp(horizontal: 16.px));
  }

  /// The style configuration for country or phone code selector fields,
  /// featuring a subtle border to distinguish it from the main phone input.
  GtInputDecoration phoneCodeDecoration({
    Color? iconColor,
    int? hintMaxLines,
    int? errorMaxLines,
    int? helperMaxLines,
    TextStyle? textStyle,
    TextStyle? hintStyle,
    TextStyle? errorStyle,
    TextStyle? labelStyle,
    TextStyle? helperStyle,
    TextStyle? disabledStyle,
  }) {
    return phoneInputDecoration(
      iconColor: iconColor,
      hintMaxLines: hintMaxLines,
      errorMaxLines: errorMaxLines,
      helperMaxLines: helperMaxLines,
      textStyle: textStyle,
      hintStyle: hintStyle,
      errorStyle: errorStyle,
      labelStyle: labelStyle,
      helperStyle: helperStyle,
      disabledStyle: disabledStyle,
    ).copyWith(
      decoration: BoxDecoration(
        borderRadius: context.borderRadiusXl,
        border: Border.all(color: context.palette.stroke.sub, width: 1.5),
      ),
      padding: context.insets.symmetricDp(horizontal: 16.px, vertical: 11.px),
    );
  }

  /// A plain style configuration for inline form fields, featuring a weak
  /// background, small body text and no focused, error or disabled variants.
  GtInputDecoration plainDecoration({
    Color? iconColor,
    int? hintMaxLines,
    int? errorMaxLines,
    int? helperMaxLines,
    TextStyle? textStyle,
    TextStyle? hintStyle,
    TextStyle? errorStyle,
    TextStyle? labelStyle,
    TextStyle? helperStyle,
    TextStyle? disabledStyle,
  }) {
    final computedTextStyle = textStyle ?? context.textStyles.bodyS();

    return GtInputDecoration(
      iconColor: iconColor,
      hintMaxLines: hintMaxLines ?? 1,
      errorMaxLines: errorMaxLines ?? 1,
      helperMaxLines: helperMaxLines ?? 1,
      size: Size(.infinity, 48),
      textStyle: computedTextStyle,
      disabledStyle:
          disabledStyle ??
          computedTextStyle.copyWith(color: context.palette.text.disabled),
      hintStyle:
          hintStyle ??
          computedTextStyle.copyWith(color: context.palette.text.soft),
      labelStyle:
          labelStyle ??
          context.textStyles.body2s(color: context.palette.text.soft),
      errorStyle:
          errorStyle ??
          context.textStyles.body2s(color: context.palette.error.base),
      helperStyle: helperStyle ?? context.textStyles.body2s(),
      decoration: BoxDecoration(
        borderRadius: context.borderRadiusXl,
        color: context.palette.bg.weak,
      ),
      padding: context.insets.symmetricDp(horizontal: 10.px),
    );
  }

  /// A compact style configuration for standard form text fields,
  /// featuring a smaller height and reduced text size.
  GtInputDecoration smDecoration({
    Color? iconColor,
    int? hintMaxLines,
    int? errorMaxLines,
    int? helperMaxLines,
    TextStyle? textStyle,
    TextStyle? hintStyle,
    TextStyle? errorStyle,
    TextStyle? labelStyle,
    TextStyle? helperStyle,
    TextStyle? disabledStyle,
  }) {
    final computedTextStyle = textStyle ?? context.textStyles.bodyS();

    return GtInputDecoration(
      iconColor: iconColor,
      hintMaxLines: hintMaxLines ?? 1,
      errorMaxLines: errorMaxLines ?? 1,
      helperMaxLines: helperMaxLines ?? 1,
      size: Size(.infinity, 60),
      textStyle: computedTextStyle,
      disabledStyle:
          disabledStyle ??
          computedTextStyle.copyWith(color: context.palette.text.disabled),
      hintStyle:
          hintStyle ??
          computedTextStyle.copyWith(color: context.palette.text.soft),
      labelStyle:
          labelStyle ??
          context.textStyles.body2s(color: context.palette.text.soft),
      errorStyle:
          errorStyle ??
          context.textStyles.body2s(color: context.palette.error.base),
      helperStyle: helperStyle ?? context.textStyles.body2s(),
      decoration: BoxDecoration(
        borderRadius: context.borderRadiusXl,
        color: context.palette.bg.weak,
      ),
      focusedDecoration: BoxDecoration(
        borderRadius: context.borderRadiusXl,
        color: context.palette.bg.white,
        border: Border.all(color: context.palette.stroke.strong, width: 2),
      ),
      errorDecoration: BoxDecoration(
        borderRadius: context.borderRadiusXl,
        color: context.palette.bg.weak,
        border: Border.all(color: context.palette.error.base, width: 1.5),
      ),
      focusedErrorDecoration: BoxDecoration(
        borderRadius: context.borderRadiusXl,
        color: context.palette.bg.white,
        border: Border.all(color: context.palette.error.base, width: 2),
      ),
      disabledDecoration: BoxDecoration(
        borderRadius: context.borderRadiusXl,
        color: context.palette.bg.weaker,
      ),
      padding: context.insets.symmetricDp(horizontal: 16.px),
    );
  }

  /// The style configuration tailored for standard search inputs,
  /// featuring a weak background and smaller text.
  GtInputDecoration searchDecoration({
    Color? iconColor,
    int? hintMaxLines,
    int? errorMaxLines,
    int? helperMaxLines,
    TextStyle? textStyle,
    TextStyle? hintStyle,
    TextStyle? errorStyle,
    TextStyle? helperStyle,
    TextStyle? disabledStyle,
  }) {
    final computedTextStyle = textStyle ?? context.textStyles.bodyXs();

    return GtInputDecoration(
      iconColor: iconColor,
      hintMaxLines: hintMaxLines ?? 1,
      errorMaxLines: errorMaxLines ?? 1,
      helperMaxLines: helperMaxLines ?? 1,
      size: Size(.infinity, 52),
      textStyle: computedTextStyle,
      disabledStyle:
          disabledStyle ??
          computedTextStyle.copyWith(color: context.palette.text.disabled),
      hintStyle:
          hintStyle ??
          computedTextStyle.copyWith(color: context.palette.text.soft),
      errorStyle:
          errorStyle ??
          computedTextStyle.copyWith(color: context.palette.error.base),
      helperStyle: helperStyle ?? context.textStyles.body2s(),
      decoration: BoxDecoration(
        borderRadius: context.borderRadiusXl,
        color: context.palette.bg.weak,
      ),
      focusedDecoration: BoxDecoration(
        borderRadius: context.borderRadiusXl,
        color: context.palette.bg.weak,
        border: Border.all(color: context.palette.stroke.strong, width: 2),
      ),
      errorDecoration: BoxDecoration(
        borderRadius: context.borderRadiusXl,
        color: context.palette.bg.weak,
        border: Border.all(color: context.palette.error.base, width: 1.5),
      ),
      focusedErrorDecoration: BoxDecoration(
        borderRadius: context.borderRadiusXl,
        color: context.palette.bg.weak,
        border: Border.all(color: context.palette.error.base, width: 2),
      ),
      disabledDecoration: BoxDecoration(
        borderRadius: context.borderRadiusXl,
        color: context.palette.bg.weaker,
      ),
      padding: context.insets.symmetricDp(horizontal: 16.px),
    );
  }

  /// A compact style configuration for search inputs,
  /// featuring a smaller height than [searchDecoration].
  GtInputDecoration smSearchDecoration({
    Color? iconColor,
    int? hintMaxLines,
    int? errorMaxLines,
    int? helperMaxLines,
    TextStyle? textStyle,
    TextStyle? hintStyle,
    TextStyle? errorStyle,
    TextStyle? helperStyle,
    TextStyle? disabledStyle,
  }) {
    final computedTextStyle = textStyle ?? context.textStyles.bodyXs();

    return GtInputDecoration(
      iconColor: iconColor,
      hintMaxLines: hintMaxLines ?? 1,
      errorMaxLines: errorMaxLines ?? 1,
      helperMaxLines: helperMaxLines ?? 1,
      size: Size(.infinity, 40),
      textStyle: computedTextStyle,
      disabledStyle:
          disabledStyle ??
          computedTextStyle.copyWith(color: context.palette.text.disabled),
      hintStyle:
          hintStyle ??
          computedTextStyle.copyWith(color: context.palette.text.soft),
      errorStyle:
          errorStyle ??
          computedTextStyle.copyWith(color: context.palette.error.base),
      helperStyle: helperStyle ?? context.textStyles.body2s(),
      decoration: BoxDecoration(
        borderRadius: context.borderRadiusXl,
        color: context.palette.bg.weak,
      ),
      focusedDecoration: BoxDecoration(
        borderRadius: context.borderRadiusXl,
        color: context.palette.bg.weak,
        border: Border.all(color: context.palette.stroke.strong, width: 2),
      ),
      errorDecoration: BoxDecoration(
        borderRadius: context.borderRadiusXl,
        color: context.palette.bg.weak,
        border: Border.all(color: context.palette.error.base, width: 1.5),
      ),
      focusedErrorDecoration: BoxDecoration(
        borderRadius: context.borderRadiusXl,
        color: context.palette.bg.weak,
        border: Border.all(color: context.palette.error.base, width: 2),
      ),
      disabledDecoration: BoxDecoration(
        borderRadius: context.borderRadiusXl,
        color: context.palette.bg.weaker,
      ),
      padding: context.insets.symmetricDp(horizontal: 8.px),
    );
  }

  /// A compact style configuration for search inputs with a white background,
  /// typically used on slightly darker or off-white surfaces.
  GtInputDecoration smWhiteSearchDecoration({
    Color? iconColor,
    int? hintMaxLines,
    int? errorMaxLines,
    int? helperMaxLines,
    TextStyle? textStyle,
    TextStyle? hintStyle,
    TextStyle? errorStyle,
    TextStyle? helperStyle,
    TextStyle? disabledStyle,
  }) {
    final computedTextStyle = textStyle ?? context.textStyles.bodyXs();

    return GtInputDecoration(
      iconColor: iconColor,
      hintMaxLines: hintMaxLines ?? 1,
      errorMaxLines: errorMaxLines ?? 1,
      helperMaxLines: helperMaxLines ?? 1,
      size: Size(.infinity, 40),
      textStyle: computedTextStyle,
      disabledStyle:
          disabledStyle ??
          computedTextStyle.copyWith(color: context.palette.text.disabled),
      hintStyle:
          hintStyle ??
          computedTextStyle.copyWith(color: context.palette.text.soft),
      errorStyle:
          errorStyle ??
          computedTextStyle.copyWith(color: context.palette.error.base),
      helperStyle: helperStyle ?? context.textStyles.body2s(),
      decoration: BoxDecoration(
        borderRadius: context.borderRadiusXl,
        color: context.palette.bg.white,
        border: Border.all(color: context.palette.stroke.sub, width: 2),
      ),
      focusedDecoration: BoxDecoration(
        borderRadius: context.borderRadiusXl,
        color: context.palette.bg.white,
        border: Border.all(color: context.palette.stroke.strong, width: 2),
      ),
      errorDecoration: BoxDecoration(
        borderRadius: context.borderRadiusXl,
        color: context.palette.bg.white,
        border: Border.all(color: context.palette.error.base, width: 1.5),
      ),
      focusedErrorDecoration: BoxDecoration(
        borderRadius: context.borderRadiusXl,
        color: context.palette.bg.white,
        border: Border.all(color: context.palette.error.base, width: 2),
      ),
      disabledDecoration: BoxDecoration(
        borderRadius: context.borderRadiusXl,
        color: context.palette.bg.weaker,
        border: Border.all(color: context.palette.stroke.soft, width: 2),
      ),
      padding: context.insets.symmetricDp(horizontal: 8.px),
    );
  }

  /// A borderless variant of [smWhiteSearchDecoration] that signals errors
  /// with a tinted fill instead of a border.
  GtInputDecoration smWhiteSearchBorderlessDecoration({
    Color? iconColor,
    int? hintMaxLines,
    int? errorMaxLines,
    int? helperMaxLines,
    TextStyle? textStyle,
    TextStyle? hintStyle,
    TextStyle? errorStyle,
    TextStyle? helperStyle,
    TextStyle? disabledStyle,
  }) {
    final computedTextStyle = textStyle ?? context.textStyles.bodyXs();
    final border = Border.all(
      color: Colors.transparent,
      width: 0,
      style: BorderStyle.none,
    );

    return GtInputDecoration(
      iconColor: iconColor,
      hintMaxLines: hintMaxLines ?? 1,
      errorMaxLines: errorMaxLines ?? 1,
      helperMaxLines: helperMaxLines ?? 1,
      size: Size(.infinity, 40),
      textStyle: computedTextStyle,
      disabledStyle:
          disabledStyle ??
          computedTextStyle.copyWith(color: context.palette.text.disabled),
      hintStyle:
          hintStyle ??
          computedTextStyle.copyWith(color: context.palette.text.soft),
      errorStyle:
          errorStyle ??
          computedTextStyle.copyWith(color: context.palette.error.base),
      helperStyle: helperStyle ?? context.textStyles.body2s(),
      decoration: BoxDecoration(
        borderRadius: context.borderRadiusXl,
        color: context.palette.bg.white,
        border: border,
      ),
      focusedDecoration: BoxDecoration(
        borderRadius: context.borderRadiusXl,
        color: context.palette.bg.white,
        border: border,
      ),
      errorDecoration: BoxDecoration(
        borderRadius: context.borderRadiusXl,
        color: context.palette.error.lighter,
        border: border,
      ),
      focusedErrorDecoration: BoxDecoration(
        borderRadius: context.borderRadiusXl,
        color: context.palette.error.light,
        border: border,
      ),
      disabledDecoration: BoxDecoration(
        borderRadius: context.borderRadiusXl,
        color: context.palette.bg.weaker,
        border: border,
      ),
      padding: context.insets.symmetricDp(horizontal: 8.px),
    );
  }

  /// A collection containing all predefined [GtInputDecoration] configurations
  /// paired with their labels, each built without overrides.
  List<(String, GtInputDecoration)> get all => [
    ('Default Decoration', defaultDecoration()),
    ('Transfer Input Style', transferInputStyle()),
    ('FX Transfer Input Style', fxTransferInputStyle()),
    ('Plain Decoration', plainDecoration()),
    ('Small Decoration', smDecoration()),
    ('Search Decoration', searchDecoration()),
    ('Small Search Decoration', smSearchDecoration()),
    ('Small White Search Decoration', smWhiteSearchDecoration()),
    (
      'Small White Search Borderless Decoration',
      smWhiteSearchBorderlessDecoration(),
    ),
  ];
}

/// A configuration object that defines the visual appearance of a custom input field.
///
/// This class groups together various text styles, box decorations, and sizing
/// constraints necessary to render a form field across all its possible states
/// (e.g., normal, focused, error, disabled).
class GtInputDecoration {
  /// The color to apply to icons within the input field.
  final Color? iconColor;

  /// The maximum number of lines the hint text can occupy.
  final int hintMaxLines;

  /// The maximum number of lines the error text can occupy.
  final int errorMaxLines;

  /// The maximum number of lines the helper text can occupy.
  final int helperMaxLines;

  /// The style to use for the main input text.
  final TextStyle textStyle;

  /// The style to use for the hint placeholder text.
  final TextStyle hintStyle;

  /// The style to use for the error text.
  final TextStyle? errorStyle;

  /// The style to use for the label text.
  final TextStyle? labelStyle;

  /// The style to use for the helper text.
  final TextStyle? helperStyle;

  /// The style to use for the input text when the field is disabled.
  final TextStyle disabledStyle;

  /// The internal padding applied to the input field content.
  final EdgeInsetsGeometry padding;

  /// The base decoration applied to the input field in its normal state.
  final BoxDecoration decoration;

  /// The decoration applied when the input field is in an error state.
  final BoxDecoration? _errorDecoration;

  /// The decoration applied when the input field is focused.
  final BoxDecoration? _focusedDecoration;

  /// The decoration applied when the input field is disabled.
  final BoxDecoration? _disabledDecoration;

  /// The decoration applied when the input field is both focused and in an error state.
  final BoxDecoration? _focusedErrorDecoration;

  /// The overall size constraints for the input field.
  final Size size;

  /// Creates a [GtInputDecoration] configuration.
  const GtInputDecoration({
    this.hintMaxLines = 1,
    this.errorMaxLines = 1,
    this.helperMaxLines = 1,
    required this.textStyle,
    required this.disabledStyle,
    required this.size,
    required this.hintStyle,
    this.errorStyle,
    this.labelStyle,
    this.helperStyle,
    required this.decoration,
    required this.padding,
    this.iconColor,
    BoxDecoration? errorDecoration,
    BoxDecoration? focusedDecoration,
    BoxDecoration? disabledDecoration,
    BoxDecoration? focusedErrorDecoration,
  }) : _errorDecoration = errorDecoration,
       _focusedDecoration = focusedDecoration,
       _disabledDecoration = disabledDecoration,
       _focusedErrorDecoration = focusedErrorDecoration;

  /// Creates a copy of this input decoration but with the given fields replaced with the new values.
  GtInputDecoration copyWith({
    Color? iconColor,
    int? hintMaxLines,
    int? errorMaxLines,
    int? helperMaxLines,
    TextStyle? textStyle,
    TextStyle? hintStyle,
    TextStyle? errorStyle,
    TextStyle? labelStyle,
    TextStyle? helperStyle,
    TextStyle? disabledStyle,
    EdgeInsetsGeometry? padding,
    BoxDecoration? decoration,
    BoxDecoration? errorDecoration,
    BoxDecoration? focusedDecoration,
    BoxDecoration? disabledDecoration,
    BoxDecoration? focusedErrorDecoration,
    Size? size,
  }) {
    return GtInputDecoration(
      iconColor: iconColor ?? this.iconColor,
      hintMaxLines: hintMaxLines ?? this.hintMaxLines,
      errorMaxLines: errorMaxLines ?? this.errorMaxLines,
      helperMaxLines: helperMaxLines ?? this.helperMaxLines,
      textStyle: textStyle ?? this.textStyle,
      hintStyle: hintStyle ?? this.hintStyle,
      errorStyle: errorStyle ?? this.errorStyle,
      labelStyle: labelStyle ?? this.labelStyle,
      helperStyle: helperStyle ?? this.helperStyle,
      disabledStyle: disabledStyle ?? this.disabledStyle,
      padding: padding ?? this.padding,
      decoration: decoration ?? this.decoration,
      errorDecoration: errorDecoration ?? _errorDecoration,
      focusedDecoration: focusedDecoration ?? _focusedDecoration,
      disabledDecoration: disabledDecoration ?? _disabledDecoration,
      focusedErrorDecoration: focusedErrorDecoration ?? _focusedErrorDecoration,
      size: size ?? this.size,
    );
  }

  /// Returns the BoxConstraints based on the configured [size].
  BoxConstraints get constraints {
    return BoxConstraints.tightFor(height: size.height);
  }

  /// Returns BoxConstraints that use the configured [size]'s height as a
  /// minimum, letting multiline inputs grow past it.
  BoxConstraints get multilineConstraints {
    return BoxConstraints(minHeight: size.height);
  }

  /// Gets the resolved error decoration, falling back to the base [decoration] if null.
  BoxDecoration get errorDecoration => _errorDecoration ?? decoration;

  /// Gets the resolved focused decoration, falling back to the base [decoration] if null.
  BoxDecoration get focusedDecoration => _focusedDecoration ?? decoration;

  /// Gets the resolved disabled decoration, falling back to the base [decoration] if null.
  BoxDecoration get disabledDecoration => _disabledDecoration ?? decoration;

  /// Gets the resolved focused-error decoration, falling back to the base [decoration] if null.
  BoxDecoration get focusedErrorDecoration {
    return _focusedErrorDecoration ?? decoration;
  }

  /// Converts this [GtInputDecoration] configuration into a standard Flutter [InputDecoration].
  ///
  /// This is typically used to apply the configured styles directly to a [TextField]
  /// or [TextFormField].
  InputDecoration get asInputDecoration {
    final transparent = Colors.transparent;

    return InputDecoration(
      iconColor: iconColor,
      errorMaxLines: errorMaxLines,
      helperMaxLines: helperMaxLines,
      hintMaxLines: hintMaxLines,
      errorStyle: errorStyle,
      labelStyle: labelStyle,
      helperStyle: helperStyle,
      hintStyle: hintStyle,
      isDense: true,
      filled: decoration.color != null,
      fillColor: decoration.color,
      contentPadding: padding,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: decoration.color ?? transparent,
          width: decoration.border?.top.width ?? 0,
        ),
        borderRadius: decoration.borderRadius?.resolve(.ltr) ?? .zero,
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: errorDecoration.color ?? transparent,
          width: errorDecoration.border?.top.width ?? 0,
        ),
        borderRadius: errorDecoration.borderRadius?.resolve(.ltr) ?? .zero,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: focusedErrorDecoration.color ?? transparent,
          width: focusedErrorDecoration.border?.top.width ?? 0,
        ),
        borderRadius:
            focusedErrorDecoration.borderRadius?.resolve(.ltr) ?? .zero,
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: disabledDecoration.color ?? transparent,
          width: disabledDecoration.border?.top.width ?? 0,
        ),
        borderRadius: disabledDecoration.borderRadius?.resolve(.ltr) ?? .zero,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: focusedDecoration.color ?? transparent,
          width: focusedDecoration.border?.top.width ?? 0,
        ),
        borderRadius: focusedDecoration.borderRadius?.resolve(.ltr) ?? .zero,
      ),
    );
  }
}
