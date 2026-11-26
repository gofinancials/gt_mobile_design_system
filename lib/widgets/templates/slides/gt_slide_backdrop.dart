import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Draws one slide's background image, shared by [GtOnboardingSlides] and
/// [GtPhotoWelcomeScreen].
///
/// On wide layouts the contained image sits over a blurred, full-bleed copy of
/// itself, so the sides of the screen are not left empty.
class GtSlideBackground extends GtStatelessWidget {
  /// The slide's background image.
  final ImageProvider image;

  /// Whether to fill the screen behind the image with a blurred copy of it.
  final bool showBlurredBackground;

  /// How the image is fitted to the screen.
  ///
  /// Defaults to [BoxFit.contain], which never crops it.
  final BoxFit fit;

  /// Where the image sits within the screen.
  ///
  /// Defaults to [Alignment.topCenter].
  final AlignmentGeometry alignment;

  /// Creates a [GtSlideBackground].
  const GtSlideBackground({
    super.key,
    required this.image,
    required this.showBlurredBackground,
    this.fit = .contain,
    this.alignment = .topCenter,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(image: image, fit: fit, alignment: alignment),
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

/// Fades between slides' content, shared by [GtOnboardingSlides] and
/// [GtPhotoWelcomeScreen].
///
/// It fades through rather than across: the outgoing content is gone by the
/// halfway point and the incoming content only appears after it, so two titles
/// are never drawn over each other. Both are anchored to the bottom by
/// [_GtBottomAnchoredCrossFadeLayout], while the height between them animates.
class GtSlideContentTransition extends GtStatefulWidget {
  /// The content to show, keyed by its slide so a change of slide is told
  /// apart from a rebuild of the same one.
  final Widget child;

  /// How long a change of slide takes.
  final Duration duration;

  /// The easing applied to the fades and the change in height.
  final Curve curve;

  /// Creates a [GtSlideContentTransition].
  const GtSlideContentTransition({
    super.key,
    required this.child,
    required this.duration,
    required this.curve,
  });

  @override
  State<GtSlideContentTransition> createState() =>
      _GtSlideContentTransitionState();
}

/// The state for [GtSlideContentTransition].
///
/// Alternates the incoming content between the cross-fade's two slots, so
/// each change of slide fades from whatever is showing.
class _GtSlideContentTransitionState extends State<GtSlideContentTransition> {
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
  void didUpdateWidget(covariant GtSlideContentTransition oldWidget) {
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
