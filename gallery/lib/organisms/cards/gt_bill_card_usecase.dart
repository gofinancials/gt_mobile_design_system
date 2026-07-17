import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtBillCard', type: GtBillCard)
Widget playgroundGtBillCardUseCase(BuildContext context) {
  final name = context.knobs.string(label: 'Bill Name', initialValue: 'Airtime');
  final mode = context.knobs.object.dropdown<String>(
    label: 'Card Mode',
    options: ['standard', 'tile'],
    initialOption: 'standard',
  );

  Widget cardWidget;
  String codeSnippet;

  if (mode == 'tile') {
    cardWidget = GtBillCard.tile(
      name: name,
      icon: GtSvg(GtVectorIllustrations.building),
    );
    codeSnippet = '''GtBillCard.tile(
  name: "$name",
  icon: GtSvg(GtVectorIllustrations.building),
)''';
  } else {
    cardWidget = GtBillCard(
      name: name,
      icon: GtSvg(GtVectorIllustrations.building),
    );
    codeSnippet = '''GtBillCard(
  name: "$name",
  icon: GtSvg(GtVectorIllustrations.building),
)''';
  }

  return GtWidgetDocPage(
    title: 'GtBillCard',
    description: 'A dedicated bill payment category card displayed as standard grid item or inline list tile.',
    code: codeSnippet,
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 160, maxHeight: 120),
        child: cardWidget,
      ),
    ),
  );
}
