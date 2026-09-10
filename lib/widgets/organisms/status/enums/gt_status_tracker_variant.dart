import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// How a [GtStatusTracker] lays out its steps.
enum GtStatusTrackerVariant {
  /// Uppercased, state-coloured labels with the subtitle stacked beneath, a
  /// 16dp node, and a checkmark on a terminal success step.
  ///
  /// The track turns green only once every step has succeeded.
  standard,

  /// A dense timeline for detail cards, rendered by
  /// [GtStatusTrackerCompactStep]: a 12dp node, the label in its natural
  /// casing, and the subtitle as a trailing, right-aligned timestamp. A
  /// terminal success keeps its filled dot rather than swapping to a
  /// checkmark.
  ///
  /// The track turns green once every step before the last has succeeded and
  /// the last step has been reached — that is, is no longer pending — so a
  /// transfer that fails or is reversed at its final step still reads as
  /// having travelled the whole track.
  compact,
}
