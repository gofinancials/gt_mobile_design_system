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
class GtTextStyles {
  /// The [BuildContext] used to access the current theme and scaling utilities.
  final BuildContext context;
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
  TextStyle _buildStyle({
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
      fontWeight: weight ?? FontWeight.normal,
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
    return _buildStyle(
      family: fonts.title,
      size: 64,
      heightPx: heightPx ?? 72,
      widthPct: -2.0,
      weight: FontWeight.bold,
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
    return _buildStyle(
      family: fonts.title,
      size: 56,
      heightPx: heightPx ?? 64,
      widthPct: -0.5,
      weight: FontWeight.bold,
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
    return _buildStyle(
      family: fonts.title,
      size: 48,
      heightPx: heightPx ?? 50,
      widthPct: 0.0,
      weight: FontWeight.bold,
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
    return _buildStyle(
      family: fonts.title,
      size: 32,
      heightPx: heightPx ?? 40,
      widthPct: 0.0,
      weight: FontWeight.bold,
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

  /// Generates the welcom screen title text style.
  TextStyle welcome({
    double? heightPx,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return _buildStyle(
      family: fonts.title,
      size: 60,
      heightPx: heightPx ?? 52,
      widthPct: -1.0,
      weight: FontWeight.bold,
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
    return _buildStyle(
      family: fonts.title,
      size: 56,
      heightPx: heightPx ?? 64,
      widthPct: -1.0,
      weight: FontWeight.bold,
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
    return _buildStyle(
      family: fonts.title,
      size: 48,
      heightPx: heightPx ?? 56,
      widthPct: -1.0,
      weight: FontWeight.bold,
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
    return _buildStyle(
      family: fonts.title,
      size: 40,
      heightPx: heightPx ?? 48,
      widthPct: -1.0,
      weight: FontWeight.bold,
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
    return _buildStyle(
      family: fonts.title,
      size: 32,
      heightPx: heightPx ?? 40,
      widthPct: -0.5,
      weight: FontWeight.bold,
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
    return _buildStyle(
      family: fonts.title,
      size: 24,
      heightPx: heightPx ?? 32,
      widthPct: 0.0,
      weight: FontWeight.bold,
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
    return _buildStyle(
      family: fonts.title,
      size: 20,
      heightPx: heightPx ?? 28,
      widthPct: 0.0,
      weight: FontWeight.bold,
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
    return _buildStyle(
      family: fonts.title,
      size: 16,
      heightPx: heightPx ?? 20,
      widthPct: 0.0,
      weight: FontWeight.bold,
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
    double? heightPx,
    Color? color,
    TextOverflow? overflow,
    required double size,
  }) {
    return _buildStyle(
      family: fonts.title,
      size: size,
      heightPx: size * 1.25,
      widthPct: 0.0,
      weight: FontWeight.w600,
      color: color,
    );
  }

  // ---------------------------------------------------------------------------
  // PARAGRAPHS (body prefix) | Inter, Regular (400)
  // ---------------------------------------------------------------------------

  /// Generates the Extra Large Body (Body XL) paragraph text style.
  TextStyle bodyXl({
    double? heightPx,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return _buildStyle(
      family: fonts.body,
      size: 24,
      heightPx: heightPx ?? 32,
      widthPct: -1.5,
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
    double? heightPx,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return _buildStyle(
      family: fonts.body,
      size: 18,
      heightPx: heightPx ?? 24,
      widthPct: -1.5,
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
    double? heightPx,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return _buildStyle(
      family: fonts.body,
      size: 16,
      heightPx: heightPx ?? 24,
      widthPct: -1.1,
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
    double? heightPx,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return _buildStyle(
      family: fonts.body,
      size: 14,
      heightPx: heightPx ?? 20,
      widthPct: -0.6,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Small Body (Body S) paragraph text style.
  TextStyle body2s({
    double? heightPx,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return _buildStyle(
      family: fonts.body,
      size: 13,
      heightPx: heightPx ?? 16,
      widthPct: 1,
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
    double? heightPx,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return _buildStyle(
      family: fonts.body,
      size: 12,
      heightPx: heightPx ?? 16,
      widthPct: 0.0,
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
    double? heightPx,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return _buildStyle(
      family: fonts.body,
      size: 11,
      heightPx: heightPx ?? 12,
      widthPct: 0.0,
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
    double? heightPx,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return _buildStyle(
      family: fonts.body,
      size: 8,
      heightPx: heightPx ?? 12,
      widthPct: 0.0,
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
    double? heightPx,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return _buildStyle(
      family: fonts.body,
      size: 17,
      heightPx: heightPx ?? 24,
      widthPct: 0.0,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  // ---------------------------------------------------------------------------
  // LABELS (label prefix) | Inter, Medium (500)
  // ---------------------------------------------------------------------------

  /// Generates the Extra Large Label (Label XL) text style.
  TextStyle labelXl({
    double? heightPx,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return _buildStyle(
      family: fonts.body,
      size: 24,
      heightPx: heightPx ?? 32,
      widthPct: 0.0,
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
    double? heightPx,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return _buildStyle(
      family: fonts.body,
      size: 18,
      heightPx: heightPx ?? 24,
      widthPct: 0.0,
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
    double? heightPx,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return _buildStyle(
      family: fonts.body,
      size: 16,
      heightPx: heightPx ?? 24,
      widthPct: 0.0,
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
    double? heightPx,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return _buildStyle(
      family: fonts.body,
      size: 14,
      heightPx: heightPx ?? 20,
      widthPct: 0.0,
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
    double? heightPx,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return _buildStyle(
      family: fonts.body,
      size: 12,
      heightPx: heightPx ?? 16,
      widthPct: 0.0,
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

  TextStyle title({
    double? heightPx,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return _buildStyle(
      family: fonts.body,
      size: 48,
      heightPx: heightPx ?? 96,
      widthPct: 0,
      weight: FontWeight.w700,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  TextStyle titleM({
    double? heightPx,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return _buildStyle(
      family: fonts.body,
      size: 16,
      heightPx: heightPx ?? 24,
      widthPct: 6.0,
      weight: FontWeight.w700,
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
    double? heightPx,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return _buildStyle(
      family: fonts.body,
      size: 14,
      heightPx: heightPx ?? 20,
      widthPct: 6.0,
      weight: FontWeight.w700,
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
    double? heightPx,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return _buildStyle(
      family: fonts.body,
      size: 12,
      heightPx: heightPx ?? 16,
      widthPct: 4.0,
      weight: FontWeight.w700,
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
    double? heightPx,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return _buildStyle(
      family: fonts.body,
      size: 11,
      heightPx: heightPx ?? 12,
      widthPct: 2.0,
      weight: FontWeight.w700,
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

  TextStyle subHeadXl({
    double? heightPx,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return _buildStyle(
      family: fonts.body,
      size: 24,
      heightPx: heightPx ?? 32,
      widthPct: -1.5,
      weight: FontWeight.w500,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// subHeadL: 20px, weight 500
  TextStyle subHeadL({
    double? heightPx,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return _buildStyle(
      family: fonts.body,
      size: 20,
      heightPx: heightPx ?? 24,
      widthPct: -1.5,
      weight: FontWeight.w500,
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
    double? heightPx,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return _buildStyle(
      family: fonts.body,
      size: 16,
      heightPx: heightPx ?? 24,
      widthPct: 6.0,
      weight: FontWeight.w500,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Medium Subheading (Subhead M) text style with no widthPct.
  TextStyle subHead2M({
    double? heightPx,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return _buildStyle(
      family: fonts.body,
      size: 16,
      heightPx: heightPx ?? 24,
      widthPct: 0,
      weight: FontWeight.w500,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Medium Subheading (Subhead M) text style with no widthPct.
  TextStyle subHead3M({
    double? heightPx,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return _buildStyle(
      family: fonts.body,
      size: 15,
      heightPx: heightPx ?? 24,
      widthPct: 0,
      weight: FontWeight.w500,
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
    double? heightPx,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return _buildStyle(
      family: fonts.body,
      size: 14,
      heightPx: heightPx ?? 20,
      widthPct: 6.0,
      weight: FontWeight.w500,
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
    double? heightPx,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return _buildStyle(
      family: fonts.body,
      size: 13,
      heightPx: heightPx ?? 16,
      widthPct: 0,
      weight: FontWeight.w500,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Extra Small Subheading (Subhead XS) text style.
  TextStyle subHeadXs({
    double? heightPx,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return _buildStyle(
      family: fonts.body,
      size: 12,
      heightPx: heightPx ?? 16,
      widthPct: 4.0,
      weight: FontWeight.w500,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      overflow: overflow,
    );
  }

  /// Generates the Extra Small Subheading (Subhead XS) text style.
  TextStyle chartYtick({
    double? heightPx,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return _buildStyle(
      family: fonts.title,
      size: 12,
      heightPx: heightPx ?? 16,
      widthPct: 4.0,
      weight: FontWeight.w500,
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
    double? heightPx,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return _buildStyle(
      family: fonts.body,
      size: 11,
      heightPx: heightPx ?? 12,
      widthPct: 2.0,
      weight: FontWeight.w500,
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
    double? heightPx,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return _buildStyle(
      family: fonts.title,
      size: 18,
      heightPx: heightPx ?? 32,
      widthPct: 1,
      weight: FontWeight.w700,
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
    double? heightPx,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return _buildStyle(
      family: fonts.title,
      size: 14,
      heightPx: heightPx ?? 16,
      widthPct: 0,
      weight: FontWeight.w700,
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
    double? heightPx,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return _buildStyle(
      family: fonts.title,
      size: 12,
      heightPx: heightPx ?? 16,
      widthPct: 0,
      weight: FontWeight.w700,
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
    double? heightPx,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return _buildStyle(
      family: fonts.title,
      size: 10,
      heightPx: heightPx ?? 12,
      widthPct: 0,
      weight: FontWeight.w700,
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
    double? heightPx,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return _buildStyle(
      family: fonts.title,
      size: 8,
      heightPx: heightPx ?? 8,
      widthPct: 0,
      weight: FontWeight.w700,
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
  /// When [isAndroid] is true, [GtFonts.bottomNav] is used; iOS uses an empty
  /// family so the platform/theme default applies.
  TextStyle navBarLabel({
    double? heightPx,
    bool isAndroid = false,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return _buildStyle(
      family: isAndroid ? fonts.title : '',
      size: isAndroid ? 11 : 9,
      heightPx: heightPx ?? 12,
      widthPct: 0,
      weight: isAndroid ? FontWeight.w700 : FontWeight.w600,
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
    double? heightPx,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return _buildStyle(
      family: fonts.body,
      size: 14,
      heightPx: heightPx ?? 20,
      widthPct: -.6,
      weight: FontWeight.w500,
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
    ('Heading 1 (context.textStyles.h1)', h1()),
    ('Heading 2 (context.textStyles.h2)', h2()),
    ('Heading 3 (context.textStyles.h3)', h3()),
    ('Heading 4 (context.textStyles.h4)', h4()),
    ('Heading 5 (context.textStyles.h5)', h5()),
    ('Heading 6 (context.textStyles.h6)', h6()),
    ('Heading 7 (context.textStyles.h7)', h7()),
    ('Body XL (context.textStyles.bodyXl)', bodyXl()),
    ('Body L (context.textStyles.bodyL)', bodyL()),
    ('Body M (context.textStyles.bodyM)', bodyM()),
    ('Body S (context.textStyles.bodyS)', bodyS()),
    ('Body 2S (context.textStyles.body2s)', body2s()),
    ('Body XS (context.textStyles.bodyXs)', bodyXs()),
    ('Body 2XS (context.textStyles.body2Xs)', body2Xs()),
    ('Body 3XS (context.textStyles.body3Xs)', body3Xs()),
    ('Input (context.textStyles.input)', input()),
    ('Label XL (context.textStyles.labelXl)', labelXl()),
    ('Label L (context.textStyles.labelL)', labelL()),
    ('Label M (context.textStyles.labelM)', labelM()),
    ('Label S (context.textStyles.labelS)', labelS()),
    ('Label XS (context.textStyles.labelXs)', labelXs()),
    ('Title M (context.textStyles.titleM)', titleM()),
    ('Title S (context.textStyles.titleS)', titleS()),
    ('Title XS (context.textStyles.titleXs)', titleXs()),
    ('Title 2XS (context.textStyles.title2xs)', title2xs()),
    ('Subhead XL (context.textStyles.subHeadXl)', subHeadXl()),
    ('Subhead L (context.textStyles.subHeadL)', subHeadL()),
    ('Subhead M (context.textStyles.subHeadM)', subHeadM()),
    ('Subhead S (context.textStyles.subHeadS)', subHeadS()),
    ('Subhead 2S (context.textStyles.subHead2s)', subHead2s()),
    ('Subhead XS (context.textStyles.subHeadXs)', subHeadXs()),
    ('Subhead 2XS (context.textStyles.subHead2xs)', subHead2xs()),
    ('Button (context.textStyles.button)', button()),
    ('Button S (context.textStyles.buttonS)', buttonS()),
    ('Button 2S (context.textStyles.button2s)', button2s()),
    ('Button XS (context.textStyles.buttonXs)', buttonXs()),
    ('Button XXS (context.textStyles.buttonXxs)', buttonXxs()),
    ('Nav Bar Label (context.textStyles.navBarLabel)', navBarLabel()),
    ('Calendar (context.textStyles.calendar)', calendar()),
  ];
}
