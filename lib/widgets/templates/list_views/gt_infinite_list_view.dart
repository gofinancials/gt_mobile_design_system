import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtInfiniteListView<T> extends GtStatefulWidget {
  final PaginatedData data;
  final OnChangedAsync<OnPressed> onScrollEnd;
  final OnPressedAsync onRefresh;
  final EdgeInsetsGeometry? padding;
  final Widget child;
  final ScrollController controller;
  final double indicatorOffset;

  const GtInfiniteListView({
    required this.data,
    required this.onScrollEnd,
    required this.onRefresh,
    required this.child,
    required this.controller,
    this.indicatorOffset = 0,
    this.padding,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _GtInfiniteListViewState();
}

class _GtInfiniteListViewState extends State<GtInfiniteListView> {
  double lastPosition = 0;
  PaginatedData get data => widget.data;
  EdgeInsetsGeometry? get padding => widget.padding;
  ScrollController get controller => widget.controller;
  double get indicatorOffset => widget.indicatorOffset;

  @override
  void initState() {
    super.initState();
    controller.addListener(_scrollObserver);
  }

  void _scrollObserver() {
    if (!controller.hasClients) return;
    if (data.isLoading || !data.hasNext) return;

    final offset = controller.position.pixels;
    final maxOffset = controller.position.maxScrollExtent;

    bool isScrollingDown = offset > lastPosition;
    lastPosition = offset;

    if (!isScrollingDown) return;

    double gapToMax = maxOffset - offset;

    if (gapToMax > 100) return;

    widget.onScrollEnd(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!controller.hasClients) return;
        final isScrolling = controller.position.isScrollingNotifier.value;
        if (isScrolling) return;
        final position = controller.position;
        controller.animateTo(
          position.pixels + context.fractionalHeight(5),
          duration: 500.milliseconds,
          curve: Curves.decelerate,
        );
      });
    });
  }

  @override
  void dispose() {
    controller.removeListener(_scrollObserver);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        Visibility(
          visible: data.isLoading && data.hasData,
          maintainSize: true,
          maintainState: true,
          maintainAnimation: true,
          child: const GtProgress(),
        ),
      ],
    );
  }
}
