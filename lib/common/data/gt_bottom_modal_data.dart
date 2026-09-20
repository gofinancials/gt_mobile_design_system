import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';

/// Represents the current state or phase of the bottom modal.
enum GtBottomModalPhase {
  /// The modal is currently processing an asynchronous task.
  loading,

  /// The asynchronous task completed successfully.
  success,

  /// The asynchronous task encountered an error.
  error,

  /// The modal is in a default or resting state.
  idle;

  /// Returns `true` if the phase is [loading].
  bool get isLoading => this == loading;
}

/// A data class for configuring the content of a bottom modal.
class GtBottomModalData extends AppEquatable {
  /// The main title text of the modal.
  final String title;

  /// An optional icon to display.
  final AppImageData? icon;

  /// An optional description text displayed below the title.
  final String? description;

  /// Creates a [GtBottomModalData] instance.
  const GtBottomModalData({required this.title, this.description, this.icon});

  /// Creates a copy of this object with the given fields replaced with new values.
  GtBottomModalData copyWith({
    String? title,
    String? description,
    AppImageData? icon,
  }) {
    return GtBottomModalData(
      icon: icon ?? this.icon,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [title, description, icon];
}

/// Controller for driving [GtBottomModal] state transitions.
///
/// This keeps the bottom modal independent from overlay logic and can be
/// triggered from button presses in any screen/use case.
///
/// The controller also owns the modal it is shown with.
/// [GtBottomModalMixin.showTaskBottomModal] binds the pushed route to the
/// controller, so [complete] takes the modal down on its own and [dismiss]
/// closes it on demand. Both remove *this* controller's route rather than
/// whatever is on top of the navigator, so a route pushed over the modal while
/// the task ran — a confirmation, a re-authentication prompt — survives.
///
/// [T] is the type of the payload the task produces, so [onComplete] receives a
/// `TaskResponse<T>` and callers can branch on it without casting.
class GtBottomModalController<T> extends ChangeNotifier {
  /// Debouncer used to delay the execution of the completion callback.
  final AppDebouncer _debouncer;

  /// The initial, unmodified data provided to the controller, used for resetting.
  final GtBottomModalData _pristineData;

  /// The current data for the bottom modal.
  GtBottomModalData _data;

  /// A completer used to track the lifecycle and result of the asynchronous task.
  Completer<TaskResponse<T>> _completer;

  /// The progress of the task, typically a value between 0.0 and 1.0.
  double? _progress;

  /// A callback executed when the associated task completes.
  final OnChanged<TaskResponse<T>>? _completionCallback;

  /// The final result (success or failure) of the completed task.
  TaskResponse<T>? _completionValue;

  /// Whether a failed task leaves its modal on screen for the caller to close.
  ///
  /// Defaults to `false`: a failure takes the modal down just as a success does.
  /// Flows that show the error inside the modal set this and close it later with
  /// [dismiss].
  final bool keepOpenOnFailure;

  /// Resolves with the route of the modal this controller is shown in.
  ///
  /// Completed from the modal's builder, which runs a frame after the route is
  /// pushed, so this is never awaited on its own — see [dismiss].
  Completer<Route<dynamic>>? _routeCompleter;

  /// The route this controller's modal was pushed as, once it has built.
  ///
  /// Held alongside [_routeCompleter] so [isModalCurrent] can be answered
  /// synchronously, which a completion callback needs.
  Route<dynamic>? _route;

  /// The future of the presentation itself, which resolves once the route has
  /// been popped — including when it was popped before it ever built.
  Future<void>? _presentation;

  /// Whether [dispose] has run. Guards the callbacks and notifications that
  /// outlive a screen: a task that lands after its screen is gone.
  bool _isDisposed = false;

  /// Resolves once this controller has finished with a task — see [settled].
  Completer<void> _settled = Completer<void>();

  /// Creates a [GtBottomModalController] associated with an asynchronous task.
  GtBottomModalController({
    required GtBottomModalData data,
    OnChanged<TaskResponse<T>>? onComplete,
    required Duration onCompleteDelay,
    this.keepOpenOnFailure = false,
    double? progress,
  }) : _data = data,
       _pristineData = data,
       _progress = progress,
       _completer = Completer(),
       _completionCallback = onComplete,
       _debouncer = AppDebouncer(onCompleteDelay);

  /// Binds this controller to the modal route it is being shown in.
  ///
  /// Called by [GtBottomModalMixin.showTaskBottomModal] from the modal's
  /// builder. Builders re-run, so only the first call is recorded.
  void attachRoute(Route<dynamic> route) {
    _route = route;
    final completer = _routeCompleter;
    if (completer == null || completer.isCompleted) return;
    completer.complete(route);
  }

  /// Whether this controller's modal is the surface the customer is on.
  ///
  /// A modal still on screen covers the screen that opened it, so that screen
  /// is no longer the navigator's current route. Anything deciding whether the
  /// customer is still where the task started has to count this modal as part
  /// of that screen rather than as something the customer navigated to —
  /// otherwise a modal held open by [keepOpenOnFailure] reads as the customer
  /// having left, and the failure it is displaying is never reported.
  ///
  /// A modal that has been pushed but has not built yet counts too: it has no
  /// route to ask, but it is on its way to the top of the navigator, and a
  /// task that completes that fast — a cached read, a rejected input — must not
  /// be treated as the customer having navigated away.
  bool get isModalCurrent {
    final route = _route;
    if (route != null) return route.isCurrent;
    return isPresented;
  }

  /// Binds this controller to the presentation of its modal.
  ///
  /// Called by [GtBottomModalMixin.showTaskBottomModal] with the future the
  /// route was pushed with, which resolves once that route is gone.
  void attachPresentation(Future<void> presentation) {
    _routeCompleter ??= Completer<Route<dynamic>>();
    _presentation ??= presentation;
  }

  /// Whether this controller has been bound to a modal that has not yet closed.
  ///
  /// Showing a controller that is already presented would stack a second modal
  /// over the first, so [GtBottomModalMixin.showTaskBottomModal] returns the
  /// running presentation instead.
  bool get isPresented => _presentation != null;

  /// Resolves once this controller's modal is gone, or immediately if it was
  /// never shown.
  ///
  /// Owners that created the controller for a single task wait on this before
  /// calling [dispose], so a modal kept open by [keepOpenOnFailure] is not left
  /// listening to a disposed controller.
  Future<void> get closed => _presentation ?? Future<void>.value();

  /// Resolves once this controller has finished with the task it is driving:
  /// the completion delay has elapsed, the modal has been taken down if it is
  /// going to be, and the completion callback has run.
  ///
  /// Also resolves when the controller is [reset] or [dispose]d with a task
  /// still in flight, so anything sequencing work behind a task — a runner
  /// waiting to report its outcome — is released rather than left waiting on a
  /// completion that is never coming.
  Future<void> get settled => _settled.future;

  /// Resolves [settled], if nothing has yet.
  void _markSettled() {
    if (_settled.isCompleted) return;
    _settled.complete();
  }

  /// Closes this controller's modal, if it is still on screen.
  ///
  /// Pops when the modal is the top route and removes it in place otherwise, so
  /// a route pushed over it is never the one that goes. Resolves once the route
  /// has left the navigator, which is also what happens when the customer
  /// dismisses the modal themselves — so this is safe to call either way.
  Future<void> dismiss() => _dismissRoute(_routeCompleter, _presentation);

  /// Releases the modal this controller is bound to and forgets it.
  ///
  /// The binding is read before it is cleared, so a controller that is reset or
  /// disposed while its modal is still on screen takes that modal down with it
  /// rather than leaving a blocking route nothing owns any more.
  void _releaseModal() {
    final completer = _routeCompleter;
    final presentation = _presentation;
    _routeCompleter = null;
    _presentation = null;
    _route = null;
    unawaited(_dismissRoute(completer, presentation));
  }

  /// Closes the route held by [completer], if it is still on screen.
  ///
  /// Takes the binding as arguments rather than reading the fields, so it can
  /// outlive the binding being cleared — see [_releaseModal].
  static Future<void> _dismissRoute(
    Completer<Route<dynamic>>? completer,
    Future<void>? presentation,
  ) async {
    if (completer == null || presentation == null) return;

    // The route is pushed synchronously but only reaches [attachRoute] when the
    // modal first builds, a frame later. A zero-delay completion can land in
    // between, so this waits for whichever comes first: the route, or the
    // presentation resolving because the modal is already gone.
    final route = await Future.any<Route<dynamic>?>([
      completer.future,
      presentation.then((_) => null),
    ]);

    if (route == null || !route.isActive) return;
    final navigator = route.navigator;
    if (navigator == null) return;

    if (route.isCurrent) {
      navigator.pop();
    } else {
      navigator.removeRoute(route);
    }

    await route.popped;
  }

  /// Completes the task with the given [value] and triggers the completion callback.
  ///
  /// After the completion delay the modal is taken down — unless [value] is a
  /// failure and [keepOpenOnFailure] is set — and the completion callback runs
  /// once the route is gone, so a callback that navigates does so from the
  /// screen underneath rather than from on top of a closing modal.
  ///
  /// If [breakIfAlreadyCompleted] is true and the task is already completed, this does nothing.
  void complete(TaskResponse<T> value, {bool breakIfAlreadyCompleted = true}) {
    if (_isDisposed) return;
    final isCompleted = _completer.isCompleted;
    if (breakIfAlreadyCompleted && isCompleted) return;
    if (isCompleted) _completer = Completer();
    _completer.complete(value);
    _completionValue = value;
    _notify();
    // [value] is held here rather than read back from `_completer` when the
    // debounce fires: a [reset] or a second completion in the meantime swaps
    // the completer for an unresolved one, and awaiting that would strand the
    // callback forever.
    _debouncer.run(() async {
      final keepOpen = value is TaskFailure<T> && keepOpenOnFailure;
      if (!keepOpen) await dismiss();
      if (_isDisposed) return;
      _completionCallback?.call(value);
      _markSettled();
    });
  }

  /// Updates the controller's state with new values and notifies listeners.
  ///
  /// * [data]: The new modal data to apply.
  /// * [progress]: The new progress value to apply.
  /// * [completer]: The new task completer to apply.
  void copyWithin({
    GtBottomModalData? data,
    double? progress,
    Completer<TaskResponse<T>>? completer,
  }) {
    _data = data ?? _data;
    _progress = progress ?? _progress;
    _completer = completer ?? _completer;

    _notify();
  }

  /// Notifies listeners unless this controller has been disposed.
  ///
  /// A task outlives the screen that started it often enough that notifying a
  /// disposed controller is a normal race rather than a programming error.
  void _notify() {
    if (_isDisposed) return;
    notifyListeners();
  }

  /// The current progress of the task.
  double? get progress => _progress;

  /// Returns the current progress as a formatted percentage string (e.g., "45").
  String get percentage {
    return ((progress ?? 0) * 100).toStringAsFixed(0);
  }

  /// Sets the progress and notifies listeners.
  set progress(double? value) {
    _progress = value;
    _notify();
  }

  /// The current modal data.
  GtBottomModalData get data => _data;

  /// Sets the modal data and notifies listeners.
  set data(GtBottomModalData value) {
    _data = value;
    _notify();
  }

  /// Updates the main title and notifies listeners.
  set title(String value) {
    _data = _data.copyWith(title: value);
    _notify();
  }

  /// The current title from the modal data.
  String get title => data.title;

  /// The current icon from the modal data.
  AppImageData? get icon => _data.icon;

  /// Updates the icon and notifies listeners.
  set icon(AppImageData? value) {
    _data = _data.copyWith(icon: value);
    _notify();
  }

  /// The current description, prioritizing the [errorMessage] if an error occurred,
  /// otherwise falling back to the description from the modal data.
  String? get description => errorMessage ?? _data.description;

  /// Updates the description and notifies listeners.
  set description(String? value) {
    _data = _data.copyWith(description: value);
    _notify();
  }

  /// Whether this controller has been disposed.
  ///
  /// Disposing is how an owner says it is finished with the task: the modal
  /// comes down and anything sequencing work behind the task stops reporting
  /// into a screen that is no longer interested.
  bool get isDisposed => _isDisposed;

  /// Whether progress is currently being tracked.
  bool get hasProgress => _progress != null;

  /// Whether the associated task is currently loading.
  bool get isLoading => !_completer.isCompleted;

  /// Whether the associated task has encountered an error.
  bool get hasError => _completionValue is TaskFailure;

  /// Whether the associated task has completed successfully with data.
  bool get isSuccessful => _completionValue is TaskSuccess;

  /// The error message from the associated task, if an error occurred.
  String? get errorMessage => _completionValue?.error?.message;

  /// Computes the current [GtBottomModalPhase] based on the task's state.
  GtBottomModalPhase get phase {
    if (isLoading) return GtBottomModalPhase.loading;
    if (isSuccessful) return GtBottomModalPhase.success;
    if (hasError) return GtBottomModalPhase.error;
    return GtBottomModalPhase.idle;
  }

  /// Resets the controller to its initial state, restoring pristine data, clearing progress, and resetting the task completer.
  ///
  /// A modal still on screen is taken down first, so a controller reused for a
  /// second task neither holds the closed route of the first nor strands a
  /// modal that nothing owns any more.
  void reset() {
    _data = _pristineData;
    _progress = null;
    _completer = Completer();
    _completionValue = null;
    _debouncer.abort();
    _releaseModal();
    _markSettled();
    _settled = Completer<void>();
    _notify();
  }

  /// Cleans up resources, aborts any pending debounced callbacks, and disposes the controller.
  ///
  /// A modal still on screen goes with it: a screen disposed while its task
  /// modal is on the root navigator would otherwise leave a blocking modal
  /// behind with nothing left to close it.
  @override
  void dispose() {
    _isDisposed = true;
    _debouncer.abort();
    _data = _pristineData;
    _progress = null;
    _completer = Completer();
    _completionValue = null;
    _releaseModal();
    _markSettled();
    super.dispose();
  }
}
