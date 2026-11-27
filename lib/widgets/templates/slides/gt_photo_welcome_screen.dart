import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

import 'gt_slide_backdrop.dart';

/// The welcome screen a new customer sees after the splash: a full-bleed
/// photograph under a header, with a headline, an optional description,
/// primary and secondary action buttons and a rich text footer.
///
/// On a phone the photograph fills the screen, cropped at its edges. On a
/// wider layout it is shown whole over a blurred copy of itself, as on
/// [GtOnboardingSlides].
///
/// With more than one slide the customer swipes between them. Unlike
/// [GtOnboardingSlides], the screen never advances on its own and draws no
/// progress line. The header stays put while the photograph and the slide's
/// text change.
///
/// The screen is drawn over a black scrim, so it gives the status and
/// navigation bars light icons while it is on screen.
class GtPhotoWelcomeScreen extends GtStatefulWidget {
  /// The slides to show, swiped between in order.
  final List<GtPhotoWelcomeSlideData> slides;

  /// The primary action button, such as "Open an account".
  final GtRaisedButton primaryButton;

  /// The secondary action button, such as "Log in".
  final GtOutlineButton secondaryButton;

  /// The text displayed in the footer area, which can contain HTML-like link
  /// tags.
  final String footerText;

  /// The content pinned at the top of the screen, beneath the status bar.
  ///
  /// If null, it is the white "OneBank by Sterling" lockup,
  /// [GtVectors.whiteOneBankBySterlingLockup].
  final Widget? header;

  /// The background color of the screen, behind the photograph.
  ///
  /// If null, it defaults to `context.palette.staticColors.black`.
  final Color? backgroundColor;

  /// The scrim over the photograph.
  ///
  /// If null, it defaults to `context.gradients.welcomeScreenGradient()`.
  final Gradient? gradient;

  /// Optional color for the footer text.
  ///
  /// If null, it defaults to [GtColors.tertiaryText].
  final Color? footerTextColor;

  /// Optional color for links within the footer text.
  ///
  /// If null, it defaults to [GtColors.neutral50].
  final Color? footerLinkColor;

  /// Creates a [GtPhotoWelcomeScreen] widget.
  const GtPhotoWelcomeScreen({
    super.key,
    required this.slides,
    required this.primaryButton,
    required this.secondaryButton,
    required this.footerText,
    this.header,
    this.backgroundColor,
    this.gradient,
    this.footerTextColor,
    this.footerLinkColor,
  }) : assert(slides.length > 0);

  @override
  State<GtPhotoWelcomeScreen> createState() => _GtPhotoWelcomeScreenState();
}

/// The state for [GtPhotoWelcomeScreen].
///
/// Tracks the slide in view, so its text can fade in as its photograph is
/// swiped to.
///
/// The scrim, the header and the slide's text sit above the page view but
/// ignore pointers, so a swipe that starts on them still reaches it; only the
/// buttons and the footer's links take touches of their own.
class _GtPhotoWelcomeScreenState extends State<GtPhotoWelcomeScreen> {
  /// Notifier for the currently active slide index.
  late final ValueNotifier<int> _activeSlide;

  /// Controller for the [PageView] that holds the photographs.
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _activeSlide = ValueNotifier(0);
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _activeSlide.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final backgroundColor =
        widget.backgroundColor ?? palette.staticColors.black;
    final isWideLayout = !context.isMobile;

    BoxFit fit = .cover;
    AlignmentGeometry alignment = .center;
    if (isWideLayout) {
      fit = .contain;
      alignment = .topCenter;
    }

    final header =
        widget.header ??
        GtSvg(
          GtVectors.whiteOneBankBySterlingLockup,
          width: context.dp(144.px),
          height: context.dp(44.px),
          semanticsLabel: 'OneBank by Sterling',
        );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: .light,
        statusBarBrightness: .dark,
        systemNavigationBarColor: backgroundColor,
        systemNavigationBarIconBrightness: .light,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: backgroundColor,
        body: Stack(
          children: [
            Positioned.fill(
              child: PageView.builder(
                controller: _controller,
                itemCount: widget.slides.length,
                allowImplicitScrolling: true,
                onPageChanged: (index) => _activeSlide.value = index,
                itemBuilder: (_, index) => GtSlideBackground(
                  image: widget.slides[index].image,
                  showBlurredBackground: isWideLayout,
                  fit: fit,
                  alignment: alignment,
                ),
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient:
                        widget.gradient ??
                        context.gradients.welcomeScreenGradient(),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: context.insets.onlyDp(top: 24.px),
                    child: Center(child: header),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: NumberListener(
                valueListenable: _activeSlide,
                builder: (index) {
                  final activeIndex = index ?? 0;

                  return Column(
                    mainAxisAlignment: .end,
                    mainAxisSize: .min,
                    children: [
                      IgnorePointer(
                        child: GtSlideContentTransition(
                          duration: GtMotion.adaptiveDuration(
                            context,
                            GtMotion.fluid,
                          ),
                          curve: Curves.easeInOutCubic,
                          child: _GtPhotoWelcomeSlideText(
                            key: ValueKey(activeIndex),
                            slide: widget.slides[activeIndex],
                          ),
                        ),
                      ),
                      const GtGap.ySectionMd(),
                      GtButtonBottomNavBar(
                        heading: widget.primaryButton,
                        button: widget.secondaryButton,
                        spacing: context.spacingMd,
                        footer: Padding(
                          padding: context.insets.onlyDp(top: 4.px),
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
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A private widget that draws one welcome slide's headline and, when it has
/// one, the description beneath it.
class _GtPhotoWelcomeSlideText extends GtStatelessWidget {
  /// The slide whose text is drawn.
  final GtPhotoWelcomeSlideData slide;

  /// Creates a [_GtPhotoWelcomeSlideText].
  const _GtPhotoWelcomeSlideText({super.key, required this.slide});

  @override
  Widget build(BuildContext context) {
    final titleColor = slide.titleColor ?? context.palette.staticColors.white;
    final descriptionColor = slide.descriptionColor ?? GtColors.mist.value;

    return Padding(
      padding: context.insets.defaultHorizontalInsets,
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        spacing: context.spacingBase,
        children: [
          GtText(
            slide.title,
            style: context.textStyles.welcomeHeadline(color: titleColor),
            textAlign: slide.textAlign,
          ),
          if (slide.description.hasValue)
            GtText(
              slide.description.value,
              style: context.textStyles.labelS(
                color: descriptionColor,
                weight: .w500,
              ),
              textAlign: slide.textAlign,
            ),
        ],
      ),
    );
  }
}
