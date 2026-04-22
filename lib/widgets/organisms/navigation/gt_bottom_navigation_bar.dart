import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/typedefs/app_typedefs.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A single tab item for [GtBottomNavigationBar].
///
/// `selectedIcon` and `unselectedIcon` allow teams to use outlined/filled icon
/// pairs exactly like the iOS reference implementation.
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

/// iOS-style bottom navigation bar with:
/// - blurred floating container
/// - animated selected-tab highlight
/// - optional trailing circular action button
class GtBottomNavigationBar extends GtStatelessWidget {
  final List<GtBottomNavigationItem> items;
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;

  /// Optional callback for the trailing circular action button.
  final OnPressed? onTrailingTap;

  /// Optional icon for the trailing action button.
  final IconData trailingIcon;

  const GtBottomNavigationBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onIndexChanged,
    this.onTrailingTap,
    this.trailingIcon = GtIcons.helpInfo,
  }) : assert(
         items.length >= 2,
         'GtBottomNavigationBar needs at least 2 items',
       );

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final radius = BorderRadius.circular(context.dp(99.px));

    final boxDecoration = BoxDecoration(
      color: palette.staticColors.white,
      borderRadius: radius,
      border: Border.all(
        color: palette.staticColors.white.withValues(alpha: 0.20),
      ),
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
                          color: palette.staticColors.black.withValues(
                            alpha: 0.01,
                          ),
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
                            // Animated active tab background.
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
      // Delegate tab index changes to the parent-controlled state.
      onTap: () => onTap(),
      child: Center(
        child: Column(
          mainAxisSize: .min,
          mainAxisAlignment: .center,
          children: [
            // Icon swaps between selected/unselected variants.
            GtIcon(
              selected ? item.selectedIcon : item.unselectedIcon,
              size: context.dp(22.px),
              variant: selected ? GtIconVariant.strong : GtIconVariant.disabled,
            ),
            SizedBox(height: context.dp(4.px)),
            // Label uses navBarLabel token with active/inactive color states.
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
    final radius = BorderRadius.circular(context.dp(99.px));

    final boxDecoration = BoxDecoration(
      color: palette.staticColors.white,
      borderRadius: radius,
      border: Border.all(
        color: palette.staticColors.white.withValues(alpha: 0.20),
      ),
      boxShadow: context.shadows.bottomNavInnerGlass(),
    );

    // Circular frosted action button (typically help/info).
    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: context.backdropFilters.bottomNavFrost(),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          // Kept as callback-only to let host screen define action behavior.
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
