import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

enum GtBottomNavBarButtonHidingBehavior {
  footer(value: "footer"),
  all(value: "all"),
  headerOnly(value: "headerOnly"),
  headerAndFooter(value: "headerAndFooter");

  const GtBottomNavBarButtonHidingBehavior({required this.value});
  final String value;
}

class GtButtonBottomNavBar extends GtStatelessWidget {
  final Widget button;
  final Widget? heading;
  final Widget? footer;
  final double? spacing;

  const GtButtonBottomNavBar({
    super.key,
    required this.button,
    this.heading,
    this.spacing,
    this.footer,
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
          children: [?heading, button, ?footer],
        ),
      ),
    );
  }
}
