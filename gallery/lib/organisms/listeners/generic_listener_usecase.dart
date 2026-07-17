import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final _counter = ValueNotifier<int>(0);

@widgetbook.UseCase(name: 'Interactive Preview', type: GenericListener)
Widget playgroundGenericListenerUseCase(BuildContext context) {
  final value = context.knobs.int.slider(
    label: 'Counter Value',
    min: 0,
    max: 100,
    initialValue: 0,
  );

  WidgetsBinding.instance.addPostFrameCallback((_) {
    _counter.value = value;
  });

  return GtWidgetDocPage(
    title: 'GenericListener',
    description:
        'Reactive widget bridge. Move the slider to see the listener rebuild in real time.',
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GenericListener<int>(
          valueListenable: _counter,
          builder: (value) {
            return GtCard(
              variant: GtCardVariant.primary,
              child: Padding(
          padding: context.insets.symmetricDp(horizontal: 16.px, vertical: 24.px),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GtText(value.toString(), style: context.textStyles.d1()),
                    const GtGap.yXs(),
                    GtText(
                      'Listener rebuilds on every change',
                      style: context.textStyles.bodyS(
                        color: context.palette.text.sub,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const GtGap.ySectionMd(),
        GtText(
          'Also available: BoolListener, NumberListener, StringListener, ListListener',
          style: context.textStyles.bodyS(color: context.palette.text.sub),
        ),
      ],
    ),
  );
}
