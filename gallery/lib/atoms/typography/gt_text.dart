// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:gt_mobile_ui/gt_mobile_ui.dart';

@widgetbook.UseCase(name: 'GtText', type: GtText)
Widget playgroundGtTextUseCase(BuildContext context) {
  const text = "The quick brown fox jumps over the lazy dog.";
  final styles = context.textStyles;

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
    options: [("None", 0), ("1 Line", 1)],
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

  final allStyles = [
    for (final style in styles.all)
      (
        style.$1,
        GtText(
          text.upper,
          style: style.$2,
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
              sectionHeader: "Text Styles",
            ),
          ),
          SliverList.separated(
            itemBuilder: (_, index) {
              final (label, text) = allStyles[index];
              return GtTextContainer(label: label, text: text);
            },
            separatorBuilder: (_, index) => const GtDivider.lg(),
            itemCount: allStyles.length,
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
