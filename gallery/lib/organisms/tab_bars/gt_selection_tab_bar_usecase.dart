import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtSelectionTabbar', type: GtSelectionTabbar)
Widget playgroundGtSelectionTabbarUseCase(BuildContext context) {
  return const _SelectionTabbarPlayground();
}

class _SelectionTabbarPlayground extends StatefulWidget {
  const _SelectionTabbarPlayground();

  @override
  State<_SelectionTabbarPlayground> createState() =>
      _SelectionTabbarPlaygroundState();
}

class _SelectionTabbarPlaygroundState
    extends State<_SelectionTabbarPlayground> {
  late final GtTabController<String> _controller;
  final _tabs = [
    GtTabData(label: "Tab 1", value: "tab1"),
    GtTabData(label: "Tab 2", value: "tab2"),
    GtTabData(label: "Tab 3", value: "tab3"),
  ];

  @override
  void initState() {
    super.initState();
    _controller = GtTabController<String>(initialValue: _tabs.first);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final useAlternateStyle = context.knobs.boolean(
      label: 'Use Alternate Style',
      initialValue: false,
    );
    final autoScroll = context.knobs.boolean(
      label: 'Auto Scroll',
      initialValue: false,
    );

    return GtWidgetDocPage(
      title: 'GtSelectionTabbar',
      description:
          'A customizable tab bar designed to toggle between multiple sections or view views.',
      code:
          '''
GtSelectionTabbar<String>(
  controller: tabController,
  useAlternateStyle: $useAlternateStyle,
  autoScroll: $autoScroll,
  tabs: [
    GtTabData(label: "Tab 1", value: "tab1"),
    GtTabData(label: "Tab 2", value: "tab2"),
    GtTabData(label: "Tab 3", value: "tab3"),
  ],
)''',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GtSelectionTabbar<String>(
            controller: _controller,
            useAlternateStyle: useAlternateStyle,
            autoScroll: autoScroll,
            tabs: _tabs,
          ),
          const GtGap.yMd(),
          ListenableBuilder(
            listenable: _controller,
            builder: (context, _) =>
                GtText("Active Selection: ${_controller.value?.value}"),
          ),
        ],
      ),
    );
  }
}
