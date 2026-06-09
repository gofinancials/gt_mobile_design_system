import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtGuageChart extends GtStatelessWidget {
  final double value;
  final double? height;
  final double? width;
  final GtGuageChartCenter? center;
  final Color? trackColor;
  final Color? valueColor;
  final double strokeWidth;
  final StrokeCap strokeCap;
  final GtCardVariant variant;

  const GtGuageChart({
    required this.value,
    this.height,
    this.width,
    this.center,
    this.trackColor,
    this.valueColor,
    this.strokeWidth = 34.3,
    this.strokeCap = StrokeCap.round,
    this.variant = .primary,
    super.key,
  }) : assert(value >= 0 && value <= 1);

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final chartValueColor = valueColor ?? variant.getIconColor(palette);
    final chartTrackColor = trackColor ?? variant.getBgColor(palette);

    return SizedBox(
      width: width,
      height: height ?? context.dp(188.px),
      child: RepaintBoundary(
        child: TweenAnimationBuilder(
          tween: Tween(begin: 0.0, end: value),
          duration: 1.seconds,
          curve: Curves.decelerate,
          builder: (_, double animatedValue, _) {
            return CustomPaint(
              painter: GtArcPainter(
                value: animatedValue,
                trackColor: chartTrackColor,
                valueColor: chartValueColor,
                strokeCap: strokeCap,
                strokeWidth: strokeWidth,
              ),
              child: center,
            );
          },
        ),
      ),
    );
  }
}

class GtGuageChartCenter extends StatelessWidget {
  final String? pillText;
  final String valueText;
  final String? footerText;
  final Color? valueColor;

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
