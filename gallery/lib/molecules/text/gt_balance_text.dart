import 'package:flutter/material.dart';
import 'package:gallery/widgets/gallery_page_header.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Widgetbook preview for [GtBalanceText] (currency + amount, optional masking).
@widgetbook.UseCase(
  name: 'Balance',
  type: GtBalanceText,
  path: '[Molecules]/GtText',
)
Widget playgroundGtBalanceTextUseCase(BuildContext context) {
  final amount = context.knobs.double.input(
    label: 'Amount',
    initialValue: 20_250_499.99,
  );
  final hidden = context.knobs.boolean(
    label: 'Hidden (mask amount)',
    initialValue: false,
  );
  final currencySymbol = context.knobs.string(
    label: 'Currency symbol',
    initialValue: "N",
  );

  return Scaffold(
    body: Padding(
      padding: context.insets.symmetricDp(
        horizontal: context.grid.singleColumn.margins.px,
      ),
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          GalleryPageHeader(
            title: "Balance Text",
            rider: "Balance text Playground",
          ),
          const GtGap.yXl(),
          GtBalanceText(
            amount: amount,
            hidden: hidden,
            currencySymbol: currencySymbol,
            textAlign: .start,
          ),
        ],
      ),
    ),
  );
}
