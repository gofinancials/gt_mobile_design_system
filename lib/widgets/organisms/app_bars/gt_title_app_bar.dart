import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// An app bar that displays a prominent title and an optional pair of trailing widgets.
class GtTitleAppBar extends GtStatelessWidget implements PreferredSizeWidget {
  /// The primary title text displayed in the app bar.
  final String title;

  /// An optional pair of widgets to display at the trailing edge.
  final GtOptionalWidgetPair? trailing;

  /// Whether the app bar should automatically add a trailing cancel button if none is provided and the route can pop.
  final bool implyTrailing;

  /// Whether a title too long for its space is shortened from the middle,
  /// keeping its head and tail, rather than clipped at its end. Defaults to
  /// false.
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

  /// Creates a [GtTitleAppBar].
  const GtTitleAppBar({
    required this.title,
    this.trailing,
    super.key,
    this.implyTrailing = true,
    this.titleMiddleEllipsis = false,
    this.primary = true,
    this.padding,
  }) : assert(title.length > 0);

  bool get _hasTrailing => trailing?.hasValue ?? false;

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = 0;
    if (primary) statusBarHeight = MediaQuery.paddingOf(context).top;

    EdgeInsetsGeometry barPadding = context.insets.defaultHorizontalInsets;
    if (primary) barPadding = barPadding.add(context.insets.onlyDp(top: 24.px));
    if (padding != null) barPadding = padding!;

    final canImplyTrailing = (context.canPop && implyTrailing);

    Widget? trailingWidget;

    if (canImplyTrailing && !_hasTrailing) trailingWidget = GtCancelButton();

    return Material(
      type: .transparency,
      child: Container(
        padding: barPadding.add(EdgeInsets.only(top: statusBarHeight)),
        color: Colors.transparent,
        child: Row(
          spacing: context.spacingSectionSm,
          children: [
            Expanded(
              child: GtText(
                title.upper,
                style: context.textStyles.h5(),
                maxLines: 1,
                middleEllipsis: titleMiddleEllipsis,
                headingLevel: 1,
              ),
            ),
            ?trailing?.head,
            ?trailing?.tail,
            ?trailingWidget,
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
