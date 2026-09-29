import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/extensions/string_extensions.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Standardized **page header**: primary screen title with optional subtitle.
///
/// Typography defaults to the form-header spec:
/// - **Title:** uppercase, 24px, weight 700 ([GtTextStyles.h5]).
/// - **Subtitle:** 14px, weight 400 ([GtTextStyles.bodyS]), same
///   color as the title.
///
/// Headers that follow a different spec, such as the centred, illustrated
/// prompts, pass [titleStyle] and [subtitleStyle], each of which replaces its
/// default wholesale.
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

  /// Horizontal placement of the title and subtitle within the header.
  ///
  /// Defaults to [CrossAxisAlignment.stretch], so the texts span the header's
  /// width and [textAlign] positions them.
  final CrossAxisAlignment crossAxisAlignment;

  /// Overrides title style. Null preserves the current default.
  ///
  /// Replaces the default wholesale, so [titleColor] does not apply to it.
  final TextStyle? titleStyle;

  /// Overrides subtitle style. Null preserves the current default.
  ///
  /// Replaces the default wholesale, so [titleColor] and [subTitleColor] do
  /// not apply to it.
  final TextStyle? subtitleStyle;

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
    this.textAlign = .start,
    this.crossAxisAlignment = .stretch,
    this.titleStyle,
    this.subtitleStyle,
  }) : _rich = false,
       hashTagColor = null,
       linkColor = null;

  /// Creates a [GtPageHeader] whose [subtitle] is parsed as rich markup by
  /// [GtRichText].
  const GtPageHeader.rich({
    super.key,
    required this.title,
    this.subtitle,
    this.titleColor,
    this.subTitleColor,
    this.spacingPx,
    this.textAlign = .start,
    this.crossAxisAlignment = .stretch,
    this.titleStyle,
    this.subtitleStyle,
    this.hashTagColor,
    this.linkColor,
  }) : _rich = true;

  /// [titleStyle], else Heading 5: 24px, weight 700 ([FontWeight.bold]).
  TextStyle _titleStyle(BuildContext context) {
    return titleStyle ?? context.textStyles.h5(color: titleColor);
  }

  /// [subtitleStyle], else Body S: 14px, regular (400) via [GtTextStyles]
  /// defaults.
  TextStyle _subtitleStyle(BuildContext context) {
    return subtitleStyle ??
        context.textStyles.bodyS(color: subTitleColor ?? titleColor);
  }

  @override
  Widget build(BuildContext context) {
    final gapPx = spacingPx;
    final spacing = gapPx == null ? context.spacingBase : context.dp(gapPx.px);

    return Column(
      crossAxisAlignment: crossAxisAlignment,
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
            style: _subtitleStyle(context),
            textAlign: textAlign,
            linkColor: linkColor ?? context.palette.primary.base,
            hashTagColor: hashTagColor ?? context.palette.primary.base,
          ),
      ],
    );
  }
}
