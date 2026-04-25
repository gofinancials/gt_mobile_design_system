import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A utility class for managing and displaying toast overlays in the GT Mobile Design System.
class GtToast extends GtOverlay {
  OverlayEntry? _entry;
  bool _inserted = false;

  /// Creates a [GtToast] instance associated with the given context.
  GtToast.of(super.context) : super(closableOnNavigation: false);

  /// Displays a toast overlay with the specified [message].
  ///
  /// Automatically dismisses after the given [duration] (in milliseconds).
  /// Can optionally include an [icon] and a visual [type] (defaults to [GtPillVariant.strong]).
  void show(
    String message, {
    IconData? icon,
    int duration = 3000,
    GtPillVariant? type,
  }) {
    Duration timeout = duration.milliseconds;
    runThrowableTask(() {
      if (_entry != null || _inserted) return;
      super.closeExistingOverlays();

      _entry = OverlayEntry(
        opaque: false,
        builder: (context) {
          return GtToastOverlay(message, icon: icon, type: type ?? .strong);
        },
      );
      _inserted = true;
      super.present(entry: _entry!, instance: this);
      Timer(timeout, close);
    }, onError: close);
  }

  /// Manually closes the currently displayed toast overlay, if any.
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

/// The visual representation of a toast overlay.
///
/// Typically used internally by [GtToast] to render the notification on screen.
class GtToastOverlay extends GtStatelessWidget {
  /// The text message displayed in the toast.
  final String message;

  /// An optional icon displayed next to the message.
  final IconData? icon;

  /// The visual variant of the toast, determining its overall styling.
  final GtPillVariant type;

  /// Creates a [GtToastOverlay].
  const GtToastOverlay(
    this.message, {
    required this.type,
    this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.palette.bg.strong.setOpacity(.17),
      child: SafeArea(
        minimum: context.insets.defaultHorizontalInsets,
        bottom: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: GtButtonPill(
            text: message,
            variant: type,
            icon: icon,
            showShadow: true,
            alignment: .topCenter,
            size: .larger,
          ),
        ),
      ),
    );
  }
}
