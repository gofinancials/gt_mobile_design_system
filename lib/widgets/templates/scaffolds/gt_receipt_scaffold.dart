import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A specialized scaffold template for displaying transaction receipts, confirmation details, or summary screens.
///
/// This scaffold provides a standardized layout wrapped in a [GtPopScope], containing:
/// - An action app bar ([GtActionAppBar]) with an optional download icon button ([GtIcons.download]) on the left and a close button ([GtCancelButton]) on the right.
/// - The main content provided via [body].
/// - A bottom navigation bar ([GtButtonBottomNavBar]) containing an action button (defaults to "Report a Problem").
///
/// Example usage:
/// ```dart
/// GtReceiptScaffold(
///   onClose: () => GtRouter.popView(),
///   onReportProblem: () => handleReportProblem(),
///   onDownload: () => handleDownloadReceipt(),
///   downloadIcon: GtIcons.share,
///   buttonText: "Report a problem",
///   buttonTextColor: Colors.black,
///   buttonBackgroundColor: Colors.grey,
///   body: ListView(
///     children: [
///       // Receipt content widgets...
///     ],
///   ),
/// )
/// ```
class GtReceiptScaffold extends GtStatelessWidget {
  /// The main body content widget displayed inside the scaffold.
  final GtReceiptBody body;

  /// Callback executed when the bottom action button (e.g., "Report a Problem") is pressed.
  final OnPressed onReportProblem;

  /// Callback executed when the close button in the top action bar is pressed.
  final OnPressed onClose;

  /// Custom label text for the bottom action button.
  ///
  /// If null, defaults to localized `"reportAProblem"`.
  final String? buttonText;

  /// Custom text color for the bottom action button.
  ///
  /// If null, defaults to [context.palette.text.white].
  final Color? buttonTextColor;

  /// Custom background color for the bottom action button.
  ///
  /// If null, defaults to [context.palette.bg.sub].
  final Color? buttonBackgroundColor;

  /// Optional icon to display for the download action button.
  ///
  /// If null, defaults to [GtIcons.download].
  final IconData? downloadIcon;

  /// Optional callback executed when the download icon button in the top app bar is pressed.
  ///
  /// If provided, a download icon button will be rendered on the left of the app bar.
  /// If null, no leading widget is displayed.
  final OnPressed? onDownload;

  /// Creates a [GtReceiptScaffold].
  ///
  /// The [body], [onClose], and [onReportProblem] parameters are required.
  const GtReceiptScaffold({
    super.key,
    required this.body,
    required this.onClose,
    required this.onReportProblem,
    this.buttonText,
    this.buttonTextColor,
    this.buttonBackgroundColor,
    this.downloadIcon,
    this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    Widget? leading;

    if (onDownload != null) {
      leading = GtIconButton(
        icon: downloadIcon ?? GtIcons.download,
        onPressed: onDownload!,
        contentPadding: .zero,
        iconColor: context.palette.icon.strong,
        color: context.palette.staticColors.transparent,
      );
    }

    return GtPopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: context.palette.staticColors.transparent,
        appBar: GtActionAppBar(
          implyLeading: false,
          leading: leading,
          trailing: GtOptionalWidgetPair(tail: GtCancelButton(onTap: onClose)),
        ),
        body: Stack(
          children: [
            Positioned.fill(child: body),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: GtButtonBottomNavBar(
                button: GtRaisedButton(
                  onPressed: onReportProblem,
                  text: buttonText ?? "reportAProblem".utr(),
                  variant: .neutralAlt,
                  alignment: .center,
                  size: .small,
                  textColor: buttonTextColor ?? context.palette.text.white,
                  color: buttonBackgroundColor ?? context.palette.bg.sub,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
