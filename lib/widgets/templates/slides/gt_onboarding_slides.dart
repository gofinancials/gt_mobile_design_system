import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A stateful widget that displays a carousel of onboarding slides.
///
/// This widget uses a [PageView] to display a list of [GtOnboardingSlideData] objects.
/// It includes automatic slide transitions, page indicators ([GtDots]), and
/// an optional logo and action buttons in an app bar.
class GtOnboardingSlides extends GtStatefulWidget {
  /// The list of data for each slide to be displayed.
  final List<GtOnboardingSlideData> slides;

  /// The color of the dot indicator for the currently active slide.
  ///
  /// If null, it defaults to `context.palette.staticColors.white`.
  final Color? activeDotColor;

  /// The color of the dot indicators for inactive slides.
  ///
  /// If null, it defaults to `context.palette.staticColors.black`.
  final Color? inActiveDotColor;

  final String footerText;

  final GtRaisedButton primaryButton;

  final GtOutlineButton secondaryButton;

  /// Creates a [GtWelcomeSlides] widget.
  const GtOnboardingSlides({
    super.key,
    required this.slides,
    this.activeDotColor,
    this.inActiveDotColor,
    required this.footerText,
    required this.primaryButton,
    required this.secondaryButton,
  });

  @override
  State<StatefulWidget> createState() => _GtOnboardingSlidesState();
}

/// The state for [GtOnboardingSlides].
///
/// Manages the [PageController], the active slide index, and the automatic
/// slide transitions.
class _GtOnboardingSlidesState extends State<GtOnboardingSlides> {
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
    final activeColor = widget.activeDotColor ?? GtColors.tertiaryText.value;
    final inActiveColor =
        widget.inActiveDotColor ?? GtColors.whiteAlpha24.value;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: PageView.builder(
              itemCount: widget.slides.length,
              controller: _controller,
              onPageChanged: _updateSlide,
              itemBuilder: (_, index) {
                final slide = widget.slides[index];
                return DecoratedBox(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: slide.image,
                      fit: .contain,
                      alignment: .topCenter,
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: context.gradients.onboardingSlideGradient(),
              ),
              child: ValueListenableBuilder(
                valueListenable: _activeSlide,
                child: SafeArea(
                  top: false,
                  child: GtButtonBottomNavBar(
                    heading: widget.primaryButton,
                    button: widget.secondaryButton,
                    spacing: context.spacingMd,
                    footer: Padding(
                      padding: context.insets.onlyDp(top: 2.px),
                      child: GtRichText(
                        widget.footerText,
                        linkColor: GtColors.neutral50.value,
                        style: context.textStyles.subHead3xs(
                          color: activeColor,
                        ),
                        textAlign: .center,
                      ),
                    ),
                  ),
                ),
                builder: (context, index, child) {
                  final slide = widget.slides[index];
                  return Column(
                    mainAxisAlignment: .end,
                    mainAxisSize: .min,
                    children: [
                      if (slide.contentImage != null) ...[
                        GtImage(
                          image: slide.contentImage,
                          width: slide.contentImageWidth,
                          alignment: .center,
                          useDefaultSize: false,
                        ),
                        ?slide.contentImageSpacer,
                      ],
                      Padding(
                        padding: context.insets.defaultHorizontalInsets,
                        child: GtText(
                          slide.title.upper,
                          style: context.textStyles.h3(
                            color:
                                slide.textColor ??
                                context.palette.staticColors.white,
                            heightPx: 40,
                          ),
                          textAlign: slide.titleTextAlign,
                        ),
                      ),
                      const GtGap.ySectionSm(),
                      Align(
                        alignment: .bottomCenter,
                        child: GtDots(
                          index,
                          length: widget.slides.length,
                          activeColor: activeColor,
                          inActiveColor: inActiveColor,
                        ),
                      ),
                      const GtGap.ySectionSm(),
                      child!,
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
