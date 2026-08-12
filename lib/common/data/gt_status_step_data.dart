import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Data model representing a single step within a [GtStatusTracker].
@immutable
class GtStatusStepData {
  /// The main title text for the step.
  final String label;

  /// The visual status state of the step.
  final GtStatusStepState state;

  /// Optional detail text (e.g., date, timestamp, or failure reason) displayed below the label.
  final String? subtitle;

  /// Optional custom icon override. If null, a default icon based on [state] is used.
  final IconData? icon;

  /// Optional custom icon color override. If null, the color derived from [state] is used.
  final Color? iconColor;

  /// Optional custom subtitle text color override. If null, defaults to the standard neutral sub text color.
  final Color? subtitleColor;

  /// Creates a [GtStatusStepData].
  const GtStatusStepData({
    required this.label,
    required this.state,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.subtitleColor,
  });

  bool get isSuccess => state == .success;
  bool get isFailure => state == .failed;
  bool get isActive => state == .active;
  bool get isPending => state == .pending;
}
