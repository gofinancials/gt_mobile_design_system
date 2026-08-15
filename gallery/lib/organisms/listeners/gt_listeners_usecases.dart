import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final _boolNotifier = ValueNotifier<bool>(true);
final _intNotifier = ValueNotifier<int>(42);
final _listNotifier = ValueNotifier<List<String>?>([
  'Apple',
  'Banana',
  'Orange',
]);
final _numberNotifier = ValueNotifier<double?>(3.14);
final _stringNotifier = ValueNotifier<String?>('Hello GtListeners');

@widgetbook.UseCase(name: 'BoolListener', type: BoolListener)
Widget playgroundBoolListenerUseCase(BuildContext context) {
  final val = context.knobs.boolean(label: 'Value', initialValue: true);
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _boolNotifier.value = val;
  });

  return GtWidgetDocPage(
    title: 'BoolListener',
    description:
        'A convenience listener widget that observes a boolean ValueListenable.',
    code: '''
BoolListener(
  valueListenable: boolNotifier,
  builder: (val) => GtText("State: \$val"),
)''',
    child: Center(
      child: BoolListener(
        valueListenable: _boolNotifier,
        builder: (value) => GtText(
          "Current State: $value",
          style: context.textStyles.h5(
            color: value
                ? context.palette.success.base
                : context.palette.error.base,
          ),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'GenericListener', type: GenericListener)
Widget playgroundGenericListenerUseCase(BuildContext context) {
  final val = context.knobs.int.slider(
    label: 'Counter Value',
    min: 0,
    max: 100,
    initialValue: 42,
  );
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _intNotifier.value = val;
  });

  return GtWidgetDocPage(
    title: 'GenericListener',
    description:
        'A generic ValueListenable builder for observing any data type.',
    code: '''
GenericListener<int>(
  valueListenable: intNotifier,
  builder: (value) => GtText("Value: \$value"),
)''',
    child: Center(
      child: GenericListener<int>(
        valueListenable: _intNotifier,
        builder: (value) =>
            GtText("Counter: $value", style: context.textStyles.h3()),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'ListListener', type: ListListener)
Widget playgroundListListenerUseCase(BuildContext context) {
  final hasItems = context.knobs.boolean(
    label: 'Has Items',
    initialValue: true,
  );
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _listNotifier.value = hasItems ? ['Apple', 'Banana', 'Orange'] : null;
  });

  return GtWidgetDocPage(
    title: 'ListListener',
    description:
        'Listens to a list ValueListenable, guaranteeing a non-null list (defaulting to empty).',
    code: '''
ListListener<String>(
  valueListenable: listNotifier,
  builder: (items) => Column(
    children: items.map((i) => GtText(i)).toList(),
  ),
)''',
    child: Center(
      child: ListListener<String>(
        valueListenable: _listNotifier,
        builder: (items) => Column(
          mainAxisSize: MainAxisSize.min,
          children: items.isEmpty
              ? [
                  GtText(
                    "Empty List",
                    style: context.textStyles.bodyS(
                      color: context.palette.text.sub,
                    ),
                  ),
                ]
              : items
                    .map(
                      (item) => GtText(item, style: context.textStyles.bodyM()),
                    )
                    .toList(),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'NumberListener', type: NumberListener)
Widget playgroundNumberListenerUseCase(BuildContext context) {
  final numVal = context.knobs.double.slider(
    label: 'Number Value',
    min: 0.0,
    max: 10.0,
    initialValue: 3.14,
  );
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _numberNotifier.value = numVal;
  });

  return GtWidgetDocPage(
    title: 'NumberListener',
    description: 'Specialized listener for observing numeric values.',
    code: '''
NumberListener<double>(
  valueListenable: doubleNotifier,
  builder: (val) => GtText("Number: \$val"),
)''',
    child: Center(
      child: NumberListener<double>(
        valueListenable: _numberNotifier,
        builder: (value) => GtText(
          "Number: ${value ?? 'null'}",
          style: context.textStyles.h4(),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'StringListener', type: StringListener)
Widget playgroundStringListenerUseCase(BuildContext context) {
  final text = context.knobs.string(
    label: 'Text',
    initialValue: 'Hello GtListeners',
  );
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _stringNotifier.value = text;
  });

  return GtWidgetDocPage(
    title: 'StringListener',
    description:
        'A dedicated listener for observing string state modifications.',
    code: '''
StringListener(
  valueListenable: stringNotifier,
  builder: (val) => GtText(val ?? ''),
)''',
    child: Center(
      child: StringListener(
        valueListenable: _stringNotifier,
        builder: (value) =>
            GtText(value ?? 'Empty', style: context.textStyles.bodyM()),
      ),
    ),
  );
}
