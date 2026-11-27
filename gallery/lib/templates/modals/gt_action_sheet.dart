import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtActionSheet', type: GtActionSheet)
Widget buildGtActionSheetUsecase(BuildContext context) {
  return const _ActionSheetPreview();
}

class _ActionSheetPreview extends StatelessWidget with GtActionSheetMixin {
  const _ActionSheetPreview();

  @override
  Widget build(BuildContext context) {
    final title = context.knobs.stringOrNull(label: 'Title');
    final message = context.knobs.stringOrNull(
      label: 'Message',
      initialValue: 'How would you like to export your statement?',
    );
    final cancelLabel = context.knobs.string(
      label: 'Cancel Label',
      initialValue: 'Cancel',
    );
    final withDestructive = context.knobs.boolean(
      label: 'With Destructive Action',
      initialValue: false,
    );
    final isDismissable = context.knobs.boolean(
      label: 'Dismissable',
      initialValue: true,
    );

    void open() {
      showActionSheet(
        context,
        title: title,
        message: message,
        cancelLabel: cancelLabel,
        isDismissable: isDismissable,
        actions: [
          GtActionSheetAction(
            label: 'Export as PDF',
            isDefault: true,
            onPressed: () => context.showToast('Exporting as PDF'),
          ),
          GtActionSheetAction(
            label: 'Export as Excel (CSV)',
            onPressed: () => context.showToast('Exporting as CSV'),
          ),
          if (withDestructive)
            GtActionSheetAction(
              label: 'Delete statement',
              isDestructive: true,
              onPressed: () => context.showToast('Deleted'),
            ),
        ],
      );
    }

    return GtWidgetDocPage(
      title: 'GtActionSheet',
      description:
          'An adaptive action sheet: a short list of choices anchored to the '
          'bottom of the screen, with a separate Cancel. iOS and macOS get the '
          'native action sheet; everywhere else gets the same content in a '
          'floating design system sheet. The sheet closes before the chosen '
          'action runs, keeps the brand of the screen that opened it, and '
          'keys every choice (gt-action-sheet-action-<index>, or the '
          'action\'s own key) and Cancel (GtActionSheet.cancelKey) for tests.',
      code:
          '''
class StatementExport extends StatelessWidget with GtActionSheetMixin {
  @override
  Widget build(BuildContext context) {
    return GtRaisedButton(
      text: "Export",
      onPressed: () => showActionSheet(
        context,
        message: "${message ?? ''}",
        cancelLabel: "$cancelLabel",
        actions: [
          GtActionSheetAction(
            label: "Export as PDF",
            isDefault: true,
            onPressed: exportPdf,
          ),
          GtActionSheetAction(
            label: "Export as Excel (CSV)",
            onPressed: exportCsv,
          ),
        ],
      ),
    );
  }
}''',
      child: GtRaisedButton(text: 'Show Action Sheet', onPressed: open),
    );
  }
}
