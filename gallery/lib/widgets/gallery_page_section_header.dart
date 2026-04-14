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
        Text(
          title.upper,
          style: context.textStyles.subHeadS(color: context.palette.text.sub),
        ),
        const GtGap.ySectionLg(),
      ],
    );
  }
}
