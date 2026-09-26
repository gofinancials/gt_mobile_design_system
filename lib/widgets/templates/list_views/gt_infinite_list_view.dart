import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// How close to the end of the scroll extent the viewport has to come, in
/// logical pixels, before the next page is requested.
const kGtScrollEndThreshold = 100.0;

/// Asks for the next page as the end of a [ScrollPosition] comes into reach.
///
/// Both [GtInfiniteListView] and [GtInfiniteListSliver] drive one of these; the
/// difference between them is only where the position comes from and where the
/// loading footer goes, so each host feeds [onScroll] from whatever it can
/// listen to.
class _GtPaginationObserver {
  /// Requests the next page, and is handed a callback that nudges the scroll
  /// position once the page has settled.
  final OnChangedAsync<OnPressed> onScrollEnd;

  /// Resolves how close to the end of the extent to come before requesting.
  ///
  /// Read through a callback, like the other three, so a host that changes it
  /// in a rebuild is not ignored.
  final double Function() threshold;

  /// Reports whether another page can be requested at all.
  final bool Function() canRequest;

  /// Resolves the context the nudge measures its distance against, or null once
  /// the host is gone.
  final BuildContext? Function() hostContext;

  /// Resolves the position to act on, or null before the host has been laid out.
  final ScrollPosition? Function() positionOf;

  /// The last offset seen, which tells a downward scroll from an upward one.
  ///
  /// It starts at the top rather than at the position's current offset, so a
  /// host that opens already scrolled down still reads as scrolling down on its
  /// first tick and can ask for a page.
  double _lastOffset = 0;

  /// Whether a page request is still in flight.
  ///
  /// The consumer's `isLoading` only gates once it has been flipped, which is at
  /// best a frame away; without this a second scroll tick asks for the same page
  /// again.
  bool _requesting = false;

  /// Creates a [_GtPaginationObserver].
  _GtPaginationObserver({
    required this.onScrollEnd,
    required this.threshold,
    required this.canRequest,
    required this.hostContext,
    required this.positionOf,
  });

  /// Forgets the offset being tracked, so a host that moves to another scroll
  /// view starts measuring afresh.
  void reset() => _lastOffset = 0;

  /// Requests the next page when [position] nears the end of its extent on a
  /// downward scroll.
  Future<void> onScroll(ScrollPosition position) async {
    if (!position.hasPixels) return;
    if (_requesting || !canRequest()) return;

    final offset = position.pixels;
    final isScrollingDown = offset > _lastOffset;
    _lastOffset = offset;

    if (!isScrollingDown) return;
    if (position.maxScrollExtent - offset > threshold()) return;

    await _request();
  }

  /// Requests a page for content that does not fill the viewport, once the
  /// frame that laid it out is done.
  ///
  /// A collection shorter than the viewport has no extent to scroll through, so
  /// the scroll-driven trigger never fires and pagination stalls on the first
  /// page. The host calls this when its content has grown, and the check costs
  /// one post-frame closure reading an extent the frame already computed.
  void fillViewport() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final position = positionOf();
      if (position == null || !position.hasPixels) return;
      if (_requesting || !canRequest()) return;
      if (position.maxScrollExtent > 0) return;
      _request();
    });
  }

  /// Asks for the next page, holding off any other request until it settles.
  Future<void> _request() async {
    _requesting = true;
    try {
      await onScrollEnd(_nudge);
    } finally {
      _requesting = false;
    }
  }

  /// Slides the new page partly into view once it has been laid out and the
  /// scroll view has come to rest.
  void _nudge() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final position = positionOf();
      final context = hostContext();
      if (position == null || context == null) return;
      if (position.isScrollingNotifier.value) return;
      position.animateTo(
        position.pixels + context.fractionalHeight(5),
        duration: 500.milliseconds,
        curve: Curves.decelerate,
      );
    });
  }
}

/// Wraps a scroll view in pull-to-refresh and automatic pagination.
///
/// The [child] is the scroll view itself — this widget supplies the refresh
/// indicator around it, watches [controller] to request the next page as its
/// end comes into reach, and shows a loading footer below it while a page is in
/// flight. Nothing about the rows is this widget's business, so the child is
/// free to be any lazy scroll view; pair it with a [GtCardListView] for a
/// grouped card list.
///
/// A page too short to fill the viewport leaves nothing to scroll through, so
/// this widget asks for the next one straight away rather than stalling on the
/// first page.
///
/// Inside a [CustomScrollView], reach for [GtInfiniteListSliver] instead: it
/// observes the host scroll view's own position, needs no controller, and puts
/// its footer inside the scroll view rather than below it.
class GtInfiniteListView<T> extends GtStatefulWidget {
  /// The page state driving the footer and deciding whether to request more.
  ///
  /// Typed at [PaginatedData]'s own floor rather than at [T], so any
  /// `PaginatedData<Row>` is accepted without [T] having to satisfy that floor.
  /// Nothing here reads the rows — this widget wraps a scroll view it does not
  /// build — so [T] stays the caller's to name.
  final PaginatedData<Identifiable> data;

  /// Requests the next page.
  ///
  /// Called with a callback that nudges the scroll position once the page has
  /// settled; invoke it after the new page has been appended. The returned
  /// future is awaited, and no further page is requested until it completes.
  final OnChangedAsync<OnPressed> onScrollEnd;

  /// Reloads the collection from the top, driven by the refresh indicator.
  final OnPressedAsync onRefresh;

  /// Padding around the scroll view, inside the refresh indicator.
  final EdgeInsetsGeometry? padding;

  /// The scroll view to paginate.
  final Widget child;

  /// The controller of [child], which this widget observes to paginate.
  final ScrollController controller;

  /// Where the refresh indicator settles, for a child sitting under a header.
  final double indicatorOffset;

  /// How close to the end of the extent to come before requesting a page.
  final double threshold;

  /// Replaces the footer shown while a page is in flight.
  final Widget? loader;

  /// Creates a [GtInfiniteListView].
  const GtInfiniteListView({
    required this.data,
    required this.onScrollEnd,
    required this.onRefresh,
    required this.child,
    required this.controller,
    this.indicatorOffset = 0,
    this.padding,
    this.threshold = kGtScrollEndThreshold,
    this.loader,
    super.key,
  });

  @override
  State<GtInfiniteListView<T>> createState() => _GtInfiniteListViewState<T>();
}

class _GtInfiniteListViewState<T> extends State<GtInfiniteListView<T>> {
  /// The observer requesting pages off the controller's position.
  late final _GtPaginationObserver _observer = _GtPaginationObserver(
    onScrollEnd: (nudge) => widget.onScrollEnd(nudge),
    threshold: () => widget.threshold,
    canRequest: () => !data.isLoading && data.hasNext,
    hostContext: () => mounted ? context : null,
    positionOf: () => controller.hasClients ? controller.position : null,
  );

  PaginatedData<Identifiable> get data => widget.data;
  EdgeInsetsGeometry? get padding => widget.padding;
  ScrollController get controller => widget.controller;
  double get indicatorOffset => widget.indicatorOffset;

  @override
  void initState() {
    super.initState();
    controller.addListener(_observe);
    _observer.fillViewport();
  }

  @override
  void didUpdateWidget(GtInfiniteListView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != controller) {
      oldWidget.controller.removeListener(_observe);
      _observer.reset();
      controller.addListener(_observe);
    }
    if (data.data.length > oldWidget.data.data.length) {
      // Only a grown collection re-checks, so a page that came back empty
      // cannot be asked for again frame after frame.
      _observer.fillViewport();
    }
  }

  /// Hands the controller's position to the observer on every scroll tick.
  ///
  /// The controller forwards its position's notifications, so this sees the
  /// scroll itself rather than only the position being attached.
  void _observe() {
    if (!controller.hasClients) return;
    _observer.onScroll(controller.position);
  }

  @override
  void dispose() {
    controller.removeListener(_observe);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showLoader = data.isLoading && data.hasData;
    Widget body = RefreshIndicator.adaptive(
      onRefresh: widget.onRefresh,
      edgeOffset: indicatorOffset,
      child: widget.child,
    );

    if (padding != null) {
      body = Padding(padding: padding!, child: body);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: body),
        if (showLoader)
          widget.loader ?? const GtProgress()
        else
          GtSizedBox(height: 6),
      ],
    );
  }
}

/// The sliver form of [GtInfiniteListView]: paginates the scroll view it is
/// placed in, and appends its loading footer to it.
///
/// It observes the enclosing [Scrollable]'s own position, so it needs no
/// controller and composes with whatever else the host holds — a header sliver,
/// a [GtCardListSliver] of rows, another list below it. The footer is a sliver
/// too, so it scrolls in at the end of the content rather than sitting pinned
/// below the viewport as the box form's does.
///
/// Like the box form, it asks for another page straight away when the content
/// does not fill the viewport.
///
/// Pull-to-refresh is not part of this widget: [RefreshIndicator] is a box
/// widget, so the host wraps its [CustomScrollView] in one.
class GtInfiniteListSliver<T> extends GtStatefulWidget {
  /// The page state driving the footer and deciding whether to request more.
  ///
  /// Typed at [PaginatedData]'s own floor rather than at [T], so any
  /// `PaginatedData<Row>` is accepted without [T] having to satisfy that floor.
  /// Nothing here reads the rows — this widget wraps a scroll view it does not
  /// build — so [T] stays the caller's to name.
  final PaginatedData<Identifiable> data;

  /// Requests the next page.
  ///
  /// Called with a callback that nudges the scroll position once the page has
  /// settled; invoke it after the new page has been appended. The returned
  /// future is awaited, and no further page is requested until it completes.
  final OnChangedAsync<OnPressed> onScrollEnd;

  /// The sliver whose content is paginated, typically the list of rows.
  final Widget child;

  /// How close to the end of the extent to come before requesting a page.
  final double threshold;

  /// Replaces the footer shown while a page is in flight.
  final Widget? loader;

  /// Creates a [GtInfiniteListSliver].
  const GtInfiniteListSliver({
    required this.data,
    required this.onScrollEnd,
    required this.child,
    this.threshold = kGtScrollEndThreshold,
    this.loader,
    super.key,
  });

  @override
  State<GtInfiniteListSliver<T>> createState() =>
      _GtInfiniteListSliverState<T>();
}

class _GtInfiniteListSliverState<T> extends State<GtInfiniteListSliver<T>> {
  /// The observer requesting pages off the host scroll view's position.
  late final _GtPaginationObserver _observer = _GtPaginationObserver(
    onScrollEnd: (nudge) => widget.onScrollEnd(nudge),
    threshold: () => widget.threshold,
    canRequest: () => !data.isLoading && data.hasNext,
    hostContext: () => mounted ? context : null,
    positionOf: () => _position,
  );

  /// The host position currently listened to.
  ScrollPosition? _position;

  PaginatedData<Identifiable> get data => widget.data;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Scrollable's scope notifies on a changed position, so a host that swaps
    // its controller — or moves this sliver into another scroll view — lands
    // here and the observer follows it.
    final position = Scrollable.maybeOf(context)?.position;
    if (position == null || position == _position) return;
    _detach();
    _position = position;
    position.addListener(_observe);
    _observer.fillViewport();
  }

  @override
  void didUpdateWidget(GtInfiniteListSliver<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only a grown collection re-checks, so a page that came back empty cannot
    // be asked for again frame after frame.
    if (data.data.length <= oldWidget.data.data.length) return;
    _observer.fillViewport();
  }

  /// Hands the host's position to the observer on every scroll tick.
  void _observe() {
    final position = _position;
    if (position == null) return;
    _observer.onScroll(position);
  }

  /// Stops listening to the host position.
  void _detach() {
    _position?.removeListener(_observe);
    _position = null;
    _observer.reset();
  }

  @override
  void dispose() {
    _detach();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showLoader = data.isLoading && data.hasData;

    return SliverMainAxisGroup(
      slivers: [
        widget.child,
        SliverToBoxAdapter(
          child: showLoader
              ? widget.loader ?? const GtProgress()
              : GtSizedBox(height: 6),
        ),
      ],
    );
  }
}
