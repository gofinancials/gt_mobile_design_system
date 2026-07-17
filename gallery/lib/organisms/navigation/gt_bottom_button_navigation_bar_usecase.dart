import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtButtonBottomNavBar', type: GtButtonBottomNavBar)
Widget playgroundGtButtonBottomNavBarUseCase(BuildContext context) {
  final text = context.knobs.string(
    label: 'Button Text',
    initialValue: 'Continue',
  );
  final isDisabled = context.knobs.boolean(
    label: 'Button Disabled',
    initialValue: false,
  );
  final isLoading = context.knobs.boolean(
    label: 'Button Loading',
    initialValue: false,
  );

  return GtWidgetDocPage(
    title: 'GtButtonBottomNavBar',
    description: 'A navigation bottom bar wrapping a single primary button.',
    code:
        '''
GtButtonBottomNavBar(
  spacing: context.spacingSm,
  heading: GtRaisedButton(
    text: "$text",
    isDisabled: $isDisabled,
    isLoading: $isLoading,
    onPressed: () {},
  ),
  button: GtTextButton(
    text: "Cancel",
    variant: .destructive,
    onPressed: () {},
  ),
)''',
    child: GtButtonBottomNavBar(
      spacing: context.spacingSm,
      heading: GtRaisedButton(
        text: text,
        isDisabled: isDisabled,
        isLoading: isLoading,
        onPressed: () {},
      ),
      button: GtTextButton(
        text: "Cancel",
        variant: .destructive,
        onPressed: () {},
      ),
    ),
  );
}
