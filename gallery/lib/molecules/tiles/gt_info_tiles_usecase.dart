import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtInfoListTile', type: GtInfoListTile)
Widget playgroundGtInfoListTileUseCase(BuildContext context) {
  final label = context.knobs.string(
    label: 'Label',
    initialValue: 'Account Number',
  );
  final text = context.knobs.string(
    label: 'Text Value',
    initialValue: '0123456789',
  );

  return GtWidgetDocPage(
    title: 'GtInfoListTile',
    description:
        'A layout displaying a descriptive label and its corresponding text value.',
    code:
        '''
GtInfoListTile(
  "$label",
  text: "$text",
  onTap: () {},
)''',
    child: Center(
      child: GtCard(
        padding: context.insets.allDp(12.px),
        variant: GtCardVariant.normal,
        child: GtInfoListTile(label, text: text, onTap: () {}),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'GtStatListTile', type: GtStatListTile)
Widget playgroundGtStatListTileUseCase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Total Earnings',
  );
  final value = context.knobs.string(
    label: 'Value',
    initialValue: '₦ 1,234,567.89',
  );
  final isPositive = context.knobs.boolean(
    label: 'Is Positive Trend',
    initialValue: true,
  );
  final asCard = context.knobs.boolean(
    label: 'Wrap in Card',
    initialValue: true,
  );

  final icon = isPositive ? GtIcons.trendUp : GtIcons.trendDown;
  final GtIconVariant variant = isPositive ? .success : .error;

  final widget = asCard
      ? GtStatListTile.asCard(
          title,
          value: value,
          isPositive: isPositive,
          icon: GtIcon(icon, variant: variant),
          onTap: () {},
        )
      : GtStatListTile(
          title,
          value: value,
          isPositive: isPositive,
          icon: GtIcon(icon, variant: variant),
          onTap: () {},
        );

  return GtWidgetDocPage(
    title: 'GtStatListTile',
    description:
        'A statistical summary tile displaying label, metric, trend indicator, and optional card container.',
    code:
        '''
// Standard:
GtStatListTile(
  "$title",
  value: "$value",
  isPositive: $isPositive,
  icon: GtIcon(GtIcons.trendUp),
)

// As Card:
GtStatListTile.asCard(
  "$title",
  value: "$value",
  isPositive: $isPositive,
  icon: GtIcon(GtIcons.spark),
)''',
    child: Center(
      child: Padding(padding: context.insets.allDp(8.px), child: widget),
    ),
  );
}

@widgetbook.UseCase(name: 'GtInputListTile', type: GtInputListTile)
Widget playgroundGtInputListTileUseCase(BuildContext context) {
  final label = context.knobs.string(
    label: 'Label',
    initialValue: 'Home Address',
  );
  final text = context.knobs.string(
    label: 'Text Value',
    initialValue: '12, Sterling Towers, Lagos.',
  );
  final asCard = context.knobs.boolean(
    label: 'Wrap in Card',
    initialValue: true,
  );

  final widget = asCard
      ? GtInputListTile.asCard(
          label,
          text: text,
          leading: const GtIcon(GtIcons.user),
          onTap: () {},
        )
      : GtInputListTile(
          label,
          text: text,
          leading: const GtIcon(GtIcons.user),
          onTap: () {},
        );

  return GtWidgetDocPage(
    title: 'GtInputListTile',
    description:
        'Commonly used for summarizing input values in a read-only list format.',
    code:
        '''
GtInputListTile(
  "$label",
  text: "$text",
  leading: GtIcon(GtIcons.user),
)''',
    child: Center(
      child: Padding(padding: context.insets.allDp(8.px), child: widget),
    ),
  );
}

@widgetbook.UseCase(name: 'GtCopyTile', type: GtCopyTile)
Widget playgroundGtCopyTileUseCase(BuildContext context) {
  final label = context.knobs.string(
    label: 'Label',
    initialValue: 'Reference ID',
  );
  final value = context.knobs.string(
    label: 'Value',
    initialValue: 'REF-8902517',
  );
  final copyIconVariant = context.knobs.objectOrNull.dropdown<GtIconVariant?>(
    label: 'Copy Icon Variant',
    options: [null, ...GtIconVariant.values],
    initialOption: null,
    labelBuilder: (v) => v?.name ?? 'Default (strong)',
  );
  final copyIconSize = context.knobs.objectOrNull.dropdown<double?>(
    label: 'Copy Icon Size',
    options: const [null, 12.0, 20.0, 24.0],
    initialOption: null,
    labelBuilder: (v) => v == null ? 'Default (16)' : '${v.toInt()}dp',
  );
  final crossAxisAlignment = context.knobs.object.dropdown<CrossAxisAlignment>(
    label: 'Cross Axis Alignment',
    options: const [
      CrossAxisAlignment.start,
      CrossAxisAlignment.center,
      CrossAxisAlignment.end,
    ],
    initialOption: CrossAxisAlignment.center,
    labelBuilder: (v) => v.name,
  );

  return GtWidgetDocPage(
    title: 'GtCopyTile',
    description:
        'A tile displaying label and value, enabling copying value to clipboard on tap.',
    code: [
      'GtCopyTile(',
      '  "$label",',
      '  value: "$value",',
      '  leading: GtIcons.gem,',
      if (copyIconVariant != null)
        '  copyIconVariant: GtIconVariant.${copyIconVariant.name},',
      if (copyIconSize != null)
        '  copyIconSize: context.dp(${copyIconSize.toInt()}.px),',
      if (crossAxisAlignment != CrossAxisAlignment.center)
        '  crossAxisAlignment: CrossAxisAlignment.${crossAxisAlignment.name},',
      ')',
    ].join('\n'),
    child: Center(
      child: GtCard(
        padding: context.insets.allDp(12.px),
        variant: GtCardVariant.normal,
        child: GtCopyTile(
          label,
          value: value,
          leading: GtIcons.gem,
          copyIconVariant: copyIconVariant,
          copyIconSize: copyIconSize == null
              ? null
              : context.dp(copyIconSize.px),
          crossAxisAlignment: crossAxisAlignment,
        ),
      ),
    ),
  );
}

const _stackedCopyLeadingPresets = ['Icon', 'Avatar', 'None'];

const _stackedCopyTrailingPresets = ['Copy Icon', 'Pill'];

const _stackedCopyPaddingPresets = ['Default', 'Vertical', 'All', 'None'];

Widget? _getStackedCopyLeading(String preset, BuildContext context) {
  return switch (preset) {
    'Avatar' => const GtAvatar(initials: 'GT', size: 40),
    'Icon' => GtIcon(
      GtIcons.temple,
      size: context.dp(20.px),
      variant: .verified,
    ),
    _ => null,
  };
}

Widget? _getStackedCopyTrailing(String preset) {
  return switch (preset) {
    'Pill' => const GtButtonPill(text: 'Copy'),
    _ => null,
  };
}

EdgeInsetsGeometry? _getStackedCopyPadding(
  String preset,
  BuildContext context,
) {
  return switch (preset) {
    'Vertical' => context.insets.symmetricDp(vertical: 12.px),
    'All' => context.insets.allDp(16.px),
    'None' => EdgeInsets.zero,
    _ => null,
  };
}

Widget _buildConfiguredStackedCopyTile({
  required BuildContext context,
  required String label,
  required String subtitle,
  required String value,
  required String leadingPreset,
  required String trailingPreset,
  required String paddingPreset,
  required GtIconVariant? copyIconVariant,
  required double? copyIconSize,
  required CrossAxisAlignment rowCrossAxisAlignment,
  required MainAxisAlignment columnCrossAxisAlignment,
  required double? horizontalSpacing,
  required double? verticalSpacing,
}) {
  return GtStackedCopyTile(
    label,
    subtitle: subtitle.isEmpty ? null : subtitle,
    value: value,
    leading: _getStackedCopyLeading(leadingPreset, context),
    trailing: _getStackedCopyTrailing(trailingPreset),
    padding: _getStackedCopyPadding(paddingPreset, context),
    copyIconVariant: copyIconVariant,
    copyIconSize: copyIconSize == null ? null : context.dp(copyIconSize.px),
    rowCrossAxisAlignment: rowCrossAxisAlignment,
    columnMainAxisAlignment: columnCrossAxisAlignment,
    horizontalSpacing: horizontalSpacing == null
        ? null
        : context.dp(horizontalSpacing.px),
    verticalSpacing: verticalSpacing == null
        ? null
        : context.dp(verticalSpacing.px),
  );
}

@widgetbook.UseCase(name: 'GtStackedCopyTile', type: GtStackedCopyTile)
Widget playgroundGtStackedCopyTileUseCase(BuildContext context) {
  final label = context.knobs.string(
    label: 'Label',
    initialValue: 'Account Number',
  );
  final subtitle = context.knobs.string(
    label: 'Subtitle',
    initialValue: '0123 456 789',
  );
  final value = context.knobs.string(
    label: 'Value (copied)',
    initialValue: '0123456789',
  );
  final leadingPreset = context.knobs.object.dropdown<String>(
    label: 'Leading',
    options: _stackedCopyLeadingPresets,
    initialOption: _stackedCopyLeadingPresets.first,
  );
  final trailingPreset = context.knobs.object.dropdown<String>(
    label: 'Trailing',
    options: _stackedCopyTrailingPresets,
    initialOption: _stackedCopyTrailingPresets.first,
  );
  final paddingPreset = context.knobs.object.dropdown<String>(
    label: 'Padding',
    options: _stackedCopyPaddingPresets,
    initialOption: _stackedCopyPaddingPresets.first,
  );
  final copyIconVariant = context.knobs.objectOrNull.dropdown<GtIconVariant?>(
    label: 'Copy Icon Variant',
    options: [null, ...GtIconVariant.values],
    initialOption: null,
    labelBuilder: (v) => v?.name ?? 'Default (disabled)',
  );
  final copyIconSize = context.knobs.objectOrNull.dropdown<double?>(
    label: 'Copy Icon Size',
    options: const [null, 16.0, 24.0, 28.0],
    initialOption: null,
    labelBuilder: (v) => v == null ? 'Default (20dp)' : '${v.toInt()}dp',
  );
  final rowCrossAxisAlignment = context.knobs.object
      .dropdown<CrossAxisAlignment>(
        label: 'Row Cross Axis Alignment',
        options: const [
          CrossAxisAlignment.start,
          CrossAxisAlignment.center,
          CrossAxisAlignment.end,
        ],
        initialOption: CrossAxisAlignment.start,
        labelBuilder: (v) => v.name,
      );
  final columnCrossAxisAlignment = context.knobs.object
      .dropdown<MainAxisAlignment>(
        label: 'Column Cross Axis Alignment',
        options: const [
          .start,
          .center,
          .end,
        ],
        initialOption: .start,
        labelBuilder: (v) => v.name,
      );
  final horizontalSpacing = context.knobs.objectOrNull.dropdown<double?>(
    label: 'Horizontal Spacing',
    options: const [null, 4.0, 12.0, 16.0],
    initialOption: null,
    labelBuilder: (v) => v == null ? 'Default (8dp)' : '${v.toInt()}dp',
  );
  final verticalSpacing = context.knobs.objectOrNull.dropdown<double?>(
    label: 'Vertical Spacing',
    options: const [null, 0.0, 8.0, 12.0],
    initialOption: null,
    labelBuilder: (v) => v == null ? 'Default (4dp)' : '${v.toInt()}dp',
  );

  final leadingSource = switch (leadingPreset) {
    'Avatar' => "GtAvatar(initials: 'GT', size: 40)",
    'Icon' => 'GtIcon(GtIcons.gem, size: context.dp(24.px))',
    _ => null,
  };
  final trailingSource = switch (trailingPreset) {
    'Pill' => "GtButtonPill(text: 'Copy')",
    _ => null,
  };
  final paddingSource = switch (paddingPreset) {
    'Vertical' => 'context.insets.symmetricDp(vertical: 12.px)',
    'All' => 'context.insets.allDp(16.px)',
    'None' => 'EdgeInsets.zero',
    _ => null,
  };

  return GtWidgetDocPage(
    title: 'GtStackedCopyTile',
    description:
        'A tile that stacks a label above a subtitle and copies a separate '
        'value to the clipboard on tap, so the subtitle can show a formatted '
        'or masked version of what gets copied. Picking a trailing widget '
        'replaces the copy icon, and the copy icon knobs then have no effect. '
        'Row Cross Axis Alignment lines up the leading widget, the text and '
        'the copy icon. Column Cross Axis Alignment lines up the label and '
        'subtitle against each other.',
    code: [
      'GtStackedCopyTile(',
      '  "$label",',
      if (subtitle.isNotEmpty) '  subtitle: "$subtitle",',
      '  value: "$value",',
      '  padding: $paddingSource,',
      if (leadingSource != null) '  leading: $leadingSource,',
      if (trailingSource != null) '  trailing: $trailingSource,',
      if (copyIconVariant != null)
        '  copyIconVariant: GtIconVariant.${copyIconVariant.name},',
      if (copyIconSize != null)
        '  copyIconSize: context.dp(${copyIconSize.toInt()}.px),',
      if (rowCrossAxisAlignment != CrossAxisAlignment.start)
        '  rowCrossAxisAlignment: CrossAxisAlignment.${rowCrossAxisAlignment.name},',
      if (columnCrossAxisAlignment != .start)
        '  columnCrossAxisAlignment: CrossAxisAlignment.${columnCrossAxisAlignment.name},',
      if (horizontalSpacing != null)
        '  horizontalSpacing: context.dp(${horizontalSpacing.toInt()}.px),',
      if (verticalSpacing != null)
        '  verticalSpacing: context.dp(${verticalSpacing.toInt()}.px),',
      ')',
    ].join('\n'),
    child: Center(
      child: GtCard(
        variant: .normal,
        child: _buildConfiguredStackedCopyTile(
          context: context,
          label: label,
          subtitle: subtitle,
          value: value,
          leadingPreset: leadingPreset,
          trailingPreset: trailingPreset,
          paddingPreset: paddingPreset,
          copyIconVariant: copyIconVariant,
          copyIconSize: copyIconSize,
          rowCrossAxisAlignment: rowCrossAxisAlignment,
          columnCrossAxisAlignment: columnCrossAxisAlignment,
          horizontalSpacing: horizontalSpacing,
          verticalSpacing: verticalSpacing,
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'GtInstructionListTile', type: GtInstructionListTile)
Widget playgroundGtInstructionListTileUseCase(BuildContext context) {
  final text = context.knobs.string(
    label: 'Instruction',
    initialValue:
        'Ensure you upload a clear JPEG or PNG of your government-issued ID card.',
  );

  return GtWidgetDocPage(
    title: 'GtInstructionListTile',
    description:
        'Displays a descriptive instructional message alongside a leading icon.',
    code:
        '''
GtInstructionListTile(
  "$text",
  icon: GtIcons.info,
)''',
    child: Center(
      child: GtCard(
        padding: context.insets.allDp(12.px),
        variant: GtCardVariant.normal,
        child: GtInstructionListTile(
          text,
          icon: GtIcons.info,
          crossAxisAlignment: .center,
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'GtDoubleColumnListTile',
  type: GtDoubleColumnListTile,
)
Widget playgroundGtDoubleColumnListTileUseCase(BuildContext context) {
  final label = context.knobs.string(
    label: 'Label',
    initialValue: 'Transaction Fee',
  );
  final value = context.knobs.string(label: 'Value', initialValue: '₦ 52.50');
  final highlightValue = context.knobs.boolean(
    label: 'Highlight Value',
    initialValue: true,
  );

  return GtWidgetDocPage(
    title: 'GtDoubleColumnListTile',
    description:
        'A list tile displaying balanced label (left) and value (right) layout.',
    code:
        '''
GtDoubleColumnListTile(
  "$label",
  value: "$value",
  highlightValue: $highlightValue,
)''',
    child: Center(
      child: GtCard(
        padding: context.insets.allDp(12.px),
        variant: GtCardVariant.normal,
        child: GtDoubleColumnListTile(
          label,
          value: value,
          highlightValue: highlightValue,
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'GtSimpleInfoTile', type: GtSimpleInfoTile)
Widget playgroundGtSimpleInfoTileUseCase(BuildContext context) {
  final text = context.knobs.string(
    label: 'Text',
    initialValue: 'Active session expires in 2 minutes.',
  );

  return GtWidgetDocPage(
    title: 'GtSimpleInfoTile',
    description:
        'Minimal status or information tag featuring a tiny icon and text side-by-side.',
    code:
        '''
GtSimpleInfoTile(
  leading: GtIcon(GtIcons.info),
  text: "$text",
)''',
    child: GtSimpleInfoTile(
      leading: const GtIcon(GtIcons.circleInfo),
      text: text,
    ),
  );
}

@widgetbook.UseCase(name: 'GtSuccessRateTile', type: GtSuccessRateTile)
Widget playgroundGtSuccessRateTileUseCase(BuildContext context) {
  final text = context.knobs.string(
    label: 'Service / Bank Name',
    initialValue: 'Sterling Bank',
  );
  final successRate = context.knobs.double.slider(
    label: 'Success Rate (0.0 - 1.0)',
    initialValue: 0.95,
    min: 0.0,
    max: 1.0,
  );
  final asCard = context.knobs.boolean(
    label: 'Wrap in Card',
    initialValue: true,
  );

  final widget = GtSuccessRateTile(
    leading: const GtImage(
      image: AppImageData(GtVectors.logo),
      width: 24,
      height: 24,
    ),
    text: text,
    successRate: successRate,
  );

  return GtWidgetDocPage(
    title: 'GtSuccessRateTile',
    description:
        'Displays service/bank names alongside semantic success rate percentage pills (stable for ≥90%, away for ≥80%, warning for ≥70%, error below 70%).',
    code:
        '''
GtSuccessRateTile(
  leading: const GtAvatar(
    avatar: AppImageData(GtNetworkImages.sampleAvatar1),
    size: 32,
  ),
  text: "$text",
  successRate: $successRate,
)''',
    child: Center(
      child: asCard
          ? GtCard(
              padding: context.insets.allDp(12.px),
              variant: GtCardVariant.normal,
              child: widget,
            )
          : Padding(padding: context.insets.allDp(12.px), child: widget),
    ),
  );
}
