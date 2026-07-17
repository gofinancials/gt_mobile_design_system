import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtTabbar', type: GtTabbar)
Widget playgroundGtTabbarUseCase(BuildContext context) {
  return const _TabbarPlayground();
}

class _TabbarPlayground extends StatefulWidget {
  const _TabbarPlayground();

  @override
  State<_TabbarPlayground> createState() => _TabbarPlaygroundState();
}

class _TabbarPlaygroundState extends State<_TabbarPlayground> {
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
      title: 'GtTabbar',
      description:
          'The standard application tab bar widget rendering horizontal selectable tabs.',
      code:
          '''
GtTabbar<String>(
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
          GtTabbar<String>(
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
