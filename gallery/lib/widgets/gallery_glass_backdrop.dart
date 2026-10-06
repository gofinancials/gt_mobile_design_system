import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GalleryGlassBackdrop extends StatelessWidget {
  final bool enabled;
  final Widget child;

  const GalleryGlassBackdrop({
    required this.child,
    this.enabled = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;
    final palette = context.palette;

    return Container(
      padding: context.insets.allDp(24.px),
      decoration: BoxDecoration(
        borderRadius: context.borderRadiusLg,
        gradient: LinearGradient(
          begin: .topLeft,
          end: .bottomRight,
          colors: [palette.raw.tealBlue600, palette.primary.base],
        ),
      ),
      child: child,
    );
  }
}
