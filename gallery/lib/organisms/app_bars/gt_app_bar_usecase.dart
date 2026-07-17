import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtAppBar', type: GtAppBar)
Widget playgroundGtAppBarUseCase(BuildContext context) {
  final title = context.knobs.string(label: 'Title', initialValue: 'Dashboard');
  final implyLeading = context.knobs.boolean(
    label: 'Imply Leading',
    initialValue: true,
  );
  final titleSize = context.knobs.object.dropdown<GtAppBarTitleSize>(
    label: 'Title Size',
    options: GtAppBarTitleSize.values,
    initialOption: GtAppBarTitleSize.small,
    labelBuilder: (v) => v.name,
  );
  final backButtonSize = context.knobs.object.dropdown<GtBackButtonSize>(
    label: 'Back Button Size',
    options: GtBackButtonSize.values,
    initialOption: GtBackButtonSize.large,
    labelBuilder: (v) => v.name,
  );
  final hasTrailing = context.knobs.boolean(
    label: 'Has Trailing Action',
    initialValue: true,
  );

  return GtWidgetDocPage(
    title: 'GtAppBar',
    description:
        'A customizable general-purpose app bar with a centered title, leading back button, and actions.',
    code:
        '''
GtAppBar(
  title: "$title",
  implyLeading: $implyLeading,
  titleSize: GtAppBarTitleSize.${titleSize.name},
  backButtonSize: GtBackButtonSize.${backButtonSize.name},${hasTrailing ? '\n  trailing: GtIconButton(icon: GtIcons.magnifier, onPressed: () {}),' : ''}
)''',
    child: GtAppBar(
      title: title,
      implyLeading: implyLeading,
      leading: GtBackButton(
        size: backButtonSize,
        routeStackSensitive: !implyLeading,
      ),
      titleSize: titleSize,
      backButtonSize: backButtonSize,
      trailing: hasTrailing
          ? GtIconButton(icon: GtIcons.magnifier, onPressed: () {})
          : null,
    ),
  );
}
