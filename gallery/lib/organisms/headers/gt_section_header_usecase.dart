import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtSectionHeader', type: GtSectionHeader)
Widget playgroundGtSectionHeaderUseCase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Personal details',
  );
  final titleCase = context.knobs.object.dropdown<GtTextCase>(
    label: 'Title Case',
    options: GtTextCase.values,
    initialOption: GtTextCase.upper,
    labelBuilder: (value) => value.name,
  );
  final titleSmall = context.knobs.boolean(
    label: 'Title S Style',
    initialValue: false,
  );
  final showTrailing = context.knobs.boolean(
    label: 'Show Trailing',
    initialValue: false,
  );

  final style = titleSmall ? context.textStyles.titleS() : null;
  final trailing = showTrailing
      ? GtTextButton(
          text: 'Edit',
          size: GtButtonSize.small,
          onPressed: () => context.showToast('Edit selected'),
        )
      : null;

  return GtWidgetDocPage(
    title: 'GtSectionHeader',
    description:
        'A header that introduces a section of content, with an optional '
        'trailing action. The title is uppercased unless a titleCase says '
        'otherwise.',
    code:
        '''
GtSectionHeader(
  "$title",
  titleCase: GtTextCase.${titleCase.name},${titleSmall ? '\n  style: context.textStyles.titleS(),' : ''}${showTrailing ? '\n  trailing: GtTextButton(\n    text: "Edit",\n    size: GtButtonSize.small,\n    onPressed: () {},\n  ),' : ''}
)''',
    child: Center(
      child: GtCard(
        padding: context.insets.allDp(16.px),
        variant: GtCardVariant.normal,
        child: GtSectionHeader(
          title,
          titleCase: titleCase,
          style: style,
          trailing: trailing,
        ),
      ),
    ),
  );
}
