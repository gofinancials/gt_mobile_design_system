import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/extensions/string_extensions.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Standardized **page header**: primary screen title with optional subtitle.
///
/// Typography is fixed to the design spec:
/// - **Title:** uppercase, 24px, weight 700 ([GtTextStyles.h5]).
/// - **Subtitle:** 14px, weight 400, 24px line height ([GtTextStyles.bodyS]), same
///   color as the title.
///
/// Uses [GtTextStyles] via [BuildContext] only, [GtGap] for the default **8px**
/// title–subtitle gap (design token: [GtSpacing.base]), and optional outer
/// [padding].
class GtPageHeader extends GtStatelessWidget {
  /// Primary heading text (shown in **uppercase**).
  final String title;

  /// Optional supporting line below the title.
  final String? subtitle;

  /// Overrides title and subtitle color; defaults to [GtPalette.text.strong].
  final Color? titleColor;

  /// Horizontal alignment of title and subtitle text.
  final TextAlign textAlign;

  /// Outer padding; when null, no extra padding is applied.
  final EdgeInsetsGeometry? padding;

  /// Creates a [GtPageHeader].
  const GtPageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.titleColor,
    this.textAlign = TextAlign.start,
    this.padding,
  });

  /// Heading 5: 24px, weight 700 ([FontWeight.bold]).
  TextStyle _titleStyle(BuildContext context) {
    return context.textStyles.h5(color: titleColor);
  }

  /// Body S: 14px, weight 400, 24px line height; color matches [titleColor] / title.
  TextStyle _subtitleStyle(BuildContext context) {
    const lineHeightPx = 24.0;
    final base = context.textStyles.bodyS(
      color: titleColor ?? context.palette.text.strong,
    );
    final size = base.fontSize ?? 14.0;
    return base.copyWith(
      fontWeight: FontWeight.w400,
      height: lineHeightPx / size,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Text block: title and optional subtitle with the standard 8px (base) gap.
    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        GtText(title.upper, style: _titleStyle(context), textAlign: textAlign),
        if (subtitle != null) ...[
          const GtGap.yBase(),
          GtText(
            subtitle!,
            style: _subtitleStyle(context),
            textAlign: textAlign,
          ),
        ],
      ],
    );

    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }

    return content;
  }
}
