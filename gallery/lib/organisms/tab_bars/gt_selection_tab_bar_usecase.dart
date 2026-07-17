import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtSelectionTabbar', type: GtSelectionTabbar)
Widget playgroundGtSelectionTabbarUseCase(BuildContext context) {
  final controller = GtTabController<String>();
  return GtWidgetDocPage(
    title: 'GtSelectionTabbar',
    description: 'Documentation for GtSelectionTabbar',
    code: '''
GtSelectionTabbar<String>(
  controller: GtTabController<String>(),
  tabs: [
    GtTabData(label: "Tab 1", value: "tab1"),
    GtTabData(label: "Tab 2", value: "tab2"),
  ],
)
''',
    child: GtSelectionTabbar<String>(
      controller: controller,
      tabs: [
        GtTabData(label: "Tab 1", value: "tab1"),
        GtTabData(label: "Tab 2", value: "tab2"),
      ],
    ),
  );
}
