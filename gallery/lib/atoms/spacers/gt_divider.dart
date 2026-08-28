import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Dividers', type: GtDivider)
Widget playgroundDividerUseCase(BuildContext context) {
  return const _DividersPlayground();
}

class _DividersPlayground extends GtStatefulWidget {
  const _DividersPlayground();

  @override
  State<_DividersPlayground> createState() => _DividersPlaygroundState();
}

class _DividersPlaygroundState extends State<_DividersPlayground> {
  late final GtTabController<String> _controller;
  late final List<GtTabData<String>> _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = [
      GtTabData(label: "In-Component", value: "in_component"),
      GtTabData(label: "Section", value: "section"),
    ];
    _controller = GtTabController<String>(initialValue: _tabs.first);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.palette.bg.white,
      body: SafeArea(
        child: Padding(
          padding: context.insets.defaultAllInsets,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GtTabbar<String>(controller: _controller, tabs: _tabs),
              const GtGap.yMd(),
              Expanded(
                child: GtTabbarView<String>.lazy(
                  controller: _controller,
                  tabs: _tabs,
                  tabBuilders: {
                    "in_component": (_) => GtWidgetDocPage(
                      title: "In-Component Dividers",
                      description:
                          "Dividers used to separate content inside widgets.",
                      code: '''
GtDivider.xs()    // Extra Small (1px)
GtDivider.sm()    // Small (2px)
GtDivider.base()  // Base (4px)
GtDivider.md()    // Medium (8px)
GtDivider.lg()    // Large (12px)
GtDivider.xl()    // Extra Large (16px)''',
                      child: Column(
                        spacing: context.spacingLg,
                        children: [
                          _DividerExampleRow(
                            label: "xs (1px)",
                            child: GtDivider.xs(),
                          ),
                          _DividerExampleRow(
                            label: "sm (2px)",
                            child: GtDivider.sm(),
                          ),
                          _DividerExampleRow(
                            label: "base (4px)",
                            child: GtDivider.base(),
                          ),
                          _DividerExampleRow(
                            label: "md (8px)",
                            child: GtDivider.md(),
                          ),
                          _DividerExampleRow(
                            label: "lg (12px)",
                            child: GtDivider.lg(),
                          ),
                          _DividerExampleRow(
                            label: "xl (16px)",
                            child: GtDivider.xl(),
                          ),
                        ],
                      ),
                    ),
                    "section": (_) => GtWidgetDocPage(
                      title: "Section Dividers",
                      description:
                          "Dividers used to separate distinct content sections of a page.",
                      code: '''
GtDivider.sectionSm()   // Small Section (20px)
GtDivider.sectionMd()   // Medium Section (24px)
GtDivider.sectionLg()   // Large Section (32px)
GtDivider.sectionXl()   // Extra Large Section (40px)
GtDivider.section2Xl()  // 2X Large Section (48px)
GtDivider.section3Xl()  // 3X Large Section (64px)
GtDivider.section4Xl()  // 4X Large Section (80px)''',
                      child: Column(
                        spacing: context.spacingLg,
                        children: [
                          _DividerExampleRow(
                            label: "sectionSm (20px)",
                            child: GtDivider.sectionSm(),
                          ),
                          _DividerExampleRow(
                            label: "sectionMd (24px)",
                            child: GtDivider.sectionMd(),
                          ),
                          _DividerExampleRow(
                            label: "sectionLg (32px)",
                            child: GtDivider.sectionLg(),
                          ),
                          _DividerExampleRow(
                            label: "sectionXl (40px)",
                            child: GtDivider.sectionXl(),
                          ),
                          _DividerExampleRow(
                            label: "section2Xl (48px)",
                            child: GtDivider.section2Xl(),
                          ),
                          _DividerExampleRow(
                            label: "section3Xl (64px)",
                            child: GtDivider.section3Xl(),
                          ),
                          _DividerExampleRow(
                            label: "section4Xl (80px)",
                            child: GtDivider.section4Xl(),
                          ),
                        ],
                      ),
                    ),
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DividerExampleRow extends StatelessWidget {
  final String label;
  final Widget child;

  const _DividerExampleRow({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        GtText(
          label,
          style: context.textStyles.bodyM(color: context.palette.text.sub),
        ),
        const GtGap.yXs(),
        child,
      ],
    );
  }
}
