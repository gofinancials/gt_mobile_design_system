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
class GtBottomModalController extends ChangeNotifier {
  /// Debouncer used to delay the execution of the completion callback.
  final AppDebouncer _debouncer;

  /// The initial, unmodified data provided to the controller, used for resetting.
  final GtBottomModalData _pristineData;

  /// The current data for the bottom modal.
  GtBottomModalData _data;

  /// A completer used to track the lifecycle and result of the asynchronous task.
  Completer<TaskResponse> _completer;

  /// The progress of the task, typically a value between 0.0 and 1.0.
  double? _progress;

  /// A callback executed when the associated task completes.
  final OnChanged<TaskResponse>? _completionCallback;

  /// The final result (success or failure) of the completed task.
  TaskResponse? _completionValue;

  /// Creates a [GtBottomModalController] associated with an asynchronous task.
  GtBottomModalController({
    required GtBottomModalData data,
    required OnChanged<TaskResponse> onComplete,
    required Duration onCompleteDelay,
    double? progress,
  }) : _data = data,
       _pristineData = data,
       _progress = progress,
       _completer = Completer(),
       _completionCallback = onComplete,
       _debouncer = AppDebouncer(onCompleteDelay);

  /// Completes the task with the given [value] and triggers the completion callback.
  ///
  /// If [breakIfAlreadyCompleted] is true and the task is already completed, this does nothing.
  void complete(TaskResponse value, {bool breakIfAlreadyCompleted = true}) {
    final isCompleted = _completer.isCompleted;
    if (breakIfAlreadyCompleted && isCompleted) return;
    if (_completer.isCompleted) _completer = Completer();
    _completer.complete(value);
    _completionValue = value;
    notifyListeners();
    _debouncer.run(() async {
      _completionCallback?.call(await _completer.future);
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
    Completer<TaskResponse>? completer,
  }) {
    _data = data ?? _data;
    _progress = progress ?? _progress;
    _completer = completer ?? _completer;

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
    notifyListeners();
  }

  /// The current modal data.
  GtBottomModalData get data => _data;

  /// Sets the modal data and notifies listeners.
  set data(GtBottomModalData value) {
    _data = value;
    notifyListeners();
  }

  /// Updates the main title and notifies listeners.
  set title(String value) {
    _data = _data.copyWith(title: value);
    notifyListeners();
  }

  /// The current title from the modal data.
  String get title => data.title;

  /// The current icon from the modal data.
  AppImageData? get icon => _data.icon;

  /// Updates the icon and notifies listeners.
  set icon(AppImageData? value) {
    _data = _data.copyWith(icon: value);
    notifyListeners();
  }

  /// The current description, prioritizing the [errorMessage] if an error occurred,
  /// otherwise falling back to the description from the modal data.
  String? get description => errorMessage ?? _data.description;

  /// Updates the description and notifies listeners.
  set description(String? value) {
    _data = _data.copyWith(description: value);
    notifyListeners();
  }

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
  void reset() {
    _data = _pristineData;
    _progress = null;
    _completer = Completer();
    _completionValue = null;
    _debouncer.abort();
    notifyListeners();
  }

  /// Cleans up resources, aborts any pending debounced callbacks, and disposes the controller.
  @override
  void dispose() {
    _debouncer.abort();
    super.dispose();
  }
}
