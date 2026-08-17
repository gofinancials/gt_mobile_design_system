import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

enum GtBottomNavBarButtonHidingBehavior {
  footer,
  all,
  header,
  headerAndFooter;

  bool get canHideHeader => switch (this) {
    .footer => false,
    _ => true,
  };

  bool get canHideFooter => switch (this) {
    .header => false,
    _ => true,
  };

  bool get canHideButton => switch (this) {
    .all => true,
    _ => false,
  };
}

class GtButtonBottomNavBar extends GtStatelessWidget {
  final Widget button;
  final Widget? heading;
  final Widget? footer;
  final GtBottomNavBarButtonHidingBehavior hidingBehavior;
  final double? spacing;

  const GtButtonBottomNavBar({
    super.key,
    required this.button,
    this.heading,
    this.spacing,
    this.hidingBehavior = .footer,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final insets = context.insets;
    Widget? head = heading;

    if (head != null && hidingBehavior.canHideHeader) {
      head = _GtButtonHidingBehaviorProvider(
        key: const Key('gt-bnavbar-heading-hider'),
        canHide: hidingBehavior.canHideHeader,
        child: head,
      );
    }

    Widget? foot = footer;
    if (foot != null && hidingBehavior.canHideFooter) {
      foot = _GtButtonHidingBehaviorProvider(
        key: const Key('gt-bnavbar-footer-hider'),
        canHide: hidingBehavior.canHideFooter,
        child: foot,
      );
    }

    Widget btn = button;
    if (hidingBehavior.canHideButton) {
      btn = _GtButtonHidingBehaviorProvider(
        key: const Key('gt-bnavbar-button-hider'),
        canHide: hidingBehavior.canHideButton,
        child: btn,
      );
    }

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
          children: [?head, btn, ?foot],
        ),
      ),
    );
  }
}

class _GtButtonHidingBehaviorProvider extends GtStatelessWidget {
  final Widget child;
  final bool canHide;

  const _GtButtonHidingBehaviorProvider({
    super.key,
    required this.canHide,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GtAnimatedFade(
      showFirst: !canHide || !context.isKeyBoardUp,
      child1: _GtExpandedFadeChild(child: child),
      child2: const _GtExpandedFadeChild(child: SizedBox.shrink()),
    );
  }
}

class _GtExpandedFadeChild extends GtStatelessWidget {
  final Widget child;

  const _GtExpandedFadeChild({required this.child});

  @override
  Widget build(BuildContext context) {
    return Row(children: [Expanded(child: child)]);
  }
}
