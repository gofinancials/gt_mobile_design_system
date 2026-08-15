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

      final curve = next == 0 ? Curves.easeOutBack : Curves.easeIn;

      _controller.animateToPage(next, duration: 500.milliseconds, curve: curve);
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
              itemCount: widget.slides.length,
              controller: _controller,
              onPageChanged: _updateSlide,
              itemBuilder: (_, index) {
                final slide = widget.slides[index];
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
                        linkColor:
                            widget.footerLinkColor ?? GtColors.neutral50.value,
                        style: context.textStyles.subHead3xs(
                          color: widget.footerTextColor ?? activeColor,
                        ),
                        textAlign: .center,
                      ),
                    ),
                  ),
                ),
                builder: (context, index, child) {
                  final slide = widget.slides[index];
                  final textColor =
                      slide.textColor ?? palette.staticColors.white;

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
