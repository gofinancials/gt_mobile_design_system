import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtDisabledOverlay', type: GtDisabledOverlay)
Widget gtDisabledOverlayUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: "Disabled Overlay",
    description:
        "A semi-transparent overlay to indicate an inactive or disabled state.",
    code: '''
GtDisabledOverlay(
  true,
  child: Container(),
)
''',
    child: Column(
      children: [
        GalleryPageSectionHeader(title: "GtDisabledOverlay"),
        GtSizedBox(
          height: 200,
          width: double.infinity,
          child: GtDisabledOverlay(
            context.knobs.boolean(label: 'Is Disabled', initialValue: true),
            child: Container(
              decoration: BoxDecoration(
                color: context.palette.primary.base,
                borderRadius: 16.circularBorderRadius,
              ),
              child: Center(
                child: GtText(
                  "Interactive Content",
                  style: context.textStyles.h5(
                    color: context.palette.text.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
