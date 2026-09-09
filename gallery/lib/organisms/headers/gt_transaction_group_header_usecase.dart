import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'GtTransactionGroupHeader',
  type: GtTransactionGroupHeader,
)
Widget playgroundGtTransactionGroupHeaderUseCase(BuildContext context) {
  final title = context.knobs.string(label: 'Title', initialValue: 'Today');
  final sum = context.knobs.string(label: 'Sum', initialValue: '₦24,500.00');
  final highlighted = context.knobs.boolean(
    label: 'Highlighted',
    initialValue: false,
  );

  return GtWidgetDocPage(
    title: 'GtTransactionGroupHeader',
    description:
        'A date-bucket header for a run of transactions, pairing an uppercased '
        'group title with the aggregate amount for that group.',
    code:
        '''
GtTransactionGroupHeader(
  "$title",
  sum: "$sum",
  highlighted: $highlighted,
)''',
    child: Center(
      child: GtCard(
        padding: context.insets.allDp(16.px),
        variant: GtCardVariant.normal,
        child: GtTransactionGroupHeader(
          title,
          sum: sum,
          highlighted: highlighted,
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'GtTransactionGroupHeader.withTrailing',
  type: GtTransactionGroupHeader,
)
Widget playgroundGtTransactionGroupHeaderWithTrailingUseCase(
  BuildContext context,
) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'March 2026',
  );
  final actionLabel = context.knobs.string(
    label: 'Trailing Label',
    initialValue: 'See all',
  );
  final highlighted = context.knobs.boolean(
    label: 'Highlighted',
    initialValue: true,
  );

  return GtWidgetDocPage(
    title: 'GtTransactionGroupHeader.withTrailing',
    description:
        'The same group header with an arbitrary trailing widget — an action '
        'button, chip or icon — in place of the aggregate amount.',
    code:
        '''
GtTransactionGroupHeader.withTrailing(
  "$title",
  highlighted: $highlighted,
  trailing: GtTextButton(
    text: "$actionLabel",
    size: GtButtonSize.small,
    onPressed: () => context.showToast("$actionLabel selected"),
  ),
)''',
    child: Center(
      child: GtCard(
        padding: context.insets.allDp(16.px),
        variant: GtCardVariant.normal,
        child: GtTransactionGroupHeader.withTrailing(
          title,
          highlighted: highlighted,
          trailing: GtTextButton(
            text: actionLabel,
            size: GtButtonSize.small,
            onPressed: () => context.showToast('$actionLabel selected'),
          ),
        ),
      ),
    ),
  );
}
