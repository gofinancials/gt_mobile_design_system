import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A stateful widget that displays a carousel of onboarding slides.
///
/// This widget uses a [PageView] to display a list of [GtOnboardingSlideData] objects.
/// It advances on its own, with a progress line beneath the status bar filling
/// while each slide is shown, and can be swiped by hand. Holding a finger on
/// the screen, or covering it with another route, pauses the progress. Below
/// the slide's title sit primary and secondary action buttons with a
/// customizable rich text footer.
class GtOnboardingSlides extends GtStatefulWidget {
  /// The list of data for each slide to be displayed.
  final List<GtOnboardingSlideData> slides;

  /// How long each slide is shown before the carousel advances, which is also
  /// how long the progress line takes to fill.
  ///
  /// Defaults to 5 seconds.
  final Duration slideDuration;

  /// The fill of the progress line, which grows while a slide is shown.
  ///
  /// If null, the fill is white.
  final Color? activeProgressColor;

  /// The track the progress line's fill grows along.
  ///
  /// If null, it defaults to [GtColors.neutralGray400].
  final Color? inActiveProgressColor;

  /// The text displayed in the footer area, which can contain HTML-like link tags.
  final String footerText;

  /// The primary action button displayed at the bottom.
  final GtRaisedButton primaryButton;

  /// The secondary action button displayed at the bottom.
  final GtOutlineButton secondaryButton;

  /// The background color of the onboarding screen.
  ///
  /// If null, it defaults to `context.palette.bg.strong`.
  final Color? backgroundColor;

  /// The gradient overlay applied behind the bottom section.
  ///
  /// If null, it defaults to `context.gradients.onboardingSlideGradient()`.
  final LinearGradient? footerGradient;

  /// Optional color for the footer text.
  ///
  /// If null, it defaults to [GtColors.tertiaryText].
  final Color? footerTextColor;

  /// Optional color for links within the footer text.
  ///
  /// If null, it defaults to [GtColors.neutral50].
  final Color? footerLinkColor;

  /// Creates a [GtOnboardingSlides] widget.
  const GtOnboardingSlides({
    super.key,
    required this.slides,
    this.slideDuration = const Duration(seconds: 5),
    this.activeProgressColor,
    this.inActiveProgressColor,
    this.backgroundColor,
    this.footerGradient,
    required this.footerText,
    required this.primaryButton,
    required this.secondaryButton,
    this.footerTextColor,
    this.footerLinkColor,
  }) : assert(slides.length > 0);

  @override
  State<StatefulWidget> createState() => _GtOnboardingSlidesState();
}

/// The state for [GtOnboardingSlides].
///
/// Manages the [PageController], the active slide index, and the automatic
/// slide transitions.
///
/// The gradient and the slide's title sit above the page view but ignore
/// pointers, so a swipe that starts on them still reaches it; only the buttons
/// and the footer's links take touches of their own.
class _GtOnboardingSlidesState extends State<GtOnboardingSlides>
    with SingleTickerProviderStateMixin {
  /// How far, in pages, the carousel may wander from [_basePage] before the
  /// next auto-advance brings it back.
  ///
  /// The page view loops by counting pages without end, and the scroll offset
  /// grows with the count. Past roughly 260,000 pixels a double can no longer
  /// place a page edge within the layout tolerance, and the sliver beneath the
  /// page view asserts in debug builds. Fifty pages either side keeps even a
  /// tablet-wide page well inside that.
  static const int _pageSpan = 50;

  /// Notifier for the currently active slide index.
  late final ValueNotifier<int> _activeSlide;

  /// Controller for the [PageView] that manages the slides.
  late final PageController _controller;

  /// How long the current slide has been shown, as a fraction of the time
  /// before the carousel advances. Drives the progress line, and advances the
  /// carousel when it completes.
  late final AnimationController _progress;

  /// The pointers currently down on the carousel. The progress holds while
  /// there are any, so a slide never moves out from under a reader's finger.
  final Set<int> _pointers = {};

  /// Whether the carousel's route is on screen. A route pushed over it mutes
  /// its tickers, and the progress holds until it is uncovered.
  bool _isVisible = true;

  /// The page the carousel starts on and is brought back to: the first slide
  /// of a whole cycle at least [_pageSpan] pages in, so it can be swiped
  /// backwards as well as forwards.
  int get _basePage {
    final length = widget.slides.length;
    return (_pageSpan / length).ceil() * length;
  }

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: _basePage);
    _activeSlide = ValueNotifier(0);
    _progress = AnimationController(vsync: this, duration: widget.slideDuration)
      ..addStatusListener((status) {
        if (status.isCompleted) _goToNextSlide();
      });
  }

  @override
  void didUpdateWidget(covariant GtOnboardingSlides oldWidget) {
    super.didUpdateWidget(oldWidget);
    _progress.duration = widget.slideDuration;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isVisible = TickerMode.valuesOf(context).enabled;
    _syncProgress();
  }

  @override
  void dispose() {
    _progress.dispose();
    _controller.dispose();
    _activeSlide.dispose();
    super.dispose();
  }

  /// Runs the progress while the carousel can advance, and holds it while a
  /// finger is down or the route is covered.
  ///
  /// A progress already full — an advance a touch interrupted before the next
  /// slide was reached — starts the current slide's time again.
  void _syncProgress() {
    final canRun = widget.slides.length > 1 && _isVisible && _pointers.isEmpty;
    if (!canRun) {
      _progress.stop();
      return;
    }
    if (_progress.isCompleted) _progress.value = 0;
    if (!_progress.isAnimating) _progress.forward();
  }

  /// Holds the progress for as long as [event]'s pointer stays down.
  void _onPointerDown(PointerDownEvent event) {
    _pointers.add(event.pointer);
    _syncProgress();
  }

  /// Releases the hold [event]'s pointer placed, once it lifts or is
  /// cancelled.
  void _onPointerUp(PointerEvent event) {
    _pointers.remove(event.pointer);
    _syncProgress();
  }

  /// Records the slide now showing, whether swiped to or advanced to, and
  /// starts its time from empty.
  void _updateSlide(int index) {
    _activeSlide.value = index % widget.slides.length;
    _progress.value = 0;
    _syncProgress();
  }

  /// Moves to the next slide once the current one's time is up.
  ///
  /// The page view uses virtual pages, so the last-to-first transition remains
  /// a normal forward animation instead of an abrupt jump.
  void _goToNextSlide() {
    if (!_controller.hasClients) return;
    final currentPage = _recentre();
    if (context.reduceMotion) {
      _controller.jumpToPage(currentPage + 1);
      return;
    }
    _controller.animateToPage(
      currentPage + 1,
      duration: GtMotion.slow,
      curve: Curves.easeInOutCubic,
    );
  }

  /// Returns the page to advance from, first jumping back near [_basePage]
  /// when the carousel has wandered more than [_pageSpan] pages from it.
  ///
  /// The jump lands on the same slide, so nothing on screen moves; only the
  /// count is reset. It runs as the auto-advance fires, after the slide has
  /// been shown untouched for its whole time, and a page left between two
  /// slides is not moved.
  int _recentre() {
    final page = _controller.page ?? _controller.initialPage.toDouble();
    final currentPage = page.round();
    final isSettled = (page - currentPage).abs() < 0.01;
    if (!isSettled || (currentPage - _basePage).abs() <= _pageSpan) {
      return currentPage;
    }

    final recentred = _basePage + currentPage % widget.slides.length;
    _controller.jumpToPage(recentred);
    return recentred;
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final defaultGradient = context.gradients.onboardingSlideGradient();
    final backgroundColor = widget.backgroundColor ?? palette.bg.strong;
    final isWideLayout = !context.isMobile;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: backgroundColor,
      body: Listener(
        onPointerDown: _onPointerDown,
        onPointerUp: _onPointerUp,
        onPointerCancel: _onPointerUp,
        child: Stack(
          children: [
            Positioned.fill(
              child: PageView.builder(
                controller: _controller,
                physics: widget.slides.length < 2
                    ? const NeverScrollableScrollPhysics()
                    : null,
                allowImplicitScrolling: true,
                onPageChanged: _updateSlide,
                itemBuilder: (_, index) => _GtOnboardingBackgroundSlide(
                  image: widget.slides[index % widget.slides.length].image,
                  showBlurredBackground: isWideLayout,
                ),
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: widget.footerGradient ?? defaultGradient,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: NumberListener(
                valueListenable: _activeSlide,
                builder: (index) {
                  final activeIndex = index ?? 0;
                  final slide = widget.slides[activeIndex];
                  final textColor =
                      slide.textColor ?? palette.staticColors.white;

                  return Column(
                    mainAxisAlignment: .end,
                    mainAxisSize: .min,
                    children: [
                      IgnorePointer(
                        child: _GtOnboardingContentTransition(
                          duration: GtMotion.adaptiveDuration(
                            context,
                            GtMotion.fluid,
                          ),
                          curve: Curves.easeInOutCubic,
                          child: Column(
                            key: ValueKey(activeIndex),
                            mainAxisSize: .min,
                            children: [
                              if (slide.contentImage != null) ...[
                                GtImage(
                                  image: slide.contentImage,
                                  width: slide.contentImageWidth,
                                  alignment: .center,
                                  useDefaultSize: false,
                                  isDecorative: true,
                                ),
                                ?slide.contentImageSpacer,
                              ],
                              Padding(
                                padding: context.insets.defaultHorizontalInsets,
                                child: GtText(
                                  slide.title.upper,
                                  style: context.textStyles.h3(
                                    color: textColor,
                                    heightPx: 40,
                                  ),
                                  textAlign: slide.titleTextAlign,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const GtGap.ySectionMd(),
                      SafeArea(
                        top: false,
                        child: GtButtonBottomNavBar(
                          heading: widget.primaryButton,
                          button: widget.secondaryButton,
                          spacing: context.spacingMd,
                          footer: Padding(
                            padding: context.insets.onlyDp(top: 2.px),
                            child: GtRichText(
                              widget.footerText,
                              linkColor:
                                  widget.footerLinkColor ??
                                  GtColors.neutral50.value,
                              style: context.textStyles.subHead3xs(
                                color:
                                    widget.footerTextColor ??
                                    GtColors.tertiaryText.value,
                              ),
                              textAlign: .center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            if (widget.slides.length > 1)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _GtOnboardingProgress(
                  progress: _progress,
                  color:
                      widget.activeProgressColor ?? palette.staticColors.white,
                  trackColor:
                      widget.inActiveProgressColor ??
                      GtColors.neutralGray400.value,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// The line beneath the status bar that fills while a slide is shown.
///
/// It only marks time, so it is left out of the semantics tree; the slide's
/// title is what a screen reader announces.
class _GtOnboardingProgress extends GtStatelessWidget {
  /// How far through the current slide's time the carousel is, from 0 to 1.
  final Animation<double> progress;

  /// The fill of the line.
  final Color color;

  /// The track the fill grows along.
  final Color trackColor;

  /// Creates a [_GtOnboardingProgress].
  const _GtOnboardingProgress({
    required this.progress,
    required this.color,
    required this.trackColor,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ExcludeSemantics(
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: context.insets.fromLTRBDp(16.px, 14.px, 16.px, 0),
            child: AnimatedBuilder(
              animation: progress,
              builder: (context, _) => GtProgress(
                value: progress.value,
                color: color,
                inactiveColor: trackColor,
                size: context.dp(2.px),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A private widget that draws one slide's background image.
///
/// On wide layouts the contained image sits over a blurred, full-bleed copy of
/// itself, so the sides of the screen are not left empty.
class _GtOnboardingBackgroundSlide extends GtStatelessWidget {
  /// The slide's background image.
  final ImageProvider image;

  /// Whether to fill the screen behind the image with a blurred copy of it.
  final bool showBlurredBackground;

  /// Creates a [_GtOnboardingBackgroundSlide].
  const _GtOnboardingBackgroundSlide({
    required this.image,
    required this.showBlurredBackground,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: image,
          fit: .contain,
          alignment: .topCenter,
        ),
      ),
    );

    if (!showBlurredBackground) {
      return RepaintBoundary(child: foreground);
    }

    // Blur only the full-bleed copy. A BackdropFilter also samples the
    // foreground and adjacent PageView pages while they overlap, which makes
    // the contained image flash out of focus during an index change.
    return RepaintBoundary(
      child: Stack(
        fit: .expand,
        children: [
          ClipRect(
            child: ImageFiltered(
              imageFilter: context.backdropFilters.imageBackdrop(),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: image,
                    fit: .cover,
                    alignment: .topCenter,
                  ),
                ),
              ),
            ),
          ),
          foreground,
        ],
      ),
    );
  }
}

/// A private widget that fades between slides' titles and content images.
///
/// It fades through rather than across: the outgoing content is gone by the
/// halfway point and the incoming content only appears after it, so two titles
/// are never drawn over each other. Both are anchored to the bottom by
/// [_GtBottomAnchoredCrossFadeLayout], while the height between them animates.
class _GtOnboardingContentTransition extends GtStatefulWidget {
  /// The content to show, keyed by its slide so a change of slide is told
  /// apart from a rebuild of the same one.
  final Widget child;

  /// How long a change of slide takes.
  final Duration duration;

  /// The easing applied to the fades and the change in height.
  final Curve curve;

  /// Creates a [_GtOnboardingContentTransition].
  const _GtOnboardingContentTransition({
    required this.child,
    required this.duration,
    required this.curve,
  });

  @override
  State<_GtOnboardingContentTransition> createState() =>
      _GtOnboardingContentTransitionState();
}

/// The state for [_GtOnboardingContentTransition].
///
/// Alternates the incoming content between the cross-fade's two slots, so
/// each change of slide fades from whatever is showing.
class _GtOnboardingContentTransitionState
    extends State<_GtOnboardingContentTransition> {
  /// The content in the cross-fade's first slot.
  late Widget _firstChild;

  /// The content in the cross-fade's second slot.
  Widget _secondChild = const SizedBox.shrink();

  /// Whether the first slot is the one showing.
  bool _showFirst = true;

  @override
  void initState() {
    super.initState();
    _firstChild = widget.child;
  }

  @override
  void didUpdateWidget(covariant _GtOnboardingContentTransition oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.child.key == widget.child.key) {
      if (_showFirst) {
        _firstChild = widget.child;
      } else {
        _secondChild = widget.child;
      }
      return;
    }

    if (_showFirst) {
      _secondChild = widget.child;
    } else {
      _firstChild = widget.child;
    }
    _showFirst = !_showFirst;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: widget.duration,
      reverseDuration: widget.duration,
      firstCurve: Interval(0, 0.5, curve: widget.curve),
      secondCurve: Interval(0.5, 1, curve: widget.curve),
      sizeCurve: widget.curve,
      alignment: Alignment.bottomCenter,
      layoutBuilder: _GtBottomAnchoredCrossFadeLayout.new,
      crossFadeState: _showFirst ? .showFirst : .showSecond,
      firstChild: _firstChild,
      secondChild: _secondChild,
    );
  }
}

/// A private widget that lays out an [AnimatedCrossFade]'s two children with
/// both anchored to the bottom.
///
/// The cross-fade's default layout pins the outgoing child to the top. The
/// design anchors every title the same distance above the buttons, so when the
/// next slide is taller — one with an image above its title — the outgoing
/// title would ride up the screen with the growing box's top edge. Anchored
/// here, it stays put while it fades.
///
/// Its constructor matches [AnimatedCrossFadeBuilder], so it is handed to the
/// cross-fade as a tear-off.
class _GtBottomAnchoredCrossFadeLayout extends GtStatelessWidget {
  /// The child fading in, which sizes the layout.
  final Widget topChild;

  /// The key the cross-fade gives [topChild]'s slot.
  final Key topChildKey;

  /// The child fading out.
  final Widget bottomChild;

  /// The key the cross-fade gives [bottomChild]'s slot.
  final Key bottomChildKey;

  /// Creates a [_GtBottomAnchoredCrossFadeLayout].
  const _GtBottomAnchoredCrossFadeLayout(
    this.topChild,
    this.topChildKey,
    this.bottomChild,
    this.bottomChildKey,
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: .none,
      alignment: .bottomCenter,
      children: [
        Positioned(
          key: bottomChildKey,
          left: 0,
          right: 0,
          bottom: 0,
          child: bottomChild,
        ),
        Positioned(key: topChildKey, child: topChild),
      ],
    );
  }
}
