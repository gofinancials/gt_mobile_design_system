import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// How a status step node is rendered in [GtStatusTrackerStep].
enum GtStatusStepNodeKind {
  /// Hollow circle for not-yet-reached steps.
  outlineDot,

  /// Solid circle for completed non-terminal steps.
  filledDot,

  /// Animated spinner for in-progress steps.
  spinner,

  /// Icon glyph (failed, reversed, terminal check, overrides).
  icon,
}

/// Represents the visual semantic state of a step in a [GtStatusTracker].
enum GtStatusStepState {
  /// The step has not been reached yet.
  pending,

  /// The step is currently in progress.
  active,

  /// The step has completed successfully.
  success,

  /// The step failed during execution.
  failed,

  /// The step was reversed or rolled back.
  reversed;

  /// Returns the semantic color associated with this state using the given [palette].
  Color color(GtPalette palette) => switch (this) {
    .active => palette.away.base,
    .success => palette.success.darker,
    .failed => palette.error.base,
    .reversed => palette.primary.base,
    .pending => palette.icon.soft,
  };

  /// Returns the semantic text color associated with this state using the given [palette].
  Color textColor(GtPalette palette) => switch (this) {
    .pending => palette.text.darkerSub,
    _ => color(palette),
  };

  /// Default node rendering strategy when no explicit icon override is provided.
  GtStatusStepNodeKind get nodeKind => switch (this) {
    .pending => GtStatusStepNodeKind.outlineDot,
    .success => GtStatusStepNodeKind.filledDot,
    .active => GtStatusStepNodeKind.spinner,
    .failed || .reversed => GtStatusStepNodeKind.icon,
  };

  /// Default icon when [nodeKind] is [GtStatusStepNodeKind.icon].
  ///
  /// Terminal success swaps to [GtIcons.checkSolid] in the list widget.
  IconData get icon => switch (this) {
    .failed => GtIcons.cancel,
    .reversed => GtIcons.refreshAlt,
    .success => GtIcons.checkSolid,
    .active || .pending => GtIcons.loader,
  };
}
