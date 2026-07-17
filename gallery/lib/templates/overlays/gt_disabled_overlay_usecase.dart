import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtDisabledOverlay', type: GtDisabledOverlay)
Widget playgroundGtDisabledOverlayUseCase(BuildContext context) {
  final isDisabled = context.knobs.boolean(
    label: 'Is Disabled',
    initialValue: true,
  );

  return GtWidgetDocPage(
    title: 'GtDisabledOverlay',
    description:
        'A semi-transparent overlay to indicate an inactive or disabled widget state.',
    code:
        '''
// Wrap any interactive widget tree to block clicks and dim content
GtDisabledOverlay(
  $isDisabled, // Toggles the disabled overlay state
  child: Card(
    child: Column(
      children: [
        Text("Interactive Form Content"),
        ElevatedButton(
          onPressed: () => handleAction(),
          child: Text("Submit"),
        ),
      ],
    ),
  ),
)''',
    child: GtSizedBox(
      height: 200,
      width: double.infinity,
      child: GtDisabledOverlay(
        isDisabled,
        child: Container(
          decoration: BoxDecoration(
            color: context.palette.primary.base,
            borderRadius: 16.circularBorderRadius,
          ),
          child: Center(
            child: GtText(
              "Interactive Content",
              style: context.textStyles.h6(color: context.palette.text.white),
            ),
          ),
        ),
      ),
    ),
  );
}
