// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:gt_mobile_ui/gt_mobile_ui.dart';

@widgetbook.UseCase(name: 'GtText', type: GtText, path: "[Atoms]/[Typography]")
Widget playgroundGtTextUseCase(BuildContext context) {
  const text = "The quick brown fox jumps over the lazy dog.";

  final softWrap = context.knobs.boolean(
    label: "Soft wrap text",
    initialValue: true,
  );
  final direction = context.knobs.object.dropdown<TextDirection>(
    label: "Text Direction",
    initialOption: TextDirection.ltr,
    options: [TextDirection.ltr, TextDirection.rtl],
  );
  final maxLines = context.knobs.object.dropdown<(String, int)>(
    label: "Max Lines",
    initialOption: ("None", 0),
    options: [
      ("None", 0),
      ("1 Line", 1),
    ],
    labelBuilder: (value) => value.$1,
  );
  final alignment = context.knobs.object.dropdown<(String, TextAlign)>(
    label: "Text Alignment",
    initialOption: ("Start", TextAlign.start),
    options: [
      ("Start", TextAlign.start),
      ("Center", TextAlign.center),
      ("End", TextAlign.end),
      ("Justify", TextAlign.justify),
    ],
    labelBuilder: (value) => value.$1,
  );

  final displayStyles = [
    (
      "DISPLAY 1 [context.textStyles.d1]",
      GtText(
        text.upper,
        style: context.textStyles.d1(),
        softWrap: softWrap,
        textDirection: direction,
        maxLines: maxLines.$2 <= 0 ? null : maxLines.$2,
        textAlign: alignment.$2,
      ),
    ),
    (
      "DISPLAY 2 [context.textStyles.d2]",
      GtText(
        text.upper,
        style: context.textStyles.d2(),
        softWrap: softWrap,
        textDirection: direction,
        maxLines: maxLines.$2 <= 0 ? null : maxLines.$2,
        textAlign: alignment.$2,
      ),
    ),
    (
      "DISPLAY 3 [context.textStyles.d3]",
      GtText(
        text.upper,
        style: context.textStyles.d3(),
        softWrap: softWrap,
        textDirection: direction,
        maxLines: maxLines.$2 <= 0 ? null : maxLines.$2,
        textAlign: alignment.$2,
      ),
    ),
    (
      "DISPLAY 4 [context.textStyles.d4]",
      GtText(
        text.upper,
        style: context.textStyles.d4(),
        softWrap: softWrap,
        textDirection: direction,
        maxLines: maxLines.$2 <= 0 ? null : maxLines.$2,
        textAlign: alignment.$2,
      ),
    ),
  ];
  final headingStyles = [
    (
      "HEADING 1 [context.textStyles.h1]",
      GtText(
        text.upper,
        style: context.textStyles.h1(),
        softWrap: softWrap,
        textDirection: direction,
        maxLines: maxLines.$2 <= 0 ? null : maxLines.$2,
        textAlign: alignment.$2,
      ),
    ),
    (
      "HEADING 2 [context.textStyles.h2]",
      GtText(
        text.upper,
        style: context.textStyles.h2(),
        softWrap: softWrap,
        textDirection: direction,
        maxLines: maxLines.$2 <= 0 ? null : maxLines.$2,
        textAlign: alignment.$2,
      ),
    ),
    (
      "HEADING 3 [context.textStyles.h3]",
      GtText(
        text.upper,
        style: context.textStyles.h3(),
        softWrap: softWrap,
        textDirection: direction,
        maxLines: maxLines.$2 <= 0 ? null : maxLines.$2,
        textAlign: alignment.$2,
      ),
    ),
    (
      "HEADING 4 [context.textStyles.h4]",
      GtText(
        text.upper,
        style: context.textStyles.h4(),
        softWrap: softWrap,
        textDirection: direction,
        maxLines: maxLines.$2 <= 0 ? null : maxLines.$2,
        textAlign: alignment.$2,
      ),
    ),
    (
      "HEADING 5 [context.textStyles.h5]",
      GtText(
        text.upper,
        style: context.textStyles.h5(),
        softWrap: softWrap,
        textDirection: direction,
        maxLines: maxLines.$2 <= 0 ? null : maxLines.$2,
        textAlign: alignment.$2,
      ),
    ),
    (
      "HEADING 6 [context.textStyles.h6]",
      GtText(
        text.upper,
        style: context.textStyles.h6(),
        softWrap: softWrap,
        textDirection: direction,
        maxLines: maxLines.$2 <= 0 ? null : maxLines.$2,
        textAlign: alignment.$2,
      ),
    ),
  ];
  final labelStyles = [
    (
      "LABEL X-LARGE [context.textStyles.labelXl]",
      GtText(
        text,
        style: context.textStyles.labelXl(),
        softWrap: softWrap,
        textDirection: direction,
        maxLines: maxLines.$2 <= 0 ? null : maxLines.$2,
        textAlign: alignment.$2,
      ),
    ),
    (
      "LABEL LARGE [context.textStyles.labelL]",
      GtText(
        text,
        style: context.textStyles.labelL(),
        softWrap: softWrap,
        textDirection: direction,
        maxLines: maxLines.$2 <= 0 ? null : maxLines.$2,
        textAlign: alignment.$2,
      ),
    ),
    (
      "LABEL MEDIUM [context.textStyles.labelM]",
      GtText(
        text,
        style: context.textStyles.labelM(),
        softWrap: softWrap,
        textDirection: direction,
        maxLines: maxLines.$2 <= 0 ? null : maxLines.$2,
        textAlign: alignment.$2,
      ),
    ),
    (
      "LABEL SMALL [context.textStyles.labelS]",
      GtText(
        text,
        style: context.textStyles.labelS(),
        softWrap: softWrap,
        textDirection: direction,
        maxLines: maxLines.$2 <= 0 ? null : maxLines.$2,
        textAlign: alignment.$2,
      ),
    ),
    (
      "LABEL X-SMALL [context.textStyles.labelXs]",
      GtText(
        text,
        style: context.textStyles.labelXs(),
        softWrap: softWrap,
        textDirection: direction,
        maxLines: maxLines.$2 <= 0 ? null : maxLines.$2,
        textAlign: alignment.$2,
      ),
    ),
  ];
  final bodyStyles = [
    (
      "BODY X-LARGE [context.textStyles.bodyXl]",
      GtText(
        text,
        style: context.textStyles.bodyXl(),
        softWrap: softWrap,
        textDirection: direction,
        maxLines: maxLines.$2 <= 0 ? null : maxLines.$2,
        textAlign: alignment.$2,
      ),
    ),
    (
      "BODY LARGE [context.textStyles.bodyL]",
      GtText(
        text,
        style: context.textStyles.bodyL(),
        softWrap: softWrap,
        textDirection: direction,
        maxLines: maxLines.$2 <= 0 ? null : maxLines.$2,
        textAlign: alignment.$2,
      ),
    ),
    (
      "BODY MEDIUM [context.textStyles.bodyM]",
      GtText(
        text,
        style: context.textStyles.bodyM(),
        softWrap: softWrap,
        textDirection: direction,
        maxLines: maxLines.$2 <= 0 ? null : maxLines.$2,
        textAlign: alignment.$2,
      ),
    ),
    (
      "BODY SMALL [context.textStyles.bodyS]",
      GtText(
        text,
        style: context.textStyles.bodyS(),
        softWrap: softWrap,
        textDirection: direction,
        maxLines: maxLines.$2 <= 0 ? null : maxLines.$2,
        textAlign: alignment.$2,
      ),
    ),
    (
      "BODY X-SMALL [context.textStyles.bodyXs]",
      GtText(
        text,
        style: context.textStyles.bodyXs(),
        softWrap: softWrap,
        textDirection: direction,
        maxLines: maxLines.$2 <= 0 ? null : maxLines.$2,
        textAlign: alignment.$2,
      ),
    ),
  ];
  final subStyles = [
    (
      "SUBHEADING MEDIUM [context.textStyles.subHeadM]",
      GtText(
        text.upper,
        style: context.textStyles.subHeadM(),
        softWrap: softWrap,
        textDirection: direction,
        maxLines: maxLines.$2 <= 0 ? null : maxLines.$2,
        textAlign: alignment.$2,
      ),
    ),
    (
      "SUBHEADING SMALL [context.textStyles.subHeadS]",
      GtText(
        text.upper,
        style: context.textStyles.subHeadS(),
        softWrap: softWrap,
        textDirection: direction,
        maxLines: maxLines.$2 <= 0 ? null : maxLines.$2,
        textAlign: alignment.$2,
      ),
    ),
    (
      "SUBHEADING X-SMALL [context.textStyles.subHeadXs]",
      GtText(
        text.upper,
        style: context.textStyles.subHeadXs(),
        softWrap: softWrap,
        textDirection: direction,
        maxLines: maxLines.$2 <= 0 ? null : maxLines.$2,
        textAlign: alignment.$2,
      ),
    ),
    (
      "SUBHEADING XX-SMALL [context.textStyles.subHead2xs]",
      GtText(
        text.upper,
        style: context.textStyles.subHead2xs(),
        softWrap: softWrap,
        textDirection: direction,
        maxLines: maxLines.$2 <= 0 ? null : maxLines.$2,
        textAlign: alignment.$2,
      ),
    ),
  ];

  return Scaffold(
    body: Padding(
      padding: context.insets.symmetricDp(
        horizontal: context.grid.singleColumn.margins.px,
      ),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: GalleryPageHeader(
              title: "Typography",
              rider: "Typography Playground",
              sectionHeader: "Display Text Styles",
            ),
          ),
          SliverList.separated(
            itemBuilder: (_, index) {
              final (label, text) = displayStyles[index];
              return GtTextContainer(label: label, text: text);
            },
            separatorBuilder: (_, index) => const GtDivider.lg(),
            itemCount: displayStyles.length,
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "Heading Styles"),
          ),
          SliverList.separated(
            itemBuilder: (_, index) {
              final (label, text) = headingStyles[index];
              return GtTextContainer(label: label, text: text);
            },
            separatorBuilder: (_, index) => const GtDivider.lg(),
            itemCount: headingStyles.length,
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "Label Styles"),
          ),
          SliverList.separated(
            itemBuilder: (_, index) {
              final (label, text) = labelStyles[index];
              return GtTextContainer(label: label, text: text);
            },
            separatorBuilder: (_, index) => const GtDivider.lg(),
            itemCount: labelStyles.length,
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "Body Styles"),
          ),
          SliverList.separated(
            itemBuilder: (_, index) {
              final (label, text) = bodyStyles[index];
              return GtTextContainer(label: label, text: text);
            },
            separatorBuilder: (_, index) => const GtDivider.lg(),
            itemCount: bodyStyles.length,
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "Sub Heading Styles"),
          ),
          SliverList.separated(
            itemBuilder: (_, index) {
              final (label, text) = subStyles[index];
              return GtTextContainer(label: label, text: text);
            },
            separatorBuilder: (_, index) => const GtDivider.lg(),
            itemCount: subStyles.length,
          ),
          SliverToBoxAdapter(child: GtGap.ySectionLg()),
        ],
      ),
    ),
  );
}

class GtTextContainer extends StatelessWidget {
  final String label;
  final GtText text;

  const GtTextContainer({required this.text, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: context.insets.allDp(16.px),
      alignment: Alignment.bottomLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: context.dp(context.spacing.sectionMd.px),
        children: [
          GtText(
            label,
            style: context.textStyles.bodyS(color: context.palette.text.sub),
          ),
          text,
          GtTextInfoRow(text.style ?? context.textStyles.bodyM()),
        ],
      ),
    );
  }
}

class GtTextInfoRow extends StatelessWidget {
  final TextStyle style;

  const GtTextInfoRow(this.style, {super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.start,
      spacing: context.dp(context.spacing.md.px),
      runSpacing: context.dp(context.spacing.md.px),
      children: [
        GtTextInfoPill("${style.fontWeight?.value ?? 400}", label: "weight"),
        GtTextInfoPill(
          "${((style.fontSize ?? 1) * (style.height ?? 1)).toStringAsFixed(0)}PX",
          label: "line height",
        ),
        GtTextInfoPill(
          (style.letterSpacing ?? 0).toStringAsFixed(1),
          label: "letter spacing",
        ),
        GtTextInfoPill(
          "${(style.fontSize ?? 0).toStringAsFixed(0)}PX",
          label: "font size",
        ),
      ],
    );
  }
}

class GtTextInfoPill extends StatelessWidget {
  final String label;
  final String value;

  const GtTextInfoPill(this.value, {required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: context.insets.symmetricDp(horizontal: 12.px, vertical: 6.px),
      decoration: BoxDecoration(
        border: Border.all(color: context.palette.stroke.soft),
        borderRadius: context.dp(context.radii.md.px).circularBorderRadius,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        spacing: context.dp(context.spacing.sm.px),
        children: [
          GtText(
            "${label.upper}:",
            style: context.textStyles.bodyXs(color: context.palette.text.soft),
          ),
          GtText(
            value,
            style: context.textStyles.bodyXs(color: context.palette.text.sub),
          ),
        ],
      ),
    );
  }
}
