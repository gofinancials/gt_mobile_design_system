import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:provider/provider.dart';

/// Provides a [ChangeNotifier] to a subtree and rebuilds it on every
/// notification.
///
/// The notifier comes from one of three sources, and which one a host picks
/// decides who disposes it:
///
/// * [notifier] — an instance owned elsewhere, usually by a parent route or a
///   controller the host already holds. Borrowed, never disposed here.
/// * [create] — an instance made for this subtree. Owned, and disposed when
///   the subtree unmounts.
/// * neither — `locator<T>()`, the registered singleton. Borrowed, never
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
class GtLocalStateWrapper<T extends ChangeNotifier> extends GtStatefulWidget {
  /// Builds the subtree from the notifier, once per notification.
  final ValueBuilder<T> builder;

  /// A notifier owned by the host. Disposing it stays the host's job.
  ///
  /// Mutually exclusive with [create].
  final T? notifier;

  /// Makes a notifier owned by this subtree and disposed when it unmounts.
  ///
  /// Runs once for the life of the [State]: a different closure on a later
  /// rebuild is ignored, so a host that needs a fresh notifier changes the
  /// widget's [key] instead.
  ///
  /// Mutually exclusive with [notifier].
  final ValueGetter<T>? create;

  /// Runs against the resolved notifier before the first build.
  ///
  /// Fires for all three sources, not just [create], because a borrowed
  /// notifier can need the same one call. The alternative, a post-frame
  /// callback at every call site, paints once with unseeded state.
  ///
  /// It runs from `initState`, so for a notifier made by [create] — nothing
  /// listening yet — a `notifyListeners()` from here is harmless. For a
  /// borrowed [notifier] or the singleton, listeners elsewhere may already be
  /// mounted and notifying mid-build trips them, exactly as it would from the
  /// host's own `initState`.
  final ValueSetter<T>? onReady;

  const GtLocalStateWrapper({
    required this.builder,
    this.notifier,
    this.create,
    this.onReady,
    super.key,
  }) : assert(
         notifier == null || create == null,
         'Pass either notifier (borrowed) or create (owned), not both.',
       );

  @override
  State<StatefulWidget> createState() => _GtLocalStateWrapperState<T>();
}

class _GtLocalStateWrapperState<T extends ChangeNotifier>
    extends State<GtLocalStateWrapper<T>> {
  late final T state;

  /// Whether [state] came from `create` and so has to be disposed here.
  late final bool owned;

  @override
  void initState() {
    super.initState();
    final create = widget.create;
    owned = widget.notifier == null && create != null;
    state = widget.notifier ?? (create != null ? create() : locator<T>());
    widget.onReady?.call(state);
  }

  @override
  void dispose() {
    if (owned) state.dispose();
    super.dispose();
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
