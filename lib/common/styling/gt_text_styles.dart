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
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return _buildStyle(
      family: fonts.display,
      size: 64,
      heightPx: 72,
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
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return _buildStyle(
      family: fonts.display,
      size: 56,
      heightPx: 64,
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
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return _buildStyle(
      family: fonts.display,
      size: 48,
      heightPx: 50,
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
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return _buildStyle(
      family: fonts.display,
      size: 32,
      heightPx: 40,
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

  /// Generates the Heading 1 (H1) text style.
  TextStyle h1({
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return _buildStyle(
      family: fonts.display,
      size: 56,
      heightPx: 64,
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
      heightPx: 56,
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
      heightPx: 48,
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
      heightPx: 40,
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
      heightPx: 32,
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
      heightPx: 28,
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
      heightPx: 20,
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
  // PARAGRAPHS (body prefix) | Inter, Regular (400)
  // ---------------------------------------------------------------------------

  /// Generates the Extra Large Body (Body XL) paragraph text style.
  TextStyle bodyXl({
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
      heightPx: 32,
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
      heightPx: 24,
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
      heightPx: 24,
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
      heightPx: 20,
      widthPct: -0.6,
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
      heightPx: 16,
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
      heightPx: 12,
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
      heightPx: 12,
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
      heightPx: 32,
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
      heightPx: 24,
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
      heightPx: 24,
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
      heightPx: 20,
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
      heightPx: 16,
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

  /// Generates the Medium Title (Title M) text style.
  TextStyle titleM({
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
      heightPx: 24,
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
      heightPx: 20,
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
      heightPx: 16,
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
      heightPx: 12,
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

  /// Generates the Medium Subheading (Subhead M) text style.
  TextStyle subHeadM({
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
      heightPx: 24,
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

  /// Generates the Small Subheading (Subhead S) text style.
  TextStyle subHeadS({
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
      heightPx: 20,
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
      heightPx: 16,
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
      heightPx: 16,
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
      heightPx: 12,
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
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return _buildStyle(
      family: fonts.display,
      size: 18,
      heightPx: 32,
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
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return _buildStyle(
      family: fonts.display,
      size: 14,
      heightPx: 16,
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
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return _buildStyle(
      family: fonts.display,
      size: 12,
      heightPx: 16,
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
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return _buildStyle(
      family: fonts.display,
      size: 10,
      heightPx: 12,
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
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return _buildStyle(
      family: fonts.display,
      size: 8,
      heightPx: 8,
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
    bool isAndroid = false,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    TextOverflow? overflow,
  }) {
    return _buildStyle(
      family: isAndroid ? fonts.display : '',
      size: isAndroid ? 11 : 9,
      heightPx: 12,
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
}
