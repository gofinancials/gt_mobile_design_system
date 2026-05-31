import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

// -----------------------------------------------------------------------------
// Status variant
// -----------------------------------------------------------------------------

/// Visual outcome for [GtStatusState]: drives status icon and icon tint tokens.
enum GtStatusStateVariant {
  /// Positive completion — success palette on the status glyph.
  success,

  /// Failure or blocking error — error palette on the status glyph.
  error,

  /// Custom state that must provide its own [GtStatusState.statusIcon].
  custom,
}

// -----------------------------------------------------------------------------
// Status screen
// -----------------------------------------------------------------------------

class GtStatusState extends GtStatelessWidget {
  /// Success, error, or custom state — controls icon resolution behavior.
  final GtStatusStateVariant variant;

  /// Primary headline under the icon (e.g. "Transfer complete").
  final String title;

  /// Supporting copy under [title].
  final String? subtitle;

  /// Optional illustration override for the status glyph.
  ///
  /// When null, a default illustration is resolved from [variant].
  final AppImageData? statusIcon;

  /// Label for the footer [GtRaisedButton] (e.g. "Done", "Try again").
  final String? actionLabel;

  /// Invoked when the footer button is pressed.
  final OnPressed? onActionPressed;

  /// Optional variant for the footer button; defaults to [GtButtonVariant.primary].
  final GtButtonVariant actionVariant;

  /// The size of the action button.
  ///
  /// Defaults to `GtButtonSize.small`.
  final GtButtonSize actionSize;

  /// The alignment of the empty state widget.
  ///
  /// Defaults to `.center`.
  final AlignmentGeometry? alignment;

  /// The alignment of the action button.
  ///
  /// Defaults to `.center`.
  final AlignmentGeometry? actionAlignment;

  /// The spacing between the title and the subtitle.
  ///
  /// Defaults to `GtGap.yMd()`. Can be customized with a [GtViewStateSpacer].
  final GtViewStateSpacer gapToSubtitle;

  /// The spacing between the subtitle and the action button.
  ///
  /// Defaults to `GtGap.yLg()`. Can be customized with a [GtViewStateSpacer].
  final GtViewStateSpacer gapToAction;

  /// The text style for the title.
  final TextStyle? titleStyle;

  /// The text style for the subtitle.
  final TextStyle? subtitleStyle;

  /// Creates a [GtStatusState] configured for the given [variant] and copy.
  const GtStatusState({
    super.key,
    required this.variant,
    required this.title,
    this.subtitle,
    this.statusIcon,
    this.actionLabel,
    this.onActionPressed,
    this.actionVariant = .primary,
    this.gapToSubtitle = const GtViewStateGapSpacer(GtGap.yMd()),
    this.gapToAction = const GtViewStateGapSpacer(GtGap.yLg()),
    this.actionSize = .medium,
    this.alignment,
    this.actionAlignment,
    this.titleStyle,
    this.subtitleStyle,
  }) : assert(
         variant != .custom || (statusIcon != null),
         'statusIcon is required when variant is GtStatusStateVariant.custom',
       ),
       assert(
         (onActionPressed == null) == (actionLabel == null),
         'onActionPressed and actionText must be provided together',
       );

  /// Convenience constructor for [GtStatusStateVariant.success].
  const GtStatusState.success({
    super.key,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onActionPressed,
    this.actionVariant = .primary,
    this.gapToSubtitle = const GtViewStateGapSpacer(GtGap.yMd()),
    this.gapToAction = const GtViewStateGapSpacer(GtGap.yLg()),
    this.actionSize = .medium,
    this.alignment,
    this.actionAlignment,
    this.titleStyle,
    this.subtitleStyle,
  }) : variant = .success,
       statusIcon = null,
       assert(
         (onActionPressed == null) == (actionLabel == null),
         'onActionPressed and actionText must be provided together',
       );

  /// Convenience constructor for [GtStatusStateVariant.error].
  const GtStatusState.error({
    super.key,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onActionPressed,
    this.actionVariant = .primary,
    this.gapToSubtitle = const GtViewStateGapSpacer(GtGap.yMd()),
    this.gapToAction = const GtViewStateGapSpacer(GtGap.yLg()),
    this.actionSize = .medium,
    this.alignment,
    this.actionAlignment,
    this.titleStyle,
    this.subtitleStyle,
  }) : variant = .error,
       statusIcon = null,
       assert(
         (onActionPressed == null) == (actionLabel == null),
         'onActionPressed and actionText must be provided together',
       );

  /// Convenience constructor for [GtStatusStateVariant.custom].
  ///
  /// [statusIcon] is required for this variant.
  const GtStatusState.custom({
    super.key,
    required this.title,
    this.subtitle,
    required AppImageData icon,
    this.actionLabel,
    this.onActionPressed,
    this.actionVariant = .primary,
    this.gapToSubtitle = const GtViewStateGapSpacer(GtGap.yMd()),
    this.gapToAction = const GtViewStateGapSpacer(GtGap.yLg()),
    this.actionSize = .medium,
    this.alignment,
    this.actionAlignment,
    this.titleStyle,
    this.subtitleStyle,
  }) : variant = .custom,
       statusIcon = icon,
       assert(
         (onActionPressed == null) == (actionLabel == null),
         'onActionPressed and actionText must be provided together',
       );

  /// Resolves the status illustration shown above the titles.
  ///
  /// Uses [statusIcon] when provided, otherwise falls back to
  /// the default asset mapped from [variant].
  AppImageData? get _statusIcon {
    return switch (variant) {
      .success => AppImageData(GtVectorIllustrations.success),
      .error => AppImageData(GtVectorIllustrations.failed),
      .custom => statusIcon,
    };
  }

  @override
  Widget build(BuildContext context) {
    return GtViewStateWidget(
      title: title,
      description: subtitle,
      icon: _statusIcon,
      actionText: actionLabel,
      onActionPressed: onActionPressed,
      actionVariant: actionVariant,
      actionSize: actionSize,
      actionAlignment: actionAlignment,
      alignment: alignment ?? .center,
      gapToDescription: gapToSubtitle,
      gapToAction: gapToAction,
      titleStyle: titleStyle,
      descriptionStyle: subtitleStyle,
    );
  }
}
