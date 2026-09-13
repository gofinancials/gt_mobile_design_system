import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A centralized styling class that provides access to the application's
/// typographic system and text styles.
///
/// **Note: This is tentative as there are still inconsistencies in the
/// Figma style guide.** These tokens and values may be updated in the future
/// once the design system is fully finalized.
///
/// This class uses the provided [BuildContext] to resolve theme-dependent
/// text styles, scaling factors, and responsive typography tokens as defined
/// in the design system.
///
/// Apart from the display (`d*`), [welcome] and heading (`h*`) styles, every
/// style method accepts optional overrides for each [buildStyle] argument
/// except `size`. A null override falls back to the style's token value.
class GtTextStyles {
  /// The [BuildContext] used to access the current theme and scaling utilities.
  final BuildContext context;

  /// The font families the styles are built from.
  final GtFonts fonts;

  /// Creates an instance of [GtTextStyles].
  ///
  /// Requires a [BuildContext] to accurately resolve context-dependent styles.
  const GtTextStyles(this.context, this.fonts);

  // ---------------------------------------------------------------------------
  // CORE BUILDER
  // Handles the conversion from Figma's % tracking and pixel line-heights
  // into Flutter's native coordinate system.
  // ---------------------------------------------------------------------------

  /// Builds a [TextStyle] from Figma's type tokens.
  ///
  /// [heightPx] is the line height in logical pixels and [widthPct] the
  /// tracking as a percentage of [size].
  TextStyle buildStyle({
    required String family,
    required double size,
    required double heightPx,
    required double widthPct,
    TextDecoration? decoration,
    FontWeight? weight,
    Color? color,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    final computedColor = color ?? context.palette.text.strong;
    return TextStyle(
      fontFamily: family,
      fontSize: size,
      height: heightPx / size,
      letterSpacing: size * (widthPct / 100),
      fontWeight: weight ?? .normal,
      color: computedColor,
      decoration: decoration,
      decorationColor: decorationColor ?? computedColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
      package: 'gt_mobile_ui',
    );
  }

  // ---------------------------------------------------------------------------
  // DISPLAY (d prefix) | Youth
  // ---------------------------------------------------------------------------

  /// Generates the Display 1 (D1) text style.
  TextStyle d1({
    double? heightPx,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return buildStyle(
      family: fonts.title,
      size: 64,
      heightPx: heightPx ?? 72,
      widthPct: -2.0,
      weight: .bold,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Display 2 (D2) text style.
  TextStyle d2({
    double? heightPx,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return buildStyle(
      family: fonts.title,
      size: 56,
      heightPx: heightPx ?? 64,
      widthPct: -0.5,
      weight: .bold,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Display 3 (D3) text style.
  TextStyle d3({
    double? heightPx,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return buildStyle(
      family: fonts.title,
      size: 48,
      heightPx: heightPx ?? 50,
      widthPct: 0.0,
      weight: .bold,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Display 4 (D4) text style.
  TextStyle d4({
    double? heightPx,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return buildStyle(
      family: fonts.title,
      size: 32,
      heightPx: heightPx ?? 40,
      widthPct: 0.0,
      weight: .bold,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  // ---------------------------------------------------------------------------
  // TITLES (h prefix) | H1: Youth, H2-H6: Readex Pro
  // ---------------------------------------------------------------------------

  /// Generates the welcome screen title text style.
  TextStyle welcome({
    double? heightPx,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return buildStyle(
      family: fonts.title,
      size: 60,
      heightPx: heightPx ?? 52,
      widthPct: -1.0,
      weight: .bold,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Heading 1 (H1) text style.
  TextStyle h1({
    double? heightPx,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return buildStyle(
      family: fonts.title,
      size: 56,
      heightPx: heightPx ?? 64,
      widthPct: -1.0,
      weight: .bold,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Heading 2 (H2) text style.
  TextStyle h2({
    double? heightPx,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return buildStyle(
      family: fonts.title,
      size: 48,
      heightPx: heightPx ?? 56,
      widthPct: -1.0,
      weight: .bold,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Heading 3 (H3) text style.
  TextStyle h3({
    double? heightPx,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return buildStyle(
      family: fonts.title,
      size: 40,
      heightPx: heightPx ?? 48,
      widthPct: -1.0,
      weight: .bold,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Heading 4 (H4) text style.
  TextStyle h4({
    double? heightPx,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return buildStyle(
      family: fonts.title,
      size: 32,
      heightPx: heightPx ?? 40,
      widthPct: -0.5,
      weight: .bold,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Heading 5 (H5) text style.
  TextStyle h5({
    double? heightPx,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return buildStyle(
      family: fonts.title,
      size: 24,
      heightPx: heightPx ?? 32,
      widthPct: 0.0,
      weight: .bold,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Heading 6 (H6) text style.
  TextStyle h6({
    double? heightPx,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return buildStyle(
      family: fonts.title,
      size: 20,
      heightPx: heightPx ?? 28,
      widthPct: 0.0,
      weight: .bold,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Heading 7 (H7) text style.
  TextStyle h7({
    double? heightPx,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return buildStyle(
      family: fonts.title,
      size: 16,
      heightPx: heightPx ?? 20,
      widthPct: 0.0,
      weight: .bold,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the avatar text style
  TextStyle avatar({
    String? family,
    double? heightPx,
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
    double? widthPct,
    required double size,
  }) {
    return buildStyle(
      family: family ?? fonts.title,
      size: size,
      heightPx: heightPx ?? size * 1.25,
      overflow: overflow,
      widthPct: widthPct ?? 0.0,
      weight: weight ?? .w600,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
    );
  }

  // ---------------------------------------------------------------------------
  // PARAGRAPHS (body prefix) | Inter, Regular (400)
  // ---------------------------------------------------------------------------

  /// Generates the Extra Large Body (Body XL) paragraph text style.
  TextStyle bodyXl({
    String? family,
    double? heightPx,
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
    double? widthPct,
  }) {
    return buildStyle(
      family: family ?? fonts.body,
      size: 24,
      heightPx: heightPx ?? 32,
      widthPct: widthPct ?? -1.5,
      weight: weight,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Large Body (Body L) paragraph text style.
  TextStyle bodyL({
    String? family,
    double? heightPx,
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
    double? widthPct,
  }) {
    return buildStyle(
      family: family ?? fonts.body,
      size: 18,
      heightPx: heightPx ?? 24,
      widthPct: widthPct ?? -1.5,
      weight: weight,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Medium Body (Body M) paragraph text style.
  TextStyle bodyM({
    String? family,
    double? heightPx,
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
    double? widthPct,
  }) {
    return buildStyle(
      family: family ?? fonts.body,
      size: 16,
      heightPx: heightPx ?? 24,
      widthPct: widthPct ?? -1.1,
      weight: weight,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Small Body (Body S) paragraph text style.
  TextStyle bodyS({
    String? family,
    double? heightPx,
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
    double? widthPct,
  }) {
    return buildStyle(
      family: family ?? fonts.body,
      size: 14,
      heightPx: heightPx ?? 20,
      widthPct: widthPct ?? -0.6,
      weight: weight,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Secondary Small Body (Body 2S) paragraph text style.
  TextStyle body2s({
    String? family,
    double? heightPx,
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
    double? widthPct,
  }) {
    return buildStyle(
      family: family ?? fonts.body,
      size: 13,
      heightPx: heightPx ?? 16,
      widthPct: widthPct ?? 1,
      weight: weight,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Extra Small Body (Body XS) paragraph text style.
  TextStyle bodyXs({
    String? family,
    double? heightPx,
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
    double? widthPct,
  }) {
    return buildStyle(
      family: family ?? fonts.body,
      size: 12,
      heightPx: heightPx ?? 16,
      widthPct: widthPct ?? 0.0,
      weight: weight,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Double Extra Small Body (Body 2XS) paragraph text style.
  TextStyle body2Xs({
    String? family,
    double? heightPx,
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
    double? widthPct,
  }) {
    return buildStyle(
      family: family ?? fonts.body,
      size: 11,
      heightPx: heightPx ?? 12,
      widthPct: widthPct ?? 0.0,
      weight: weight,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Body 2.5XS paragraph text style.
  TextStyle body2_5Xs({
    String? family,
    double? heightPx,
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
    double? widthPct,
  }) {
    return buildStyle(
      family: family ?? fonts.body,
      size: 10,
      heightPx: heightPx ?? 10,
      widthPct: widthPct ?? 0.0,
      weight: weight,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Triple Extra Small Body (Body 3XS) paragraph text style.
  TextStyle body3Xs({
    String? family,
    double? heightPx,
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
    double? widthPct,
  }) {
    return buildStyle(
      family: family ?? fonts.body,
      size: 8,
      heightPx: heightPx ?? 12,
      widthPct: widthPct ?? 0.0,
      weight: weight,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the standard Input text style, typically used inside text fields.
  TextStyle input({
    String? family,
    double? heightPx,
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
    double? widthPct,
  }) {
    return buildStyle(
      family: family ?? fonts.body,
      size: 17,
      heightPx: heightPx ?? 24,
      widthPct: widthPct ?? 0.0,
      weight: weight,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  // ---------------------------------------------------------------------------
  // LABELS (label prefix) | Inter, Medium (400)
  // ---------------------------------------------------------------------------

  /// Generates the Extra Large Label (Label XL) text style.
  TextStyle labelXl({
    String? family,
    double? heightPx,
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
    double? widthPct,
  }) {
    return buildStyle(
      family: family ?? fonts.body,
      size: 24,
      heightPx: heightPx ?? 32,
      widthPct: widthPct ?? 0.0,
      weight: weight,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Large Label (Label L) text style.
  TextStyle labelL({
    String? family,
    double? heightPx,
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
    double? widthPct,
  }) {
    return buildStyle(
      family: family ?? fonts.body,
      size: 18,
      heightPx: heightPx ?? 24,
      widthPct: widthPct ?? 0.0,
      weight: weight,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Medium Label (Label M) text style.
  TextStyle labelM({
    String? family,
    double? heightPx,
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
    double? widthPct,
  }) {
    return buildStyle(
      family: family ?? fonts.body,
      size: 16,
      heightPx: heightPx ?? 24,
      widthPct: widthPct ?? 0.0,
      weight: weight,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Small Label (Label S) text style.
  TextStyle labelS({
    String? family,
    double? heightPx,
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
    double? widthPct,
  }) {
    return buildStyle(
      family: family ?? fonts.body,
      size: 14,
      heightPx: heightPx ?? 20,
      widthPct: widthPct ?? 0.0,
      weight: weight,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Extra Small Label (Label XS) text style.
  TextStyle labelXs({
    String? family,
    double? heightPx,
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
    double? widthPct,
  }) {
    return buildStyle(
      family: family ?? fonts.body,
      size: 12,
      heightPx: heightPx ?? 16,
      widthPct: widthPct ?? 0.0,
      weight: weight,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  // ---------------------------------------------------------------------------
  // TITLES (title prefix) | Inter, Bold (700), High Tracking
  // ---------------------------------------------------------------------------

  /// Generates the Title text style.
  TextStyle title({
    String? family,
    double? heightPx,
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
    double? widthPct,
  }) {
    return buildStyle(
      family: family ?? fonts.body,
      size: 48,
      heightPx: heightPx ?? 96,
      widthPct: widthPct ?? 0,
      weight: weight ?? .w700,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Title 3 text style.
  TextStyle title3({
    String? family,
    double? heightPx,
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
    double? widthPct,
  }) {
    return buildStyle(
      family: family ?? fonts.body,
      size: 20,
      heightPx: heightPx ?? 40,
      widthPct: widthPct ?? 0,
      weight: weight ?? .w700,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Medium Title (Title M) text style.
  TextStyle titleM({
    String? family,
    double? heightPx,
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
    double? widthPct,
  }) {
    return buildStyle(
      family: family ?? fonts.body,
      size: 16,
      heightPx: heightPx ?? 24,
      widthPct: widthPct ?? 6.0,
      weight: weight ?? .w700,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Small Title (Title S) text style.
  TextStyle titleS({
    String? family,
    double? heightPx,
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
    double? widthPct,
  }) {
    return buildStyle(
      family: family ?? fonts.body,
      size: 14,
      heightPx: heightPx ?? 20,
      widthPct: widthPct ?? 6.0,
      weight: weight ?? .w700,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Extra Small Title (Title XS) text style.
  TextStyle titleXs({
    String? family,
    double? heightPx,
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
    double? widthPct,
  }) {
    return buildStyle(
      family: family ?? fonts.body,
      size: 12,
      heightPx: heightPx ?? 16,
      widthPct: widthPct ?? 4.0,
      weight: weight ?? .w700,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Double Extra Small Title (Title 2XS) text style.
  TextStyle title2xs({
    String? family,
    double? heightPx,
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
    double? widthPct,
  }) {
    return buildStyle(
      family: family ?? fonts.body,
      size: 11,
      heightPx: heightPx ?? 12,
      widthPct: widthPct ?? 2.0,
      weight: weight ?? .w700,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Triple Extra Small Title (Title 3XS) text style.
  TextStyle title3xs({
    String? family,
    double? heightPx,
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
    double? widthPct,
  }) {
    return buildStyle(
      family: family ?? fonts.body,
      size: 10,
      heightPx: heightPx ?? 11,
      widthPct: widthPct ?? 2.0,
      weight: weight ?? .w700,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Quadruple Extra Small Title (Title 4XS) text style.
  TextStyle title4xs({
    String? family,
    double? heightPx,
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
    double? widthPct,
  }) {
    return buildStyle(
      family: family ?? fonts.body,
      size: 8,
      heightPx: heightPx ?? 9,
      widthPct: widthPct ?? 2.0,
      weight: weight ?? .w700,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  // ---------------------------------------------------------------------------
  // SUBHEADINGS (subHead prefix) | Inter, Medium (500), High Tracking
  // ---------------------------------------------------------------------------

  /// Generates the Extra Large Subheading (Subhead XL) text style.
  TextStyle subHeadXl({
    String? family,
    double? heightPx,
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
    double? widthPct,
  }) {
    return buildStyle(
      family: family ?? fonts.body,
      size: 24,
      heightPx: heightPx ?? 32,
      widthPct: widthPct ?? -1.5,
      weight: weight ?? .w500,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Large Subheading (Subhead L) text style.
  TextStyle subHeadL({
    String? family,
    double? heightPx,
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
    double? widthPct,
  }) {
    return buildStyle(
      family: family ?? fonts.body,
      size: 20,
      heightPx: heightPx ?? 24,
      widthPct: widthPct ?? -1.5,
      weight: weight ?? .w500,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Medium Subheading (Subhead M) text style.
  TextStyle subHeadM({
    String? family,
    double? heightPx,
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
    double? widthPct,
  }) {
    return buildStyle(
      family: family ?? fonts.body,
      size: 16,
      heightPx: heightPx ?? 24,
      widthPct: widthPct ?? 6.0,
      weight: weight ?? .w500,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Secondary Medium Subheading (Subhead 2M) text style, with
  /// no tracking.
  TextStyle subHead2M({
    String? family,
    double? heightPx,
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
    double? widthPct,
  }) {
    return buildStyle(
      family: family ?? fonts.body,
      size: 16,
      heightPx: heightPx ?? 24,
      widthPct: widthPct ?? 0,
      weight: weight ?? .w500,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Tertiary Medium Subheading (Subhead 3M) text style, a 15px
  /// Subhead 2M.
  TextStyle subHead3M({
    String? family,
    double? heightPx,
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
    double? widthPct,
  }) {
    return buildStyle(
      family: family ?? fonts.body,
      size: 15,
      heightPx: heightPx ?? 24,
      widthPct: widthPct ?? 0,
      weight: weight ?? .w500,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Small Subheading (Subhead S) text style.
  TextStyle subHeadS({
    String? family,
    double? heightPx,
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
    double? widthPct,
  }) {
    return buildStyle(
      family: family ?? fonts.body,
      size: 14,
      heightPx: heightPx ?? 20,
      widthPct: widthPct ?? 6.0,
      weight: weight ?? .w500,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Secondary Small Subheading (Subhead 2S) text style.
  TextStyle subHead2s({
    String? family,
    double? heightPx,
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
    double? widthPct,
  }) {
    return buildStyle(
      family: family ?? fonts.body,
      size: 13,
      heightPx: heightPx ?? 16,
      widthPct: widthPct ?? 0,
      weight: weight ?? .w500,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Extra Small Subheading (Subhead XS) text style.
  ///
  /// Tracking defaults to 4%. Pass [widthPct] to override it.
  TextStyle subHeadXs({
    String? family,
    double? heightPx,
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
    double? widthPct,
  }) {
    return buildStyle(
      family: family ?? fonts.body,
      size: 12,
      heightPx: heightPx ?? 16,
      widthPct: widthPct ?? 4.0,
      weight: weight ?? .w500,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the chart Y-axis tick (Chart Y Tick) text style.
  TextStyle chartYtick({
    String? family,
    double? heightPx,
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
    double? widthPct,
  }) {
    return buildStyle(
      family: family ?? fonts.title,
      size: 12,
      heightPx: heightPx ?? 16,
      widthPct: widthPct ?? 4.0,
      weight: weight ?? .w500,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Double Extra Small Subheading (Subhead 2XS) text style.
  TextStyle subHead2xs({
    String? family,
    double? heightPx,
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
    double? widthPct,
  }) {
    return buildStyle(
      family: family ?? fonts.body,
      size: 11,
      heightPx: heightPx ?? 12,
      widthPct: widthPct ?? 2.0,
      weight: weight ?? .w500,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Triple Extra Small Subheading (Subhead 3XS) text style.
  TextStyle subHead3xs({
    String? family,
    double? heightPx,
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
    double? widthPct,
  }) {
    return buildStyle(
      family: family ?? fonts.body,
      size: 10,
      heightPx: heightPx ?? 14,
      widthPct: widthPct ?? 0,
      weight: weight ?? .w500,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Subhead 3.5XS text style.
  TextStyle subHead3_5xs({
    String? family,
    double? heightPx,
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
    double? widthPct,
  }) {
    return buildStyle(
      family: family ?? fonts.body,
      size: 9,
      heightPx: heightPx ?? 12,
      widthPct: widthPct ?? 0,
      weight: weight ?? .w500,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Quadruple Extra Small Subheading (Subhead 4XS) text style.
  TextStyle subHead4xs({
    String? family,
    double? heightPx,
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
    double? widthPct,
  }) {
    return buildStyle(
      family: family ?? fonts.body,
      size: 8,
      heightPx: heightPx ?? 12,
      widthPct: widthPct ?? 0,
      weight: weight ?? .w500,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the standard Button text style.
  TextStyle button({
    String? family,
    double? heightPx,
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
    double? widthPct,
  }) {
    return buildStyle(
      family: family ?? fonts.title,
      size: 18,
      heightPx: heightPx ?? 32,
      widthPct: widthPct ?? 1,
      weight: weight ?? .w700,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Small Button (Button S) text style.
  TextStyle buttonS({
    String? family,
    double? heightPx,
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
    double? widthPct,
  }) {
    return buildStyle(
      family: family ?? fonts.title,
      size: 14,
      heightPx: heightPx ?? 16,
      widthPct: widthPct ?? 0,
      weight: weight ?? .w700,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Secondary Small Button (Button 2S) text style.
  TextStyle button2s({
    String? family,
    double? heightPx,
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
    double? widthPct,
  }) {
    return buildStyle(
      family: family ?? fonts.title,
      size: 12,
      heightPx: heightPx ?? 12,
      widthPct: widthPct ?? 0,
      weight: weight ?? .w700,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Extra Small Button (Button XS) text style.
  TextStyle buttonXs({
    String? family,
    double? heightPx,
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
    double? widthPct,
  }) {
    return buildStyle(
      family: family ?? fonts.title,
      size: 10,
      heightPx: heightPx ?? 12,
      widthPct: widthPct ?? 0,
      weight: weight ?? .w700,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Double Extra Small Button (Button XXS) text style.
  TextStyle buttonXxs({
    String? family,
    double? heightPx,
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
    double? widthPct,
  }) {
    return buildStyle(
      family: family ?? fonts.title,
      size: 8,
      heightPx: heightPx ?? 8,
      widthPct: widthPct ?? 0,
      weight: weight ?? .w700,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  // ---------------------------------------------------------------------------
  // NAVIGATION
  // ---------------------------------------------------------------------------

  /// Bottom navigation label text for the floating **iOS** bar or Material
  /// **Android** [BottomNavigationBar].
  ///
  /// When [isAndroid] is true, [GtFonts.title] is used; iOS uses
  /// [GtFonts.body].
  TextStyle navBarLabel({
    String? family,
    double? heightPx,
    bool isAndroid = false,
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
    double? widthPct,
  }) {
    return buildStyle(
      family: family ?? (isAndroid ? fonts.title : fonts.body),
      size: isAndroid ? 11 : 9,
      heightPx: heightPx ?? 12,
      widthPct: widthPct ?? 0,
      weight: weight ?? (isAndroid ? .w700 : .w600),
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the text style used for calendar days and headers.
  TextStyle calendar({
    String? family,
    double? heightPx,
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
    double? widthPct,
  }) {
    return buildStyle(
      family: family ?? fonts.body,
      size: 14,
      heightPx: heightPx ?? 20,
      widthPct: widthPct ?? -.6,
      weight: weight ?? .w500,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the FX amount input (FX Input) text style.
  TextStyle fxInput({
    String? family,
    double? heightPx,
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
    double? widthPct,
  }) {
    return buildStyle(
      family: family ?? fonts.title,
      size: 28,
      heightPx: heightPx ?? 32,
      widthPct: widthPct ?? 0,
      weight: weight ?? .bold,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Rate Pill text style.
  TextStyle ratePill({
    String? family,
    double? heightPx,
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
    double? widthPct,
  }) {
    return buildStyle(
      family: family ?? fonts.title,
      size: 14,
      heightPx: heightPx ?? 20,
      widthPct: widthPct ?? 0,
      weight: weight ?? .w600,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// A collection containing all predefined [TextStyle] configurations paired with their labels.
  List<(String, TextStyle)> get all => [
    ('Display 1 (context.textStyles.d1)', d1()),
    ('Display 2 (context.textStyles.d2)', d2()),
    ('Display 3 (context.textStyles.d3)', d3()),
    ('Display 4 (context.textStyles.d4)', d4()),
    ('Welcome (context.textStyles.welcome)', welcome()),
    ('Heading 1 (context.textStyles.h1)', h1()),
    ('Heading 2 (context.textStyles.h2)', h2()),
    ('Heading 3 (context.textStyles.h3)', h3()),
    ('Heading 4 (context.textStyles.h4)', h4()),
    ('Heading 5 (context.textStyles.h5)', h5()),
    ('Heading 6 (context.textStyles.h6)', h6()),
    ('Heading 7 (context.textStyles.h7)', h7()),
    ('Avatar (context.textStyles.avatar)', avatar(size: 24)),
    ('Body XL (context.textStyles.bodyXl)', bodyXl()),
    ('Body L (context.textStyles.bodyL)', bodyL()),
    ('Body M (context.textStyles.bodyM)', bodyM()),
    ('Body S (context.textStyles.bodyS)', bodyS()),
    ('Body 2S (context.textStyles.body2s)', body2s()),
    ('Body XS (context.textStyles.bodyXs)', bodyXs()),
    ('Body 2XS (context.textStyles.body2Xs)', body2Xs()),
    ('Body 2.5XS (context.textStyles.body2_5Xs)', body2_5Xs()),
    ('Body 3XS (context.textStyles.body3Xs)', body3Xs()),
    ('Input (context.textStyles.input)', input()),
    ('Label XL (context.textStyles.labelXl)', labelXl()),
    ('Label L (context.textStyles.labelL)', labelL()),
    ('Label M (context.textStyles.labelM)', labelM()),
    ('Label S (context.textStyles.labelS)', labelS()),
    ('Label XS (context.textStyles.labelXs)', labelXs()),
    ('Title (context.textStyles.title)', title()),
    ('Title M (context.textStyles.titleM)', titleM()),
    ('Title S (context.textStyles.titleS)', titleS()),
    ('Title XS (context.textStyles.titleXs)', titleXs()),
    ('Title 2XS (context.textStyles.title2xs)', title2xs()),
    ('Title 3XS (context.textStyles.title3xs)', title3xs()),
    ('Title 4XS (context.textStyles.title4xs)', title4xs()),
    ('Subhead XL (context.textStyles.subHeadXl)', subHeadXl()),
    ('Subhead L (context.textStyles.subHeadL)', subHeadL()),
    ('Subhead M (context.textStyles.subHeadM)', subHeadM()),
    ('Subhead 2M (context.textStyles.subHead2M)', subHead2M()),
    ('Subhead 3M (context.textStyles.subHead3M)', subHead3M()),
    ('Subhead S (context.textStyles.subHeadS)', subHeadS()),
    ('Subhead 2S (context.textStyles.subHead2s)', subHead2s()),
    ('Subhead XS (context.textStyles.subHeadXs)', subHeadXs()),
    ('Chart Y Tick (context.textStyles.chartYtick)', chartYtick()),
    ('Subhead 2XS (context.textStyles.subHead2xs)', subHead2xs()),
    ('Subhead 3XS (context.textStyles.subHead3xs)', subHead3xs()),
    ('Subhead 3.5XS (context.textStyles.subHead3_5xs)', subHead3_5xs()),
    ('Subhead 4XS (context.textStyles.subHead4xs)', subHead4xs()),
    ('Button (context.textStyles.button)', button()),
    ('Button S (context.textStyles.buttonS)', buttonS()),
    ('Button 2S (context.textStyles.button2s)', button2s()),
    ('Button XS (context.textStyles.buttonXs)', buttonXs()),
    ('Button XXS (context.textStyles.buttonXxs)', buttonXxs()),
    ('Nav Bar Label (context.textStyles.navBarLabel)', navBarLabel()),
    ('Calendar (context.textStyles.calendar)', calendar()),
    ('FX Input (context.textStyles.fxInput)', fxInput()),
    ('Rate Pill (context.textStyles.ratePill)', ratePill()),
  ];
}
