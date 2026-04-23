import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtSelectionTabbar<T> extends GtStatefulWidget {
  final List<GtTabData<T>> tabs;
  final GtTabController<T> controller;
  final OnChanged<T>? onChangeTab;
  final bool useAlternateStyle;

  const GtSelectionTabbar({
    super.key,
    required this.tabs,
    required this.controller,
    this.onChangeTab,
    this.useAlternateStyle = false,
  }) : assert(tabs.length > 0);

  @override
  State<GtSelectionTabbar> createState() => _GtSelectionTabbarState();
}

class _GtSelectionTabbarState extends State<GtSelectionTabbar> {
  @override
  void initState() {
    super.initState();
    if (!widget.controller.hasValue) {
      widget.controller.value = widget.tabs.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAlt = widget.useAlternateStyle;
    final spacing = isAlt ? context.spacingSm : context.spacingBase;

    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final tabs = widget.tabs;
        final value = widget.controller.value;

        return SingleChildScrollView(
          scrollDirection: .horizontal,
          child: Row(
            spacing: spacing,
            crossAxisAlignment: .center,
            children: [
              for (final tab in tabs)
                if (widget.useAlternateStyle)
                  GtTabPill.selection(
                    text: tab.label,
                    value: tab,
                    activeValue: value,
                    icon: tab.icon,
                    onSelect: (newTab) {
                      widget.controller.value = newTab;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        widget.onChangeTab?.call(newTab.value);
                      });
                    },
                    variant: .primary,
                  )
                else
                  GtTabPill(
                    text: tab.label,
                    value: tab,
                    activeValue: value,
                    icon: tab.icon,
                    onSelect: (newTab) {
                      widget.controller.value = newTab;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        widget.onChangeTab?.call(newTab.value);
                      });
                    },
                    variant: .primary,
                  ),
            ],
          ),
        );
      },
    );
  }
}
