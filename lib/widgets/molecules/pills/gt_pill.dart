import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

enum GtStatusPillVariant {
  strong,
  neutral,
  featured,
  info,
  success,
  warning,
  error,
  highlighted,
  stable,
  verified,
  away,
}

extension on GtStatusPillVariant? {
  Color getTextColor(GtPalette palette) {
    return switch (this) {
      .neutral => palette.text.sub,
      .featured => palette.feature.base,
      .info => palette.information.base,
      .success => palette.success.dark,
      .warning => palette.warning.dark,
      .error => palette.error.base,
      .highlighted => palette.highlighted.base,
      .stable => palette.stable.base,
      .verified => palette.success.base,
      .away => palette.away.base,
      _ => palette.text.strong,
    };
  }

  Color getBorderColor(GtPalette palette) {
    return switch (this) {
      .neutral => palette.text.soft,
      .featured => palette.feature.light,
      .info => palette.information.light,
      .success => palette.success.light,
      .warning => palette.warning.light,
      .error => palette.error.light,
      .highlighted => palette.highlighted.light,
      .stable => palette.stable.light,
      .verified => palette.success.light,
      .away => palette.away.light,
      _ => palette.text.strong.setOpacity(0.4),
    };
  }

  Color getBgColor(GtPalette palette) {
    return switch (this) {
      .neutral => palette.bg.weak,
      .featured => palette.feature.lighter,
      .info => palette.information.lighter,
      .success => palette.success.lighter,
      .warning => palette.warning.lighter,
      .error => palette.error.lighter,
      .highlighted => palette.highlighted.lighter,
      .stable => palette.stable.lighter,
      .verified => palette.success.lighter,
      .away => palette.away.lighter,
      _ => palette.text.strong.setOpacity(0.2),
    };
  }
}

class GtStatusPill extends StatelessWidget {
  final String text;
  final GtStatusPillVariant? variant;
  final IconData? icon;
  final bool showBorder;

  const GtStatusPill({
    super.key,
    required this.text,
    this.variant,
    this.icon,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textColor = variant.getTextColor(palette);
    final bgColor = variant.getBgColor(palette);
    final borderColor = variant.getBorderColor(palette);

    Widget child = GtText(
      text.upper,
      style: context.textStyles.buttonXxs(color: textColor),
      textAlign: TextAlign.center,
    );

    if (icon != null) {
      child = Row(
        spacing: context.spacingSm,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GtIcon.withColor(icon!, color: textColor, size: 11),
          child,
        ],
      );
    }

    return Container(
      padding: context.insets.allDp(4.px),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: context.borderRadiusSm,
        border: Border.all(color: showBorder ? borderColor : bgColor),
      ),
      child: child,
    );
  }
}
