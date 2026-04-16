import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtBackButton extends GtStatelessWidget {
  final OnPressed? action;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry alignment;
  final bool routeStackSensitive;
  final bool primary;

  const GtBackButton({
    super.key,
    this.action,
    this.padding,
    this.routeStackSensitive = true,
    this.primary = false,
    this.alignment = Alignment.centerLeft,
  });

  // TODO: implement GtRouter can pop method
  bool get canPop => true;

  @override
  Widget build(BuildContext context) {
    if (!canPop && routeStackSensitive) {
      return const Offstage();
    }

    return Material(
      type: MaterialType.transparency,
      child: Hero(
        tag: "gt-back-button",
        child: InkWell(
          onTap: () {
            if (!canPop && routeStackSensitive) return;
            if (action != null) return action!();
            if (!canPop) return;

            Navigator.of(context).pop();
          },
          child: GtSvg.asIcon(
            GtVectorIcons.chevyLeftIcon,
            size: context.dp(24.px),
            alignment: alignment,
          ),
        ),
      ),
    );
  }
}
