import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/typedefs/app_typedefs.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Visual variant for [GtBottomNavigationBar].
///
/// [ios] is the default floating glass bar; [android] uses Material
/// [BottomNavigationBar] with fixed tabs (no trailing action).
enum GtBottomNavigationStyle { ios, android }

/// A single tab item for [GtBottomNavigationBar] and [GtAndroidBottomNavigationBar].
///
/// `selectedIcon` and `unselectedIcon` allow teams to use outlined/filled icon
/// pairs for both iOS and Android variants.
class GtBottomNavigationItem {
  final IconData selectedIcon;
  final IconData unselectedIcon;
  final String label;

  const GtBottomNavigationItem({
    required this.selectedIcon,
    required this.unselectedIcon,
    required this.label,
  });
}

/// Host-configurable bottom navigation: **iOS** floating glass (default) or
/// **Android** Material [BottomNavigationBar].
///
/// For Android-only trees you can also use [GtAndroidBottomNavigationBar]
/// directly (no trailing action).
class GtBottomNavigationBar extends GtStatelessWidget {
  final List<GtBottomNavigationItem> items;
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;

  /// Defaults to [GtBottomNavigationStyle.ios].
  final GtBottomNavigationStyle style;

  /// Optional callback for the trailing circular action button (**iOS only**).
  final OnPressed? onTrailingTap;

  /// Optional icon for the trailing action button (**iOS only**).
  final IconData trailingIcon;

  const GtBottomNavigationBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onIndexChanged,
    this.style = GtBottomNavigationStyle.ios,
    this.onTrailingTap,
    this.trailingIcon = GtIcons.helpInfo,
  }) : assert(
         items.length >= 2,
         'GtBottomNavigationBar needs at least 2 items',
       );

  @override
  Widget build(BuildContext context) {
    return switch (style) {
      GtBottomNavigationStyle.ios => _GtIosFloatingBottomNavigationBar(
        items: items,
        currentIndex: currentIndex,
        onIndexChanged: onIndexChanged,
        onTrailingTap: onTrailingTap,
        trailingIcon: trailingIcon,
      ),
      GtBottomNavigationStyle.android => GtAndroidBottomNavigationBar(
        items: items,
        currentIndex: currentIndex,
        onIndexChanged: onIndexChanged,
      ),
    };
  }
}

/// Material [BottomNavigationBar] for Android — fixed tabs, filled/outlined
/// icon pairs from [GtBottomNavigationItem], palette-driven colors.
///
/// Does **not** support a trailing action; use the iOS variant for that.
class GtAndroidBottomNavigationBar extends GtStatelessWidget {
  final List<GtBottomNavigationItem> items;
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;

  const GtAndroidBottomNavigationBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onIndexChanged,
  }) : assert(
         items.length >= 2,
         'GtAndroidBottomNavigationBar needs at least 2 items',
       );

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final inactive = GtColors.neutralGray600.value;
    final activeIcon = palette.text.strong;
    final selectedLabelStyle = context.textStyles.navBarLabel(
      isAndroid: true,
      color: palette.primary.dark,
    );
    final unselectedLabelStyle = context.textStyles.navBarLabel(
      isAndroid: true,
      color: inactive,
    );
    final iconSize = context.dp(22.px);
    // Top inset matches host padding; bottom adds clear space before the label.
    final iconPadding = EdgeInsets.only(
      top: context.spacingBase,
      bottom: context.spacingSm,
    );

    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      backgroundColor: palette.bg.white,
      selectedItemColor: activeIcon,
      unselectedItemColor: inactive,
      selectedLabelStyle: selectedLabelStyle,
      unselectedLabelStyle: unselectedLabelStyle,
      showUnselectedLabels: true,
      onTap: onIndexChanged,
      items: [
        for (final item in items)
          BottomNavigationBarItem(
            icon: Padding(
              padding: iconPadding,
              child: GtIcon.withColor(
                item.unselectedIcon,
                size: iconSize,
                color: inactive,
              ),
            ),
            activeIcon: Padding(
              padding: iconPadding,
              child: GtIcon.withColor(
                item.selectedIcon,
                size: iconSize,
                color: activeIcon,
              ),
            ),
            label: item.label,
          ),
      ],
    );
  }
}

/// iOS-style bottom navigation bar with:
/// - blurred floating container
/// - animated selected-tab highlight
/// - optional trailing circular action button
class _GtIosFloatingBottomNavigationBar extends GtStatelessWidget {
  final List<GtBottomNavigationItem> items;
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;
  final OnPressed? onTrailingTap;
  final IconData trailingIcon;

  const _GtIosFloatingBottomNavigationBar({
    required this.items,
    required this.currentIndex,
    required this.onIndexChanged,
    required this.onTrailingTap,
    required this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final radius = context.borderRadiusFull;

    final boxDecoration = BoxDecoration(
      color: palette.bg.white,
      borderRadius: radius,
      border: Border.all(color: palette.bg.white.withValues(alpha: 0.20)),
      boxShadow: context.shadows.bottomNavInnerGlass(),
    );

    return Row(
      crossAxisAlignment: .center,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: radius,
            child: BackdropFilter(
              filter: context.backdropFilters.bottomNavFrost(),
              child: Container(
                height: context.dp(68.px),
                decoration: boxDecoration,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: palette.bg.strong.withValues(alpha: 0.01),
                        ),
                      ),
                    ),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final tabWidth = constraints.maxWidth / items.length;
                        final inset = context.dp(4.px);
                        final highlightHeight =
                            constraints.maxHeight - (2 * inset);

                        return Stack(
                          children: [
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 350),
                              curve: Curves.easeInOutCubic,
                              left: (tabWidth * currentIndex) + inset,
                              top: inset,
                              width: tabWidth - (2 * inset),
                              height: highlightHeight,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: palette.bg.weak,
                                  borderRadius: radius,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                for (var i = 0; i < items.length; i++)
                                  Expanded(
                                    child: _GtBottomNavigationTab(
                                      item: items[i],
                                      selected: i == currentIndex,
                                      onTap: () => onIndexChanged(i),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (onTrailingTap != null) ...[
          SizedBox(width: context.dp(12.px)),
          _GtBottomNavigationTrailingAction(
            onTap: onTrailingTap!,
            icon: trailingIcon,
          ),
        ],
      ],
    );
  }
}

class _GtBottomNavigationTab extends GtStatelessWidget {
  final GtBottomNavigationItem item;
  final bool selected;
  final OnPressed onTap;

  const _GtBottomNavigationTab({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onTap(),
      child: Center(
        child: Column(
          mainAxisSize: .min,
          mainAxisAlignment: .center,
          children: [
            GtIcon(
              selected ? item.selectedIcon : item.unselectedIcon,
              size: context.dp(22.px),
              variant: selected ? GtIconVariant.strong : GtIconVariant.disabled,
            ),
            const GtGap.ySm(),
            GtText(
              item.label,
              textAlign: TextAlign.center,
              style: context.textStyles.navBarLabel(
                color: selected
                    ? palette.text.strong
                    : GtColors.neutralGray600.value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GtBottomNavigationTrailingAction extends GtStatelessWidget {
  final OnPressed onTap;
  final IconData icon;

  const _GtBottomNavigationTrailingAction({
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final radius = context.borderRadiusFull;

    final boxDecoration = BoxDecoration(
      color: palette.bg.white,
      borderRadius: radius,
      border: Border.all(color: palette.bg.white.withValues(alpha: 0.20)),
      boxShadow: context.shadows.bottomNavInnerGlass(),
    );

    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: context.backdropFilters.bottomNavFrost(),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => onTap(),
          child: Container(
            height: context.dp(68.px),
            width: context.dp(68.px),
            decoration: boxDecoration,
            child: Center(
              child: GtIcon(
                icon,
                size: context.dp(25.px),
                variant: GtIconVariant.sub,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
