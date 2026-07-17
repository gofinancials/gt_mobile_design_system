import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtActionAppBar', type: GtActionAppBar)
Widget playgroundGtActionAppBarUseCase(BuildContext context) {
  final implyLeading = context.knobs.boolean(
    label: 'Imply Leading',
    initialValue: true,
  );
  final impliedLeadingSize = context.knobs.object.dropdown<GtBackButtonSize>(
    label: 'Implied Leading Size',
    options: GtBackButtonSize.values,
    initialOption: GtBackButtonSize.large,
    labelBuilder: (v) => v.name,
  );
  final hasTrailing = context.knobs.boolean(
    label: 'Has Trailing Actions',
    initialValue: true,
  );

  return GtWidgetDocPage(
    title: 'GtActionAppBar',
    description:
        'An app bar designed for action-heavy screens, providing space for a leading widget and trailing actions.',
    code:
        '''
GtActionAppBar(
  implyLeading: $implyLeading,
  impliedLeadingSize: GtBackButtonSize.${impliedLeadingSize.name},
  ${hasTrailing ? '''trailing: GtOptionalWidgetPair(
    head: GtIconButton(icon: GtIcons.spark, onPressed: () {}),
    tail: GtIconButton(icon: GtIcons.bell, onPressed: () {}),
  ),''' : ''}
)''',
    child: GtActionAppBar(
      implyLeading: implyLeading,
      impliedLeadingSize: impliedLeadingSize,
      leading: GtBackButton(
        size: impliedLeadingSize,
        routeStackSensitive: !implyLeading,
      ),
      trailing: hasTrailing
          ? GtOptionalWidgetPair(
              head: GtIconButton(icon: GtIcons.spark, onPressed: () {}),
              tail: GtIconButton(icon: GtIcons.bell, onPressed: () {}),
            )
          : null,
    ),
  );
}
