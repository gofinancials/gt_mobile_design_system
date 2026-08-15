import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtSummaryScaffold', type: GtSummaryScaffold)
Widget playgroundGtSummaryScaffoldUseCase(BuildContext context) {
  return const _SummaryScaffoldDoc();
}

@widgetbook.UseCase(name: 'GtSummaryScaffold Gallery', type: GtSummaryScaffold)
Widget playgroundGtSummaryScaffoldGalleryUseCase(BuildContext context) {
  return const _SummaryScaffoldPreview();
}

@widgetbook.UseCase(name: 'GtSummaryBody', type: GtSummaryBody)
Widget playgroundGtSummaryBodyUseCase(BuildContext context) {
  return const _SummaryBodyInlinePreview();
}

const _bankLogo = AppImageData(GtVectors.logo);
const _avatar = AppImageData(GtAssetImages.avatar);
const _categoryGlyph = AppImageData(GtNetworkImages.transfer);

/// The presets, named for the screen each one reproduces.
const _presets = [
  'Standard Transfer',
  'Scheduled Transfer',
  'Approval Request',
  'Savings Goal',
  'Bulk Payment',
  'With Success Rates',
];

/// The recipient card the transfer presets share.
const _recipientSection = GtSummarySection(
  tiles: [
    GtSummaryTileData(label: "Account Number", value: "0123456789"),
    GtSummaryTileData(
      label: "Bank Name",
      value: "Sterling Bank",
      leading: _bankLogo,
    ),
    GtSummaryTileData(
      label: "Account Name",
      value: "KENNETH OSMOSIS",
      leading: _avatar,
    ),
  ],
);

const _bulkSections = [
  GtSummarySection(
    layout: .stacked,
    tiles: [
      GtSummaryTileData(label: "Name of bulk payment", value: "Staff Salary"),
    ],
  ),
  GtSummaryPaymentsSection(
    title: "Payments",
    entries: [
      GtSummaryPaymentEntry(
        name: "Basit Samad",
        detail: "0123456789",
        amount: "₦10,000.00",
        fees: "Fees: ₦0",
        avatar: _avatar,
      ),
      GtSummaryPaymentEntry(
        name: "Funmilola Malik",
        detail: "0123456789",
        amount: "₦10,000.00",
        fees: "Fees: ₦50",
        avatar: _avatar,
      ),
      GtSummaryPaymentEntry(
        name: "Kenneth Osmosis",
        detail: "3011456789",
        amount: "₦10,000.00",
        fees: "Fees: ₦50",
        avatar: _avatar,
      ),
    ],
  ),
  GtSummarySection(
    tiles: [
      GtSummaryTileData(label: "Date", value: "1st Aug, 2025 15:04 PM"),
      GtSummaryTileData(
        label: "Total transaction fees",
        value: "₦52.50(incl. VAT)",
      ),
      GtSummaryTileData(label: "Bulk ID", value: "TRX24072983910527NGN"),
      GtSummaryTileData(label: "Reference", value: "TRX24072983910527NGN"),
      GtSummaryTileData(label: "Session ID", value: "TRX24072983910527NGN"),
    ],
  ),
];

List<GtSummaryCard> _getSections(String preset, BuildContext context) {
  return switch (preset) {
    'Scheduled Transfer' => const [
      GtSummarySection(
        tiles: [
          GtSummaryTileData(label: "Transaction Fee", value: "No Fees"),
          GtSummaryTileData(label: "From", value: "Savings • 0123456789"),
        ],
      ),
      _recipientSection,
      GtSummarySection(
        tiles: [
          GtSummaryTileData(label: "Message", value: "Upcoming jollof party"),
          GtSummaryTileData(
            label: "Category",
            value: "Transfer",
            trailing: _categoryGlyph,
          ),
        ],
      ),
      GtSummarySection(
        tiles: [
          GtSummaryTileData(label: "When", value: "05/08/2025"),
          GtSummaryTileData(label: "Time", value: "10:41 AM"),
          GtSummaryTileData(label: "Repeat Frequency", value: "11/10/2025"),
          GtSummaryTileData(label: "Stops Repeating", value: "11/10/2025"),
        ],
      ),
    ],
    'Approval Request' => const [
      GtSummarySection(
        tiles: [
          GtSummaryTileData(label: "Transaction Fee", value: "No Fees"),
          GtSummaryTileData(label: "Initiated by", value: "Dewunmi Aladenusi"),
          GtSummaryTileData(label: "From", value: "Flex • 0123456789"),
        ],
      ),
      GtSummarySection(
        tiles: [
          GtSummaryTileData(label: "When", value: "05/08/2025"),
          GtSummaryTileData(label: "Repeats", value: "Never"),
        ],
      ),
      _recipientSection,
    ],
    'Savings Goal' => const [
      GtSummarySection(
        tiles: [
          GtSummaryTileData(label: "Transaction Fee", value: "No Fees"),
          GtSummaryTileData(label: "From", value: "Flex • 0123456789"),
          GtSummaryTileData(label: "To", value: "Dubai trip"),
        ],
      ),
      GtSummarySection(
        tiles: [
          GtSummaryTileData(label: "Message", value: "Upcoming jollof party"),
          GtSummaryTileData(
            label: "Category",
            value: "Transfer",
            leading: _categoryGlyph,
            valueColor: Color(0xFF1FC16B),
          ),
        ],
      ),
    ],
    'Bulk Payment' => _bulkSections,
    'With Success Rates' => [
      const GtSummarySection(
        tiles: [
          GtSummaryTileData(label: "Transaction Fee", value: "No Fees"),
          GtSummaryTileData(label: "From", value: "Flex • 0123456789"),
        ],
      ),
      const GtSummarySection(
        tiles: [
          GtSummaryTileData(label: "Account Number", value: "0123456789"),
          GtSummaryTileData(
            label: "Bank Name",
            value: "Sterling Bank",
            leading: _bankLogo,
          ),
          GtSummaryTileData(
            label: "Account Name",
            value: "ALEX LOBALOBA",
            leading: _avatar,
          ),
        ],
      ),
      GtSummaryRatesSection(
        description: "Bank Transfer success rates in the last 30 minutes",
        rates: const [
          GtSuccessRateData(name: "Sterling Bank", rate: .98, logo: _bankLogo),
        ],
        actionLabel: "See all bank transfer rates",
        onAction: () => GtToast.of(context).show("Opening all transfer rates"),
      ),
    ],
    _ => const [
      GtSummarySection(
        tiles: [
          GtSummaryTileData(label: "Transaction Fee", value: "No Fees"),
          GtSummaryTileData(label: "From", value: "Savings • 0123456789"),
        ],
      ),
      _recipientSection,
    ],
  };
}

class _SummaryKnobs {
  final String title;
  final String description;
  final String amount;
  final String amountCaption;
  final String actionLabel;
  final String preset;
  final GtSummaryTitleStyle titleStyle;
  final GtSummaryAmountStyle amountStyle;
  final bool showDescription;
  final bool showSecondaryAction;
  final bool isActionDisabled;
  final bool isActionLoading;

  const _SummaryKnobs({
    required this.title,
    required this.description,
    required this.amount,
    required this.amountCaption,
    required this.actionLabel,
    required this.preset,
    required this.titleStyle,
    required this.amountStyle,
    required this.showDescription,
    required this.showSecondaryAction,
    required this.isActionDisabled,
    required this.isActionLoading,
  });

  factory _SummaryKnobs.of(BuildContext context) {
    return _SummaryKnobs(
      title: context.knobs.string(label: 'Title', initialValue: 'Summary'),
      titleStyle: context.knobs.object.dropdown<GtSummaryTitleStyle>(
        label: 'Title Style',
        options: GtSummaryTitleStyle.values,
        initialOption: GtSummaryTitleStyle.appBar,
        labelBuilder: (value) => value.name,
      ),
      showDescription: context.knobs.boolean(
        label: 'Show Description',
        initialValue: true,
      ),
      description: context.knobs.string(
        label: 'Description',
        initialValue: 'Check the details below before you send.',
      ),
      amount: context.knobs.string(label: 'Amount', initialValue: '₦20,000.00'),
      amountStyle: context.knobs.object.dropdown<GtSummaryAmountStyle>(
        label: 'Amount Style',
        options: GtSummaryAmountStyle.values,
        initialOption: GtSummaryAmountStyle.leading,
        labelBuilder: (value) => value.name,
      ),
      amountCaption: context.knobs.string(
        label: 'Amount Caption (featured only)',
        initialValue: 'Bulk payment total',
      ),
      preset: context.knobs.object.dropdown<String>(
        label: 'Sections Preset',
        options: _presets,
        initialOption: 'Standard Transfer',
      ),
      actionLabel: context.knobs.string(
        label: 'Action Label',
        initialValue: 'Confirm',
      ),
      showSecondaryAction: context.knobs.boolean(
        label: 'Show Secondary Action',
        initialValue: false,
      ),
      isActionDisabled: context.knobs.boolean(
        label: 'Action Disabled',
        initialValue: false,
      ),
      isActionLoading: context.knobs.boolean(
        label: 'Action Loading',
        initialValue: false,
      ),
    );
  }

  bool get isFeatured => amountStyle == GtSummaryAmountStyle.featured;

  /// Builds the body for the preview.
  ///
  /// Returns the concrete [GtSummaryBody] rather than a widget because
  /// [GtSummaryScaffold.body] is typed to it; the scaffold reads the body's
  /// fields to forward the headline title.
  GtSummaryBody buildBody(BuildContext context) {
    return GtSummaryBody(
      amount: amount,
      amountStyle: amountStyle,
      amountCaption: isFeatured ? amountCaption : null,
      description: showDescription ? description : null,
      sections: _getSections(preset, context),
    );
  }
}

/// The doc entry, which points at the full-screen use case.
///
/// A summary is a pushed screen, not a sheet, so it is shown full-bleed in its
/// own use case rather than presented from a button here.
class _SummaryScaffoldDoc extends StatelessWidget {
  const _SummaryScaffoldDoc();

  @override
  Widget build(BuildContext context) {
    final knobs = _SummaryKnobs.of(context);

    return GtWidgetDocPage(
      title: 'GtSummaryScaffold',
      description:
          'A full-screen template for pre-transaction summary screens. The '
          'back chevron pops the route and a confirming action is pinned '
          'beneath the content, optionally beside a square secondary button. '
          'The title moves rather than changes: appBar centres it beside the '
          'chevron, headline drops it into the body and leaves the app bar '
          'bare. The action takes its colour from the active theme.',
      code:
          '''
GtSummaryScaffold(
  title: "${knobs.title}",
  titleStyle: GtSummaryTitleStyle.${knobs.titleStyle.name},
  actionLabel: "${knobs.actionLabel}",
  ${knobs.showSecondaryAction ? 'secondaryIcon: GtIcons.calendar,\n  onSecondaryAction: () => scheduleTransfer(),' : ''}
  onAction: () => submitTransfer(),
  body: GtSummaryBody(
    amount: "${knobs.amount}",
    amountStyle: GtSummaryAmountStyle.${knobs.amountStyle.name},
    description: "${knobs.description}",
    sections: const [
      GtSummarySection(
        tiles: [
          GtSummaryTileData(label: "Transaction Fee", value: "No Fees"),
          GtSummaryTileData(label: "From", value: "Savings • 0123456789"),
        ],
      ),
    ],
  ),
);''',
      child: const GtEmptyStateCard(
        description:
            'Select "GtSummaryScaffold Gallery" in the sidebar to view the '
            'summary screen full screen.',
        icon: GtIcons.clipboardCheck,
      ),
    );
  }
}

class _SummaryScaffoldPreview extends StatelessWidget {
  const _SummaryScaffoldPreview();

  @override
  Widget build(BuildContext context) {
    final knobs = _SummaryKnobs.of(context);

    return GtSummaryScaffold(
      title: knobs.title,
      titleStyle: knobs.titleStyle,
      actionLabel: knobs.actionLabel,
      isActionDisabled: knobs.isActionDisabled,
      isActionLoading: knobs.isActionLoading,
      secondaryIcon: knobs.showSecondaryAction ? GtIcons.calendar : null,
      onSecondaryAction: knobs.showSecondaryAction
          ? () => GtToast.of(context).show("Schedule tapped")
          : null,
      onAction: () => GtToast.of(context).show("${knobs.actionLabel} tapped"),
      body: knobs.buildBody(context),
    );
  }
}

class _SummaryBodyInlinePreview extends StatelessWidget {
  const _SummaryBodyInlinePreview();

  @override
  Widget build(BuildContext context) {
    final knobs = _SummaryKnobs.of(context);

    return GtWidgetDocPage(
      title: 'GtSummaryBody',
      description:
          'Organism widget presenting the amount — either left-aligned at the '
          'head of the first card or centred above them with a caption — then '
          'one card per entry in a sealed list of card kinds: label/value '
          'rows, a payee list, or transfer success rates, in any order. Row '
          'images bracket the value, so a bank logo leads the name it belongs '
          'to while a category glyph trails it.',
      code:
          '''
GtSummaryBody(
  amount: "${knobs.amount}",
  amountStyle: GtSummaryAmountStyle.${knobs.amountStyle.name},
  description: "${knobs.description}",
  sections: const [
    GtSummarySection(
      tiles: [
        GtSummaryTileData(label: "Transaction Fee", value: "No Fees"),
        GtSummaryTileData(
          label: "Bank Name",
          value: "Sterling Bank",
          leading: AppImageData(GtVectors.logo),
        ),
      ],
    ),
    GtSummaryPaymentsSection(
      title: "Payments",
      entries: [
        GtSummaryPaymentEntry(
          name: "Basit Samad",
          detail: "0123456789",
          amount: "₦10,000.00",
          fees: "Fees: ₦0",
        ),
      ],
    ),
  ],
)''',
      child: GtSizedBox(height: 650, child: knobs.buildBody(context)),
    );
  }
}
