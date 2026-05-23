import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Defines the standard sizes available for Go Tech back button.
enum GtBackButtonSize {
  /// A small action button with a baseline height of 20.
  small(24),

  /// A large action button with a baseline height of 48.
  large(32);

  const GtBackButtonSize(this.value);

  /// The baseline height value in logical pixels.
  final double value;
}

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

  /// The size of the back button.
  final GtBackButtonSize size;

  /// Optional color to override the default color of the back icon.
  final Color? color;

  /// Creates a new [GtBackButton].
  const GtBackButton({
    super.key,
    this.action,
    this.padding,
    this.routeStackSensitive = true,
    this.alignment = Alignment.centerLeft,
    this.size = .large,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final canPop = context.canPop;
    final cubeSize = context.dp(size.value.px);
    final iconSize = switch (size) {
      .small => context.dp(18.px),
      _ => context.dp(20.px),
    };

    if (!canPop && routeStackSensitive) {
      return const Offstage();
    }

    return Align(
      alignment: alignment,
      child: Material(
        type: MaterialType.transparency,
        child: Hero(
          tag: "gt-back-button",
          child: GtInkWell(
            hapticFeedbackType: .medium,
            onTap: () {
              if (action != null) return action!();
              if (!canPop && routeStackSensitive) return;

              Navigator.of(context).maybePop();
            },
            child: GtSquareConstrainedBox(
              cubeSize,
              child: GtIcon.withColor(
                GtIcons.chevronLeft,
                size: iconSize,
                alignment: .center,
                color: color ?? context.palette.icon.strong,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
