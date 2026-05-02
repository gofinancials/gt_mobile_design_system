import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// An adaptive confirmation dialog for the design system.
///
/// Displays a [title], an optional [description], and two action buttons
/// (allow and deny). It automatically adapts its layout to the current platform
/// (Cupertino for iOS/macOS, Material for others).
class GtConfirmDialog extends GtStatelessWidget {
  /// The primary title of the confirmation dialog.
  final String title;

  /// An optional detailed description or message displayed below the title.
  final String? description;

  /// The text label for the affirmative/allow action button. Defaults to "Yes".
  final String? allowText;

  /// The text label for the negative/deny action button. Defaults to "No".
  final String? denyText;

  /// The callback triggered when the user taps the allow action.
  final OnPressed onContinue;

  /// Creates a [GtConfirmDialog].
  const GtConfirmDialog({
    super.key,
    this.denyText,
    this.allowText,
    this.description,
    required this.title,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    Widget? content;
    if (description != null) {
      content = GtText(
        description,
        style: context.textStyles.bodyXs(color: context.palette.text.sub),
      );
    }
    return AlertDialog.adaptive(
      title: GtText(title),
      content: content,
      backgroundColor: context.palette.bg.white,
      actions: [
        GtConfirmDialogAction(
          key: const Key("gt-dialog-cancel-btn"),
          text: denyText ?? "no".ctr(),
          onTap: GtRouter.popView,
          destructive: true,
        ),
        GtConfirmDialogAction(
          key: const Key("gt-dialog-allow-btn"),
          text: allowText ?? "yes".ctr(),
          onTap: () {
            Navigator.of(context).pop();
            onContinue.call();
          },
        ),
      ],
    );
  }
}

/// A responsive action button used within the [GtConfirmDialog].
class GtConfirmDialogAction extends GtStatelessWidget {
  /// The text label displayed on the button.
  final String text;

  /// Whether this action performs a destructive operation (e.g., deleting data).
  /// 
  /// If true, the text is typically colored with the theme's error color.
  final bool destructive;

  /// The callback executed when the button is tapped.
  final OnPressed onTap;

  /// Creates a [GtConfirmDialogAction].
  const GtConfirmDialogAction({
    super.key,
    required this.text,
    this.destructive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.palette;
    final textColor = destructive ? colors.error.base : null;
    final child = GtText(text, style: context.textStyles.bodyS(color: textColor));
    if (context.isIos || context.isMacos) {
      return CupertinoDialogAction(
        onPressed: onTap,
        isDefaultAction: !destructive,
        isDestructiveAction: destructive,
        child: child,
      );
    }
    return TextButton(onPressed: onTap, child: child);
  }
}

/// A mixin that provides a convenience method for displaying a [GtConfirmDialog].
mixin GtConfirmDialogMixin {
  /// Presents an adaptive confirmation dialog.
  ///
  /// Requires a [title] and an [onContinue] callback. You can optionally provide
  /// a [description], custom [allowText], and custom [denyText]. The dialog can
  /// be dismissed by tapping the barrier if [isDismissable] is true (default).
  void confirmAction(
    BuildContext context, {
    String? allowText,
    String? denyText,
    String? description,
    required String title,
    bool isDismissable = true,
    required OnPressed onContinue,
  }) async {
    showAdaptiveDialog(
      context: context,
      barrierDismissible: isDismissable,
      useRootNavigator: true,
      builder: (context) {
        GtRouter.openedModal();
        return GtConfirmDialog(
          key: ValueKey(Object.hash(title, allowText, denyText, description)),
          title: title,
          description: description,
          onContinue: onContinue,
          allowText: allowText,
          denyText: denyText,
        );
      },
    );
  }
}
