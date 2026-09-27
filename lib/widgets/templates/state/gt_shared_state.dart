import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Owns one [ChangeNotifier] on behalf of every subtree that holds it, and
/// disposes it once none do.
///
/// Routes pushed onto one [Navigator] are siblings, so a notifier provided
/// inside one route is invisible to the next. A flow whose screens have to
/// share one live instance — a quote, a pending authorization — has had to
/// register it as a singleton instead, which then lives for the rest of the
/// session. [GtSharedState] gives that instance a lifetime matching the
/// flow's: the host registers the holder as the singleton, and each route of
/// the flow holds it through [GtStateSource.shared]. The notifier is made when
/// the first route mounts and disposed after the last one unmounts.
///
/// ```dart
/// // Registration: the holder lives for the app, the notifier does not.
/// locator.registerLazySingleton<GtSharedState<TransferState>>(
///   () => GtSharedState(() => TransferState(locator())),
/// );
///
/// // Every route of the flow.
/// GtLocalStateWrapper<TransferState>(
///   shared: locator(),
///   builder: (state) => TransferAmountScreen(state: state),
/// )
/// ```
///
/// A sheet or dialog is a route of its own and does not see the page's
/// provider, so a sheet that needs the notifier holds it the same way, with
/// its own `shared:` wrapper. The page underneath keeps holding it while the
/// sheet is open.
///
/// A route wrapper whose builder returns a page built outside it, rather than
/// a page built from the notifier, rebuilds nothing on notification except
/// the widgets that watch the notifier through the context. That is the
/// cheaper shape for a notifier a whole flow shares.
///
/// Disposal waits for the end of the frame in which the last holder let go,
/// so a replacement route that takes hold in that same frame, as
/// `pushReplacementNamed` and `pushNamedAndRemoveUntil` can arrange, keeps the
/// instance instead of receiving a new one.
class GtSharedState<T extends ChangeNotifier> {
  /// Makes the notifier when the first holder takes hold.
  final ValueGetter<T> _create;

  /// The live notifier, or `null` while nothing holds it.
  T? _state;

  /// How many subtrees currently hold [current].
  int _holders = 0;

  /// Creates a [GtSharedState] that makes its notifier with [create].
  ///
  /// [create] runs again each time the notifier is needed after a previous
  /// one was disposed, so every run must return a fresh instance.
  GtSharedState(ValueGetter<T> create) : _create = create;

  /// The live notifier, or `null` when nothing holds one.
  ///
  /// Reading it never creates a notifier, which makes it the safe target for a
  /// session reset: `holder.current?.reset()` clears a flow in progress and
  /// does nothing otherwise.
  T? get current => _state;

  /// How many subtrees currently hold the notifier.
  int get holders => _holders;

  /// Takes hold of the notifier, making it if nothing held one, and returns
  /// it.
  ///
  /// Every call must be balanced by exactly one [release].
  /// [GtLocalStateWrapper] and its siblings do both for a
  /// [GtStateSource.shared] source.
  T acquire() {
    _holders++;
    return _state ??= _create();
  }

  /// Lets go of the notifier, and disposes it at the end of the frame if
  /// nothing has taken hold of it again by then.
  void release() {
    assert(_holders > 0, 'release() called more often than acquire().');
    _holders--;
    if (_holders > 0) return;
    SchedulerBinding.instance.addPostFrameCallback((_) => _disposeIfUnheld());
    SchedulerBinding.instance.ensureVisualUpdate();
  }

  /// Disposes the notifier unless a holder has taken hold since [release].
  void _disposeIfUnheld() {
    if (_holders > 0) return;
    final state = _state;
    _state = null;
    state?.dispose();
  }
}
