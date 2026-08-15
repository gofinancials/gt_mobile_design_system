import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtAnimatedSlider', type: GtAnimatedSlider)
Widget playgroundGtAnimatedSliderUseCase(BuildContext context) {
  final showChild = context.knobs.boolean(
    label: 'Show Child',
    initialValue: true,
  );
  final axis = context.knobs.object.dropdown<Axis>(
    label: 'Transition Axis',
    options: Axis.values,
    initialOption: Axis.vertical,
    labelBuilder: (v) => v.name,
  );
  final duration = context.knobs.int.slider(
    label: 'Duration (ms)',
    min: 100,
    max: 1000,
    initialValue: 300,
  );

  return GtWidgetDocPage(
    title: 'GtAnimatedSlider',
    description:
        'A switcher widget that animates the visibility of its child using a size transition along a vertical or horizontal axis.',
    code:
        '''
GtAnimatedSlider(
  duration: $duration,
  axis: Axis.${axis.name},
  child: ${showChild ? 'MyWidget()' : 'SizedBox.shrink()'},
)''',
    child: Center(
      child: GtCard(
        padding: context.insets.allDp(16.px),
        variant: GtCardVariant.normal,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GtAnimatedSlider(
              duration: duration,
              axis: axis,
              child: showChild
                  ? Container(
                      key: const ValueKey('content'),
                      height: 100.px,
                      width: 200.px,
                      color: context.palette.primary.base,
                      alignment: Alignment.center,
                      child: GtText(
                        "Sliding Content",
                        style: context.textStyles.bodyM(
                          color: context.palette.text.white,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(key: ValueKey('empty')),
            ),
          ],
        ),
      ),
    ),
  );
}
