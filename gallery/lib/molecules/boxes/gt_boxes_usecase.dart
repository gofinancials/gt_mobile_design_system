import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtBoxes', type: GtSizedBox)
Widget playgroundGtBoxesUseCase(BuildContext context) {
  return const _BoxesPlayground();
}

class _BoxesPlayground extends GtStatefulWidget {
  const _BoxesPlayground();

  @override
  State<_BoxesPlayground> createState() => _BoxesPlaygroundState();
}

final _tabs = [
  GtTabData(label: "GtSizedBox", value: "sized_box"),
  GtTabData(label: "GtSquareBox", value: "square_box"),
  GtTabData(label: "GtFractionalBox", value: "fractional_box"),
];

class _BoxesPlaygroundState extends State<_BoxesPlayground> {
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
    // GtSizedBox Knobs
    final boxWidth = context.knobs.double.slider(
      label: "GtSizedBox Width",
      initialValue: 100,
      min: 30,
      max: 300,
    );
    final boxHeight = context.knobs.double.slider(
      label: "GtSizedBox Height",
      initialValue: 100,
      min: 30,
      max: 300,
    );

    // GtSquareBox Knobs
    final squareSize = context.knobs.double.slider(
      label: "GtSquareBox Size",
      initialValue: 80,
      min: 30,
      max: 300,
    );

    // GtFractionalBox Knobs
    final fractionalWidth = context.knobs.double.slider(
      label: "Fractional Width",
      initialValue: 0.5,
      min: 0.1,
      max: 1.0,
    );
    final fractionalHeight = context.knobs.double.slider(
      label: "Fractional Height",
      initialValue: 0.8,
      min: 0.1,
      max: 1.0,
    );
    final fractionalAlignment = context.knobs.object.dropdown<Alignment>(
      label: "Fractional Alignment",
      options: const [
        Alignment.center,
        Alignment.topLeft,
        Alignment.topRight,
        Alignment.bottomLeft,
        Alignment.bottomRight,
        Alignment.centerLeft,
        Alignment.centerRight,
      ],
      initialOption: Alignment.center,
    );

    return Scaffold(
      key: const PageStorageKey("boxes_scaffold_key"),
      backgroundColor: context.palette.bg.white,
      body: SafeArea(
        child: Padding(
          padding: context.insets.defaultAllInsets,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GtTabbar<String>(
                controller: _controller,
                tabs: _tabs,
                key: const PageStorageKey("boxes_key_tabbar"),
              ),
              const GtGap.yMd(),
              Expanded(
                child: GtTabbarView<String>.lazy(
                  key: const PageStorageKey("boxes_key"),
                  controller: _controller,
                  tabs: _tabs,
                  tabBuilders: {
                    "sized_box": (_) => GtWidgetDocPage(
                      title: "GtSizedBox",
                      description:
                          "A standardized box that automatically scales height and width to DP.",
                      code:
                          '''
GtSizedBox(
  width: $boxWidth,
  height: $boxHeight,
  child: Container(color: palette.primary.base),
)''',
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 310),
                        child: Center(
                          child: GtSizedBox(
                            width: boxWidth,
                            height: boxHeight,
                            child: Container(
                              color: context.palette.primary.base,
                              alignment: Alignment.center,
                              child: GtText(
                                "${boxWidth.toInt()} x ${boxHeight.toInt()}",
                                style: context.textStyles.bodyS(
                                  color: context.palette.text.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    "square_box": (_) => GtWidgetDocPage(
                      title: "GtSquareBox",
                      description:
                          "Forces its child to have equal width and height, scaled to DP.",
                      code:
                          '''
GtSquareBox(
  size: $squareSize,
  child: Container(color: palette.warning.base),
)''',
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 310,
                          minHeight: 50,
                        ),
                        child: Center(
                          child: GtSquareBox(
                            size: squareSize,
                            child: Container(
                              color: context.palette.warning.base,
                              alignment: Alignment.center,
                              child: GtText(
                                "${squareSize.toInt()}px sq",
                                style: context.textStyles.bodyS(
                                  color: context.palette.text.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    "fractional_box": (_) => GtWidgetDocPage(
                      title: "GtFractionalBox",
                      description:
                          "Sizes its child fractionally based on parent constraints.",
                      code:
                          '''
GtFractionalBox(
  widthFactor: $fractionalWidth,
  heightFactor: $fractionalHeight,
  alignment: Alignment.${fractionalAlignment.toString().split('.').last},
  child: Container(color: palette.information.base),
)''',
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 310,
                          maxWidth: double.infinity,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: context.palette.stroke.sub,
                            ),
                          ),
                          child: GtFractionalBox(
                            widthFactor: fractionalWidth,
                            heightFactor: fractionalHeight,
                            alignment: fractionalAlignment,
                            child: Container(
                              color: context.palette.information.base,
                              alignment: Alignment.center,
                              child: GtText(
                                "${(fractionalWidth * 100).toInt()}% W x ${(fractionalHeight * 100).toInt()}% H",
                                style: context.textStyles.bodyXs(
                                  color: context.palette.text.white,
                                ),
                              ),
                            ),
                          ),
                        ),
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
