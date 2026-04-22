import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GalleryPageHeader extends StatelessWidget {
  final String title;
  final String rider;
  final String? sectionHeader;

  const GalleryPageHeader({
    required this.title,
    required this.rider,
    this.sectionHeader,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        const GtGap.ySectionXl(),
        Text(title.upper, style: context.textStyles.d1()),
        const GtGap.ySectionMd(),
        Text(
          rider,
          style: context.textStyles.subHeadM(color: context.palette.text.sub),
        ),
        const GtGap.ySectionLg(),
        const GtDivider.none(),
        if (sectionHeader.hasValue) ...[
          const GtGap.yMd(),
          Text(
            sectionHeader?.upper ?? "",
            style: context.textStyles.subHeadS(color: context.palette.text.sub),
          ),
        ],
        const GtGap.ySectionLg(),
      ],
    );
  }
}
