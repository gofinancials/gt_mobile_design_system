import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A full-screen template for one step of a guided journey.
///
/// The five scaffolds beside this one — [GtConfirmationScaffold],
/// [GtDashboardScaffold], [GtReceiptScaffold], [GtSummaryScaffold] and
/// [GtTransferDetailScaffold] — are all settled or terminal surfaces. This is
/// the screen before them: the question or short form a customer sees over and
/// over through account opening, KYC or a product application, which until now
/// every site assembled for itself out of [Scaffold], [GtActionAppBar],
/// [GtBackButton], [GtSpinner], [GtHelpButton], [GtButtonBottomNavBar],
/// [GtScrollableBody] and [GtPageHeader].
///
/// Every one of those parts already worked; the composition is what was
/// missing, and the composition is where the decisions live:
///
/// - The progress ring precedes the help pill, with a `md` gap between them.
/// - The ring is a [GtSpinner] configured `strokeCap: .square` and
///   `clockwise: false`, so it reads as a segment count rather than a loader.
/// - The action is pinned in a [GtButtonBottomNavBar] rather than trailing the
///   body, so it holds its place as the body grows.
/// - The body scrolls beneath a fixed header, and the header-to-body gap is
///   stated once here rather than redrawn per screen.
///
/// Every chrome element is opt-in, because the designs do not agree on them:
/// some steps carry a ring, some a pill, some both side by side, and the
/// chevron-list steps carry no bottom action at all. A step declares what its
/// own design shows rather than inheriting a default that is wrong for one
/// family of screens.
///
/// Example usage:
/// ```dart
/// GtStepScaffold(
///   title: "What is your BVN?",
///   subtitle: "We use it to confirm your identity. It takes a moment.",
///   progress: .4,
///   onHelp: () => openSupportSheet(),
///   bottomAction: GtRaisedButton(text: "Continue", onPressed: submit),
///   body: GtTextField(label: "BVN", controller: bvnController),
/// )
/// ```
class GtStepScaffold extends GtStatelessWidget {
  /// The step's question or instruction, uppercased by [GtPageHeader].
  final String title;

  /// An optional supporting line beneath the [title].
  ///
  /// Steps that ask a self-explanatory question carry none.
  final String? subtitle;

  /// The step's content, laid out beneath the header inside a scrolling body.
  final Widget body;

  /// An optional action pinned to the foot of the screen.
  ///
  /// Rendered inside a [GtButtonBottomNavBar], so it holds its place while the
  /// body scrolls. Null leaves the scaffold without a bottom bar, which is what
  /// a step whose rows are themselves the action — a list of chevron cards —
  /// wants.
  final Widget? bottomAction;

  /// How far through the journey this step sits, from `0` to `1`.
  ///
  /// Drawn as the app bar's ring. Null renders no ring, for a step that stands
  /// outside a counted journey.
  final double? progress;

  /// Callback executed when the help pill is pressed.
  ///
  /// The scaffold builds the [GtHelpButton] itself, the way
  /// [GtConfirmationScaffold] builds its share action. Null renders no pill.
  final OnPressed? onHelp;

  /// An optional override for the help pill's label colour.
  ///
  /// The pill otherwise takes its colours from the active theme. Supply this
  /// only where an app's own design fixes the label to a colour the theme does
  /// not carry.
  final Color? helpTextColor;

  /// Whether the back chevron is rendered.
  ///
  /// Defaults to true. A committed checkpoint — a step the customer cannot
  /// retreat from — passes false, which removes the chevron rather than
  /// disabling it, and the app bar does not imply one in its place.
  final bool showBackButton;

  /// The vertical gap between the header, the [body] and the trailing space, in
  /// **design pixels**.
  ///
  /// When null this is [BuildContext.spacingSectionSm] (~24dp), which is what a
  /// form step wants. A denser step — a column of chevron cards — passes `16`.
  final double? bodySpacingPx;

  /// Creates a [GtStepScaffold].
  const GtStepScaffold({
    super.key,
    required this.title,
    required this.body,
    this.subtitle,
    this.bottomAction,
    this.progress,
    this.onHelp,
    this.helpTextColor,
    this.showBackButton = true,
    this.bodySpacingPx,
  }) : assert(
         progress == null || (progress >= 0 && progress <= 1),
         'GtStepScaffold.progress is a fraction of the journey, from 0 to 1.',
       );

  @override
  Widget build(BuildContext context) {
    Widget? leading;
    if (showBackButton) {
      leading = const GtBackButton(
        key: Key('step-back-button'),
        routeStackSensitive: true,
      );
    }

    final help = onHelp;
    final ring = progress;

    Widget? ringWidget;
    if (ring != null) {
      ringWidget = GtSpinner(
        key: const Key('step-progress'),
        value: ring,
        strokeCap: .square,
        clockwise: false,
      );
    }

    Widget? helpWidget;
    if (help != null) {
      helpWidget = GtHelpButton(
        key: const Key('step-help'),
        onPressed: help,
        textColor: helpTextColor,
      );
    }

    Widget? trailing = ringWidget ?? helpWidget;

    // The ring and the pill sit closer together than the app bar spaces its
    // own actions, so the pair travels as one trailing widget.
    if (ringWidget != null && helpWidget != null) {
      trailing = Row(
        mainAxisSize: .min,
        children: [ringWidget, const GtGap.sMd(), helpWidget],
      );
    }

    Widget? bottomBar;
    if (bottomAction case final action?) {
      bottomBar = GtButtonBottomNavBar(
        key: const Key('step-bottom-bar'),
        button: action,
      );
    }

    final gapPx = bodySpacingPx;
    final spacing = gapPx == null
        ? context.spacingSectionSm
        : context.dp(gapPx.px);

    return Scaffold(
      appBar: GtActionAppBar(
        leading: leading,
        implyLeading: false,
        trailing: .new(tail: trailing),
      ),
      bottomNavigationBar: bottomBar,
      body: GtScrollableBody(
        child: Column(
          crossAxisAlignment: .stretch,
          spacing: spacing,
          children: [
            GtPageHeader(title: title, subtitle: subtitle),
            body,
            const GtGap.ySectionSm(),
          ],
        ),
      ),
    );
  }
}
