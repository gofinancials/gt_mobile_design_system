import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A utility class for managing and displaying alert overlays in the GT Mobile Design System.
class GtAlert extends GtOverlay {
  OverlayEntry? _entry;
  bool _inserted = false;

  /// Creates a [GtAlert] instance associated with the given context.
  GtAlert.of(super.context) : super(closableOnNavigation: false);

  /// Displays an alert overlay with the specified [title] and [message].
  ///
  /// Automatically dismisses after the given [duration] (in milliseconds).
  /// The visual style is determined by the [type] (defaults to [GtNotificationVariant.error]).
  void show(
    String title, {
    required String message,
    int duration = 3000,
    GtNotificationVariant? type,
  }) {
    Duration timeout = duration.milliseconds;
    runThrowableTask(() {
      if (_entry != null || _inserted) return;
      super.closeExistingOverlays();

      _entry = OverlayEntry(
        opaque: false,
        builder: (context) {
          return GtAlertOverlay(
            title,
            message: message,
            type: type ?? .error,
            onClose: close,
          );
        },
      );
      _inserted = true;
      super.present(entry: _entry!, instance: this);
      Timer(timeout, close);
    }, onError: close);
  }

  /// Manually closes the currently displayed alert overlay, if any.
  @override
  close() {
    tryRunThrowableTask(() {
      if (_entry != null && _inserted) {
        _entry?.remove();
        _entry = null;
        _inserted = false;
      }
    });
  }
}

/// The visual representation of an alert overlay.
///
/// Typically used internally by [GtAlert] to render the notification.
class GtAlertOverlay extends GtStatelessWidget {
  /// The main title text of the alert.
  final String title;

  /// The detailed message text of the alert.
  final String message;

  /// The visual variant of the notification, determining its color and icon.
  final GtNotificationVariant type;

  /// Callback triggered when the user dismisses the alert.
  final OnPressed onClose;

  /// Creates a [GtAlertOverlay].
  const GtAlertOverlay(
    this.title, {
    required this.type,
    required this.message,
    required this.onClose,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.palette.bg.strong.setOpacity(.17),
      child: SafeArea(
        bottom: false,
        minimum: context.insets.defaultHorizontalInsets,
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            GtNotificationCard(
              title: title,
              subtitle: message,
              onClose: onClose,
              variant: type,
            ),
          ],
        ),
      ),
    );
  }
}
