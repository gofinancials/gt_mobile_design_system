import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final _categoryCtrl = GtTransferCategoryController(null);

@widgetbook.UseCase(
  name: 'GtTransferCategoryGrid',
  type: GtTransferCategoryGrid,
)
Widget buildGtTransferCategoryGridUsecase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtTransferCategoryGrid',
    description: 'A structured grid layout designed for choosing transaction categories.',
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
