import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Documentation', type: GtCard)
Widget playgroundGtCardDoc(BuildContext context) {
  final variant = context.knobs.object.dropdown(
    label: 'Variant',
    options: GtCardVariant.values,
    initialOption: GtCardVariant.normal,
    labelBuilder: (v) => v.name,
  );
  final cornerStyle = context.knobs.object.dropdown(
    label: 'Corner',
    options: CornerStyle.values,
    initialOption: CornerStyle.rounded,
    labelBuilder: (c) => c.name,
  );

  final codeSnippet = '''
GtCard(
  variant: GtCardVariant.${variant.name},
  cornerStyle: CornerStyle.${cornerStyle.name},
  child: Padding(
    padding: const EdgeInsets.all(24),
    child: GtText('Card content'),
  ),
)''';

  return GtWidgetDocPage(
    title: 'GtCard',
    description: '''
<b>GtCard</b> is the foundational card container used across the design system.

It features left border accent coloring determined by the <e>variant</e> parameter and customizable corners.''',
    code: codeSnippet,
    child: SizedBox(
      width: 320.px,
      child: GtCard(
        variant: variant,
        cornerStyle: cornerStyle,
        child: Padding(
          padding: context.insets.allDp(24.px),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GtIcon(GtIcons.gemSparkle, variant: .featured, size: 32),
              const GtGap.yMd(),
              GtText('Card Content', style: context.textStyles.h4()),
              const GtGap.yXs(),
              GtText(
                'This is a GtCard with variant and corner style controls.',
                style: context.textStyles.bodyS(color: context.palette.text.sub),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
