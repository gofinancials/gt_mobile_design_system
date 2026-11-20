import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A scaffold template for transfer detail screens.
///
/// Wraps a [GtTransferDetailBody] in a [GtPopScope] and a transparent
/// [Scaffold], and shares the layout of [GtReceiptScaffold]:
/// - An action app bar ([GtActionAppBar]) with an optional download icon button ([GtIcons.download]) on the left and a close button ([GtCancelButton]) on the right.
/// - The body, stacked beneath an optional floating bottom navigation bar
///   ([GtButtonBottomNavBar]) whose action button defaults to
///   "Report a Problem". The bar is drawn only when [onReportProblem] is set,
///   and can be drawn disabled with [isButtonDisabled].
///
/// It is designed to be presented modally, typically via
/// `GtBottomSheetMixin.showDraggableSheet`.
///
/// Example usage:
/// ```dart
/// showDraggableSheet(
///   context,
///   initialChildSize: .9,
///   builder: (controller) {
///     return GtTransferDetailScaffold(
///       onClose: () => GtRouter.popView(),
///       onReportProblem: () => handleReportProblem(),
///       body: GtTransferDetailBody(
///         controller: controller,
///         amount: 20000,
///         recipient: recipient,
///         steps: steps,
///         sections: sections,
///       ),
///     );
///   },
/// );
/// ```
class GtTransferDetailScaffold extends GtStatelessWidget {
  /// The main body content widget displayed inside the scaffold.
  final GtTransferDetailBody body;

  /// Callback executed when the bottom action button (e.g., "Report a Problem") is pressed.
  ///
  /// If null, no bottom bar is drawn and the body drops the trailing space it
  /// reserves for the bar. To keep the bar visible but inert, set
  /// [isButtonDisabled] instead.
  final OnPressed? onReportProblem;

  /// Whether the bottom action button is drawn disabled. Defaults to false.
  ///
  /// A disabled button ignores taps and takes the disabled colours, which win
  /// over [buttonTextColor] and [buttonBackgroundColor]. It has no effect when
  /// [onReportProblem] is null, since no bar is drawn.
  final bool isButtonDisabled;

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

  /// Whether the body is drawn as a skeleton of itself while its content
  /// loads. Defaults to false.
  ///
  /// Only the body is boned; the app bar and the bottom action, if any, stay
  /// real and usable. The body is laid out as given, so while this is set
  /// pass it placeholder data shaped like the real content. The skeleton
  /// absorbs touches, so the body does not scroll until it lifts.
  final bool isLoading;

  /// What is announced while [isLoading] is set, such as "Loading transfer".
  ///
  /// See [GtSkeleton.semanticsLabel].
  final String? loadingSemanticsLabel;

  /// Creates a [GtTransferDetailScaffold].
  ///
  /// The [body] and [onClose] parameters are required.
  const GtTransferDetailScaffold({
    super.key,
    required this.body,
    required this.onClose,
    this.onReportProblem,
    this.isButtonDisabled = false,
    this.buttonText,
    this.buttonTextColor,
    this.buttonBackgroundColor,
    this.downloadIcon,
    this.onDownload,
    this.isLoading = false,
    this.loadingSemanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = body;
    if (isLoading) {
      content = GtSkeleton(
        semanticsLabel: loadingSemanticsLabel,
        child: content,
      );
    }

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

    Widget? bottomBar;
    if (onReportProblem case final action?) {
      bottomBar = GtButtonBottomNavBar(
        button: GtRaisedButton(
          onPressed: action,
          isDisabled: isButtonDisabled,
          text: buttonText ?? "reportAProblem".utr(),
          variant: .neutralAlt,
          alignment: .center,
          size: .small,
          textColor: buttonTextColor ?? context.palette.text.white,
          color: buttonBackgroundColor ?? context.palette.bg.sub,
        ),
      );
    }

    content = GtReceiptBottomBarScope(
      hasBottomBar: bottomBar != null,
      child: content,
    );

    if (bottomBar != null) {
      content = Stack(
        children: [
          Positioned.fill(child: content),
          Positioned(bottom: 0, left: 0, right: 0, child: bottomBar),
        ],
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
        body: content,
      ),
    );
  }
}
