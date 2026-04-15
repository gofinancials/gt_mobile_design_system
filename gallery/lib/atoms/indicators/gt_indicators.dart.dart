// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:gt_mobile_ui/gt_mobile_ui.dart';

@widgetbook.UseCase(
  name: 'GtIndicators',
  type: GtSwitch,
  path: "[Atoms]/[Indicators]",
)
Widget playgroundGtIndicatorsUseCase(BuildContext context) {
  final color = context.knobs.object.dropdown<(String, Color?)>(
    label: "Active Color",
    initialOption: ("None", null),
    options: [
      ("Success", context.palette.success.base),
      ("Primary", context.palette.primary.base),
      ("Error", context.palette.error.base),
      ("Warning", context.palette.warning.base),
      ("Information", context.palette.information.base),
      ("None", null),
    ],
    labelBuilder: (value) => value.$1,
  );
  bool state = context.knobs.boolean(
    label: "Toggle Active State",
    initialValue: true,
  );
  bool disabled = context.knobs.boolean(
    label: "Toggle Disabled State",
    initialValue: false,
  );
  final progressValues = context.knobs.object.dropdown<(String, double)>(
    label: "Value",
    initialOption: ("80%", 0.8),
    options: [
      ("80%", 0.8),
      ("60%", 0.6),
      ("40%", 0.4),
      ("20%", 0.2),
      ("0%", 0),
    ],
    labelBuilder: (value) => value.$1,
  );
  final checkBoxType = context.knobs.object.dropdown<(String, GtCheckBoxShape)>(
    label: "CheckBox Shape",
    initialOption:  ("Square", GtCheckBoxShape.square),
    options: [
      ("Square", GtCheckBoxShape.square),
      ("Circle", GtCheckBoxShape.circle),
    ],
    labelBuilder: (value) => value.$1,
  );
  int dotLength = context.knobs.int.slider(label: "Dot Length", max: 10, initialValue: 5);
  int countValue = context.knobs.int.slider(label: "CountValue", max: 10, initialValue: 1);
  final countType = context.knobs.object.dropdown<(String, GtCountIndicatorType)>(
    label: "Count Indicator Type",
    initialOption:  ("Error", GtCountIndicatorType.error),
    options: [
      ("Error", GtCountIndicatorType.error),
      ("Success", GtCountIndicatorType.success),
      ("Info", GtCountIndicatorType.info),
      ("Warning", GtCountIndicatorType.warning),
      ("Neutral", GtCountIndicatorType.neutral),
    ],
    labelBuilder: (value) => value.$1,
  );
  int activeDot = context.knobs.int.slider(label: "Dot Value", max: dotLength);
  double slideValue = context.knobs.double.slider(label: "Slider Value", max: 1, divisions: 10);


  return Scaffold(
    body: Padding(
      padding: context.insets.symmetricDp(
        horizontal: context.grid.singleColumn.margins.px,
      ),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: GalleryPageHeader(
              title: "Indicators Playground",
              rider:
                  "Take a look at our switches, radios, checkboxes and more!",
              sectionHeader: "GtSwitch WIdget",
            ),
          ),
          SliverToBoxAdapter(
            child: GtIdicatorDescxriptionContainer(
              title: "GtSwitch",
              description:
                  "The switch indicator for Go Tech Apps, has a default active color matching <e>context.palette.success.base</e>, active color can be set via its constructor also",
              child: GtSwitch(
                value: disabled ? disabled : state,
                onChanged: (value) => state = value,
                disabled: disabled,
                activeColor: color.$2,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "GtCheckBox"),
          ),
          SliverToBoxAdapter(
            child: GtIdicatorDescxriptionContainer(
              title: "GtCheckBox",
              description: "Multi Select options with GtCheckBox",
              child: GtCheckBox(
                value: 1,
                onChanged: (_) {},
                isActive: state,
                disabled: disabled,
                activeColor: color.$2,
                shape: checkBoxType.$2,
              ),
            ),
          ),
          SliverToBoxAdapter(child: GalleryPageSectionHeader(title: "GtRadio")),
          SliverToBoxAdapter(
            child: GtIdicatorDescxriptionContainer(
              title: "GtRadio<T>/GtRadio<int>.conditional",
              description: "Select one of a set of options with GtRadio",
              child: GtRadio<int>.conditional(
                value: 1,
                onChanged: (_) {},
                condition: state,
                disabled: disabled,
                activeColor: color.$2,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "GtSpinner"),
          ),
          SliverToBoxAdapter(
            child: GtIdicatorDescxriptionContainer(
              title: "GtSpinner",
              description:
                  "Show circular progress indicators with GtSpinner, has a default active color matching <e>context.palette.primary.base</e>, active color can be set via its constructor also",
              child: GtSpinner(size: 30),
            ),
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "GtAnimatedProgress"),
          ),
          SliverToBoxAdapter(
            child: GtIdicatorDescxriptionContainer(
              title: "GtAnimatedProgress",
              description:
                  "Show simple animated progress with this class, you can modify the animation duration via its constructor",
              child: GtAnimatedProgress(value: progressValues.$2),
            ),
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "GtProgress"),
          ),
          SliverToBoxAdapter(
            child: GtIdicatorDescxriptionContainer(
              title: "GtProgress",
              description:
                  "Show simple or indeterminate progress with this class",
              child: GtProgress(),
            ),
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "GtSlider"),
          ),
          SliverToBoxAdapter(
            child: GtIdicatorDescxriptionContainer(
              title: "GtSlider",
              description:
                  "Show simple or indeterminate progress with this class",
              child: GtSlider(
                value: slideValue,
                onChanged: (value) => slideValue = value,
              ),
            ),
          ),
          SliverToBoxAdapter(child: GalleryPageSectionHeader(title: "GtDots")),
          SliverToBoxAdapter(
            child: GtIdicatorDescxriptionContainer(
              title: "GtDots",
              description:
                  "Show simple active carousel slide indicatoirs with this class",
              child: GtDots(activeDot, activeColor: color.$2, length: dotLength),
            ),
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "GtScaledDots"),
          ),
          SliverToBoxAdapter(
            child: GtIdicatorDescxriptionContainer(
              title: "GtScaledDots",
              description:
                  "Show simple scaled active carousel slide indicatoirs with this class",
              child: GtScaledDots(activeDot, activeColor: color.$2, length: dotLength),
            ),
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "GtCountIndicator"),
          ),
          SliverToBoxAdapter(
            child: GtIdicatorDescxriptionContainer(
              title: "GtCountIndicator",
              description:
                  "Highlight counts with GtCountIndicator",
              child: GtCountIndicator(countValue, type: countType.$2,),
            ),
          ),
          SliverToBoxAdapter(child: GtGap.ySectionLg()),
        ],
      ),
    ),
  );
}

class GtIdicatorDescxriptionContainer extends GtStatelessWidget {
  final String title;
  final String description;
  final Widget child;

  const GtIdicatorDescxriptionContainer({
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
      child: Row(
        children: [
          Expanded(
            flex: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GtText(title, style: context.textStyles.h4()),
                GtRichText(description, textStyle: context.textStyles.bodyS()),
              ],
            ),
          ),
          GtGap.hLg(),
          Flexible(
            flex: 2,
            child: Align(
              alignment: AlignmentGeometry.centerRight,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
