import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A widget designed to display centered content within a [GtGuageChart].
///
/// It vertically aligns an optional [pillText], a primary [valueText], and an optional [footerText].
class GtGuageChartCenter extends StatelessWidget {
  /// The optional text displayed in a pill-shaped badge above the primary value.
  final String? pillText;

  /// The primary prominent text displayed in the center.
  final String valueText;

  /// The optional secondary descriptive text displayed below the primary value.
  final String? footerText;

  /// The optional color for the [valueText]. Defaults to the standard h5 text color.
  final Color? valueColor;

  /// Creates a new [GtGuageChartCenter] with the given [valueText].
  const GtGuageChartCenter(
    this.valueText, {
    this.pillText,
    this.footerText,
    this.valueColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final styles = context.textStyles;
    final palette = context.palette;

    final valueStyle = styles.h5(color: valueColor);
    final footerStyle = styles.bodyXs(color: palette.text.soft);
    final pillStyle = styles.buttonXs();

    return FractionalTranslation(
      translation: Offset(0, -.15),
      child: Column(
        mainAxisAlignment: .center,
        crossAxisAlignment: .center,
        mainAxisSize: .min,
        spacing: context.spacingBase,
        children: [
          if (pillText.hasValue)
            GtPill(
              text: pillText?.upper ?? "",
              padding: context.insets.symmetricDp(
                horizontal: 8.px,
                vertical: 6.px,
              ),
              variant: .neutral,
              bgColor: palette.bg.weak,
              borderColor: palette.bg.soft,
              textStyle: pillStyle,
              textColor: palette.text.strong,
              alignment: .center,
              borderRadius: context.borderRadiusFull,
            ),
          GtText(valueText, style: valueStyle, maxLines: 1, textAlign: .center),
          if (footerText.hasValue)
            GtText(
              footerText!,
              style: footerStyle,
              textAlign: .center,
              maxLines: 1,
            ),
        ],
      ),
    );
  }
}
