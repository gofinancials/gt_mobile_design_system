import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A widget that seamlessly positions an overlay child relative to a target widget
/// using an [OverlayPortal] and composited transforms.
///
/// This is typically used for dropdowns, tooltips, or contextual menus that need
/// to float above the rest of the UI but remain visually anchored to a specific widget.
class GtOverlayPortal extends GtStatefulWidget {
  /// The controller used to toggle the visibility of the overlay.
  final OverlayPortalController controller;

  /// The widget to be displayed within the overlay.
  final Widget overlayChild;

  /// The alignment point on the main [child] widget to anchor to.
  final Alignment childAnchor;

  /// The alignment point on the [overlayChild] widget that connects to the [childAnchor].
  final Alignment overlayAnchor;

  /// An additional positional offset applied to the [overlayChild].
  final Offset overlayOffSet;

  /// The primary target widget that the overlay is positioned relative to.
  final Widget child;

  /// Creates a [GtOverlayPortal].
  const GtOverlayPortal({
    required this.controller,
    required this.overlayChild,
    required this.child,
    this.overlayOffSet = Offset.zero,
    this.childAnchor = Alignment.topRight,
    this.overlayAnchor = Alignment.bottomLeft,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _GtOverlayPortalState();
}

class _GtOverlayPortalState extends State<GtOverlayPortal> {
  final LayerLink _link = LayerLink();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: OverlayPortal(
        controller: widget.controller,
        overlayChildBuilder: (context) {
          return CompositedTransformFollower(
            link: _link,
            targetAnchor: widget.childAnchor,
            followerAnchor: widget.overlayAnchor,
            offset: widget.overlayOffSet,
            child: widget.overlayChild,
          );
        },
        child: widget.child,
      ),
    );
  }
}
