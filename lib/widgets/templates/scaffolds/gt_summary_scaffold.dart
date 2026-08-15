import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Where a [GtSummaryScaffold] renders its title.
enum GtSummaryTitleStyle {
  /// Centred in the app bar, beside the back chevron.
  appBar,

  /// Left-aligned in the body, beneath a back-chevron-only app bar.
  headline;

  /// Whether this style places the title inside the scrolling body.
  bool get isHeadline => this == GtSummaryTitleStyle.headline;
}

/// A full-screen template for pre-transaction summary screens.
///
/// A pushed route rather than a sheet: the back chevron pops it, the system
/// back gesture is left alone, and the confirming action is pinned beneath the
/// content as a bottom bar.
///
/// The title moves rather than changes: [GtSummaryTitleStyle.appBar] centres it
/// beside the chevron, [GtSummaryTitleStyle.headline] drops it into the body as
/// a left-aligned heading and leaves the app bar bare. Both render the same
/// uppercased h5, so switching styles repositions the title without resizing it.
///
/// The action button takes its colour from the active theme, which is why the
/// same screen reads cyan in one app and green in another. A [secondaryIcon]
/// adds a square button beside it, as the bulk-payment design does for
/// scheduling.
///
/// Example usage:
/// ```dart
/// GtSummaryScaffold(
///   title: "Summary",
///   actionLabel: "Confirm",
///   onAction: () => submitTransfer(),
///   body: GtSummaryBody(
///     amount: "₦20,000.00",
///     description: "Check the details below before you send.",
///     sections: sections,
///   ),
/// )
/// ```
class GtSummaryScaffold extends GtStatelessWidget {
  /// The scrollable summary content.
  ///
  /// When [titleStyle] is [GtSummaryTitleStyle.headline] the scaffold supplies
  /// the body's `title` itself, so leave [GtSummaryBody.title] null.
  final GtSummaryBody body;

  /// The screen title, uppercased wherever it is rendered.
  final String title;

  /// Where the [title] is rendered. Defaults to [GtSummaryTitleStyle.appBar].
  final GtSummaryTitleStyle titleStyle;

  /// The label of the pinned action button, for example `"Confirm"`.
  final String actionLabel;

  /// Callback executed when the action button is pressed.
  final OnPressed onAction;

  /// An optional override for the back chevron.
  ///
  /// If null the chevron pops the current route, and hides itself when there is
  /// no route to pop back to. Supply this only to run something first, such as
  /// abandoning a draft.
  final OnPressed? onBack;

  /// An optional icon for a square button beside the action, such as a
  /// calendar for scheduling a payment.
  ///
  /// The button is rendered only when both this and [onSecondaryAction] are
  /// supplied.
  final IconData? secondaryIcon;

  /// Callback executed when the secondary button is pressed.
  final OnPressed? onSecondaryAction;

  /// Whether the action button is disabled.
  final bool isActionDisabled;

  /// Whether the action button is in its loading state.
  final bool isActionLoading;

  /// Creates a [GtSummaryScaffold].
  const GtSummaryScaffold({
    super.key,
    required this.body,
    required this.title,
    required this.actionLabel,
    required this.onAction,
    this.onBack,
    this.titleStyle = .appBar,
    this.secondaryIcon,
    this.onSecondaryAction,
    this.isActionDisabled = false,
    this.isActionLoading = false,
  });

  bool get _hasSecondaryAction =>
      secondaryIcon != null && onSecondaryAction != null;

  @override
  Widget build(BuildContext context) {
    assert(
      !titleStyle.isHeadline || body.title == null,
      'Set the title on GtSummaryScaffold, not on its body: the headline style '
      'already forwards it.',
    );

    // The headline style keeps the app bar bare and hands the title to the
    // body, so it scrolls away with the content it introduces.
    final PreferredSizeWidget appBar = titleStyle.isHeadline
        ? GtActionAppBar()
        : GtAppBar(title: title, titleSize: .large);

    Widget action = GtRaisedButton(
      key: const Key('summary-action'),
      text: actionLabel,
      onPressed: onAction,
      isDisabled: isActionDisabled,
      isLoading: isActionLoading,
    );

    if (_hasSecondaryAction) {
      action = Row(
        spacing: context.spacingBase,
        children: [
          Expanded(child: action),
          GtIconButton(
            key: const Key('summary-secondary-action'),
            icon: secondaryIcon!,
            onPressed: onSecondaryAction!,
            variant: .secondary,
            shape: .square,
            isDisabled: isActionDisabled || isActionLoading,
          ),
        ],
      );
    }

    Widget headlineBody = GtSummaryBody(
      key: body.key,
      amount: body.amount,
      sections: body.sections,
      controller: body.controller,
      physics: body.physics,
      amountStyle: body.amountStyle,
      amountCaption: body.amountCaption,
      title: title,
      description: body.description,
    );

    return Scaffold(
      appBar: appBar,
      body: titleStyle.isHeadline ? headlineBody : body,
      bottomNavigationBar: GtButtonBottomNavBar(button: action),
    );
  }
}
