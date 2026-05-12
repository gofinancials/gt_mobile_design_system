import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
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
class GtBottomNavigationItem extends AppEquatable {
  final IconData selectedIcon;
  final IconData unselectedIcon;
  final String label;
  final OnChanged<int>? onSelected;

  const GtBottomNavigationItem({
    required this.selectedIcon,
    required this.unselectedIcon,
    required this.label,
    this.onSelected,
  });

  @override
  List<Object?> get props => [selectedIcon, unselectedIcon, label];
}

/// Host-configurable bottom navigation: **iOS** floating glass (default) or
/// **Android** Material [BottomNavigationBar].
///
/// For Android-only trees you can also use [GtAndroidBottomNavigationBar]
/// directly (no trailing action).
///
/// @category Organisms
class GtBottomNavigationBar extends GtStatelessWidget {
  final List<GtBottomNavigationItem> items;
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;

  /// Defaults to [GtBottomNavigationStyle.ios].
  final GtBottomNavigationStyle? style;

  /// Optional callback for the trailing circular action button (**iOS only**).
  final OnPressed? onTrailingTap;

  /// Optional icon for the trailing action button (**iOS only**).
  final IconData trailingIcon;

  const GtBottomNavigationBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onIndexChanged,
    this.style,
    this.onTrailingTap,
    this.trailingIcon = GtIcons.helpInfo,
  }) : assert(
         items.length >= 2,
         'GtBottomNavigationBar needs at least 2 items',
       );

  @override
  Widget build(BuildContext context) {
    GtBottomNavigationStyle platformStyle = context.isAndroid ? .android : .ios;
    return switch (style ?? platformStyle) {
      .ios => _GtIosFloatingBottomNavigationBar(
        items: items,
        currentIndex: currentIndex,
        onIndexChanged: onIndexChanged,
        onTrailingTap: onTrailingTap,
        trailingIcon: trailingIcon,
      ),
      .android => GtAndroidBottomNavigationBar(
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
///
/// @category Organisms
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
    final inactive = palette.text.soft;
    final active = palette.primary.dark;

    return Stack(
      alignment: .bottomCenter,
      children: [
        Container(
          padding: context.insets.fromLTRBDp(
            7.5.px,
            12.px,
            7.5.px,
            (context.mediaQueryData.bottomInset + 12).px,
          ),
          color: palette.bg.white,
          child: Table(
            defaultVerticalAlignment: .middle,
            children: [
              TableRow(
                children: [
                  for (final (i, item) in items.indexed)
                    GtInkWell(
                      onTap: () => onIndexChanged(i),
                      child: Padding(
                        padding: context.insets.allDp(11.px),
                        child: Column(
                          spacing: context.spacingBase,
                          mainAxisSize: .min,
                          crossAxisAlignment: .center,
                          children: [
                            GtBottomNavIcon(
                              currentIndex == i
                                  ? item.selectedIcon
                                  : item.unselectedIcon,
                              selected: currentIndex == i,
                              selectedColor: palette.primary.dark,
                              unselectedColor: palette.icon.soft,
                            ),
                            GtText(
                              item.label.upper,
                              maxLines: 1,
                              style: context.textStyles.navBarLabel(
                                isAndroid: true,
                                color: currentIndex == i ? active : inactive,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
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
      color: palette.bg.strong.setOpacity(.01),
      borderRadius: radius,
      border: Border.all(color: palette.bg.white.setOpacity(.65)),
      boxShadow: context.shadows.bottomNavInnerGlass(),
    );

    return Stack(
      alignment: .bottomCenter,
      children: [
        SafeArea(
          top: false,
          bottom: context.isAndroid,
          maintainBottomViewPadding: true,
          minimum: context.insets.onlyDp(bottom: context.isAndroid ? 8.px : 0),
          child: Container(
            constraints: BoxConstraints(maxHeight: context.dp(95.px)),
            padding: context.insets.fromLTRBDp(16.px, 0, 16.px, 21.px),
            child: Row(
              crossAxisAlignment: .center,
              mainAxisSize: .min,
              children: [
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      boxShadow: context.isInDarkMode
                          ? context.shadows.md(context.palette.bg.weak)
                          : context.shadows.bottomNavShadow(),
                      borderRadius: radius,
                    ),
                    child: ClipRRect(
                      borderRadius: radius,
                      child: BackdropFilter(
                        filter: context.backdropFilters.bottomNavFrost(),
                        child: Container(
                          clipBehavior: .hardEdge,
                          height: context.dp(68.px),
                          decoration: boxDecoration,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: palette.bg.strong.withValues(
                                      alpha: 0.01,
                                    ),
                                  ),
                                ),
                              ),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final tabWidth =
                                      constraints.maxWidth / items.length;
                                  final inset = context.dp(4.px);
                                  final highlightHeight =
                                      constraints.maxHeight - (2 * inset);

                                  return Stack(
                                    clipBehavior: .hardEdge,
                                    children: [
                                      AnimatedPositioned(
                                        duration: const Duration(
                                          milliseconds: 350,
                                        ),
                                        curve: Curves.easeInOutCubic,
                                        left: (tabWidth * currentIndex) + inset,
                                        top: inset,
                                        width: tabWidth - (2 * inset),
                                        height: highlightHeight,
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            color: palette.fill.sub,
                                            borderRadius: radius,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          for (final (i, item) in items.indexed)
                                            Expanded(
                                              child: _GtBottomNavigationTab(
                                                item: item,
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
                ),
                if (onTrailingTap != null) ...[
                  SizedBox(width: context.dp(12.px)),
                  _GtBottomNavigationTrailingAction(
                    onTap: onTrailingTap!,
                    icon: trailingIcon,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class GtBottomNavIcon extends GtStatelessWidget {
  final IconData icon;
  final bool selected;
  final Color unselectedColor;
  final Color selectedColor;

  const GtBottomNavIcon(
    this.icon, {
    required this.selected,
    required this.unselectedColor,
    required this.selectedColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GtIcon.withColor(
      icon,
      size: context.dp(28.px),
      color: switch (selected) {
        true => selectedColor,
        _ => unselectedColor,
      },
      alignment: .center,
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
          crossAxisAlignment: .center,
          children: [
            GtBottomNavIcon(
              selected ? item.selectedIcon : item.unselectedIcon,
              selected: selected,
              selectedColor: palette.primary.dark,
              unselectedColor: palette.icon.sub,
            ),
            GtText(
              item.label,
              textAlign: TextAlign.center,
              style: context.textStyles.navBarLabel(
                color: selected ? palette.primary.darker : palette.text.soft,
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
      color: palette.bg.strong.setOpacity(.02),
      borderRadius: radius,
      border: Border.all(color: palette.bg.white.setOpacity(.65)),
      boxShadow: context.shadows.bottomNavInnerGlass(),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: context.isInDarkMode
            ? context.shadows.md(context.palette.bg.weak)
            : context.shadows.bottomNavShadow(),
        shape: .circle,
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: context.backdropFilters.bottomNavFrost(),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => onTap(),
            child: Container(
              alignment: .center,
              height: context.dp(68.px),
              width: context.dp(68.px),
              decoration: boxDecoration,
              child: Center(child: GtIcon(icon, size: context.dp(28.px))),
            ),
          ),
        ),
      ),
    );
  }
}
