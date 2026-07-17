import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Documentation', type: GenericListener)
Widget playgroundGenericListenerDoc(BuildContext context) {
  final codeSnippet = '''
final _counter = ValueNotifier<int>(0);

GenericListener<int>(
  valueListenable: _counter,
  builder: (context, value, child) {
    return GtText('Value is: \$value');
  },
)

// Variants also available:
// - BoolListener
// - NumberListener
// - StringListener
// - ListListener
''';

  return GtWidgetDocPage(
    title: 'GenericListener',
    description: '''
<b>GenericListener</b> is a reactive builder widget that rebuilds its child when a given value changes.

It is a lightweight and clean wrapper around <b>ValueListenableBuilder</b> for state handling in isolation.''',
    code: codeSnippet,
    child: SizedBox(
      width: 320.px,
      height: 120.px,
      child: Center(
        child: GtText(
          'Select "Interactive Preview" in the sidebar\nto test state changes in real time.',
          style: context.textStyles.bodyM(color: context.palette.text.sub),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}
