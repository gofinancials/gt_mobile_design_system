import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:provider/provider.dart';

/// Where a local state wrapper gets one of its notifiers, and so whether it
/// disposes it.
///
/// The same four sources [GtLocalStateWrapper] takes as `notifier`, `create`,
/// `shared` and none of them, spelled as a value so [GtLocalStateWrapper2] and
/// [GtLocalStateWrapper3] can take one per notifier:
///
/// * [GtStateSource.borrowed] — an instance owned elsewhere. Never disposed by
///   the wrapper.
/// * [GtStateSource.owned] — an instance made for the subtree. Disposed when
///   the subtree unmounts.
/// * [GtStateSource.shared] — an instance several routes share through a
///   [GtSharedState]. Held while the subtree is mounted, and disposed by the
///   holder once no subtree holds it.
/// * [GtStateSource.located] — `locator<T>()`, the registered singleton. Never
///   disposed by the wrapper.
sealed class GtStateSource<T extends ChangeNotifier> {
  /// Creates a [GtStateSource].
  const GtStateSource();

  /// A notifier owned by the host. Disposing it stays the host's job.
  const factory GtStateSource.borrowed(T notifier) = _BorrowedStateSource<T>;

  /// A notifier made by [create] for the subtree and disposed with it.
  ///
  /// [create] runs once for the life of the wrapper's [State]; a different
  /// source on a later rebuild is ignored, so a host that needs a fresh
  /// notifier changes the wrapper's key instead.
  const factory GtStateSource.owned(ValueGetter<T> create) =
      _OwnedStateSource<T>;

  /// The singleton registered for the wrapper's type argument, borrowed from
  /// the locator.
  ///
  /// Resolved against the wrapper's type argument rather than this source's,
  /// so the `const` default of a wrapper parameter stays correct.
  const factory GtStateSource.located() = _LocatedStateSource<T>;

  /// The notifier [holder] keeps for every route of a flow, held while the
  /// subtree is mounted.
  ///
  /// The subtree never disposes it; [holder] does, once the last subtree
  /// holding it has unmounted.
  const factory GtStateSource.shared(GtSharedState<T> holder) =
      _SharedStateSource<T>;
}

/// A private [GtStateSource] for a notifier the host owns.
class _BorrowedStateSource<T extends ChangeNotifier> extends GtStateSource<T> {
  /// The notifier handed to the subtree.
  final T notifier;

  /// Creates a [_BorrowedStateSource].
  const _BorrowedStateSource(this.notifier);
}

/// A private [GtStateSource] for a notifier the wrapper makes and disposes.
class _OwnedStateSource<T extends ChangeNotifier> extends GtStateSource<T> {
  /// Makes the notifier, once.
  final ValueGetter<T> create;

  /// Creates an [_OwnedStateSource].
  const _OwnedStateSource(this.create);
}

/// A private [GtStateSource] for the locator's singleton.
class _LocatedStateSource<T extends ChangeNotifier> extends GtStateSource<T> {
  /// Creates a [_LocatedStateSource].
  const _LocatedStateSource();
}

/// A private [GtStateSource] for a notifier held through a [GtSharedState].
class _SharedStateSource<T extends ChangeNotifier> extends GtStateSource<T> {
  /// The holder that makes and disposes the notifier.
  final GtSharedState<T> holder;

  /// Creates a [_SharedStateSource].
  const _SharedStateSource(this.holder);
}

/// Resolves [GtStateSource]s for a local state wrapper's [State], and
/// disposes or releases what it resolved when the [State] is disposed.
mixin _GtLocalStateOwner<W extends StatefulWidget> on State<W> {
  /// What each owned or shared notifier needs at disposal, in resolution
  /// order: `dispose` for an owned one, `release` of its holder for a shared
  /// one.
  final List<VoidCallback> _cleanups = [];

  /// Returns the notifier [source] describes, remembering how to let go of it
  /// when [source] made or holds it.
  ///
  /// [T] is passed explicitly by the caller, so a located source resolves the
  /// wrapper's type argument whatever its own type argument is.
  T resolve<T extends ChangeNotifier>(GtStateSource<T> source) {
    return switch (source) {
      _BorrowedStateSource<T>(:final notifier) => notifier,
      _OwnedStateSource<T>(:final create) => _own(create()),
      _SharedStateSource<T>(:final holder) => _hold(holder),
      _LocatedStateSource<T>() => locator<T>(),
    };
  }

  /// Records [state] as owned and returns it.
  T _own<T extends ChangeNotifier>(T state) {
    _cleanups.add(state.dispose);
    return state;
  }

  /// Takes hold of [holder]'s notifier, records the matching release, and
  /// returns it.
  T _hold<T extends ChangeNotifier>(GtSharedState<T> holder) {
    final state = holder.acquire();
    _cleanups.add(holder.release);
    return state;
  }

  /// Lets go of what was resolved newest first, so a notifier made holding an
  /// earlier one can still unsubscribe from it.
  @override
  void dispose() {
    for (final cleanup in _cleanups.reversed) {
      cleanup();
    }
    super.dispose();
  }
}

/// Provides a [ChangeNotifier] to a subtree and rebuilds it on every
/// notification.
///
/// The notifier comes from one of four sources, and which one a host picks
/// decides who disposes it:
///
/// * [notifier] — an instance owned elsewhere, usually by a parent route or a
///   controller the host already holds. Borrowed, never disposed here.
/// * [create] — an instance made for this subtree. Owned, and disposed when
///   the subtree unmounts.
/// * [shared] — an instance every route of a flow shares. Held while this
///   subtree is mounted and disposed by its [GtSharedState] once no route
///   holds it.
/// * none of them — `locator<T>()`, the registered singleton. Borrowed, never
///   disposed here.
///
/// [create] is the case the widget's name implies and the one that used to be
/// missing: without it a host that wanted a notifier scoped to its subtree had
/// to wrap this widget in a [StatefulWidget] of its own whose only job was the
/// `dispose`, or else leak the notifier — its listeners and its subscriptions
/// staying alive for the rest of the session — every time the screen was
/// opened and closed.
///
/// ```dart
/// GtLocalStateWrapper<FilterController>(
///   create: FilterController.new,
///   onReady: (controller) => controller.seed(initialFilters),
///   builder: (controller) => GtFilterSheet(controller: controller),
/// )
/// ```
///
/// A subtree that needs two or three notifiers uses [GtLocalStateWrapper2] or
/// [GtLocalStateWrapper3] rather than nesting this widget.
class GtLocalStateWrapper<T extends ChangeNotifier> extends GtStatefulWidget {
  /// Builds the subtree from the notifier, once per notification.
  final ValueBuilder<T> builder;

  /// A notifier owned by the host. Disposing it stays the host's job.
  ///
  /// Mutually exclusive with [create] and [shared].
  final T? notifier;

  /// Makes a notifier owned by this subtree and disposed when it unmounts.
  ///
  /// Runs once for the life of the [State]: a different closure on a later
  /// rebuild is ignored, so a host that needs a fresh notifier changes the
  /// widget's [key] instead.
  ///
  /// Mutually exclusive with [notifier] and [shared].
  final ValueGetter<T>? create;

  /// Holds the notifier a [GtSharedState] keeps for every route of a flow.
  ///
  /// Taken hold of in `initState` and let go of in `dispose`. The holder, not
  /// this widget, disposes the notifier once the last route holding it has
  /// gone.
  ///
  /// Mutually exclusive with [notifier] and [create].
  final GtSharedState<T>? shared;

  /// Runs against the resolved notifier before the first build.
  ///
  /// Fires for every source, not just [create], because a borrowed
  /// notifier can need the same one call. The alternative, a post-frame
  /// callback at every call site, paints once with unseeded state.
  ///
  /// It runs from `initState`, so for a notifier made by [create] — nothing
  /// listening yet — a `notifyListeners()` from here is harmless. For a
  /// borrowed [notifier], a [shared] one or the singleton, listeners elsewhere may already be
  /// mounted and notifying mid-build trips them, exactly as it would from the
  /// host's own `initState`.
  final ValueSetter<T>? onReady;

  /// Creates a [GtLocalStateWrapper].
  const GtLocalStateWrapper({
    required this.builder,
    this.notifier,
    this.create,
    this.shared,
    this.onReady,
    super.key,
  }) : assert(
         notifier == null || create == null,
         'Pass either notifier (borrowed) or create (owned), not both.',
       ),
       assert(
         shared == null || (notifier == null && create == null),
         'Pass shared on its own, without notifier or create.',
       );

  /// The [GtStateSource] that [notifier], [create] and [shared] describe.
  GtStateSource<T> get _source {
    GtStateSource<T> source = .located();
    if (shared case GtSharedState<T> shared) {
      source = .shared(shared);
    }
    if (create case ValueGetter<T> create) {
      source = .owned(create);
    }
    if (notifier case T notifier) {
      source = .borrowed(notifier);
    }
    return source;
  }

  @override
  State<StatefulWidget> createState() => _GtLocalStateWrapperState<T>();
}

/// The [State] for [GtLocalStateWrapper].
class _GtLocalStateWrapperState<T extends ChangeNotifier>
    extends State<GtLocalStateWrapper<T>>
    with _GtLocalStateOwner<GtLocalStateWrapper<T>> {
  /// The notifier the subtree is built from.
  late final T state;

  @override
  void initState() {
    super.initState();
    state = resolve<T>(widget._source);
    widget.onReady?.call(state);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(
      value: state,
      child: Consumer<T>(
        builder: (context, value, child) {
          return widget.builder(value);
        },
      ),
    );
  }
}

/// [GtLocalStateWrapper] for two notifiers: provides both to a subtree and
/// rebuilds it when either notifies.
///
/// Each notifier has its own [GtStateSource], so one can be owned by the
/// subtree while the other is borrowed. Both default to the locator.
///
/// ```dart
/// GtLocalStateWrapper2<FilterController, TransactionsState>(
///   first: .owned(FilterController.new),
///   builder: (filters, transactions) => GtTransactionList(
///     filters: filters,
///     transactions: transactions,
///   ),
/// )
/// ```
///
/// Descendants can also read either notifier from the context, as they can
/// under [GtLocalStateWrapper]. That lookup is by type, so [A] and [B] must
/// differ; two notifiers of one type need two wrappers.
///
/// [GtStateSource.owned] cannot see the other notifier. A notifier made from
/// another belongs in the host, which then borrows both.
class GtLocalStateWrapper2<A extends ChangeNotifier, B extends ChangeNotifier>
    extends GtStatefulWidget {
  /// Builds the subtree from both notifiers, once per notification of either.
  final ValueBuilder2<A, B> builder;

  /// Where the [A] notifier comes from.
  final GtStateSource<A> first;

  /// Where the [B] notifier comes from.
  final GtStateSource<B> second;

  /// Runs against both resolved notifiers before the first build, with the
  /// same timing and caveats as [GtLocalStateWrapper.onReady].
  final OnChanged2<A, B>? onReady;

  /// Creates a [GtLocalStateWrapper2].
  const GtLocalStateWrapper2({
    required this.builder,
    this.first = const GtStateSource.located(),
    this.second = const GtStateSource.located(),
    this.onReady,
    super.key,
  }) : assert(
         A != B,
         'A and B must differ: provider looks notifiers up by type.',
       );

  @override
  State<StatefulWidget> createState() => _GtLocalStateWrapper2State<A, B>();
}

/// The [State] for [GtLocalStateWrapper2].
class _GtLocalStateWrapper2State<
  A extends ChangeNotifier,
  B extends ChangeNotifier
>
    extends State<GtLocalStateWrapper2<A, B>>
    with _GtLocalStateOwner<GtLocalStateWrapper2<A, B>> {
  /// The [A] notifier the subtree is built from.
  late final A first;

  /// The [B] notifier the subtree is built from.
  late final B second;

  @override
  void initState() {
    super.initState();
    first = resolve<A>(widget.first);
    second = resolve<B>(widget.second);
    widget.onReady?.call(first, second);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<A>.value(value: first),
        ChangeNotifierProvider<B>.value(value: second),
      ],
      child: Consumer2<A, B>(
        builder: (context, first, second, child) {
          return widget.builder(first, second);
        },
      ),
    );
  }
}

/// [GtLocalStateWrapper] for three notifiers: provides all three to a subtree
/// and rebuilds it when any notifies.
///
/// Each notifier has its own [GtStateSource], and all three default to the
/// locator. The same limits as [GtLocalStateWrapper2] apply: [A], [B] and [C]
/// must be distinct types, and an owned notifier cannot see the others.
///
/// ```dart
/// GtLocalStateWrapper3<FilterController, SortController, TransactionsState>(
///   first: .owned(FilterController.new),
///   second: .owned(SortController.new),
///   builder: (filters, sort, transactions) => GtTransactionList(
///     filters: filters,
///     sort: sort,
///     transactions: transactions,
///   ),
/// )
/// ```
class GtLocalStateWrapper3<
  A extends ChangeNotifier,
  B extends ChangeNotifier,
  C extends ChangeNotifier
>
    extends GtStatefulWidget {
  /// Builds the subtree from all three notifiers, once per notification of
  /// any.
  final ValueBuilder3<A, B, C> builder;

  /// Where the [A] notifier comes from.
  final GtStateSource<A> first;

  /// Where the [B] notifier comes from.
  final GtStateSource<B> second;

  /// Where the [C] notifier comes from.
  final GtStateSource<C> third;

  /// Runs against all three resolved notifiers before the first build, with
  /// the same timing and caveats as [GtLocalStateWrapper.onReady].
  final void Function(A first, B second, C third)? onReady;

  /// Creates a [GtLocalStateWrapper3].
  const GtLocalStateWrapper3({
    required this.builder,
    this.first = const GtStateSource.located(),
    this.second = const GtStateSource.located(),
    this.third = const GtStateSource.located(),
    this.onReady,
    super.key,
  }) : assert(
         A != B && A != C && B != C,
         'A, B and C must differ: provider looks notifiers up by type.',
       );

  @override
  State<StatefulWidget> createState() => _GtLocalStateWrapper3State<A, B, C>();
}

/// The [State] for [GtLocalStateWrapper3].
class _GtLocalStateWrapper3State<
  A extends ChangeNotifier,
  B extends ChangeNotifier,
  C extends ChangeNotifier
>
    extends State<GtLocalStateWrapper3<A, B, C>>
    with _GtLocalStateOwner<GtLocalStateWrapper3<A, B, C>> {
  /// The [A] notifier the subtree is built from.
  late final A first;

  /// The [B] notifier the subtree is built from.
  late final B second;

  /// The [C] notifier the subtree is built from.
  late final C third;

  @override
  void initState() {
    super.initState();
    first = resolve<A>(widget.first);
    second = resolve<B>(widget.second);
    third = resolve<C>(widget.third);
    widget.onReady?.call(first, second, third);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<A>.value(value: first),
        ChangeNotifierProvider<B>.value(value: second),
        ChangeNotifierProvider<C>.value(value: third),
      ],
      child: Consumer3<A, B, C>(
        builder: (context, first, second, third, child) {
          return widget.builder(first, second, third);
        },
      ),
    );
  }
}
