import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtButtonBottomNavBar extends GtStatelessWidget {
  final Widget button;
  final Widget? heading;
  final double? spacing;

  const GtButtonBottomNavBar({
    super.key,
    required this.button,
    this.heading,
    this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    final insets = context.insets;
    return SafeArea(
      top: false,
      maintainBottomViewPadding: true,
      child: Padding(
        padding: insets.defaultHorizontalInsets.add(
          insets.onlyDp(bottom: 24.px),
        ),
        child: Column(
          mainAxisAlignment: .end,
          mainAxisSize: .min,
          crossAxisAlignment: .stretch,
          spacing: spacing ?? context.spacingLg,
          children: [?heading, button],
        ),
      ),
    );
  }
}
