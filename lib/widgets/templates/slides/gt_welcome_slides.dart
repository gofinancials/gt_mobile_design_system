import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A stateful widget that displays a carousel of welcome slides.
///
/// This widget uses a [PageView] to display a list of [GtSlideData] objects.
/// It includes automatic slide transitions, page indicators ([GtDots]), and
/// an optional logo and action buttons in an app bar.
class GtWelcomeSlides extends GtStatefulWidget {
  /// The list of data for each slide to be displayed.
  final List<GtSlideData> slides;

  /// Whether to display the Sterling logo in the app bar. Defaults to true.
  final bool showLogo;

  /// The color for the icons in the app bar, such as the cancel button.
  ///
  /// If null, it defaults to `context.palette.staticColors.white`.
  final Color? iconColor;

  /// The color of the dot indicator for the currently active slide.
  ///
  /// If null, it defaults to `context.palette.staticColors.white`.
  final Color? activeDotColor;

  /// The color of the dot indicators for inactive slides.
  ///
  /// If null, it defaults to `context.palette.staticColors.black`.
  final Color? inActiveDotColor;

  /// Creates a [GtWelcomeSlides] widget.
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

/// The state for [GtWelcomeSlides].
///
/// Manages the [PageController], the active slide index, and the automatic
/// slide transitions.
class _GtWelcomeSlidesState extends State<GtWelcomeSlides> {
  /// Notifier for the currently active slide index.
  late final ValueNotifier<int> _activeSlide;

  /// Controller for the [PageView] that manages the slides.
  late final PageController _controller;

  /// Debouncer to manage the automatic transition to the next slide.
  late final AppDebouncer _debouncer;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _activeSlide = ValueNotifier(0);
    _debouncer = AppDebouncer(2.seconds);
    _goToNextSlide(_controller.initialPage);
  }

  @override
  void dispose() {
    _controller.dispose();
    _activeSlide.dispose();
    _debouncer.abort();
    super.dispose();
  }

  /// Updates the active slide index when the user manually swipes.
  ///
  /// This also resets the debouncer for the automatic slide transition.
  void _updateSlide(int index) {
    if (_debouncer.isActive) _debouncer.abort();
    _activeSlide.value = index;
    _goToNextSlide(index);
  }

  /// Schedules an automatic transition to the next slide after a delay.
  ///
  /// If the current slide is the last one, it loops back to the first slide.
  /// The transition is animated, except when jumping from the last to the first
  /// slide.
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
