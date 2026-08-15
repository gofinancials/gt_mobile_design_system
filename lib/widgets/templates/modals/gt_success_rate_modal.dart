import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Sheet chrome for a [GtSuccessRateBody].
///
/// Pairs the body with a [GtModalAppBar] carrying an optional refresh action on
/// the left, a centred [title], and the app bar's built-in cancel button on the
/// right. Designed to be presented via `GtBottomSheetMixin.showDraggableSheet`.
///
/// [onRefresh] is expected to publish a fresh [SuccessRateHolder] to the body;
/// supplying a new `rates` instance is what triggers a reload. Hold that holder
/// in a [ValueNotifier] and rebuild through a [GenericListener] rather than
/// calling `setState`.
///
/// Example usage:
/// ```dart
/// final ratesNotifier = ValueNotifier<SuccessRateHolder>(
///   api.fetchSuccessRates(),
/// );
///
/// showDraggableSheet(
///   context,
///   initialChildSize: .9,
///   builder: (controller) {
///     return GenericListener<SuccessRateHolder>(
///       valueListenable: ratesNotifier,
///       builder: (rates) => GtSuccessRateModal(
///         title: "Transfer Success Rate",
///         onRefresh: () => ratesNotifier.value = api.fetchSuccessRates(),
///         body: GtSuccessRateBody(
///           controller: controller,
///           rates: rates,
///           description:
///               "See how recipient banks are performing to avoid failed or "
///               "delayed transfers.",
///         ),
///       ),
///     );
///   },
/// );
/// ```
class GtSuccessRateModal extends GtStatelessWidget {
  /// The searchable success-rate list rendered beneath the app bar.
  final GtSuccessRateBody body;

  /// The app bar title, uppercased and centred by [GtModalAppBar].
  ///
  /// If null, defaults to localized `"transferSuccessRate"`.
  final String? title;

  /// Optional callback for the refresh action in the app bar.
  ///
  /// If null, no leading action is rendered.
  final OnPressed? onRefresh;

  /// Optional icon for the refresh action.
  ///
  /// If null, defaults to [GtIcons.refresh].
  final IconData? refreshIcon;

  /// Creates a [GtSuccessRateModal].
  const GtSuccessRateModal({
    super.key,
    required this.body,
    this.title,
    this.onRefresh,
    this.refreshIcon,
  });

  @override
  Widget build(BuildContext context) {
    Widget? leading;

    if (onRefresh != null) {
      leading = GtIconButton(
        icon: refreshIcon ?? GtIcons.refreshSolid,
        onPressed: onRefresh!,
        contentPadding: .zero,
        iconColor: context.palette.icon.strong,
        color: context.palette.staticColors.transparent,
      );
    }

    return Padding(
      padding: context.insets.onlyDp(top: 24.px),
      child: Scaffold(
        backgroundColor: context.palette.staticColors.transparent,
        appBar: GtAppBar(
          leading: leading,
          title: title ?? "transferSuccessRate".utr(),
          trailing: GtCancelButton(size: .xLarge),
        ),
        body: body,
      ),
    );
  }
}
