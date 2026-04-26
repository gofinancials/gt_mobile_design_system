import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtWelcomeSlides extends GtStatefulWidget {
  final List<GtSlideData> slides;
  final bool showLogo;
  final Color? iconColor;
  final Color? activeDotColor;
  final Color? inActiveDotColor;

  const GtWelcomeSlides({
    super.key,
    required this.slides,
    this.showLogo = true,
    this.iconColor,
    this.activeDotColor,
    this.inActiveDotColor,
  });

  @override
  State<StatefulWidget> createState() => _GtWelcomeSlidesState();
}

class _GtWelcomeSlidesState extends State<GtWelcomeSlides> {
  late final ValueNotifier<int> _activeSlide;
  late final PageController _controller;
  late final AppDebouncer _debouncer;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _activeSlide = ValueNotifier(0);
    _debouncer = AppDebouncer(2.seconds);
    _goToNextSlide(_controller.initialPage);
  }

  void _updateSlide(int index) {
    if (_debouncer.isActive) _debouncer.abort();
    _activeSlide.value = index;
    _goToNextSlide(index);
  }

  void _goToNextSlide(int index) {
    int next = index + 1;
    if (next == widget.slides.length) next = 0;

    _debouncer.run(() {
      if (!_controller.hasClients) {
        _activeSlide.value = next;
        return;
      }

      if (next == 0) {
        _controller.jumpToPage(next);
        return;
      }

      _controller.animateToPage(
        next,
        duration: 500.milliseconds,
        curve: Curves.easeIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final activeColor = widget.activeDotColor ?? palette.staticColors.white;
    final inActiveColor = widget.inActiveDotColor ?? palette.staticColors.black;
    Widget leading = const Offstage();

    if (widget.showLogo) leading = GtSvg(GtVectors.sterling);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: GtActionAppBar(
        leading: leading,
        trailing: GtOptionalWidgetPair(
          tail: GtCancelButton(
            color: widget.iconColor ?? context.palette.staticColors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: PageView.builder(
              itemCount: widget.slides.length,
              controller: _controller,
              onPageChanged: _updateSlide,
              itemBuilder: (_, index) {
                final slide = widget.slides[index];
                return GtWelcomeSlide(slide: slide);
              },
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: context.spacingsection2xl,
            child: SafeArea(
              child: Align(
                alignment: .bottomCenter,
                child: NumberListener(
                  valueListenable: _activeSlide,
                  builder: (page) {
                    return GtDots(
                      page,
                      length: widget.slides.length,
                      activeColor: activeColor,
                      inActiveColor: inActiveColor,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
