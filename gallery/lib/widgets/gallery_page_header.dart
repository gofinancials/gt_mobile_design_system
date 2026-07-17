import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GalleryPageHeader extends StatelessWidget {
  final String title;
  final String? rider;
  final String? sectionHeader;

  const GalleryPageHeader({
    required this.title,
    this.rider,
    this.sectionHeader,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        GtText(title.upper, style: context.textStyles.d2()),
        if (rider.hasValue) ...[
          const GtGap.ySm(),
          GtRichText(
            rider,
            style: context.textStyles.bodyM(color: context.palette.text.sub),
          ),
        ],

        const GtDivider.sectionMd(),
        if (sectionHeader.hasValue) ...[
          GtText(
            sectionHeader?.upper ?? "",
            style: context.textStyles.subHeadS(color: context.palette.text.sub),
          ),
          const GtGap.ySectionSm(),
        ],
      ],
    );
  }
}
