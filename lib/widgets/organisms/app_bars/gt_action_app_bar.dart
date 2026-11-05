import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// An app bar designed for action-heavy screens, providing space for a leading widget and multiple trailing actions.
class GtActionAppBar extends GtStatelessWidget implements PreferredSizeWidget {
  /// An optional custom widget to display at the leading edge.
  final Widget? leading;

  /// An optional pair of widgets to display at the trailing edge.
  final GtOptionalWidgetPair? trailing;

  /// Whether the app bar should automatically add a back button if [leading] is null and the route can pop.
  final bool implyLeading;

  /// The size of the back button if [leading] is null and the route can pop.
  final GtBackButtonSize impliedLeadingSize;

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

  /// Creates a [GtActionAppBar].
  const GtActionAppBar({
    this.leading,
    this.trailing,
    super.key,
    this.implyLeading = true,
    this.impliedLeadingSize = .large,
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
      leadingWidget = GtBackButton(size: impliedLeadingSize);
    }

    return Material(
      type: .transparency,
      child: Container(
        padding: barPadding.add(EdgeInsets.only(top: statusBarHeight)),
        color: Colors.transparent,
        child: Row(
          spacing: context.spacingBase,
          children: [
            ?leadingWidget,
            const Spacer(),
            ?trailing?.head,
            ?trailing?.tail,
          ],
        ),
      ),
    );
  }

  /// The tallest the bar grows below the status bar: its vertical insets plus a
  /// [kToolbarHeight] row. [Scaffold] treats it as a ceiling and lays its body
  /// where the bar actually ends.
  @override
  Size get preferredSize {
    double verticalInset = 0;
    if (primary) verticalInset = 24;
    if (padding != null) verticalInset = padding!.vertical;
    return Size.fromHeight(verticalInset + kToolbarHeight);
  }
}
