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

  /// The optional height of the app bar.
  final String? heroTag;

  /// The size of the back button.
  final GtBackButtonSize backButtonSize;

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
  });

  bool get _hasLeading => leading != null;

  @override
  Widget build(BuildContext context) {
    final toolbarHeight = MediaQuery.paddingOf(context).top;
    final canImplyLeading = (context.canPop && implyLeading);

    Widget? leadingWidget = leading;

    if (canImplyLeading && !_hasLeading) {
      leadingWidget = GtBackButton(size: backButtonSize);
    }

    Widget child = Container(
      padding: (context.insets.defaultHorizontalInsets).add(
        EdgeInsets.only(top: toolbarHeight),
      ),
      color: Colors.transparent,
      child: Table(
        defaultVerticalAlignment: .middle,
        columnWidths: const {
          0: FlexColumnWidth(4),
          1: FlexColumnWidth(10),
          2: FlexColumnWidth(4),
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

  @override
  Size get preferredSize {
    return Size.fromHeight(kToolbarHeight);
  }
}
