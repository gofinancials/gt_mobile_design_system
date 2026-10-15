import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Defines the available font sizes for the title in a [GtAppBar].
enum GtAppBarTitleSize {
  /// Small title text size.
  small,

  /// Medium title text size.
  medium,

  /// Large title text size.
  large;

  /// Resolves the style for this size, optionally overriding its [color].
  ///
  /// A null [color] falls through to the palette default, so callers that do
  /// not care are unaffected.
  TextStyle getStyle(BuildContext context, {Color? color}) {
    return switch (this) {
      .small => context.textStyles.button(color: color),
      .medium => context.textStyles.h6(color: color),
      .large => context.textStyles.h5(color: color),
    };
  }
}

/// A highly customizable general-purpose app bar.
///
/// Supports an optional leading widget, a centered title, and an optional trailing widget.
class GtAppBar extends GtStatelessWidget implements PreferredSizeWidget {
  /// The widget displayed at the leading edge (left side).
  final Widget? leading;

  /// The primary title text displayed in the center.
  final String? title;

  /// The widget displayed at the trailing edge (right side).
  final Widget? trailing;

  /// Whether the app bar should automatically add a back button if [leading] is null and the route can pop.
  final bool implyLeading;

  /// The predefined size configuration for the [title].
  final GtAppBarTitleSize titleSize;

  /// An optional color overriding the palette default for the [title].
  ///
  /// Needed when the app bar sits on a caller-supplied background, which the
  /// palette-derived default knows nothing about and so cannot contrast with.
  final Color? titleColor;

  /// An optional [Hero] tag, so the bar flies between routes that share it.
  final String? heroTag;

  /// The size of the back button.
  final GtBackButtonSize backButtonSize;

  /// Whether a title too long for its two lines is shortened from the middle,
  /// keeping its head and tail, rather than clipped at the end of its second
  /// line. Defaults to false.
  ///
  /// Set it for titles whose end tells screens apart, such as a recipient's
  /// name followed by their account number. See [GtText.middleEllipsis].
  final bool titleMiddleEllipsis;

  /// Whether the bar heads a routed page, at the top of the screen. Defaults
  /// to true.
  ///
  /// A primary bar clears the status bar and sets its row 24 below it, where
  /// Figma's page frames draw the header. Pass false when the bar heads a
  /// sheet, which spaces its own top.
  final bool primary;

  /// The insets around the bar's row, replacing its default 16 on either side
  /// and, on a [primary] bar, 24 above.
  ///
  /// A [primary] bar still clears the status bar on top of these.
  final EdgeInsetsGeometry? padding;

  /// Creates a [GtAppBar].
  const GtAppBar({
    this.leading,
    this.title,
    this.trailing,
    super.key,
    this.implyLeading = true,
    this.titleSize = .small,
    this.backButtonSize = .large,
    this.heroTag,
    this.titleColor,
    this.titleMiddleEllipsis = false,
    this.primary = true,
    this.padding,
  });

  bool get _hasLeading => leading != null;

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = 0;
    if (primary) statusBarHeight = MediaQuery.paddingOf(context).top;

    EdgeInsetsGeometry barPadding = context.insets.defaultHorizontalInsets;
    if (primary) barPadding = barPadding.add(context.insets.onlyDp(top: 24.px));
    if (padding != null) barPadding = padding!;

    final canImplyLeading = (context.canPop && implyLeading);

    Widget? leadingWidget = leading;

    if (canImplyLeading && !_hasLeading) {
      leadingWidget = GtBackButton(size: backButtonSize);
    }

    Widget child = Container(
      padding: barPadding.add(EdgeInsets.only(top: statusBarHeight)),
      color: Colors.transparent,
      child: Table(
        defaultVerticalAlignment: .middle,
        // The actions are pinned to 32 dp, so their columns are too: the title
        // takes everything between them and, the sides being equal, stays
        // centred on the screen.
        columnWidths: const {
          0: FixedColumnWidth(32),
          1: FlexColumnWidth(),
          2: FixedColumnWidth(32),
        },
        children: [
          TableRow(
            children: [
              Align(
                alignment: .centerLeft,
                child: GtSquareConstrainedBox(32, child: leadingWidget),
              ),
              GtText(
                title?.upper,
                style: titleSize.getStyle(context, color: titleColor),
                textAlign: .center,
                maxLines: 2,
                middleEllipsis: titleMiddleEllipsis,
                // The screen's own title, and the anchor a screen reader user
                // jumps to when moving by heading.
                headingLevel: 1,
              ),
              Align(
                alignment: .centerRight,
                child: GtSquareConstrainedBox(32, child: trailing),
              ),
            ],
          ),
        ],
      ),
    );

    if (heroTag != null) {
      child = Hero(tag: heroTag!, child: child);
    }

    return Material(type: .transparency, child: child);
  }

  /// The tallest the bar grows below the status bar: its vertical insets plus a
  /// title on both of its 32-high lines. [Scaffold] treats it as a ceiling and
  /// lays its body where the bar actually ends.
  @override
  Size get preferredSize {
    double verticalInset = 0;
    if (primary) verticalInset = 24;
    if (padding != null) verticalInset = padding!.vertical;
    return Size.fromHeight(verticalInset + 2 * 32);
  }
}
