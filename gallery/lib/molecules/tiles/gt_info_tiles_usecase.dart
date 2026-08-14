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

  return GtWidgetDocPage(
    title: 'GtCopyTile',
    description:
        'A tile displaying label and value, enabling copying value to clipboard on tap.',
    code:
        '''
GtCopyTile(
  "$label",
  value: "$value",
  leading: GtIcons.gem,
)''',
    child: Center(
      child: GtCard(
        padding: context.insets.allDp(12.px),
        variant: GtCardVariant.normal,
        child: GtCopyTile(label, value: value, leading: GtIcons.gem),
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
