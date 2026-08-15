import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtSuccessRateModal', type: GtSuccessRateModal)
Widget playgroundGtSuccessRateModalUseCase(BuildContext context) {
  return const _SuccessRateModalPreview();
}

@widgetbook.UseCase(name: 'GtSuccessRateBody', type: GtSuccessRateBody)
Widget playgroundGtSuccessRateBodyUseCase(BuildContext context) {
  return const _SuccessRateBodyInlinePreview();
}

const _description =
    "See how recipient banks are performing to avoid failed or delayed "
    "transfers.";

const _banks = [
  GtSuccessRateData(name: "Sterling Bank", rate: 1),
  GtSuccessRateData(name: "Opay", rate: .99),
  GtSuccessRateData(name: "Kuda MFB", rate: .98),
  GtSuccessRateData(name: "Paystack-Titan", rate: .87),
  GtSuccessRateData(name: "GTBank", rate: .98),
  GtSuccessRateData(name: "Moniepoint", rate: 0),
  GtSuccessRateData(name: "Zenith Bank", rate: .98),
];

List<GtSuccessRateData> _withLogos(BuildContext context, bool interactive) {
  return _banks.mapList(
    (bank) => GtSuccessRateData(
      name: bank.name,
      rate: bank.rate,
      logo: const AppImageData(GtVectors.logo),
      onTap: interactive
          ? () => GtToast.of(context).show("${bank.name} tapped")
          : null,
    ),
  );
}

SuccessRateHolder _getRates(String preset, BuildContext context) {
  return switch (preset) {
    'With Logos' => _withLogos(context, false),
    'Interactive Rows' => _withLogos(context, true),
    'Slow Network (2s)' => Future.delayed(2.seconds, () => _banks),
    'Fails To Load' => Future<List<GtSuccessRateData>>.delayed(
      1.seconds,
    ).then((_) => throw Exception('Could not reach the rates service')),
    'Empty' => const <GtSuccessRateData>[],
    _ => _banks,
  };
}

class _SuccessRateKnobs {
  final String title;
  final String description;
  final String searchHint;
  final String preset;
  final bool showSearch;
  final bool autoFocusSearch;
  final bool showRefresh;
  final bool showDescription;

  const _SuccessRateKnobs({
    required this.title,
    required this.description,
    required this.searchHint,
    required this.preset,
    required this.showSearch,
    required this.autoFocusSearch,
    required this.showRefresh,
    required this.showDescription,
  });

  factory _SuccessRateKnobs.of(BuildContext context) {
    return _SuccessRateKnobs(
      title: context.knobs.string(
        label: 'Title',
        initialValue: 'Transfer Success Rate',
      ),
      showDescription: context.knobs.boolean(
        label: 'Show Description',
        initialValue: true,
      ),
      description: context.knobs.string(
        label: 'Description',
        initialValue: _description,
      ),
      searchHint: context.knobs.string(
        label: 'Search Hint',
        initialValue: 'Search bank name',
      ),
      preset: context.knobs.object.dropdown<String>(
        label: 'Data Preset',
        options: [
          'Standard',
          'With Logos',
          'Interactive Rows',
          'Slow Network (2s)',
          'Fails To Load',
          'Empty',
        ],
        initialOption: 'Standard',
      ),
      showSearch: context.knobs.boolean(
        label: 'Show Search',
        initialValue: true,
      ),
      autoFocusSearch: context.knobs.boolean(
        label: 'Autofocus Search',
        initialValue: false,
      ),
      showRefresh: context.knobs.boolean(
        label: 'Show Refresh Action',
        initialValue: true,
      ),
    );
  }

  GtSuccessRateBody buildBody(
    BuildContext context,
    SuccessRateHolder rates, [
    ScrollController? controller,
  ]) {
    return GtSuccessRateBody(
      controller: controller,
      rates: rates,
      description: showDescription ? description : null,
      searchHint: searchHint,
      showSearch: showSearch,
      autoFocusSearch: autoFocusSearch,
      emptyWidget: Padding(
        padding: context.insets.defaultHorizontalInsets,
        child: const GtEmptyStateCard(
          icon: GtIcons.magnifier,
          description: "No banks match that name.",
        ),
      ),
      errorWidget: Padding(
        padding: context.insets.defaultHorizontalInsets,
        child: const GtEmptyStateCard(
          icon: GtIcons.alert,
          description: "Could not load rates. Hit refresh to try again.",
        ),
      ),
    );
  }
}

class _SuccessRateModalPreview extends StatefulWidget {
  const _SuccessRateModalPreview();

  @override
  State<_SuccessRateModalPreview> createState() =>
      _SuccessRateModalPreviewState();
}

class _SuccessRateModalPreviewState extends State<_SuccessRateModalPreview>
    with GtBottomSheetMixin {
  /// The holder currently driving the sheet. Publishing a new holder is what
  /// makes [GtSuccessRateBody] reload, so refresh is a notifier assignment
  /// rather than a state callback.
  ///
  /// One long-lived notifier, seeded on open, so the sheet never listens to an
  /// instance this state has already disposed.
  final ratesNotifier = ValueNotifier<SuccessRateHolder>(
    const <GtSuccessRateData>[],
  );

  @override
  void dispose() {
    ratesNotifier.dispose();
    super.dispose();
  }

  void _openModal(BuildContext context, _SuccessRateKnobs knobs) {
    ratesNotifier.value = _getRates(knobs.preset, context);

    showDraggableSheet(
      context,
      initialChildSize: .9,
      maxChildSize: 1,
      minChildSize: .5,
      builder: (controller) {
        return GenericListener<SuccessRateHolder>(
          valueListenable: ratesNotifier,
          builder: (rates) {
            return GtSuccessRateModal(
              title: knobs.title,
              onRefresh: knobs.showRefresh
                  ? () {
                      GtToast.of(context).show("Refreshing rates");
                      ratesNotifier.value = _getRates(knobs.preset, context);
                    }
                  : null,
              body: knobs.buildBody(context, rates, controller),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final knobs = _SuccessRateKnobs.of(context);

    return GtWidgetDocPage(
      title: 'GtSuccessRateModal',
      description:
          'Sheet chrome for GtSuccessRateBody: a refresh action on the left, a '
          'centred title, and the modal app bar\'s built-in cancel button on '
          'the right. Refresh publishes a fresh holder through a notifier, '
          'which is what makes the body reload.',
      code:
          '''
final ratesNotifier = ValueNotifier<SuccessRateHolder>(
  api.fetchSuccessRates(),
);

showDraggableSheet(
  context,
  builder: (controller) {
    return GenericListener<SuccessRateHolder>(
      valueListenable: ratesNotifier,
      builder: (rates) => GtSuccessRateModal(
        title: "${knobs.title}",
        onRefresh: () => ratesNotifier.value = api.fetchSuccessRates(),
        body: GtSuccessRateBody(
          controller: controller,
          rates: rates,
          description: "${knobs.description}",
          searchHint: "${knobs.searchHint}",
        ),
      ),
    );
  },
);''',
      child: GtRaisedButton(
        text: 'Present Success Rate Modal',
        onPressed: () => _openModal(context, knobs),
      ),
    );
  }
}

class _SuccessRateBodyInlinePreview extends StatefulWidget {
  const _SuccessRateBodyInlinePreview();

  @override
  State<_SuccessRateBodyInlinePreview> createState() =>
      _SuccessRateBodyInlinePreviewState();
}

class _SuccessRateBodyInlinePreviewState
    extends State<_SuccessRateBodyInlinePreview> {
  SuccessRateHolder? _rates;
  String? _preset;

  @override
  Widget build(BuildContext context) {
    final knobs = _SuccessRateKnobs.of(context);

    // Rebuild the holder only when the preset knob changes, so unrelated knob
    // edits do not re-trigger the loading state.
    if (_preset != knobs.preset || _rates == null) {
      _preset = knobs.preset;
      _rates = _getRates(knobs.preset, context);
    }

    return GtWidgetDocPage(
      title: 'GtSuccessRateBody',
      description:
          'Organism widget presenting a searchable list of institutions and '
          'their transfer success rates. Filtering is debounced and delegated '
          'to GtSuccessRateData.filter; builder and listBuilder hand control of '
          'row and list presentation back to the caller.',
      code:
          '''
GtSuccessRateBody(
  rates: [
    GtSuccessRateData(name: "Sterling Bank", rate: 1),
    GtSuccessRateData(name: "Opay", rate: .99),
    GtSuccessRateData(
      name: "Kuda MFB",
      rate: .98,
      filterDelegate: (query) =>
          "Kuda MFB".includes(query) || "Kuda Bank".includes(query),
    ),
  ],
  description: "${knobs.description}",
  searchHint: "${knobs.searchHint}",
  showSearch: ${knobs.showSearch},
)''',
      child: GtSizedBox(height: 650, child: knobs.buildBody(context, _rates!)),
    );
  }
}
