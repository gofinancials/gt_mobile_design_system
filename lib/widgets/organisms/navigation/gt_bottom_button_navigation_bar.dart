import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Which parts of a [GtButtonBottomNavBar] fade out while the keyboard is
/// visible.
enum GtBottomNavBarButtonHidingBehavior {
  /// Hides only the footer.
  footer,

  /// Hides the heading, the button, and the footer.
  all,

  /// Hides only the heading.
  header,

  /// Hides the heading and the footer, keeping the button.
  headerAndFooter;

  /// Whether the heading fades out while the keyboard is visible.
  bool get canHideHeader => switch (this) {
    .footer => false,
    _ => true,
  };

  /// Whether the footer fades out while the keyboard is visible.
  bool get canHideFooter => switch (this) {
    .header => false,
    _ => true,
  };

  /// Whether the button fades out while the keyboard is visible.
  bool get canHideButton => switch (this) {
    .all => true,
    _ => false,
  };
}

/// A bottom bar that pins a primary [button], with an optional [heading]
/// above it and [footer] below it.
///
/// The bar keeps its content above the system bottom inset, such as the
/// Android navigation bar, in both [Scaffold.bottomNavigationBar] and
/// [Scaffold.bottomSheet].
class GtButtonBottomNavBar extends GtStatelessWidget {
  /// The primary action.
  final Widget button;

  /// Optional content above [button].
  final Widget? heading;

  /// Optional content below [button].
  final Widget? footer;

  /// Which parts fade out while the keyboard is visible.
  ///
  /// Defaults to [GtBottomNavBarButtonHidingBehavior.headerAndFooter].
  final GtBottomNavBarButtonHidingBehavior hidingBehavior;

  /// The vertical gap between [heading], [button], and [footer].
  ///
  /// Defaults to [BuildContext.spacingLg].
  final double? spacing;

  /// Creates a [GtButtonBottomNavBar].
  const GtButtonBottomNavBar({
    super.key,
    required this.button,
    this.heading,
    this.spacing,
    this.hidingBehavior = .headerAndFooter,
    this.footer,
  });

  /// The bottom inset a [Scaffold] removed before building this bar as its
  /// [Scaffold.bottomSheet], or zero anywhere else.
  ///
  /// While [Scaffold.resizeToAvoidBottomInset] is true, a scaffold removes the
  /// bottom inset from its bottom sheet even with the keyboard closed. The
  /// sheet only rests on the screen edge when the scaffold has no bottom
  /// navigation bar or persistent footer, so only then is the inset restored.
  double resolveScaffoldSheetInset(BuildContext context) {
    final scaffold = Scaffold.maybeOf(context);
    final sheet = scaffold?.widget.bottomSheet;
    if (scaffold == null || sheet == null) return 0;
    if (scaffold.widget.bottomNavigationBar != null) return 0;
    if (scaffold.widget.persistentFooterButtons != null) return 0;

    bool isSheet = identical(sheet, this);
    context.visitAncestorElements((element) {
      if (isSheet || element.widget is Scaffold) return false;
      isSheet = identical(element.widget, sheet);
      return true;
    });
    if (!isSheet) return 0;

    final query = scaffold.context.getInheritedWidgetOfExactType<MediaQuery>();
    return query?.data.padding.bottom ?? 0;
  }

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

    final keyPadVisible = context.isKeyBoardUp;
    final bottomPadding = keyPadVisible ? 10.px : 24.px;

    return SafeArea(
      top: false,
      minimum: EdgeInsets.only(bottom: resolveScaffoldSheetInset(context)),
      maintainBottomViewPadding: !keyPadVisible,
      child: Padding(
        padding: insets.defaultHorizontalInsets.add(
          insets.onlyDp(bottom: bottomPadding),
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

/// A private widget that fades [child] out while the keyboard is visible.
class _GtButtonHidingBehaviorProvider extends GtStatelessWidget {
  /// The content to show or hide.
  final Widget child;

  /// Whether [child] may fade out while the keyboard is visible.
  final bool canHide;

  /// Creates a [_GtButtonHidingBehaviorProvider].
  const _GtButtonHidingBehaviorProvider({
    super.key,
    required this.canHide,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GtAnimatedFade(
      showFirst: !canHide || !context.isKeyBoardUp,
      child1: FractionallySizedBox(widthFactor: 1, child: child),
      child2: const SizedBox.shrink(),
    );
  }
}
