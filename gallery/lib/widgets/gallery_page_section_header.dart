import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GalleryPageSectionHeader extends StatelessWidget {
  final String title;

  const GalleryPageSectionHeader({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const GtGap.ySectionLg(),
        const GtDivider.none(),
        const GtGap.yMd(),
        GtText(
          title.upper,
          style: context.textStyles.subHeadS(color: context.palette.text.sub),
        ),
        const GtGap.ySectionLg(),
      ],
    );
  }
}

class GallerySectionCard extends StatelessWidget {
  final String title;
  final String? rider;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const GallerySectionCard(
    this.title, {
    this.rider,
    required this.child,
    this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final defaultPadding = context.insets.symmetricDp(
      horizontal: 12.px,
      vertical: 16.px,
    );

    return GtCard(
      margin: context.insets.symmetricDp(vertical: 14.px),
      border: BorderSide(
        color: context.palette.bg.soft,
        width: 2,
        style: switch (padding) {
          .zero => BorderStyle.none,
          _ => BorderStyle.solid,
        },
      ),
      color: context.palette.bg.white,
      padding: .zero,
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          GtCard(
            color: context.palette.bg.soft,
            borderRadius: context.dp(context.radii.lg.px).topBorderRadius,
            child: GtPageHeader(title: title, subtitle: rider, spacingPx: 0),
          ),
          Padding(padding: padding ?? defaultPadding, child: child),
        ],
      ),
    );
  }
}
