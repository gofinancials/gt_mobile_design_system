import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

enum GtCountIndicatorType { error, success, info, warning, neutral }

class GtCountIndicator extends GtStatelessWidget {
  final int count;
  final double? size;
  final GtCountIndicatorType type;

  const GtCountIndicator(
    this.count, {
    this.size,
    super.key,
    this.type = GtCountIndicatorType.error,
  });

  Color _getBgColor(GtPalette palette) {
    return switch (type) {
      .error => palette.error.base,
      .success => palette.success.base,
      .info => palette.information.base,
      .warning => palette.warning.base,
      _ => palette.bg.surface,
    };
  }

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const Offstage();

    final palette = context.palette;
    final bgColor = _getBgColor(palette);
    final textColor = palette.text.white;

    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      constraints: BoxConstraints(
        minWidth: size ?? context.dp(20.px),
        minHeight: size ?? context.dp(20.px),
      ),
      child: Center(
        child: GtText(
          "${count > 9 ? '9+' : count}",
          textAlign: TextAlign.center,
          style: context.textStyles.bodyXs(color: textColor),
        ),
      ),
    );
  }
}
