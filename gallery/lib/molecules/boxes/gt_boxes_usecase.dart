import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'GtBoxes',
  type: GtSizedBox,
  path: "[Molecules]/GtBoxes",
)
Widget playgroundGtBoxesUseCase(BuildContext context) {
  // Knobs for GtSizedBox
  final boxWidth = context.knobs.double.slider(
    label: "GtSizedBox Width",
    initialValue: 100,
    min: 0,
    max: 300,
    divisions: 150,
  );
  final boxHeight = context.knobs.double.slider(
    label: "GtSizedBox Height",
    initialValue: 100,
    min: 0,
    max: 300,
    divisions: 150,
  );

  // Knobs for GtSquareBox
  final squareSize = context.knobs.double.slider(
    label: "GtSquareBox Size",
    initialValue: 80,
    min: 0,
    max: 300,
    divisions: 150,
  );

  // Knobs for GtFractionalBox
  final fractionalWidth = context.knobs.double.slider(
    label: "Fractional Width",
    initialValue: 0.5,
    min: 0.0,
    max: 1.0,
  );
  final fractionalHeight = context.knobs.double.slider(
    label: "Fractional Height",
    initialValue: 0.8,
    min: 0.0,
    max: 1.0,
  );

  // Knobs for the Grid Layout demonstration
  final gridOptions = [
    ("Single Column", context.grid.singleColumn),
    ("Double Column", context.grid.doubleColumn),
    ("Triple Column", context.grid.tripleColumn),
    ("4-Column", context.grid.fourColumn),
    ("8-Column", context.grid.eightColumn),
  ];

  // Knobs for alignment of the fractional box

  final alignmentOptions = [
    ("Center", Alignment.center),
    ("Top Left", Alignment.topLeft),
    ("Top Right", Alignment.topRight),
    ("Bottom Left", Alignment.bottomLeft),
    ("Bottom Right", Alignment.bottomRight),
    ("Top Center", Alignment.topCenter),
    ("Bottom Center", Alignment.bottomCenter),
    ("Left Center", Alignment.centerLeft),
    ("Right Center", Alignment.centerRight),
  ];

  final selectedGrid = context.knobs.object.dropdown<(String, GtGridLayout)>(
    label: "Grid Configuration",
    options: gridOptions,
    labelBuilder: (value) => value.$1,
    initialOption: gridOptions[1], // Default to Double Column
  );

  final selectedAlignment = context.knobs.object.dropdown<(String, Alignment)>(
    label: "Box Alignment in Grid",
    options: alignmentOptions,
    labelBuilder: (value) => value.$1,
    initialOption: alignmentOptions[1], // Default to Double Column
  );

  return Scaffold(
    key: const PageStorageKey("Boxes Playground"),
    body: Padding(
      padding: context.insets.symmetricDp(
        horizontal: context.grid.singleColumn.margins.px,
      ),
      child: CustomScrollView(
        key: const PageStorageKey("Boxes Playground Scroll View"),
        slivers: [
          SliverToBoxAdapter(
            child: GalleryPageHeader(
              title: "Boxes Playground",
              rider: "Explore standardized sizing and fractional layouts.",
              sectionHeader: "GtSizedBox",
            ),
          ),
          SliverToBoxAdapter(
            child: GtBoxDescriptionContainer(
              title: "GtSizedBox",
              description:
                  "A standardized box that automatically scales height and width to DP.",
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
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "GtSquaredBox"),
          ),
          SliverToBoxAdapter(
            child: GtBoxDescriptionContainer(
              title: "GtSquareBox",
              description:
                  "Forces its child to have equal width and height, scaled to DP.",
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
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "GtFractionalBox"),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: context.insets.onlyDp(bottom: 8.px),
              child: GtText(
                "GtFractionalBox & Grid Integration",
                style: context.textStyles.h4(),
              ),
            ),
          ),
          SliverGrid.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: selectedGrid.$2.columns,
              mainAxisSpacing: selectedGrid.$2.gutter,
              crossAxisSpacing: selectedGrid.$2.gutter,
              mainAxisExtent: 120,
            ),
            itemCount: selectedGrid.$2.columns,
            itemBuilder: (context, index) {
              return GtFractionalBox(
                widthFactor: fractionalWidth,
                heightFactor: fractionalHeight,
                alignment: selectedAlignment.$2,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: context.palette.stroke.sub),
                    color: context.palette.information.base,
                  ),
                  child: Center(
                    child: GtText(
                      "${(fractionalWidth * 100).toInt()}% W\n${(fractionalHeight * 100).toInt()}% H",
                      style: context.textStyles.bodyXs(
                        color: context.palette.text.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    ),
  );
}

// Local description container to keep the use-case self-contained.
class GtBoxDescriptionContainer extends GtStatelessWidget {
  final String title;
  final String description;
  final Widget child;

  const GtBoxDescriptionContainer({
    required this.title,
    required this.description,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: context.insets.allDp(16.px),
      decoration: BoxDecoration(
        border: Border.all(color: context.palette.bg.sub, width: 1),
        borderRadius: context.radii.md.circularBorderRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GtText(title, style: context.textStyles.h4()),
          GtGap.yXs(),
          GtText(description, style: context.textStyles.bodyS()),
          GtGap.yMd(),
          Container(
            alignment: Alignment.center,
            padding: context.insets.allDp(8.px),
            width: double.infinity,
            child: child,
          ),
        ],
      ),
    );
  }
}
