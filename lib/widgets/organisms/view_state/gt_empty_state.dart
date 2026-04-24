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
  final String icon;

  /// Main heading text for the empty state.
  final String title;

  /// Supporting descriptive copy beneath the title.
  final String subtitle;

  /// Creates a [GtEmptyState] with required icon/title/subtitle content.
  const GtEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final illustrationSize = context.dp(130.px);

    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .center,
      spacing: context.spacingBase,
      children: [
        // Empty-state illustration.
        GtSvg(icon, width: illustrationSize, height: illustrationSize),
        const GtGap.yXl(),
        // Primary heading.
        GtText(
          title.upper,
          textAlign: TextAlign.center,
          style: context.textStyles.h6(color: palette.text.strong),
        ),
        // Supporting description.
        GtText(
          subtitle,
          textAlign: TextAlign.center,
          style: context.textStyles.subHead2xs(
            color: GtColors.neutral600.value,
          ),
        ),
      ],
    );
  }
}
