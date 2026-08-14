import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A scaffold template for transaction confirmation screens.
///
/// Wraps a [GtConfirmationBody] in a [GtPopScope] and a transparent [Scaffold],
/// beneath a [GtAppBar] carrying:
/// - A back chevron on the left which invokes [onClose].
/// - A centred, uppercased [title].
/// - An optional share action on the right, shown only when [onShare] is given.
///
/// Unlike [GtReceiptScaffold] this template renders no bottom navigation bar,
/// so the body is laid out directly rather than stacked beneath a floating
/// action. It is designed to be presented modally, typically via
/// `GtBottomSheetMixin.showDraggableSheet`, in which case the back chevron
/// dismisses the sheet.
///
/// Example usage:
/// ```dart
/// showDraggableSheet(
///   context,
///   initialChildSize: .9,
///   builder: (controller) {
///     return GtConfirmationScaffold(
///       title: "Transfer Confirmation",
///       onClose: () => GtRouter.popView(),
///       onShare: () => handleShareReceipt(),
///       body: GtConfirmationBody(
///         controller: controller,
///         amount: "20,000.00",
///         date: "September 29, 2025",
///         time: "02:45 PM",
///         status: const GtReceiptStatusData(
///           status: GtReceiptStatus.success,
///           title: "Delivered",
///         ),
///         sections: sections,
///       ),
///     );
///   },
/// );
/// ```
class GtConfirmationScaffold extends GtStatelessWidget {
  /// The main body content displayed inside the scaffold.
  final GtConfirmationBody body;

  /// The app bar title, uppercased and centred by [GtAppBar].
  final String title;

  /// Callback executed when the back chevron in the app bar is pressed.
  ///
  /// When the scaffold is presented as a sheet this should dismiss it.
  final OnPressed onClose;

  /// Optional callback executed when the share action is pressed.
  ///
  /// If null, no trailing action is rendered.
  final OnPressed? onShare;

  /// Optional icon for the share action.
  ///
  /// If null, defaults to [GtIcons.shareIos].
  final IconData? shareIcon;

  /// The size configuration for the app bar [title]. Defaults to
  /// [GtAppBarTitleSize.small].
  final GtAppBarTitleSize titleSize;

  /// Creates a [GtConfirmationScaffold].
  ///
  /// The [body], [title] and [onClose] parameters are required.
  const GtConfirmationScaffold({
    super.key,
    required this.body,
    required this.title,
    required this.onClose,
    this.onShare,
    this.shareIcon,
    this.titleSize = .small,
  });

  @override
  Widget build(BuildContext context) {
    Widget? trailing;

    if (onShare != null) {
      trailing = GtIconButton(
        icon: shareIcon ?? GtIcons.shareSolid,
        onPressed: onShare!,
        contentPadding: .zero,
        iconColor: context.palette.icon.strong,
        color: context.palette.staticColors.transparent,
      );
    }

    return GtPopScope(
      canPop: false,
      child: Padding(
        padding: context.insets.onlyDp(top: 16.px),
        child: Scaffold(
          backgroundColor: context.palette.staticColors.transparent,
          appBar: GtAppBar(
            title: title,
            titleSize: titleSize,
            implyLeading: false,
            leading: GtBackButton(action: onClose, routeStackSensitive: false),
            trailing: trailing,
          ),
          body: body,
        ),
      ),
    );
  }
}
