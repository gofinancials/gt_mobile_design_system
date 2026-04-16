import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtCancelButton extends GtStatelessWidget {
  final OnPressed? subAction;
  final OnPressed? onTap;
  final AlignmentGeometry alignment;
  final double size;
  final bool asHero;
  final bool primary;

  const GtCancelButton({
    super.key,
    this.subAction,
    this.onTap,
    this.alignment = Alignment.centerRight,
    this.size = 24,
    this.asHero = false,
    this.primary = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        if (subAction != null) {
          subAction!();
        }
        if (onTap != null) {
          return onTap!();
        }
        Navigator.of(context).pop();
      },
      child: GtSvg.asIcon(
        GtVectorIcons.cancelIcon,
        size: context.dp(size.px),
        alignment: alignment,
      ),
    );

    if (asHero) {
      child = Material(
        type: MaterialType.transparency,
        child: Hero(tag: "app-cancel-button-hero", child: child),
      );
    }

    return child;
  }
}
