import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A centralized styling class that provides access to the application's
/// form input styles and decorations.
///
/// This class uses the provided [BuildContext] to resolve theme-dependent
/// colors, border radii, padding, and typography for various input components
/// (e.g., text fields, dropdowns) as defined in the design system.
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
  InputDecoration get inputStyle {
    return InputDecoration(
      iconColor: Colors.transparent,
      errorMaxLines: 0,
      helperMaxLines: 0,
      hintMaxLines: 0,
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
  GtInputDecoration get transferInputStyle {
    final textStyle = context.textStyles.h3();
    final disabledStyle = textStyle.copyWith(
      color: context.palette.text.disabled,
    );
    return GtInputDecoration(
      size: Size(.infinity, 70),
      textStyle: textStyle,
      disabledStyle: disabledStyle,
      hintStyle: disabledStyle,
      errorStyle: context.textStyles.body2s(color: context.palette.error.base),
      helperStyle: context.textStyles.body2s(),
      decoration: BoxDecoration(),
      padding: context.insets.allDp(8.px),
    );
  }

  /// The default style configuration for standard form text fields,
  /// featuring a weak background and standard height.
  GtInputDecoration get defaultDecoration {
    final textStyle = context.textStyles.input();
    final hintStyle = textStyle.copyWith(color: context.palette.text.soft);
    final disabledStyle = textStyle.copyWith(
      color: context.palette.text.disabled,
    );

    return GtInputDecoration(
      size: Size(.infinity, 64),
      textStyle: textStyle,
      disabledStyle: disabledStyle,
      hintStyle: hintStyle,
      labelStyle: context.textStyles.body2s(color: context.palette.text.soft),
      errorStyle: context.textStyles.body2s(color: context.palette.error.base),
      helperStyle: context.textStyles.body2s(),
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
        border: Border.all(color: context.palette.error.base, width: 1.6),
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
      padding: context.insets.symmetricDp(horizontal: 16.px, vertical: 12.px),
    );
  }

  /// A compact style configuration for standard form text fields,
  /// featuring a smaller height and reduced text size.
  GtInputDecoration get smDecoration {
    final textStyle = context.textStyles.bodyS();
    final hintStyle = textStyle.copyWith(color: context.palette.text.soft);
    final disabledStyle = textStyle.copyWith(
      color: context.palette.text.disabled,
    );

    return GtInputDecoration(
      size: Size(.infinity, 60),
      textStyle: textStyle,
      disabledStyle: disabledStyle,
      hintStyle: hintStyle,
      labelStyle: context.textStyles.body2s(color: context.palette.text.soft),
      errorStyle: context.textStyles.body2s(color: context.palette.error.base),
      helperStyle: context.textStyles.body2s(),
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
        border: Border.all(color: context.palette.error.base, width: 1.6),
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
      padding: context.insets.symmetricDp(horizontal: 8.5.px, vertical: 6.px),
    );
  }

  /// The style configuration tailored for standard search inputs,
  /// featuring a weak background and smaller text.
  GtInputDecoration get searchDecoration {
    final textStyle = context.textStyles.bodyXs();
    final hintStyle = textStyle.copyWith(color: context.palette.text.soft);
    final disabledStyle = textStyle.copyWith(
      color: context.palette.text.disabled,
    );

    return GtInputDecoration(
      size: Size(.infinity, 52),
      textStyle: textStyle,
      disabledStyle: disabledStyle,
      hintStyle: hintStyle,
      errorStyle: textStyle.copyWith(color: context.palette.error.base),
      helperStyle: context.textStyles.body2s(),
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
        border: Border.all(color: context.palette.error.base, width: 1.6),
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
      padding: context.insets.symmetricDp(horizontal: 8.px, vertical: 6.px),
    );
  }

  /// A compact style configuration for search inputs,
  /// featuring a smaller height than [searchStyle].
  GtInputDecoration get smSearchDecoration {
    final textStyle = context.textStyles.bodyXs();
    final hintStyle = textStyle.copyWith(color: context.palette.text.soft);
    final disabledStyle = textStyle.copyWith(
      color: context.palette.text.disabled,
    );

    return GtInputDecoration(
      size: Size(.infinity, 40),
      textStyle: textStyle,
      disabledStyle: disabledStyle,
      hintStyle: hintStyle,
      errorStyle: textStyle.copyWith(color: context.palette.error.base),
      helperStyle: context.textStyles.body2s(),
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
        border: Border.all(color: context.palette.error.base, width: 1.6),
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
      padding: context.insets.symmetricDp(horizontal: 8.px, vertical: 6.px),
    );
  }

  /// A compact style configuration for search inputs with a white background,
  /// typically used on slightly darker or off-white surfaces.
  GtInputDecoration get smWhiteSearchDecoration {
    final textStyle = context.textStyles.bodyXs();
    final hintStyle = textStyle.copyWith(color: context.palette.text.soft);
    final disabledStyle = textStyle.copyWith(
      color: context.palette.text.disabled,
    );

    return GtInputDecoration(
      size: Size(.infinity, 40),
      textStyle: textStyle,
      disabledStyle: disabledStyle,
      hintStyle: hintStyle,
      errorStyle: textStyle.copyWith(color: context.palette.error.base),
      helperStyle: context.textStyles.body2s(),
      decoration: BoxDecoration(
        borderRadius: context.borderRadiusXl,
        color: context.palette.bg.white,
      ),
      focusedDecoration: BoxDecoration(
        borderRadius: context.borderRadiusXl,
        color: context.palette.bg.white,
        border: Border.all(color: context.palette.stroke.strong, width: 2),
      ),
      errorDecoration: BoxDecoration(
        borderRadius: context.borderRadiusXl,
        color: context.palette.bg.white,
        border: Border.all(color: context.palette.error.base, width: 1.6),
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
      padding: context.insets.symmetricDp(horizontal: 8.px, vertical: 6.px),
    );
  }

  /// A collection containing all predefined [GtInputDecoration] configurations paired with their labels.
  List<(String, GtInputDecoration)> get all => [
    ('Transfer Input Style', transferInputStyle),
    ('Default Decoration', defaultDecoration),
    ('Small Decoration', smDecoration),
    ('Search Decoration', searchDecoration),
    ('Small Search Decoration', smSearchDecoration),
    ('Small White Search Decoration', smWhiteSearchDecoration),
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

  /// Returns the BoxConstraints based on the configured [size].
  BoxConstraints get constraints => BoxConstraints(minHeight: size.height);

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
