import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtTabbar', type: GtTabbar)
Widget playgroundGtTabbarUseCase(BuildContext context) {
  return const _TabbarPlayground();
}

@widgetbook.UseCase(name: 'Eager', type: GtTabbarView)
Widget playgroundEagerGtTabbarViewUseCase(BuildContext context) {
  return const _TabbarViewPlayground();
}

@widgetbook.UseCase(name: 'Lazy', type: GtTabbarView)
Widget playgroundLazyGtTabbarViewUseCase(BuildContext context) {
  return const _TabbarViewPlayground(lazy: true);
}

@widgetbook.UseCase(name: 'Relabelled Tabs', type: GtTabbar)
Widget playgroundRelabelledGtTabbarUseCase(BuildContext context) {
  return const _RelabelPlayground();
}

class _TabbarPlayground extends GtStatefulWidget {
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

class _TabbarViewPlayground extends GtStatefulWidget {
  final bool lazy;

  const _TabbarViewPlayground({this.lazy = false});

  @override
  State<_TabbarViewPlayground> createState() => _TabbarViewPlaygroundState();
}

class _TabbarViewPlaygroundState extends State<_TabbarViewPlayground> {
  static const _tabs = [
    GtTabData(label: 'Overview', value: 'overview'),
    GtTabData(label: 'Activity', value: 'activity'),
    GtTabData(label: 'Settings', value: 'settings'),
  ];

  late final GtTabController<String> _controller;

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
    final title = widget.lazy ? 'GtTabbarView.lazy' : 'GtTabbarView';
    final tabView = widget.lazy
        ? GtTabbarView<String>.lazy(
            controller: _controller,
            tabs: _tabs,
            tabBuilders: {
              for (final tab in _tabs)
                tab.value: (_) => _TabViewContent(label: tab.label),
            },
          )
        : GtTabbarView<String>(
            controller: _controller,
            tabs: _tabs,
            tabViews: const {
              'overview': _TabViewContent(label: 'Overview'),
              'activity': _TabViewContent(label: 'Activity'),
              'settings': _TabViewContent(label: 'Settings'),
            },
          );

    return GtWidgetDocPage(
      title: title,
      description: widget.lazy
          ? 'Builder-backed pages are constructed on demand. Select a tab or swipe horizontally to switch pages.'
          : 'Preconstructed pages support tab selection and horizontal swipe navigation.',
      code: widget.lazy ? _lazyCode : _eagerCode,
      child: AspectRatio(
        aspectRatio: 3 / 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GtTabbar<String>(controller: _controller, tabs: _tabs),
            const GtGap.yMd(),
            Expanded(child: tabView),
          ],
        ),
      ),
    );
  }
}

class _TabViewContent extends GtStatelessWidget {
  final String label;

  const _TabViewContent({required this.label});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.palette.bg.sub,
        borderRadius: context.borderRadiusLg,
      ),
      child: Center(
        child: GtText('$label page', style: context.textStyles.subHeadS()),
      ),
    );
  }
}

const _eagerCode = '''
GtTabbarView<String>(
  controller: tabController,
  tabs: tabs,
  tabViews: const {
    'overview': OverviewPage(),
    'activity': ActivityPage(),
    'settings': SettingsPage(),
  },
)''';

const _lazyCode = '''
GtTabbarView<String>.lazy(
  controller: tabController,
  tabs: tabs,
  tabBuilders: {
    'overview': (_) => const OverviewPage(),
    'activity': (_) => const ActivityPage(),
    'settings': (_) => const SettingsPage(),
  },
)''';

class _RelabelPlayground extends GtStatefulWidget {
  const _RelabelPlayground();

  @override
  State<_RelabelPlayground> createState() => _RelabelPlaygroundState();
}

class _RelabelPlaygroundState extends State<_RelabelPlayground> {
  static const _personalTabs = [
    GtTabData(label: 'Pay', value: 'pay'),
    GtTabData(label: 'Schedule', value: 'schedule'),
    GtTabData(label: 'History', value: 'history'),
  ];

  static const _flexTabs = [
    GtTabData(label: 'Send', value: 'pay'),
    GtTabData(label: 'Schedule', value: 'schedule'),
    GtTabData(label: 'History', value: 'history'),
  ];

  late final GtTabController<String> _controller;

  @override
  void initState() {
    super.initState();
    _controller = GtTabController<String>(initialValue: _personalTabs.first);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFlex = context.knobs.boolean(
      label: 'Flex Account',
      initialValue: false,
    );
    final tabs = isFlex ? _flexTabs : _personalTabs;

    return GtWidgetDocPage(
      title: 'Relabelled Tabs',
      description:
          'Switch account family to relabel the first pill in place. The '
          'selection, the indicator and the page below all stay put, and the '
          'header reads the new label back off the controller.',
      code: _relabelCode,
      child: AspectRatio(
        aspectRatio: 3 / 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListenableBuilder(
              listenable: _controller,
              builder: (context, _) => GtText(
                'Selected: ${_controller.value?.label} '
                '(${_controller.value?.value})',
                style: context.textStyles.subHeadS(),
              ),
            ),
            const GtGap.yMd(),
            GtTabbar<String>(controller: _controller, tabs: tabs),
            const GtGap.yMd(),
            Expanded(
              child: GtTabbarView<String>(
                controller: _controller,
                tabs: tabs,
                tabViews: {
                  for (final tab in tabs)
                    tab.value: _TabViewContent(label: tab.label),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const _relabelCode = '''
// The same tabs, drawn differently per account family.
const personalTabs = [
  GtTabData(label: 'Pay', value: 'pay'),
  GtTabData(label: 'Schedule', value: 'schedule'),
];
const flexTabs = [
  GtTabData(label: 'Send', value: 'pay'),
  GtTabData(label: 'Schedule', value: 'schedule'),
];

// Tabs are identified by `value`, so swapping the list keeps the selection.
GtTabbar<String>(
  controller: tabController,
  tabs: isFlex ? flexTabs : personalTabs,
)''';
