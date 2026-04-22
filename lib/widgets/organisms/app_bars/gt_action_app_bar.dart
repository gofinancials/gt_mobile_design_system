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

  /// Creates a [GtActionAppBar].
  const GtActionAppBar({
    this.leading,
    this.trailing,
    super.key,
    this.implyLeading = true,
  });

  bool get _hasLeading => leading != null;

  @override
  Widget build(BuildContext context) {
    final toolbarHeight = MediaQuery.paddingOf(context).top;
    final canImplyLeading = (context.canPop && implyLeading);

    Widget? leadingWidget = leading;

    if (canImplyLeading && !_hasLeading) leadingWidget = GtBackButton();

    return Material(
      type: .transparency,
      child: Container(
        padding: (context.insets.defaultHorizontalInsets).add(
          EdgeInsets.only(top: toolbarHeight),
        ),
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

  @override
  Size get preferredSize {
    return Size.fromHeight(kToolbarHeight);
  }
}