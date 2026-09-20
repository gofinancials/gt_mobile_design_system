import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

// -----------------------------------------------------------------------------
// Arm resolution
// -----------------------------------------------------------------------------

/// Which arm of an asynchronous task is on screen.
///
/// Resolution is deliberately a single expression shared by every render site.
/// Written per screen it drifts: some sites show a spinner over stale data,
/// some show an empty state before the first load has run, and a pristine task
/// and an empty result become indistinguishable.
enum GtAsyncStateArm {
  /// First load, with nothing to show behind it.
  loading,

  /// The task failed and holds no usable data.
  error,

  /// The task completed and returned nothing.
  empty,

  /// Data is available — including a refresh over data already on screen.
  data;

  /// Resolves the arm for [task].
  ///
  /// Data wins over everything: a refresh, or an error arriving over a list
  /// already on screen, must not blank out what the customer is reading. A
  /// pristine task that has not loaded yet is [loading], never [empty].
  factory GtAsyncStateArm.of(AsyncData task) {
    if (task.hasData) return .data;
    if (task.isLoading || task.isPristine) return .loading;
    if (task.hasError) return .error;
    return .empty;
  }
}

// -----------------------------------------------------------------------------
// Box body
// -----------------------------------------------------------------------------

/// Resolves the loading / error / empty / data arms of an asynchronous task in
/// one place.
///
/// The package already ships every visual an async screen needs — [GtSpinner],
/// [GtStatusState] and [GtEmptyStateCard] — but nothing that chooses between
/// them, so each host used to re-derive the choice and each host was free to
/// disagree about whether a pristine task is empty or whether an error over
/// cached data should blank the screen. [GtAsyncStateArm.of] is that choice,
/// made once.
///
/// ```dart
/// GtAsyncStateBody(
///   task: controller.transactions,
///   emptyDescription: 'No transactions yet',
///   emptyIcon: GtIcons.file,
///   errorTitle: 'Something went wrong',
///   retryLabel: 'Try again',
///   onRetry: controller.load,
///   builder: (context) => ListView(children: [...]),
/// )
/// ```
///
/// It ships **no skeleton default**, because the package ships no shimmer
/// primitive to default to: `gt_generic_shimmer.dart` and
/// `gt_image_shimmer.dart` are still stubs. Where a screen shows
/// content-shaped loading, pass that skeleton as [loading]; where it shows a
/// centred spinner, leave it null.
///
/// For a task rendered inside a [CustomScrollView], use [GtAsyncStateSliver].
class GtAsyncStateBody extends GtStatelessWidget {
  /// The task whose arm is being resolved.
  ///
  /// Any [AsyncData] — [FutureData], [FutureListData] or [PaginatedData] —
  /// satisfies this.
  final AsyncData task;

  /// Renders the data arm. Called only when [task] has data.
  ///
  /// Only [padding] wraps its result; the centring applied to the other arms
  /// does not, because a populated screen's own list or scroll view lays itself
  /// out.
  final WidgetBuilder builder;

  /// Copy for the empty arm.
  ///
  /// Required unless [empty] replaces the arm outright, so that no site falls
  /// back to a blank frame.
  final String? emptyDescription;

  /// Glyph above [emptyDescription]. Null renders the card without one.
  final IconData? emptyIcon;

  /// Headline for the error arm.
  ///
  /// Required unless [error] replaces the arm outright. The package holds no
  /// copy of its own, so the host supplies its own localised string.
  final String? errorTitle;

  /// Supporting copy under [errorTitle].
  ///
  /// Defaults to the task's own [AsyncData.errorMessage] when null.
  final String? errorSubtitle;

  /// Illustration override for the error arm's glyph.
  ///
  /// Forwarded to [GtStatusState.graphic], which takes precedence over the
  /// variant's default illustration and leaves sizing to the caller.
  final Widget? errorGraphic;

  /// Size of the error arm's default illustration.
  ///
  /// Forwarded to [GtStatusState.iconSize]; ignored when [errorGraphic] is
  /// supplied. Defaults to 124.
  final double? errorIconSize;

  /// Label for the error arm's retry button.
  ///
  /// Supplied together with [onRetry] or not at all — [GtStatusState] asserts
  /// on the pairing.
  final String? retryLabel;

  /// Retry handler for the error arm.
  ///
  /// Supplied together with [retryLabel] or not at all.
  final OnPressed? onRetry;

  /// Replaces the centred [GtSpinner].
  ///
  /// Supply a locally-composed skeleton where the screen shows content-shaped
  /// loading. Unlike the other arms it is laid out at the host's own height
  /// rather than centred, so a skeleton sits where the rows go.
  final Widget? loading;

  /// Replaces the default [GtEmptyStateCard].
  final Widget? empty;

  /// Replaces the default [GtStatusState.error].
  final Widget? error;

  /// The padding around whichever arm is on screen.
  ///
  /// [GtInsets.defaultHorizontalInsets] is the fallback when this is null, not
  /// a rule: the view-state organisms are content, not screens, so they stretch
  /// edge to edge and a host that pads nothing would run the failure copy and
  /// its retry button into both screen edges.
  ///
  /// It applies to every arm, the data arm included, so a populated screen is
  /// inset the same way its empty and error arms are. Pass [EdgeInsets.zero]
  /// where an ancestor already pads, or any other inset the screen calls for.
  final EdgeInsetsGeometry? padding;

  /// Creates a [GtAsyncStateBody] for [task].
  const GtAsyncStateBody({
    super.key,
    required this.task,
    required this.builder,
    this.emptyDescription,
    this.emptyIcon,
    this.errorTitle,
    this.errorSubtitle,
    this.errorGraphic,
    this.errorIconSize,
    this.retryLabel,
    this.onRetry,
    this.loading,
    this.empty,
    this.error,
    this.padding,
  }) : assert(
         empty != null || emptyDescription != null,
         'emptyDescription is required unless empty replaces the arm',
       ),
       assert(
         error != null || errorTitle != null,
         'errorTitle is required unless error replaces the arm',
       ),
       assert(
         (onRetry == null) == (retryLabel == null),
         'onRetry and retryLabel must be provided together',
       );

  @override
  Widget build(BuildContext context) {
    final arm = GtAsyncStateArm.of(task);

    final child = switch (arm) {
      .data => builder(context),
      _ => _GtAsyncStateArmView(
        arm: arm,
        task: task,
        emptyDescription: emptyDescription,
        emptyIcon: emptyIcon,
        errorTitle: errorTitle,
        errorSubtitle: errorSubtitle,
        errorGraphic: errorGraphic,
        errorIconSize: errorIconSize,
        retryLabel: retryLabel,
        onRetry: onRetry,
        loading: loading,
        empty: empty,
        error: error,
      ),
    };

    return Padding(
      padding: padding ?? context.insets.defaultHorizontalInsets,
      child: child,
    );
  }
}

// -----------------------------------------------------------------------------
// Sliver body
// -----------------------------------------------------------------------------

/// The sliver form of [GtAsyncStateBody], for a task rendered inside a
/// [CustomScrollView].
///
/// This is a real sliver, not a box wrapper around one: like [SliverPadding] it
/// is a [SingleChildRenderObjectWidget] over a [RenderSliverPadding], and its
/// child slot holds whichever arm [task] resolves to. It does not mirror
/// [GtAsyncStateBody]'s defaults — every arm here is a sliver the caller
/// supplies, and the widget only switches between them.
///
/// That is the whole point: the arm goes to the viewport as the sliver it is.
/// A million-row [SliverList] on the data arm builds only the rows in view,
/// and a skeleton on the loading arm can be just as lazy, because neither is
/// ever wrapped in a box.
///
/// ```dart
/// CustomScrollView(
///   slivers: [
///     const SliverAppBar(title: GtText('Statements')),
///     GtAsyncStateSliver(
///       task: controller.statements,
///       sliver: SliverList.builder(
///         itemCount: controller.statements.data.length,
///         itemBuilder: (context, i) => GtInfoListTile(...),
///       ),
///       loading: SliverList.builder(
///         itemCount: 12,
///         itemBuilder: (context, i) => const StatementRowSkeleton(),
///       ),
///       empty: const SliverFillRemaining(
///         hasScrollBody: false,
///         child: GtEmptyStateCard(
///           icon: GtIcons.file,
///           description: 'No statements yet',
///         ),
///       ),
///     ),
///   ],
/// )
/// ```
///
/// An arm left null renders nothing, so a screen opts into only the arms it
/// draws. To reuse this package's own loading, empty and error visuals, put a
/// [GtAsyncStateBody] in a [SliverFillRemaining]; they are box organisms, and
/// making that composition explicit is what keeps them off the data arm.
///
/// The arm is laid out inside this widget's own [padding], which every arm
/// shares and which any screen can replace.
class GtAsyncStateSliver extends SingleChildRenderObjectWidget
    with AppAnalyticsMixin {
  /// See [GtAsyncStateBody.task].
  final AsyncData task;

  /// The arm [task] resolves to, by [GtAsyncStateArm.of].
  ///
  /// Resolved once at construction, because a [RenderObjectWidget] picks its
  /// child then. Exposed so a host can read what is on screen without
  /// re-deriving it.
  final GtAsyncStateArm arm;

  /// The padding around whichever arm is on screen.
  ///
  /// Applied by this widget's own [RenderSliverPadding], so it insets the arm's
  /// sliver rather than boxing it — which is why a lazy [SliverList] on the
  /// data arm stays lazy through it.
  ///
  /// [GtInsets.defaultHorizontalInsets] is the fallback when this is null, not
  /// a rule. It applies to every arm, the data arm included: a list that wants
  /// its own insets can take [EdgeInsets.zero] here and pad its rows, and a
  /// host whose ancestor already pads can do the same.
  final EdgeInsetsGeometry? padding;

  /// Creates a [GtAsyncStateSliver] showing the arm [task] resolves to.
  ///
  /// Every arm must be a sliver. [sliver] draws the data arm; [loading],
  /// [empty] and [error] draw theirs, and any left null render nothing. Wrap a
  /// box arm in [SliverToBoxAdapter] or [SliverFillRemaining] to supply one.
  factory GtAsyncStateSliver({
    Key? key,
    required AsyncData task,
    required Widget sliver,
    Widget? loading,
    Widget? empty,
    Widget? error,
    EdgeInsetsGeometry? padding,
  }) {
    final arm = GtAsyncStateArm.of(task);

    return GtAsyncStateSliver._(
      key: key,
      task: task,
      arm: arm,
      padding: padding,
      sliver: switch (arm) {
        .data => sliver,
        .loading => loading,
        .error => error,
        .empty => empty,
      },
    );
  }

  const GtAsyncStateSliver._({
    super.key,
    required this.task,
    required this.arm,
    required this.padding,
    required Widget? sliver,
  }) : super(child: sliver);

  /// The inset to lay the arm's sliver out with.
  EdgeInsetsGeometry _resolvePadding(BuildContext context) {
    return padding ?? context.insets.defaultHorizontalInsets;
  }

  @override
  RenderSliverPadding createRenderObject(BuildContext context) {
    return RenderSliverPadding(
      padding: _resolvePadding(context),
      textDirection: Directionality.of(context),
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderSliverPadding renderObject,
  ) {
    renderObject
      ..padding = _resolvePadding(context)
      ..textDirection = Directionality.of(context);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<GtAsyncStateArm>('arm', arm));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding));
  }
}

// -----------------------------------------------------------------------------
// Internals
// -----------------------------------------------------------------------------

/// Draws a non-data arm with the package's own visuals, so both the box and the
/// sliver form show the same thing for the same [arm].
class _GtAsyncStateArmView extends GtStatelessWidget {
  final GtAsyncStateArm arm;
  final AsyncData task;
  final String? emptyDescription;
  final IconData? emptyIcon;
  final String? errorTitle;
  final String? errorSubtitle;
  final Widget? errorGraphic;
  final double? errorIconSize;
  final String? retryLabel;
  final OnPressed? onRetry;
  final Widget? loading;
  final Widget? empty;
  final Widget? error;

  const _GtAsyncStateArmView({
    required this.arm,
    required this.task,
    required this.emptyDescription,
    required this.emptyIcon,
    required this.errorTitle,
    required this.errorSubtitle,
    required this.errorGraphic,
    required this.errorIconSize,
    required this.retryLabel,
    required this.onRetry,
    required this.loading,
    required this.empty,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    final errorWidget = GtStatusState.error(
      title: errorTitle.value,
      subtitle: errorSubtitle ?? task.errorMessage,
      graphic: errorGraphic,
      iconSize: errorIconSize,
      actionLabel: retryLabel,
      onActionPressed: onRetry,
    );
    final emptyWidget = GtEmptyStateCard(
      icon: emptyIcon,
      description: emptyDescription.value,
    );

    final view = switch (arm) {
      .loading => loading ?? const Center(child: GtSpinner()),
      .error => error ?? errorWidget,
      .empty => empty ?? emptyWidget,
      _ => const Offstage(),
    };

    // In the middle of the host's height, at the arm's own height. The loading
    // arm is left as supplied so a skeleton lands where the rows go.
    return arm == .loading ? view : GtCentredAsyncStateArm(child: view);
  }
}

/// Centres a non-data arm in the middle of the host's height, at the arm's own
/// height, stretched to the host's full width so its copy wraps and centres
/// against the screen rather than against its own intrinsic width.
class GtCentredAsyncStateArm extends GtStatelessWidget {
  final Widget child;

  const GtCentredAsyncStateArm({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        child: IntrinsicHeight(child: child),
      ),
    );
  }
}
