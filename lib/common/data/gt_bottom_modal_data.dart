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

  /// The title text to display when the modal is in the success phase.
  final String? successTitle;

  /// The title text to display when the modal is in the error phase.
  final String? errorTitle;

  /// An optional icon to display.
  final AppImageData? icon;

  /// An optional description text displayed below the title.
  final String? description;

  /// Creates a [GtBottomModalData] instance.
  const GtBottomModalData({
    required this.title,
    this.description,
    this.icon,
    this.successTitle,
    this.errorTitle,
  });

  /// Creates a copy of this object with the given fields replaced with new values.
  GtBottomModalData copyWith({
    String? title,
    String? description,
    AppImageData? icon,
    String? successTitle,
    String? errorTitle,
  }) {
    return GtBottomModalData(
      icon: icon ?? this.icon,
      title: title ?? this.title,
      description: description ?? this.description,
      successTitle: successTitle ?? this.successTitle,
      errorTitle: errorTitle ?? this.errorTitle,
    );
  }

  @override
  List<Object?> get props => [
    title,
    description,
    icon,
    successTitle,
    errorTitle,
  ];
}

/// Controller for driving [GtLoaderBottomModal] state transitions.
///
/// This keeps the bottom modal independent from overlay logic and can be
/// triggered from button presses in any screen/use case.
class GtBottomModalController extends ChangeNotifier {
  /// The current data for the bottom modal.
  GtBottomModalData _data;

  /// An optional notifier for tracking an asynchronous task.
  ValueNotifier<AsyncData>? _taskNotifier;

  /// The progress of the task, typically a value between 0.0 and 1.0.
  double? _progress;

  /// A callback executed when the associated task completes.
  final OnChanged<AsyncData>? _completionCallback;

  /// The delay before executing the [_completionCallback] after the task finishes.
  final Duration? _completionCallbackDelay;

  /// Creates a [GtBottomModalController] associated with an asynchronous task.
  GtBottomModalController({
    required GtBottomModalData data,
    required ValueNotifier<AsyncData> taskNotifier,
    required OnChanged<AsyncData> onComplete,
    required Duration onCompleteDelay,
    double? progress,
  }) : _data = data,
       _progress = progress,
       _taskNotifier = taskNotifier,
       _completionCallback = onComplete,
       _completionCallbackDelay = onCompleteDelay;

  /// Updates the controller's state with new values and notifies listeners.
  void copyWithin({
    GtBottomModalData? data,
    double? progress,
    ValueNotifier<AsyncData>? taskNotifier,
  }) {
    _data = data ?? _data;
    _progress = progress ?? _progress;
    _taskNotifier = taskNotifier ?? _taskNotifier;

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
  String get title {
    final text = data.title;
    if (task == null) return text;
    return switch (phase) {
      .success => data.successTitle ?? data.title,
      .error => data.errorTitle ?? data.title,
      _ => text,
    };
  }

  /// Updates the title displayed during the error phase and notifies listeners.
  set errorTitle(String value) {
    _data = _data.copyWith(errorTitle: value);
    notifyListeners();
  }

  /// Updates the title displayed during the success phase and notifies listeners.
  set successTitle(String value) {
    _data = _data.copyWith(successTitle: value);
    notifyListeners();
  }

  /// The current icon from the modal data.
  AppImageData? get icon => _data.icon;

  /// Updates the icon and notifies listeners.
  set icon(AppImageData? value) {
    _data = _data.copyWith(icon: value);
    notifyListeners();
  }

  /// The current description from the modal data.
  String? get description => errorMessage ?? _data.description;

  /// Updates the description and notifies listeners.
  set description(String? value) {
    _data = _data.copyWith(description: value);
    notifyListeners();
  }

  /// The notifier for the asynchronous task.
  ValueNotifier<AsyncData>? get taskNotifier => _taskNotifier;

  /// A callback executed when the associated task completes.
  OnChanged<AsyncData>? get onComplete => _completionCallback;

  /// The delay before executing the [_completionCallback] after the task finishes.
  Duration? get completionDelay => _completionCallbackDelay;

  /// Sets the task notifier and notifies listeners.
  set taskNotifier(ValueNotifier<AsyncData>? value) {
    _taskNotifier = value;
    notifyListeners();
  }

  /// The current [AsyncData] value from the task notifier, if any.
  AsyncData? get task => _taskNotifier?.value;

  /// Whether a task is currently associated with this controller.
  bool get hasTask => task != null;

  /// Whether progress is currently being tracked.
  bool get hasProgress => _progress != null;

  /// Whether the associated task is currently loading.
  bool get isLoading => task?.isLoading ?? false;

  /// Whether the associated task has encountered an error.
  bool get hasError => task?.hasError ?? false;

  /// Whether the associated task has completed successfully with data.
  bool get isSuccessful => task?.hasData ?? false;

  /// The error message from the associated task, if an error occurred.
  String? get errorMessage => task?.error?.message;

  /// Computes the current [GtBottomModalPhase] based on the task's state.
  GtBottomModalPhase get phase {
    if (isLoading) return GtBottomModalPhase.loading;
    if (isSuccessful) return GtBottomModalPhase.success;
    if (hasError) return GtBottomModalPhase.error;
    return GtBottomModalPhase.idle;
  }

  /// Resets the controller to its initial state, clearing progress and task notifier.
  void reset() {
    _data = GtBottomModalData(
      title: _data.title,
      description: _data.description,
      icon: _data.icon,
    );
    _progress = null;
    _taskNotifier = null;
  }

  @override
  void dispose() {
    reset();
    super.dispose();
  }
}
