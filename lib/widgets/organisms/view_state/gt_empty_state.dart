import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Reusable empty-state organism for scenarios where there is no content/data
/// to display yet.
///
/// The layout is intentionally simple and centered: illustration, title, and
/// subtitle. Host screens can wrap this widget with their own app bar, actions,
/// or modal container as needed.
class GtEmptyState extends GtStatelessWidget {
  /// Illustration asset path rendered at the top (e.g. from
  /// [GtVectorIllustrations]).
  final AppImageData icon;

  /// An optional custom graphic to display above the title.
  ///
  /// This can be any widget, including an animation. When provided, it takes
  /// precedence over [icon]. The caller owns its sizing and semantics.
  final Widget? graphic;

  /// Main heading text for the empty state.
  final String title;

  /// Supporting descriptive copy beneath the title.
  final String? subtitle;

  /// The spacing between the title and the subtitle.
  ///
  /// Defaults to `GtGap.yMd()`.
  final GtViewStateSpacer gapToSubtitle;

  /// The text to display on the call-to-action button.
  final String? actionText;

  /// The callback to execute when the call-to-action button is pressed.
  final OnPressed? onActionPressed;

  /// The visual variant of the call-to-action button.
  final GtButtonVariant? buttonVariant;

  /// The alignment of the empty state widget.
  ///
  /// Defaults to `.center`.
  final AlignmentGeometry? alignment;

  /// The text style for the title.
  final TextStyle? titleStyle;

  /// The text style for the subtitle.
  final TextStyle? subtitleStyle;

  /// Defines the text capitalization behavior for the title.
  final GtButtonTextCase titleCase;

  /// Creates a [GtEmptyState] with required icon/title/subtitle content.
  const GtEmptyState({
    super.key,
    this.icon = const AppImageData(GtVectorIllustrations.empty),
    this.graphic,
    required this.title,
    this.subtitle,
    this.gapToSubtitle = const GtViewStateGapSpacer(GtGap.yMd()),
    this.actionText,
    this.onActionPressed,
    this.buttonVariant,
    this.alignment,
    this.titleCase = .upper,
    this.titleStyle,
    this.subtitleStyle,
  }) : assert(
         (onActionPressed == null) == (actionText == null),
         'onActionPressed and actionText must be provided together',
       );

  @override
  Widget build(BuildContext context) {
    return GtViewStateWidget(
      title: title,
      description: subtitle,
      icon: icon,
      graphic: graphic,
      alignment: alignment ?? .center,
      gapToDescription: gapToSubtitle,
      actionText: actionText,
      onActionPressed: onActionPressed,
      actionVariant: buttonVariant,
      actionSize: .xsmall,
      actionAlignment: .center,
      titleCase: titleCase,
      titleStyle: titleStyle,
      descriptionStyle: subtitleStyle,
    );
  }
}
