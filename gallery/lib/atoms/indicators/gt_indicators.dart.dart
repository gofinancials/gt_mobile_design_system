// ignore_for_file: deprecated_member_use

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/foundation.dart';
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
    initialOption: ("Square", GtCheckBoxShape.square),
    options: [
      ("Square", GtCheckBoxShape.square),
      ("Circle", GtCheckBoxShape.circle),
    ],
    labelBuilder: (value) => value.$1,
  );

   double slideValue = context.knobs.double.slider(
    label: "Slider Value",
    max: 1,
    divisions: 10,
  );

  int dotLength = context.knobs.int.slider(
    label: "Dot Length",
    max: 10,
    initialValue: 5,
  );
  int activeDot = context.knobs.int.slider(label: "Dot Value", max: dotLength);

  int countValue = context.knobs.int.slider(
    label: "Count Value",
    max: 10,
    initialValue: 1,
  );
  final countType = context.knobs.object
      .dropdown<(String, GtCountIndicatorType)>(
        label: "Count Indicator Type",
        initialOption: ("Error", GtCountIndicatorType.error),
        options: [
          ("Error", GtCountIndicatorType.error),
          ("Success", GtCountIndicatorType.success),
          ("Info", GtCountIndicatorType.info),
          ("Warning", GtCountIndicatorType.warning),
          ("Neutral", GtCountIndicatorType.neutral),
        ],
        labelBuilder: (value) => value.$1,
      );

  return Scaffold(
    key: PageStorageKey("Indicators Playground"),
    body: Padding(
      padding: context.insets.symmetricDp(
        horizontal: context.grid.singleColumn.margins.px,
      ),
      child: CustomScrollView(
        key: PageStorageKey("Indicators Playground Scroll View"),
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
            child: GtIdicatorDescriptionContainer(
              title: "GtSwitch",
              description:
                  "A standardized switch widget used to toggle between on and off states, has a default active color matching <e>context.palette.success.base</e>, active color can be set via its constructor also",
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
            child: GtIdicatorDescriptionContainer(
              title: "GtCheckBox",
              description:
                  "A highly customizable, stateless checkbox component for the Go Tech design system.",
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
            child: GtIdicatorDescriptionContainer(
              title: "GtRadio<T>/GtRadio<T>.conditional",
              description:
                  "A highly customizable, stateless radio button component for the Go Tech design system.",
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
            child: GtIdicatorDescriptionContainer(
              title: "GtSpinner",
              description:
                  "A versatile spinner that either animates indefinitely or acts as a pie chart.",
              child: GtSpinner(size: 30, color: color.$2),
            ),
          ),
          SliverToBoxAdapter(child: GtGap.yMd()),
          SliverToBoxAdapter(
            child: GtIdicatorDescriptionContainer(
              title: "GtSpinner with value",
              child: GtSpinner(
                size: 30,
                color: color.$2,
                value: progressValues.$2,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "GtAnimatedProgress"),
          ),
          SliverToBoxAdapter(
            child: GtIdicatorDescriptionContainer(
              title: "GtAnimatedProgress",
              description:
                  "A progress indicator that smoothly animates its value upon initialization.",
              child: GtAnimatedProgress(
                value: progressValues.$2,
                valueColor: color.$2,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "GtProgress"),
          ),
          SliverToBoxAdapter(
            child: GtIdicatorDescriptionContainer(
              title: "GtProgress",
              description:
                  "A linear progress indicator for the Go Tech design system.",
              child: GtProgress(color: color.$2),
            ),
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "GtSlider"),
          ),
          SliverToBoxAdapter(
            child: GtIdicatorDescriptionContainer(
              title: "GtSlider",
              description:
                  "An adaptive slider widget for the Go Tech design system.",
              child: GtSlider(
                value: slideValue,
                onChanged: (value) => slideValue = value,
              ),
            ),
          ),
          SliverToBoxAdapter(child: GalleryPageSectionHeader(title: "GtDots")),
          SliverToBoxAdapter(
            child: GtIdicatorDescriptionContainer(
              title: "GtDots",
              description:
                  "A standard row of dot indicators, typically used for carousels or paginated content.",
              child: GtDots(
                min(dotLength, activeDot),
                activeColor: color.$2,
                length: dotLength,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "GtScaledDots"),
          ),
          SliverToBoxAdapter(
            child: GtIdicatorDescriptionContainer(
              title: "GtScaledDots",
              description:
                  "A row of dot indicators that dynamically scales down the size of dots based on their distance from the active dot.",
              child: GtScaledDots(
                min(dotLength, activeDot),
                activeColor: color.$2,
                length: dotLength,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "GtInputDots"),
          ),
          SliverToBoxAdapter(
            child: GtIdicatorDescriptionContainer(
              title: "GtInmputDots",
              description:
                  "A row of dot indicators that dynamically scales down the size of dots based on their distance from the active dot.",
              child: GtInputDots(
                maxLength: dotLength,
                color: color.$2,
                inputValue: "1" * min(dotLength, activeDot),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "GtCountIndicator"),
          ),
          SliverToBoxAdapter(
            child: GtIdicatorDescriptionContainer(
              title: "GtCountIndicator",
              description:
                  "A circular badge widget used to display numeric counts, such as unread notifications.",
              child: GtCountIndicator(countValue, type: countType.$2),
            ),
          ),
          SliverToBoxAdapter(child: GtGap.ySectionLg()),
        ],
      ),
    ),
  );
}

class GtIdicatorDescriptionContainer extends GtStatelessWidget {
  final String title;
  final String? description;
  final Widget child;

  const GtIdicatorDescriptionContainer({
    required this.title,
    this.description,
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
                if (description.hasValue)
                  GtRichText(
                    description,
                    textStyle: context.textStyles.bodyS(),
                  ),
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
