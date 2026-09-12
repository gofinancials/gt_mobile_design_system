import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

const _leadingPresets = ['Icon', 'Avatar', 'Illustration', 'None'];

const _trailingPresets = ['Illustration', 'Chevron', 'Pill', 'None'];

const _paddingPresets = ['Default', 'Compact', 'Roomy'];

const _textStylePresets = [
  'Default',
  'subHeadXs',
  'subHeadS',
  'bodyS',
  'labelM',
];

Widget? _getLeading(
  String preset,
  BuildContext context,
  GtCardVariant variant,
) {
  return switch (preset) {
    'Icon' => GtIcon(
      GtIcons.coinStack,
      size: 24,
    ),
    'Avatar' => const GtAvatar(initials: 'TS', size: 40),
    'Illustration' => GtSvg(
      GtVectorIllustrations.cash,
      width: context.dp(56.px),
      height: context.dp(56.px),
    ),
    _ => null,
  };
}

Widget? _getTrailing(String preset, BuildContext context) {
  return switch (preset) {
    'Illustration' => GtSvg(
      GtVectorIllustrations.overdraft,
      width: 80,
    ),
    'Chevron' => GtIcon.withColor(
      GtIcons.chevronRight,
      color: context.palette.icon.sub,
      size: 16,
    ),
    'Pill' => const GtButtonPill(text: 'New'),
    _ => null,
  };
}

EdgeInsetsGeometry? _getPadding(String preset, BuildContext context) {
  return switch (preset) {
    'Compact' => context.insets.allDp(12.px),
    'Roomy' => context.insets.allDp(24.px),
    _ => null,
  };
}

TextStyle? _getTextStyle(String preset, BuildContext context) {
  final styles = context.textStyles;
  return switch (preset) {
    'subHeadXs' => styles.subHeadXs(),
    'subHeadS' => styles.subHeadS(),
    'bodyS' => styles.bodyS(),
    'labelM' => styles.labelM(),
    _ => null,
  };
}

String _colorSource(Color value) =>
    'Color(0x${value.toARGB32().toRadixString(16)})';

Widget _buildConfiguredProductInfoCard({
  required BuildContext context,
  required String name,
  required String description,
  required GtCardVariant variant,
  required String leadingPreset,
  required String trailingPreset,
  required Color? color,
  required String paddingPreset,
  required String nameStylePreset,
  required String descriptionStylePreset,
  required CrossAxisAlignment? rowAlignment,
  required MainAxisAlignment? columnAlignment,
  required double? horizontalSpacing,
  required double? verticalSpacing,
  required bool tappable,
  required bool fixedHeight,
}) {
  Widget card = GtProductInfoCard(
    name: name,
    description: description.isEmpty ? null : description,
    variant: variant,
    leading: _getLeading(leadingPreset, context, variant),
    trailing: _getTrailing(trailingPreset, context),
    color: color,
    padding: _getPadding(paddingPreset, context),
    nameStyle: _getTextStyle(nameStylePreset, context),
    descriptionStyle: _getTextStyle(descriptionStylePreset, context),
    rowAlignment: rowAlignment,
    columnAlignment: columnAlignment,
    horizontalSpacing: horizontalSpacing == null
        ? null
        : context.dp(horizontalSpacing.px),
    verticalSpacing: verticalSpacing == null
        ? null
        : context.dp(verticalSpacing.px),
    onTap: tappable ? () => GtToast.of(context).show('$name tapped') : null,
  );

  // Stretch needs a bounded height, which the preview's scroll view never
  // gives; IntrinsicHeight is how a caller in a list would supply one.
  if (rowAlignment == CrossAxisAlignment.stretch) {
    card = IntrinsicHeight(child: card);
  }

  if (fixedHeight) {
    card = GtSizedBox(height: 140, child: card);
  }

  return card;
}

@widgetbook.UseCase(name: 'GtProductInfoCard', type: GtProductInfoCard)
Widget playgroundGtProductInfoCardUseCase(BuildContext context) {
  final name = context.knobs.string(
    label: 'Product Name',
    initialValue: 'Target Savings',
  );
  final description = context.knobs.string(
    label: 'Description',
    initialValue: 'Save towards a goal and earn up to 12% a year',
  );
  final variant = context.knobs.object.dropdown<GtCardVariant>(
    label: 'Variant',
    options: GtCardVariant.values,
    initialOption: GtCardVariant.normal,
    labelBuilder: (v) => v.name,
  );
  final color = context.knobs.colorOrNull(
    label: 'Background Colour',
    initialValue: null,
  );
  final leadingPreset = context.knobs.object.dropdown<String>(
    label: 'Leading',
    options: _leadingPresets,
    initialOption: _leadingPresets.first,
  );
  final trailingPreset = context.knobs.object.dropdown<String>(
    label: 'Trailing',
    options: _trailingPresets,
    initialOption: _trailingPresets.first,
  );
  final paddingPreset = context.knobs.object.dropdown<String>(
    label: 'Padding',
    options: _paddingPresets,
    initialOption: _paddingPresets.first,
  );
  final nameStylePreset = context.knobs.object.dropdown<String>(
    label: 'Name Style',
    options: _textStylePresets,
    initialOption: _textStylePresets.first,
  );
  final descriptionStylePreset = context.knobs.object.dropdown<String>(
    label: 'Description Style',
    options: _textStylePresets,
    initialOption: _textStylePresets.first,
  );
  final rowAlignment = context.knobs.objectOrNull.dropdown<CrossAxisAlignment?>(
    label: 'Row Alignment',
    options: const [
      null,
      CrossAxisAlignment.start,
      CrossAxisAlignment.center,
      CrossAxisAlignment.end,
      CrossAxisAlignment.stretch,
    ],
    initialOption: null,
    labelBuilder: (v) => v?.name ?? 'Default (start)',
  );
  final columnAlignment = context.knobs.objectOrNull
      .dropdown<MainAxisAlignment?>(
        label: 'Column Alignment',
        options: const [
          null,
          MainAxisAlignment.start,
          MainAxisAlignment.center,
          MainAxisAlignment.end,
          MainAxisAlignment.spaceBetween,
        ],
        initialOption: null,
        labelBuilder: (v) => v?.name ?? 'Default (center)',
      );
  final horizontalSpacing = context.knobs.objectOrNull.dropdown<double?>(
    label: 'Horizontal Spacing',
    options: const [null, 4.0, 8.0, 16.0, 24.0],
    initialOption: null,
    labelBuilder: (v) => v == null ? 'Default (12dp)' : '${v.toInt()}dp',
  );
  final verticalSpacing = context.knobs.objectOrNull.dropdown<double?>(
    label: 'Vertical Spacing',
    options: const [null, 0.0, 4.0, 8.0, 12.0],
    initialOption: null,
    labelBuilder: (v) => v == null ? 'Default (2dp)' : '${v.toInt()}dp',
  );
  final tappable = context.knobs.boolean(label: 'Tappable', initialValue: true);
  final fixedHeight = context.knobs.boolean(
    label: 'Fixed Height (140dp)',
    initialValue: false,
  );

  final leadingSource = switch (leadingPreset) {
    'Icon' => 'GtIcon.withColor(GtIcons.target, color: iconColor, size: 32)',
    'Avatar' => "GtAvatar(initials: 'TS', size: 40)",
    'Illustration' =>
      'GtSvg(GtVectorIllustrations.cash, width: 56, height: 56)',
    _ => null,
  };
  final trailingSource = switch (trailingPreset) {
    'Chevron' =>
      'GtIcon.withColor(GtIcons.chevronRight, color: iconColor, size: 16)',
    'Pill' => "GtButtonPill(text: 'New')",
    _ => null,
  };
  final paddingSource = switch (paddingPreset) {
    'Compact' => 'context.insets.allDp(12.px)',
    'Roomy' => 'context.insets.allDp(24.px)',
    _ => null,
  };

  return GtWidgetDocPage(
    title: 'GtProductInfoCard',
    description:
        'A full-width product row: a one-line name and an optional wrapping '
        'description between optional leading and trailing widgets. Where '
        'GtProductCard is a compact grid tile, this sits in a list and needs a '
        'bounded width. Row Alignment lines the three parts up against each '
        'other. Column Alignment only moves the text once the column has spare '
        'height, so pick stretch — the preview wraps a stretched card in '
        'IntrinsicHeight, as a list would need to — or turn on Fixed Height.',
    code: [
      'GtProductInfoCard(',
      '  name: "$name",',
      if (description.isNotEmpty) '  description: "$description",',
      if (leadingSource != null) '  leading: $leadingSource,',
      if (trailingSource != null) '  trailing: $trailingSource,',
      '  variant: GtCardVariant.${variant.name},',
      if (color != null) '  color: ${_colorSource(color)},',
      if (paddingSource != null) '  padding: $paddingSource,',
      if (nameStylePreset != 'Default')
        '  nameStyle: context.textStyles.$nameStylePreset(),',
      if (descriptionStylePreset != 'Default')
        '  descriptionStyle: context.textStyles.$descriptionStylePreset(),',
      if (rowAlignment != null)
        '  rowAlignment: CrossAxisAlignment.${rowAlignment.name},',
      if (columnAlignment != null)
        '  columnAlignment: MainAxisAlignment.${columnAlignment.name},',
      if (horizontalSpacing != null)
        '  horizontalSpacing: context.dp(${horizontalSpacing.toInt()}.px),',
      if (verticalSpacing != null)
        '  verticalSpacing: context.dp(${verticalSpacing.toInt()}.px),',
      if (tappable) '  onTap: () {},',
      ')',
    ].join('\n'),
    accessibilityNotes: const [
      'With onTap set, the whole card is announced as one button described by '
          'its contents. It has no label of its own, so the name alone should '
          'identify the product.',
      'The name is capped at one line, so a long name is cut off at large '
          'text scales rather than wrapping. Keep names short and put detail '
          'in the description, which wraps.',
    ],
    child: _buildConfiguredProductInfoCard(
      context: context,
      name: name,
      description: description,
      variant: variant,
      leadingPreset: leadingPreset,
      trailingPreset: trailingPreset,
      color: color,
      paddingPreset: paddingPreset,
      nameStylePreset: nameStylePreset,
      descriptionStylePreset: descriptionStylePreset,
      rowAlignment: rowAlignment,
      columnAlignment: columnAlignment,
      horizontalSpacing: horizontalSpacing,
      verticalSpacing: verticalSpacing,
      tappable: tappable,
      fixedHeight: fixedHeight,
    ),
  );
}
