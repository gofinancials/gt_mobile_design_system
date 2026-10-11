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

  /// Creates a [GtTitleAppBar].
  const GtTitleAppBar({
    required this.title,
    this.trailing,
    super.key,
    this.implyTrailing = true,
    this.titleMiddleEllipsis = false,
  }) : assert(title.length > 0);

  bool get _hasTrailing => trailing?.hasValue ?? false;

  @override
  Widget build(BuildContext context) {
    final toolbarHeight = MediaQuery.paddingOf(context).top;
    final canImplyTrailing = (context.canPop && implyTrailing);

    Widget? trailingWidget;

    if (canImplyTrailing && !_hasTrailing) trailingWidget = GtCancelButton();

    return Material(
      type: .transparency,
      child: Container(
        padding: (context.insets.defaultHorizontalInsets).add(
          EdgeInsets.only(top: toolbarHeight),
        ),
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

  @override
  Size get preferredSize {
    return Size.fromHeight(kToolbarHeight);
  }
}
