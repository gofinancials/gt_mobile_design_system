import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A scrolling page body: the package's answer to the raw
/// [SingleChildScrollView] every form step, sheet body and error page used to
/// reach for.
///
/// Nothing here wrapped one before — [GtInfiniteListView] is pagination, and no
/// scaffold takes a scrolling body — so each host settled its own padding, and
/// a body that wanted to fill the viewport solved that by hand. This carries
/// the four things those hosts kept rewriting:
///
/// - [padding], defaulting to [GtInsets.defaultAllInsets], so a page body does
///   not restate the design system's own gutter.
/// - [controller], so a sheet body can drive the sheet's own scroll controller.
/// - [physics], so an [AlwaysScrollableScrollPhysics] under a
///   [RefreshIndicator] lets a body shorter than the screen still pull to
///   refresh.
/// - [fillViewport], the piece with no counterpart anywhere else in the
///   package.
///
/// ```dart
/// GtScrollableBody(
///   controller: sheetController,
///   physics: const AlwaysScrollableScrollPhysics(),
///   fillViewport: true,
///   child: Column(
///     children: [
///       const GtText('Who are you sending to?'),
///       const Spacer(),
///       GtButton(label: 'Continue', onPressed: submit),
///     ],
///   ),
/// )
/// ```
///
/// ## Filling the viewport
///
/// A [Spacer] or an [Expanded] inside a scroll view throws: the viewport hands
/// its child unbounded height, and a flex child has no finite space to expand
/// into. That is the shape of every form step with a pinned bottom action, so
/// [fillViewport] composes the three widgets that give the child a bounded
/// height without capping how far it can scroll — a [LayoutBuilder] to read the
/// incoming height, a [ConstrainedBox] whose `minHeight` is that height, and an
/// [IntrinsicHeight] to resolve the child against it. Content shorter than the
/// screen is stretched to exactly one viewport and does not scroll; content
/// taller than it scrolls as it always would.
///
/// [IntrinsicHeight] is what bounds that scope: it measures its child, so a
/// lazy child — a [ListView], a [GtInfiniteListView], anything that builds on
/// demand — throws under [fillViewport]. It is for finite, form-shaped bodies.
///
/// There is no sliver form of this widget because Flutter already ships one:
/// inside a [CustomScrollView], a `SliverFillRemaining(hasScrollBody: false)`
/// is the same behaviour, laid out by the viewport itself. Reach for that when
/// the screen is already a [CustomScrollView]; reach for this when it is not.
class GtScrollableBody extends GtStatelessWidget {
  /// The scrolling content.
  ///
  /// Under [fillViewport] it must lay out at a measurable height, so a lazy
  /// list does not belong here.
  final Widget child;

  /// The padding around [child], inside the viewport, so it scrolls with the
  /// content rather than clipping it.
  ///
  /// [GtInsets.defaultAllInsets] is the fallback when this is null, because a
  /// page body wants the design system's gutter far more often than it wants
  /// none. Pass [EdgeInsets.zero] where an ancestor already pads, or where a
  /// row inside the body bleeds to both screen edges.
  final EdgeInsetsGeometry? padding;

  /// The controller driving the scroll position.
  ///
  /// Null leaves the body on the [PrimaryScrollController], which is what a
  /// plain page wants. A body inside a draggable sheet passes the controller
  /// the sheet builds it with, so dragging the content drags the sheet.
  final ScrollController? controller;

  /// The physics governing how the body responds to a drag.
  ///
  /// Null inherits the platform default, under which a body shorter than the
  /// screen does not scroll at all — and so cannot be pulled. Pass
  /// [AlwaysScrollableScrollPhysics] under a [RefreshIndicator] to keep
  /// pull-to-refresh working on a short body.
  final ScrollPhysics? physics;

  /// Whether a [child] shorter than the viewport is stretched to fill it.
  ///
  /// Defaults to false, so the common sweep — a raw scroll view that only ever
  /// wraps its content — pays for neither the [LayoutBuilder] nor the
  /// [IntrinsicHeight]. Set it true for a body built with [Spacer] or
  /// [Expanded].
  final bool fillViewport;

  /// Creates a [GtScrollableBody] around [child].
  const GtScrollableBody({
    super.key,
    required this.child,
    this.padding,
    this.controller,
    this.physics,
    this.fillViewport = false,
  });

  @override
  Widget build(BuildContext context) {
    final insets = padding ?? context.insets.defaultAllInsets;

    if (!fillViewport) {
      return SingleChildScrollView(
        controller: controller,
        physics: physics,
        padding: insets,
        child: child,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          controller: controller,
          physics: physics,
          child: ConstrainedBox(
            // Unbounded height means there is no viewport to fill — a
            // SingleChildScrollView throws there anyway, and an infinite
            // minHeight would throw first and say less about why.
            constraints: BoxConstraints(
              minHeight: constraints.hasBoundedHeight
                  ? constraints.maxHeight
                  : 0,
            ),
            // Inside the constraint, not on the scroll view: the padding is
            // then part of the height being filled, so a short body measures
            // exactly one viewport and does not scroll by its own gutter.
            child: IntrinsicHeight(
              child: Padding(padding: insets, child: child),
            ),
          ),
        );
      },
    );
  }
}
