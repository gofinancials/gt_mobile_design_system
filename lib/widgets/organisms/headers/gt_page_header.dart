import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_foundation/extensions/string_extensions.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Standardized **page header**: primary screen title with optional subtitle.
///
/// Typography is fixed to the design spec:
/// - **Title:** uppercase, 24px, weight 700 ([GtTextStyles.h5]).
/// - **Subtitle:** 14px, weight 400, 24px line height ([GtTextStyles.bodyS]), same
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

  /// Vertical gap between title and subtitle in **design pixels**.
  ///
  /// When `null`, uses [spacingBase] (`context.spacingBase`, ~8dp). Otherwise
  /// passed through [BuildContext.dp] via [num.px].
  final double? spacingPx;

  /// Horizontal alignment of title and subtitle text.
  final TextAlign textAlign;

  /// Creates a [GtPageHeader].
  const GtPageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.titleColor,
    this.spacingPx,
    this.textAlign = TextAlign.start,
  });

  /// Heading 5: 24px, weight 700 ([FontWeight.bold]).
  TextStyle _titleStyle(BuildContext context) {
    return context.textStyles.h5(color: titleColor);
  }

  /// Body S: 14px, regular (400) via [GtTextStyles] defaults, 24px line height.
  TextStyle _subtitleStyle(BuildContext context) {
    const lineHeightPx = 24.0;
    final base = context.textStyles.bodyS(color: titleColor);
    final size = base.fontSize ?? 14.0;
    return base.copyWith(height: lineHeightPx / size);
  }

  @override
  Widget build(BuildContext context) {
    final gapPx = spacingPx;
    final spacing = gapPx == null ? context.spacingBase : context.dp(gapPx.px);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      spacing: spacing,
      children: [
        GtText(title.upper, style: _titleStyle(context), textAlign: textAlign),
        if (subtitle != null)
          GtText(
            subtitle!,
            style: _subtitleStyle(context),
            textAlign: textAlign,
          ),
      ],
    );
  }
}
