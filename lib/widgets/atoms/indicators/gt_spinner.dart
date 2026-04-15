import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtSpinner extends GtStatelessWidget {
  final Color? color;
  final double? size;
  final double? value;
  final bool forceCentering;

  const GtSpinner({
    this.color,
    this.size,
    this.forceCentering = false,
    super.key,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = SizedBox(
      height: size ?? context.dp(20.px),
      width: size ?? context.dp(20.px),
      child: RepaintBoundary(
        child: CircularProgressIndicator(
          value: value,
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? context.palette.primary.base,
          ),
        ),
      ),
    );
    if (forceCentering) {
      child = Center(child: child);
    }
    return child;
  }
}
