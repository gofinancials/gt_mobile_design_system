import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtExpansionTile', type: GtExpansionTile)
Widget playgroundGtExpansionTileUseCase(BuildContext context) {
  return const _ExpansionTileGalleryView();
}

class _ExpansionTileGalleryView extends StatelessWidget {
  const _ExpansionTileGalleryView();

  @override
  Widget build(BuildContext context) {
    final headerTitle = context.knobs.string(
      label: 'Header Title',
      initialValue: 'Account Details',
    );

    final autoScroll = context.knobs.boolean(
      label: 'Auto Scroll',
      initialValue: true,
    );

    final isInitiallyExpanded = context.knobs.boolean(
      label: 'Initially Expanded',
      initialValue: false,
    );

    final iconSize = context.knobs.double.slider(
      label: 'Icon Size (dp)',
      initialValue: 20.0,
      min: 16.0,
      max: 48.0,
    );

    final expandIcon = context.knobs.object.dropdown<IconData>(
      label: 'Expand Icon',
      initialOption: GtIcons.chevronDownOutline,
      options: [
        GtIcons.chevronDownOutline,
        GtIcons.plus,
        GtIcons.rotateAnticlockwise,
      ],
      labelBuilder: (icon) => icon == GtIcons.chevronDownOutline
          ? 'Chevron Up'
          : icon == GtIcons.plus
          ? 'Plus'
          : 'Rotate',
    );

    final collapseIcon = context.knobs.object.dropdown<IconData>(
      label: 'Collapse Icon',
      initialOption: GtIcons.chevronUpOutline,
      options: [GtIcons.chevronUpOutline, GtIcons.cancel, GtIcons.refreshAlt],
      labelBuilder: (icon) => icon == GtIcons.chevronUpOutline
          ? 'Chevron Up'
          : icon == GtIcons.cancel
          ? 'Cancel'
          : 'Refresh',
    );

    final codeSnippet =
        '''
GtExpansionTile(
  leading: GtText(
    '$headerTitle',
    style: context.textStyles.button(),
  ),
  autoScroll: $autoScroll,
  isInitiallyExpanded: $isInitiallyExpanded,
  iconSize: $iconSize,
  expandIcon: GtIcons.${expandIcon == GtIcons.chevronUp
            ? 'chevronUp'
            : expandIcon == GtIcons.plus
            ? 'plus'
            : 'rotateAnticlockwise'},
  collapseIcon: GtIcons.${collapseIcon == GtIcons.chevronDown
            ? 'chevronDown'
            : collapseIcon == GtIcons.cancel
            ? 'cancel'
            : 'refreshAlt'},
  children: [
    Padding(
      padding: context.insets.symmetricDp(vertical: 8.px),
      child: GtDoubleColumnListTile('Account Number', value: '0123456789'),
    ),
    Padding(
      padding: context.insets.symmetricDp(vertical: 8.px),
      child: GtDoubleColumnListTile('Account Type', value: 'Savings'),
    ),
    Padding(
      padding: context.insets.symmetricDp(vertical: 8.px),
      child: GtDoubleColumnListTile('Available Balance', value: '\$14,500.00'),
    ),
  ],
)''';

    return GtWidgetDocPage(
      title: 'GtExpansionTile',
      description:
          'An expandable container organism that reveals content upon tapping the header.',
      code: codeSnippet,
      child: GtCard(
        child: GtExpansionTile(
          key: ValueKey((
            headerTitle,
            autoScroll,
            isInitiallyExpanded,
            iconSize,
            expandIcon,
            collapseIcon,
          )),
          autoScroll: autoScroll,
          isInitiallyExpanded: isInitiallyExpanded,
          iconSize: iconSize,
          expandIcon: expandIcon,
          collapseIcon: collapseIcon,
          leading: GtSectionHeader(headerTitle),
          children: [
            const GtGap.ySm(),
            _DetailRow(label: 'Account Number', value: '0123456789'),
            _DetailRow(label: 'Account Type', value: 'Savings'),
            _DetailRow(label: 'Available Balance', value: '\$14,500.00'),
            const GtGap.ySm(),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.insets.symmetricDp(vertical: 6.px),
      child: GtDoubleColumnListTile(label, value: value),
    );
  }
}
