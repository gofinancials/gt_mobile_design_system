import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtHelpCard', type: GtHelpCard)
Widget playgroundGtHelpCardUseCase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Need more help?',
  );
  final subtitle = context.knobs.string(
    label: 'Subtitle',
    initialValue: 'Chat with us',
  );
  final variant = context.knobs.object.dropdown<GtCardVariant>(
    label: 'Variant',
    options: GtCardVariant.values,
    initialOption: GtCardVariant.away,
    labelBuilder: (v) => v.name,
  );

  final custom = context.knobs.boolean(
    label: 'Custom styling',
    initialValue: false,
  );

  return GtWidgetDocPage(
    title: 'GtHelpCard',
    description:
        'A help support card providing interactive customer care linkages.',
    code:
        '''
GtHelpCard(
  // Set custom to false (or omit these inputs) for the original defaults.
  backgroundColor: $custom ? context.palette.primary.alpha16 : null,
  titleStyle: $custom ? context.textStyles.subHeadM() : null,
  titleColor: $custom ? context.palette.primary.dark : null,
  padding: $custom ? context.insets.allDp(24.px) : null,
  verticalSpacing: $custom ? 0 : null,
  subtitleStyle: $custom ? context.textStyles.bodyS() : null,
  horizontalSpacing: $custom ? context.spacingXl : null,
  title: "$title",
  subtitle: "$subtitle",
  variant: GtCardVariant.${variant.name},
)''',
    child: GtHelpCard(
      backgroundColor: custom ? context.palette.primary.alpha16 : null,
      titleStyle: custom ? context.textStyles.subHeadM() : null,
      titleColor: custom ? context.palette.primary.dark : null,
      padding: custom ? context.insets.allDp(24.px) : null,
      verticalSpacing: custom ? 0 : null,
      subtitleStyle: custom ? context.textStyles.bodyS() : null,
      horizontalSpacing: custom ? context.spacingXl : null,
      title: title,
      subtitle: subtitle,
      variant: variant,
    ),
  );
}
