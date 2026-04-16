import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A standardized back button component for the Go Tech design system.
///
/// This widget displays a back chevron icon and automatically handles popping
/// the current navigation route. It can be configured to be [routeStackSensitive],
/// which allows it to intelligently hide itself if there are no previous routes to return to.
class GtBackButton extends GtStatelessWidget {
  /// An optional custom callback to execute when the button is tapped.
  ///
  /// If provided, this overrides the default [Navigator.pop] behavior.
  final OnPressed? action;

  /// Optional padding to apply around the button's touch target.
  final EdgeInsetsGeometry? padding;

  /// The alignment of the back icon within its container. Defaults to [Alignment.centerLeft].
  final AlignmentGeometry alignment;

  /// Whether the button should automatically hide when the route stack cannot be popped.
  final bool routeStackSensitive;

  /// Indicates whether the button should use primary thematic styling.
  final bool primary;

  /// Creates a new [GtBackButton].
  const GtBackButton({
    super.key,
    this.action,
    this.padding,
    this.routeStackSensitive = true,
    this.primary = false,
    this.alignment = Alignment.centerLeft,
  });

  /// Determines whether the current navigation stack can be popped.
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
