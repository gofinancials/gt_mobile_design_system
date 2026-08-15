import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

/// Announces changes within [child] to assistive technologies as they happen.
///
/// Screen readers only speak what the user has navigated to, so a subtree that
/// swaps from a loading spinner to a success message is silent by default.
/// Wrapping it in a live region makes the change spoken without stealing focus.
///
/// Use this for state that changes on its own: transfer results, form
/// validation errors, countdowns, and inline status messages. Do not use it
/// for content the user changes themselves — that is already announced.
class GtLiveRegion extends StatelessWidget {
  /// An accessible name describing the region as a whole.
  final String? label;

  /// Whether announcements are currently active.
  ///
  /// Set this to false while the region is idle so that unrelated rebuilds do
  /// not produce speech.
  final bool enabled;

  /// The subtree whose changes should be announced.
  final Widget child;

  /// Creates a [GtLiveRegion].
  const GtLiveRegion({
    required this.child,
    this.label,
    this.enabled = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    return Semantics(
      container: true,
      liveRegion: true,
      label: label,
      child: child,
    );
  }
}

/// Imperative screen-reader announcements.
///
/// Prefer [GtLiveRegion] wherever the change is expressed in the widget tree.
/// Android has deprecated its announcement API because TalkBack clears its
/// speech queue to service it, so these helpers interrupt the user in a way a
/// live region does not.
///
/// Reach for them only when the change has no on-screen representation, or when
/// it happens outside of a build — a route dismissal, a background task
/// finishing, a copy-to-clipboard confirmation.
abstract final class GtAnnouncer {
  /// Speaks [message] once the current utterance finishes.
  ///
  /// Use for confirmations and status updates that are not time critical.
  /// Returns without doing anything when the platform has no announcement
  /// support, or when [message] is blank.
  static Future<void> announce(BuildContext context, String message) {
    return _send(context, message, Assertiveness.polite);
  }

  /// Speaks [message] immediately, interrupting any in-progress speech.
  ///
  /// Reserve this for errors and failures the user must not miss. Overusing it
  /// makes the interface feel like it is shouting.
  static Future<void> alert(BuildContext context, String message) {
    return _send(context, message, Assertiveness.assertive);
  }

  static Future<void> _send(
    BuildContext context,
    String message,
    Assertiveness assertiveness,
  ) async {
    if (message.trim().isEmpty) return;
    if (!context.mounted) return;
    if (!MediaQuery.supportsAnnounceOf(context)) return;

    await SemanticsService.sendAnnouncement(
      View.of(context),
      message,
      Directionality.maybeOf(context) ?? TextDirection.ltr,
      assertiveness: assertiveness,
    );
  }
}
