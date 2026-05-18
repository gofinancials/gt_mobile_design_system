import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/extensions/string_extensions.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Standardized **page header**: primary screen title with optional subtitle.
///
/// Typography is fixed to the design spec:
/// - **Title:** uppercase, 24px, weight 700 ([GtTextStyles.h5]).
/// - **Subtitle:** 14px, weight 400 ([GtTextStyles.bodyS]), same
///   color as the title.
///
/// Uses [GtTextStyles] via [BuildContext] only. Vertical space between title and
/// subtitle uses [Column.spacing]; when [spacingPx] is null it falls
/// back to [BuildContext.spacingBase] (~8dp). Wrap with [Padding] or padded
/// parents (e.g. [SafeArea], [ListView] padding) as needed.
class GtPageHeader extends GtStatelessWidget {
  /// Primary heading text (shown in **uppercase**).
  final String title;

  /// Optional supporting line below the title.
  final String? subtitle;

  /// Overrides title and subtitle color; defaults to [GtPalette.text.strong].
  final Color? titleColor;

  /// Overrides subtitle color; defaults to [GtPalette.text.strong].
  final Color? subTitleColor;

  /// Vertical gap between title and subtitle in **design pixels**.
  ///
  /// When `null`, uses [spacingBase] (`context.spacingBase`, ~8dp). Otherwise
  /// passed through [BuildContext.dp] via [num.px].
  final double? spacingPx;

  /// Horizontal alignment of title and subtitle text.
  final TextAlign textAlign;

  /// The color used to style automatically detected hashtags (`<ht>` tags). Defaults to the highlighted base color.
  final Color? hashTagColor;

  /// The color used for links (`<a>`, `<b><a>`, etc.). Defaults to the base text color.
  final Color? linkColor;

  final bool _rich;

  /// Creates a [GtPageHeader].
  const GtPageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.titleColor,
    this.subTitleColor,
    this.spacingPx,
    this.textAlign = TextAlign.start,
  }) : _rich = false,
       hashTagColor = null,
       linkColor = null;

  const GtPageHeader.rich({
    super.key,
    required this.title,
    this.subtitle,
    this.titleColor,
    this.subTitleColor,
    this.spacingPx,
    this.textAlign = TextAlign.start,
    this.hashTagColor,
    this.linkColor,
  }) : _rich = true;

  /// Heading 5: 24px, weight 700 ([FontWeight.bold]).
  TextStyle _titleStyle(BuildContext context) {
    return context.textStyles.h5(color: titleColor);
  }

  /// Body S: 14px, regular (400) via [GtTextStyles] defaults.
  TextStyle _subtitleStyle(BuildContext context) {
    return context.textStyles.bodyS(color: subTitleColor ?? titleColor);
  }

  @override
  Widget build(BuildContext context) {
    final gapPx = spacingPx;
    final spacing = gapPx == null ? context.spacingBase : context.dp(gapPx.px);

    return Column(
      crossAxisAlignment: .stretch,
      mainAxisSize: .min,
      spacing: spacing,
      children: [
        GtText(title.upper, style: _titleStyle(context), textAlign: textAlign),
        if (subtitle.hasValue && !_rich)
          GtText(
            subtitle,
            style: _subtitleStyle(context),
            textAlign: textAlign,
          ),
        if (subtitle.hasValue && _rich)
          GtRichText(
            subtitle,
            key: ValueKey((context.isInDarkMode, subtitle?.length)),
            style: _subtitleStyle(context),
            textAlign: textAlign,
            linkColor: linkColor ?? context.palette.primary.base,
            hashTagColor: hashTagColor ?? context.palette.primary.base,
          ),
      ],
    );
  }
}
