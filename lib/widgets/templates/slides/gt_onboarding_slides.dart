import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A stateful widget that displays a carousel of onboarding slides.
///
/// This widget uses a [PageView] to display a list of [GtOnboardingSlideData] objects.
/// It includes automatic slide transitions, page indicators ([GtDots]), and
/// primary and secondary action buttons with a customizable rich text footer.
class GtOnboardingSlides extends GtStatefulWidget {
  /// The list of data for each slide to be displayed.
  final List<GtOnboardingSlideData> slides;

  /// The color of the dot indicator for the currently active slide.
  ///
  /// If null, it defaults to [GtColors.tertiaryText].
  final Color? activeDotColor;

  /// The color of the dot indicators for inactive slides.
  ///
  /// If null, it defaults to [GtColors.whiteAlpha24].
  final Color? inActiveDotColor;

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
  /// If null, it defaults to [activeDotColor] or [GtColors.tertiaryText].
  final Color? footerTextColor;

  /// Optional color for links within the footer text.
  ///
  /// If null, it defaults to [GtColors.neutral50].
  final Color? footerLinkColor;

  /// Creates a [GtOnboardingSlides] widget.
  const GtOnboardingSlides({
    super.key,
    required this.slides,
    this.activeDotColor,
    this.inActiveDotColor,
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
class _GtOnboardingSlidesState extends State<GtOnboardingSlides> {
  static const int _virtualInitialPage = 10000;

  /// Notifier for the currently active slide index.
  late final ValueNotifier<int> _activeSlide;

  /// Controller for the [PageView] that manages the slides.
  late final PageController _controller;

  /// Debouncer to manage the automatic transition to the next slide.
  late final AppDebouncer _debouncer;

  @override
  void initState() {
    super.initState();
    final initialPage =
        _virtualInitialPage - (_virtualInitialPage % widget.slides.length);
    _controller = PageController(initialPage: initialPage);
    _activeSlide = ValueNotifier(0);
    _debouncer = AppDebouncer(3.5.seconds);
    _goToNextSlide();
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
    _activeSlide.value = index % widget.slides.length;
    _goToNextSlide();
  }

  /// Schedules an automatic transition to the next slide after a delay.
  ///
  /// The page view uses virtual pages, so the last-to-first transition remains
  /// a normal forward animation instead of an abrupt jump.
  void _goToNextSlide() {
    if (widget.slides.length < 2) return;
    _debouncer.run(() {
      if (!_controller.hasClients) return;
      final currentPage = _controller.page?.round() ?? _controller.initialPage;
      _controller.animateToPage(
        currentPage + 1,
        duration: GtMotion.fluid,
        curve: GtSpringCurves.gentle,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final activeColor = widget.activeDotColor ?? GtColors.tertiaryText.value;
    final inActiveColor =
        widget.inActiveDotColor ?? GtColors.whiteAlpha24.value;
    final defaultGradient = context.gradients.onboardingSlideGradient();
    final backgroundColor = widget.backgroundColor ?? palette.bg.strong;
    final isWideLayout = !context.isMobile;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: PageView.builder(
              controller: _controller,
              onPageChanged: _updateSlide,
              itemBuilder: (_, index) {
                final slide = widget.slides[index % widget.slides.length];
                final image = DecoratedBox(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: slide.image,
                      fit: .contain,
                      alignment: .topCenter,
                    ),
                  ),
                );

                if (!isWideLayout) return image;

                // On wide layouts the contained image leaves bare space on
                // either side, so a blurred, full-bleed copy fills it in.
                return Stack(
                  fit: .expand,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: slide.image,
                          fit: .cover,
                          alignment: .topCenter,
                        ),
                      ),
                    ),
                    BackdropFilter(
                      filter: context.backdropFilters.imageBackdrop(),
                      child: image,
                    ),
                  ],
                );
              },
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: widget.footerGradient ?? defaultGradient,
              ),
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
                      AnimatedSwitcher(
                        duration: GtMotion.adaptiveDuration(
                          context,
                          GtMotion.fluid,
                        ),
                        switchInCurve: GtSpringCurves.gentle,
                        transitionBuilder: (child, animation) => FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, .08),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        ),
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
                            const GtGap.ySectionSm(),
                            Align(
                              alignment: .bottomCenter,
                              child: GtDots(
                                activeIndex,
                                length: widget.slides.length,
                                activeColor: activeColor,
                                inActiveColor: inActiveColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const GtGap.ySectionSm(),
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
                                color: widget.footerTextColor ?? activeColor,
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
          ),
        ],
      ),
    );
  }
}
