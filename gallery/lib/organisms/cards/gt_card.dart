import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/extensions/extensions.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Cards Gallery', type: GtCard)
Widget buildGtCardUseCase(BuildContext context) {
  final cardVariant = context.knobs.object.dropdown(
    label: 'Card Variant',
    options: GtCardVariant.values,
    initialOption: GtCardVariant.normal,
    labelBuilder: (value) => value.name.capitalise(),
  );

  final cornerStyle = context.knobs.object.dropdown(
    label: 'Corner Style',
    options: CornerStyle.values,
    initialOption: CornerStyle.rounded,
    labelBuilder: (value) => value.name.capitalise(),
  );

  final bannerTitle = context.knobs
      .string(
        label: 'Banner Title',
        initialValue:
            'Make it easy to get paid. Invite your friends to send you money.',
      )
      .upper;

  final bannerSubtitle = context.knobs.string(
    label: 'Banner Subtitle',
    initialValue: 'Request money either by a link or a QR Code',
  );

  bool bannerVisibility = context.knobs.boolean(
    label: 'Hide banner',
    initialValue: false,
  );

  final bannerVariant = context.knobs.object.dropdown(
    label: 'Banner Variant',
    options: GtCardVariant.values,
    initialOption: GtCardVariant.warning,
    labelBuilder: (value) => value.name.capitalise(),
  );

  return Scaffold(
    body: ListView(
      padding: context.insets.symmetricDp(
        horizontal: context.grid.singleColumn.margins.px,
      ),
      children: [
        GalleryPageHeader(
          title: "Cards",
          rider: "Playground for cards",
          sectionHeader: "GtCard",
        ),
        GtCard(
          variant: cardVariant,
          cornerStyle: cornerStyle,
          child: const GtText(
            'This is a standard GtCard. Use the knobs to change my variant and corner style.',
          ),
        ),
        const GalleryPageSectionHeader(title: "GTbannerCard"),
        GtBannerCard(
          title: bannerTitle,
          subtitle: bannerSubtitle,
          variant: bannerVariant,
          hidden: bannerVisibility,
          onClose: () => bannerVisibility = true,
        ),
      ],
    ),
  );
}
