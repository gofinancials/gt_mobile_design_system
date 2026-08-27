import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'GtTransferCategoryGrid',
  type: GtTransferCategoryGrid,
)
Widget buildGtTransferCategoryGridUsecase(BuildContext context) {
  return const _TransferCategoryGridPreview();
}

class _TransferCategoryGridPreview extends GtStatefulWidget {
  const _TransferCategoryGridPreview();

  @override
  State<_TransferCategoryGridPreview> createState() =>
      _TransferCategoryGridPreviewState();
}

class _TransferCategoryGridPreviewState
    extends State<_TransferCategoryGridPreview> {
  final _categoryCtrl = GtTransactionCategoryController(null, categories: []);

  @override
  void dispose() {
    _categoryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GtWidgetDocPage(
      title: 'GtTransferCategoryGrid',
      description:
          'A structured grid layout designed for choosing transaction categories.',
      code: '''
GtTransferCategoryGrid(
  controller: categoryController,
  onAdd: () {},
)''',
      child: Center(
        child: GtCard(
          padding: context.insets.allDp(12.px),
          variant: GtCardVariant.normal,
          child: GtTransferCategoryGrid(
            controller: _categoryCtrl,
            onAdd: () {},
          ),
        ),
      ),
    );
  }
}
