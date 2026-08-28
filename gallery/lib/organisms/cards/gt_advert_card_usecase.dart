import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Carousel', type: GtAdvertCard)
Widget playgroundGtAdvertCardUseCase(BuildContext context) {
  final palette = context.palette;

  return GtWidgetDocPage(
    title: 'GtAddressCard',
    description:
        'A structured card specifically styled for displaying addresses and verification borders.',
    code: '''
Column(
  spacing: context.spacingMd,
  crossAxisAlignment: .stretch,
  children: [
    GtSectionHeader('Do more with your money'),
    SingleChildScrollView(
      child: Row(
        spacing: context.spacingBase,
        children: [
          GtAdvertCard(
            color: palette.feature.base,
            illustration: const AppImageData.asset(
              GtVectorIllustrations.emptyState,
            ),
            title: 'Send money',
            subtitle: 'Pay someone, buy something, or sort your bills',
            actionLabel: 'Pay someone',
            onPressed: () => context.showToast('Pay someone selected'),
            onDismiss: () => context.showToast('Send money dismissed'),
          ),
          GtAdvertCard(
            color: palette.success.darker,
            illustration: const AppImageData.asset(
              GtVectorIllustrations.date,
            ),
            title: 'And more...',
            subtitle:
                'Buy, sell, save or schedule payment with peace of mind',
            actionLabel: 'Schedule payment',
            onPressed: () => context.showToast('Schedule payment selected'),
            onDismiss: () => context.showToast('Schedule card dismissed'),
          ),
        ],
      ),
    ),
  ],
)''',
    child: Column(
      spacing: context.spacingMd,
      crossAxisAlignment: .stretch,
      mainAxisSize: .min,
      children: [
        GtSectionHeader('Do more with your money'),
        GtAdvertCardCarousel(
          children: [
            GtAdvertCard(
              color: palette.feature.base,
              illustration: const AppImageData.asset(
                GtVectorIllustrations.emptyState,
              ),
              title: 'Send money',
              subtitle: 'Pay someone, buy something, or sort your bills',
              actionLabel: 'Pay someone',
              onPressed: () => context.showToast('Pay someone selected'),
              onDismiss: () => context.showToast('Send money dismissed'),
            ),
            GtAdvertCard(
              color: palette.success.base,
              illustration: const AppImageData.asset(
                GtVectorIllustrations.date,
              ),
              title: 'And more...',
              subtitle:
                  'Buy, sell, save or schedule payment with peace of mind',
              actionLabel: 'Schedule payment',
              onPressed: () => context.showToast('Schedule payment selected'),
              onDismiss: () => context.showToast('Schedule card dismissed'),
            ),
          ],
        ),
      ],
    ),
  );
}
