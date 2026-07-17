import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtAnimatedFade', type: GtAnimatedFade)
Widget gtAnimatedFadeUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: "Animated Fade Switcher",
    description: "Animates a cross-fade between two children.",
    code: '''
GtAnimatedFade(
  showFirst: true,
  child1: Container(),
  child2: Container(),
)
''',
    child: GtAnimatedFade(
      showFirst: context.knobs.boolean(
        label: 'Show First Child',
        initialValue: true,
      ),
      duration: 300,
      child1: Container(
        height: 100.px,
        color: context.palette.primary.base,
        child: Center(
          child: GtText(
            "First Child",
            style: context.textStyles.bodyM(color: context.palette.text.white),
          ),
        ),
      ),
      child2: Container(
        height: 100.px,
        color: context.palette.success.base,
        child: Center(
          child: GtText(
            "Second Child",
            style: context.textStyles.bodyM(color: context.palette.text.white),
          ),
        ),
      ),
    ),
  );
}
