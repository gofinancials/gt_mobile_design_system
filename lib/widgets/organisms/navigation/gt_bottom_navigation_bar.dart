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

  /// An accessible name for the trailing action, already localised.
  ///
  /// The action is icon-only, so without a name a screen reader announces it
  /// as an unlabelled button.
  final String? trailingSemanticsLabel;

  /// Whether the selection highlight and icon change should animate.
  final bool enableSelectionAnimation;

  const GtBottomNavigationBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onIndexChanged,
    this.style,
    this.onTrailingTap,
    this.trailingIcon = GtIcons.helpInfo,
    this.trailingSemanticsLabel,
    this.enableSelectionAnimation = true,
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
        trailingSemanticsLabel: trailingSemanticsLabel,
        enableSelectionAnimation: enableSelectionAnimation,
      ),
      .android => GtAndroidBottomNavigationBar(
        items: items,
        currentIndex: currentIndex,
        onIndexChanged: onIndexChanged,
        enableSelectionAnimation: enableSelectionAnimation,
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
  final bool enableSelectionAnimation;

  const GtAndroidBottomNavigationBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onIndexChanged,
    this.enableSelectionAnimation = true,
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
                      // Tabs announced as buttons lose their selected state,
                      // so the user cannot hear which section they are in.
                      role: .tab,
                      isSelected: currentIndex == i,
                      semanticsLabel: item.label,
                      excludeDescendantSemantics: true,
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
                              enableSelectionAnimation:
                                  enableSelectionAnimation,
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
/// - blurred floating glass container
/// - animated selected-tab highlight pill
/// - optional trailing circular action button
///
/// Geometry is transcribed 1:1 from the Figma spec (`Floating Nav Bar`,
/// node `26743:67467`) and expressed in design pixels via [num.px] so
/// [BuildContext.dp] can scale it down on narrower devices.
class _GtIosFloatingBottomNavigationBar extends GtStatelessWidget {
  /// Height of the glass pill and of the trailing circular action.
  static const _barHeight = 58.0;

  /// Gap between the glass edge and the tab row, i.e. the vertical breathing
  /// room around the selection pill.
  static const _glassInsetY = 4.0;

  /// Gap between the glass edge and the first/last tab.
  static const _glassInsetX = 6.0;

  /// Visible gap between the tab pill and the trailing action.
  static const _actionGap = 10.0;

  /// Screen edge padding either side of the bar.
  static const _screenInsetX = 16.0;

  /// Padding between the bar and the home indicator / screen bottom.
  static const _screenInsetY = 12.0;

  /// Tab icon and trailing action icon size.
  static const _iconSize = 24.0;

  /// Horizontal padding inside a tab, which is what truncates long labels.
  static const _tabInsetX = 8.0;

  final List<GtBottomNavigationItem> items;
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;
  final OnPressed? onTrailingTap;
  final IconData trailingIcon;
  final String? trailingSemanticsLabel;
  final bool enableSelectionAnimation;

  const _GtIosFloatingBottomNavigationBar({
    required this.items,
    required this.currentIndex,
    required this.onIndexChanged,
    required this.onTrailingTap,
    required this.trailingIcon,
    required this.trailingSemanticsLabel,
    required this.enableSelectionAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      // The bar floats above the home indicator rather than under it, so the
      // last tab stays reachable and the glass edge is not clipped by the
      // system gesture area.
      maintainBottomViewPadding: true,
      child: Padding(
        padding: context.insets.fromLTRBDp(
          _screenInsetX.px,
          0,
          _screenInsetX.px,
          _screenInsetY.px,
        ),
        child: SizedBox(
          height: context.dp(_barHeight.px),
          child: Row(
            crossAxisAlignment: .stretch,
            children: [
              Expanded(
                child: _GtBottomNavigationGlass(
                  child: Padding(
                    padding: context.insets.symmetricDp(
                      horizontal: _glassInsetX.px,
                      vertical: _glassInsetY.px,
                    ),
                    child: _GtBottomNavigationTabs(
                      items: items,
                      currentIndex: currentIndex,
                      onIndexChanged: onIndexChanged,
                      iconSize: _iconSize,
                      tabInsetX: _tabInsetX,
                      enableSelectionAnimation: enableSelectionAnimation,
                    ),
                  ),
                ),
              ),
              if (onTrailingTap != null) ...[
                SizedBox(width: context.dp(_actionGap.px)),
                _GtBottomNavigationTrailingAction(
                  onTap: onTrailingTap!,
                  icon: trailingIcon,
                  iconSize: _iconSize,
                  size: _barHeight,
                  semanticsLabel: trailingSemanticsLabel,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// The frosted glass surface shared by the tab pill and the trailing action.
///
/// Reproduces the Figma `Fill + Shadow` layer: a 65% [GtPaletteBgColors.white]
/// fill over a blurred backdrop, an inner highlight along the edge, and a soft
/// drop shadow. Every layer resolves through the palette, so the surface
/// inverts with the theme instead of staying light in dark mode.
class _GtBottomNavigationGlass extends GtStatelessWidget {
  final Widget child;
  final BoxShape shape;

  const _GtBottomNavigationGlass({
    required this.child,
    this.shape = BoxShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final radius = context.borderRadiusFull;
    final isCircle = shape == BoxShape.circle;

    return DecoratedBox(
      decoration: BoxDecoration(
        shape: shape,
        borderRadius: isCircle ? null : radius,
        boxShadow: context.isInDarkMode
            ? context.shadows.md(palette.bg.weak)
            : context.shadows.bottomNavShadow(),
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: context.backdropFilters.bottomNavFrost(),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: palette.bg.white.setOpacity(.65),
              borderRadius: radius,
              boxShadow: context.shadows.bottomNavInnerGlass(),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// The tab row plus the selection pill that slides behind the active tab.
class _GtBottomNavigationTabs extends GtStatelessWidget {
  final List<GtBottomNavigationItem> items;
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;
  final double iconSize;
  final double tabInsetX;
  final bool enableSelectionAnimation;

  const _GtBottomNavigationTabs({
    required this.items,
    required this.currentIndex,
    required this.onIndexChanged,
    required this.iconSize,
    required this.tabInsetX,
    required this.enableSelectionAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final radius = context.borderRadiusFull;

    return LayoutBuilder(
      builder: (context, constraints) {
        final tabWidth = constraints.maxWidth / items.length;

        return Stack(
          clipBehavior: .hardEdge,
          // Passthrough hands the incoming tight height down to the tab row.
          // Under the default loose fit the row shrink-wraps its icon+label and
          // Stack pins it to topStart, so the content rides the top of the pill
          // instead of sitting in the middle of it.
          fit: .passthrough,
          children: [
            // The pill spans the full height and width of a tab slot, so the
            // icon and label sit centred inside it rather than floating above
            // a smaller chip.
            AnimatedPositioned(
              duration: enableSelectionAnimation
                  ? GtMotion.adaptiveDuration(context, GtMotion.fluid)
                  : Duration.zero,
              curve: GtSpringCurves.snappy,
              left: tabWidth * currentIndex,
              top: 0,
              bottom: 0,
              width: tabWidth,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: context.palette.fill.weak,
                  borderRadius: radius,
                ),
              ),
            ),
            Row(
              // Each tab fills the pill height so the whole pill is tappable,
              // not just the icon and label.
              crossAxisAlignment: .stretch,
              children: [
                for (final (i, item) in items.indexed)
                  Expanded(
                    child: _GtBottomNavigationTab(
                      item: item,
                      selected: i == currentIndex,
                      iconSize: iconSize,
                      insetX: tabInsetX,
                      onTap: () => onIndexChanged(i),
                      enableSelectionAnimation: enableSelectionAnimation,
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class GtBottomNavIcon extends GtStatelessWidget {
  final IconData icon;
  final bool selected;
  final Color unselectedColor;
  final Color selectedColor;
  final bool enableSelectionAnimation;

  /// Icon size in design pixels; scaled through [BuildContext.dp].
  ///
  /// Defaults to the Android bar's 28, the iOS bar passes the 24 its Figma
  /// spec calls for.
  final double size;

  const GtBottomNavIcon(
    this.icon, {
    required this.selected,
    required this.unselectedColor,
    required this.selectedColor,
    this.size = 28,
    this.enableSelectionAnimation = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GtAnimatedSwitcher(
      duration: enableSelectionAnimation ? GtMotion.normal.inMilliseconds : 0,
      beginScale: GtMotion.iconPressScale,
      switchInCurve: GtSpringCurves.bouncy,
      switchOutCurve: Curves.easeOutCubic,
      child: GtIcon.withColor(
        icon,
        key: ValueKey((icon, selected)),
        size: context.dp(size.px),
        color: switch (selected) {
          true => selectedColor,
          _ => unselectedColor,
        },
        alignment: .center,
      ),
    );
  }
}

class _GtBottomNavigationTab extends GtStatelessWidget {
  final GtBottomNavigationItem item;
  final bool selected;
  final double iconSize;
  final double insetX;
  final OnPressed onTap;
  final bool enableSelectionAnimation;

  const _GtBottomNavigationTab({
    required this.item,
    required this.selected,
    required this.iconSize,
    required this.insetX,
    required this.onTap,
    required this.enableSelectionAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    // The design's selected tones (`primary.dark` / `primary.darker`) are fixed
    // teals tuned against the light pill. On the dark pill they sink into the
    // background — `primary.darker` lands near 1.2:1 — so dark mode steps up to
    // the light brand tone instead of inheriting an unreadable label.
    final isDark = context.isInDarkMode;
    final selectedIconColor = isDark
        ? palette.primary.base
        : palette.primary.dark;
    final selectedLabelColor = isDark
        ? palette.primary.base
        : palette.primary.darker;

    return GtInkWell(
      // GestureDetector takes no focus and reports no semantics, so this tab
      // was unreachable by screen readers, keyboards, and switch control.
      role: .tab,
      isSelected: selected,
      semanticsLabel: item.label,
      excludeDescendantSemantics: true,
      onTap: () => onTap(),
      child: Padding(
        padding: context.insets.symmetricDp(horizontal: insetX.px),
        child: Column(
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          children: [
            GtBottomNavIcon(
              selected ? item.selectedIcon : item.unselectedIcon,
              selected: selected,
              size: iconSize,
              selectedColor: selectedIconColor,
              unselectedColor: palette.icon.sub,
              enableSelectionAnimation: enableSelectionAnimation,
            ),
            GtText(
              item.label,
              // The bar has a fixed height, so a wrapped label would overflow
              // the glass rather than push it taller.
              maxLines: 1,
              overflow: .ellipsis,
              textAlign: TextAlign.center,
              style: context.textStyles.navBarLabel(
                color: selected ? selectedLabelColor : palette.text.darkerSub,
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
  final double iconSize;
  final double size;
  final String? semanticsLabel;

  const _GtBottomNavigationTrailingAction({
    required this.onTap,
    required this.icon,
    required this.iconSize,
    required this.size,
    required this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    return _GtBottomNavigationGlass(
      shape: .circle,
      child: GtInkWell(
        // GestureDetector takes no focus and reports no semantics.
        role: .button,
        semanticsLabel: semanticsLabel,
        excludeDescendantSemantics: true,
        onTap: () => onTap(),
        child: SizedBox.square(
          dimension: context.dp(size.px),
          child: Center(child: GtIcon(icon, size: context.dp(iconSize.px))),
        ),
      ),
    );
  }
}
