import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A static list of [GtSuccessRateData] or a future that resolves to one.
typedef SuccessRateHolder = FutureOr<List<GtSuccessRateData>>;

/// A searchable list of institutions and their transfer success rates.
///
/// Presents an optional [description], a debounced search field, and one
/// [GtSuccessRateTile] per entry.
///
/// Rows are built lazily by a `ListView.builder` and stitched into what reads
/// as a single card by [GtCardListTile], whose positional [GtCardListTileType]
/// rounds only the outermost edges. This keeps the grouped look of the design
/// without materialising every institution up front.
///
/// Follows the presentation and filtering contract established by
/// [GtDropDownModal]:
/// - [rates] accepts a synchronous list or a future, with [loadingWidget],
///   [errorWidget] and [emptyWidget] covering the three non-happy states.
/// - Typing filters through [GtSuccessRateData.filter], debounced by
///   [debounceTime], without rebuilding the surrounding chrome.
/// - [builder] overrides how a single row renders; [listBuilder] replaces the
///   list wholesale. The two are mutually exclusive.
///
/// State is held in listenables rather than `setState`: a
/// [FutureListDataNotifier] owns the source data together with its loading and
/// error state, and a separate [ValueNotifier] owns the debounced query. The
/// visible list is derived from the two at build time, so there is no cached
/// filtered copy that can drift out of sync with a reload.
///
/// Passing a new [rates] instance reloads the list, which is how a caller
/// implements pull-to-refresh or a refresh action. Drive that from a
/// [ValueNotifier] holding the current [SuccessRateHolder] rather than from
/// `setState`; a reload keeps the previous rows on screen and preserves the
/// active search query.
///
/// Example usage:
/// ```dart
/// GtSuccessRateBody(
///   description: "See how recipient banks are performing.",
///   rates: [
///     GtSuccessRateData(name: "Sterling Bank", rate: 1),
///     GtSuccessRateData(name: "Opay", rate: .99),
///   ],
/// )
/// ```
///
/// Reloading from a notifier:
/// ```dart
/// final ratesNotifier = ValueNotifier<SuccessRateHolder>(
///   api.fetchSuccessRates(),
/// );
///
/// GenericListener<SuccessRateHolder>(
///   valueListenable: ratesNotifier,
///   builder: (rates) => GtSuccessRateBody(rates: rates),
/// );
///
/// // Later, to refresh:
/// ratesNotifier.value = api.fetchSuccessRates();
/// ```
class GtSuccessRateBody extends GtStatefulWidget {
  /// An optional controller for the underlying scroll view.
  ///
  /// Supply the controller handed to you by a draggable sheet builder so the
  /// content and the sheet scroll as one.
  final ScrollController? controller;

  /// The entries to display, or a future resolving to them.
  ///
  /// Supplying a new instance reloads the list.
  final SuccessRateHolder rates;

  /// Optional supporting copy rendered above the search field.
  final String? description;

  /// Optional hint text for the search field.
  final String? searchHint;

  /// Whether the search field is rendered. Defaults to true.
  final bool showSearch;

  /// Whether the search field takes focus when the list first appears.
  ///
  /// Defaults to false so the list is visible before the keyboard covers it.
  final bool autoFocusSearch;

  /// How long to wait after the last keystroke before filtering.
  ///
  /// Defaults to 300ms.
  final Duration? debounceTime;

  /// Displayed while [rates] resolves. Defaults to a [GtSpinner].
  final Widget? loadingWidget;

  /// Displayed when [rates] fails to resolve.
  final Widget? errorWidget;

  /// Displayed when there are no entries, or none match the search query.
  final Widget? emptyWidget;

  /// Overrides how an individual entry renders.
  final ValueBuilder<GtSuccessRateData>? builder;

  /// Replaces the entire list, receiving the filtered entries and the scroll
  /// controller.
  ///
  /// The default list is already lazy; reach for this only when the grouped
  /// card presentation itself is wrong, such as a sectioned or paginated view.
  final ValueBuilder2<List<GtSuccessRateData>, ScrollController?>? listBuilder;

  /// Creates a [GtSuccessRateBody].
  const GtSuccessRateBody({
    super.key,
    required this.rates,
    this.controller,
    this.description,
    this.searchHint,
    this.showSearch = true,
    this.autoFocusSearch = false,
    this.debounceTime,
    this.loadingWidget,
    this.errorWidget,
    this.emptyWidget,
    this.builder,
    this.listBuilder,
  }) : assert(
         builder == null || listBuilder == null,
         'Cannot provide both builder and listBuilder.',
       );

  @override
  State<GtSuccessRateBody> createState() => _GtSuccessRateBodyState();
}

class _GtSuccessRateBodyState extends State<GtSuccessRateBody> {
  late final AppDebouncer debouncer;

  /// The source data plus its loading/error state.
  late final FutureListDataNotifier<GtSuccessRateData> ratesNotifier;

  /// The debounced search query. Held separately so typing rebuilds only the
  /// list, and so the filtered view is always derived from the source rather
  /// than cached alongside it.
  late final ValueNotifier<String?> queryNotifier;

  @override
  void initState() {
    super.initState();
    debouncer = AppDebouncer(widget.debounceTime ?? 300.milliseconds);
    ratesNotifier = FutureListDataNotifier.pristine();
    queryNotifier = ValueNotifier(null);
    _load();
  }

  @override
  void didUpdateWidget(covariant GtSuccessRateBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (identical(widget.rates, oldWidget.rates)) return;
    _load();
  }

  @override
  void dispose() {
    debouncer.abort();
    queryNotifier.dispose();
    ratesNotifier.dispose();
    super.dispose();
  }

  /// Resolves [GtSuccessRateBody.rates] into [ratesNotifier].
  ///
  /// Errors are captured as a [TaskError] on the notifier rather than rethrown,
  /// so the widget reaches its error state without surfacing an unhandled
  /// async error.
  Future<void> _load() async {
    ratesNotifier.setLoading();

    try {
      final data = await widget.rates;
      if (!mounted) return;
      ratesNotifier.setData(data);
    } catch (e, t) {
      AppLogger.severe("$e", error: e, stackTrace: t);
      if (!mounted) return;
      ratesNotifier.setError(TaskError(message: "$e", error: e));
    }
  }

  void _filterRates(String? query) {
    debouncer.abort();
    debouncer.run(() {
      if (!mounted) return;
      queryNotifier.value = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GenericListener<FutureListData<GtSuccessRateData>>(
      valueListenable: ratesNotifier,
      builder: (state) {
        return Padding(
          padding: context.insets.fromLTRBDp(16.px, 24.px, 16.px, 0.px),
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              if (widget.description case String description) ...[
                GtText(
                  description,
                  key: const Key('success-rate-description'),
                  style: context.textStyles.body2Xs(
                    color: context.palette.text.sub,
                  ),
                ),
                const GtGap.ySectionSm(),
              ],
              if (widget.showSearch && state.hasData) ...[
                GtSearchField(
                  key: const Key('success-rate-search'),
                  onChange: _filterRates,
                  autoFocus: widget.autoFocusSearch,
                  hintText: widget.searchHint ?? "searchBankName".utr(),
                  decoration: context.inputStyles.searchDecoration,
                  prefix: ExcludeSemantics(
                    child: GtIcon.withColor(
                      GtIcons.magnifier,
                      color: context.palette.primary.base,
                    ),
                  ),
                ),
                const GtGap.yLg(),
              ],
              // Nested so that typing rebuilds only the list, leaving the
              // description and the search field itself untouched.
              Expanded(
                child: GenericListener<String?>(
                  valueListenable: queryNotifier,
                  builder: (query) => _SuccessRateContent(
                    state: state,
                    query: query,
                    controller: widget.controller,
                    loadingWidget: widget.loadingWidget,
                    errorWidget: widget.errorWidget,
                    emptyWidget: widget.emptyWidget,
                    builder: widget.builder,
                    listBuilder: widget.listBuilder,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Resolves the load state into the list, or into the matching placeholder.
class _SuccessRateContent extends GtStatelessWidget {
  final FutureListData<GtSuccessRateData> state;
  final String? query;
  final ScrollController? controller;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final Widget? emptyWidget;
  final ValueBuilder<GtSuccessRateData>? builder;
  final ValueBuilder2<List<GtSuccessRateData>, ScrollController?>? listBuilder;

  const _SuccessRateContent({
    required this.state,
    required this.query,
    required this.controller,
    required this.loadingWidget,
    required this.errorWidget,
    required this.emptyWidget,
    required this.builder,
    required this.listBuilder,
  });

  @override
  Widget build(BuildContext context) {
    // Only a first load shows the spinner; a refresh keeps the current rows on
    // screen rather than flashing a placeholder over them.
    if (state.isLoading && !state.hasData) return loadingWidget ?? GtSpinner();

    if (state.hasError && errorWidget != null) return errorWidget!;

    final entries = state.data.whereList((it) => it.filter(query));

    if (!entries.hasValue) return emptyWidget ?? const Offstage();

    if (listBuilder != null) return listBuilder!(entries, controller);

    return _SuccessRateList(entries, controller: controller, builder: builder);
  }
}

/// The default presentation: a lazily built list whose rows are stitched into
/// one continuous card by [GtCardListTile].
class _SuccessRateList extends GtStatelessWidget {
  final List<GtSuccessRateData> entries;
  final ScrollController? controller;
  final ValueBuilder<GtSuccessRateData>? builder;

  const _SuccessRateList(this.entries, {this.controller, this.builder});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      key: const Key('success-rate-list'),
      controller: controller,
      padding: context.insets.onlyDp(bottom: 16.px),
      itemCount: entries.length,
      separatorBuilder: (context, index) {
        return GtCardListTile(type: .divider, child: GtSizedBox(height: 20));
      },
      itemBuilder: (context, index) {
        return GtCardListTile(
          key: Key('success-rate-row-$index'),
          type: GtCardListTileType.fromIndex(
            index: index,
            length: entries.length,
          ),
          horizontalPadding: 12,
          // Padding the tile only pads the card's two outer edges; the gap
          // between adjacent rows comes from the separator above.
          verticalPadding: 12,
          child: _SuccessRateRow(entries[index], builder: builder),
        );
      },
    );
  }
}

/// Renders a single entry, delegating to [builder] when one is supplied and
/// wrapping the row in a [GtInkWell] when the entry is tappable.
class _SuccessRateRow extends GtStatelessWidget {
  final GtSuccessRateData entry;
  final ValueBuilder<GtSuccessRateData>? builder;

  const _SuccessRateRow(this.entry, {this.builder});

  @override
  Widget build(BuildContext context) {
    final logoSize = context.dp(24.px);

    Widget child =
        builder?.call(entry) ??
        GtSuccessRateTile(
          text: entry.name,
          successRate: entry.rate,
          leading: switch (entry.logo) {
            AppImageData logo => GtImage(
              image: logo,
              width: logoSize,
              height: logoSize,
              isDecorative: true,
            ),
            _ => GtAvatar(size: logoSize, initials: entry.name.initials),
          },
        );

    if (entry.onTap != null) {
      child = GtInkWell(
        role: .button,
        onTap: entry.onTap,
        borderRadius: context.borderRadiusSm,
        child: child,
      );
    }

    return child;
  }
}
