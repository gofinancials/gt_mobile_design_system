import 'package:flutter/cupertino.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// One choice offered by a [GtActionSheet].
class GtActionSheetAction {
  /// The label the choice is shown with.
  final String label;

  /// Called once the sheet has closed, when the customer picks this choice.
  final OnPressed onPressed;

  /// Whether this is the choice the customer is most likely to want, set in
  /// a heavier weight.
  final bool isDefault;

  /// Whether this choice destroys something, such as deleting a document,
  /// set in the error colour.
  final bool isDestructive;

  /// The key given to the tappable choice, for finding it in tests.
  ///
  /// Defaults to `gt-action-sheet-action-<index>`, by the choice's position
  /// in [GtActionSheet.actions]. Pass one of your own when the order of the
  /// choices can change.
  final Key? key;

  /// Creates a [GtActionSheetAction].
  const GtActionSheetAction({
    required this.label,
    required this.onPressed,
    this.isDefault = false,
    this.isDestructive = false,
    this.key,
  });
}

/// An adaptive action sheet: a short list of choices anchored to the bottom
/// of the screen, with a separate Cancel.
///
/// On iOS and macOS it is the native [CupertinoActionSheet]: the optional
/// [title] and [message] over the [actions], each in the brand colour, and
/// Cancel set apart beneath them in the button face. Everywhere else it is
/// the same content laid out for a floating design system bottom sheet.
///
/// Picking a choice or Cancel pops the sheet's route with the chosen
/// [GtActionSheetAction], or with null for Cancel. It never runs the choice
/// itself; [GtActionSheetMixin.showActionSheet] presents the sheet and runs
/// the chosen [GtActionSheetAction.onPressed] once the sheet has closed, and
/// is the usual way to show one.
///
/// Each choice is keyed by its [GtActionSheetAction.key], and Cancel by
/// [cancelKey], so tests can find them on either platform.
class GtActionSheet extends GtStatelessWidget {
  /// The key given to the Cancel button.
  static const cancelKey = Key('gt-action-sheet-cancel');

  /// An optional heading over the [message].
  final String? title;

  /// An optional question or explanation over the [actions], such as
  /// "How would you like to export your statement?".
  final String? message;

  /// The choices, in the order they are shown. Must not be empty.
  final List<GtActionSheetAction> actions;

  /// The label of the Cancel button. Defaults to the localised "cancel".
  final String? cancelLabel;

  /// Creates a [GtActionSheet].
  const GtActionSheet({
    required this.actions,
    this.title,
    this.message,
    this.cancelLabel,
    super.key,
  }) : assert(actions.length > 0, 'GtActionSheet requires an action');

  /// The key of the choice at [index], its own when it carries one.
  static Key keyOf(GtActionSheetAction action, int index) {
    return action.key ?? ValueKey('gt-action-sheet-action-$index');
  }

  /// The colour a choice's label is set in: the error colour for a
  /// destructive choice, and otherwise the brand.
  ///
  /// In light mode the brand is [GtPaletteBrandColors.base], as drawn. In dark
  /// mode it is [GtPalette.opPrimaryInk]: the dark palettes deepen `base` so
  /// it can carry white button labels, which leaves it too dark to read as
  /// text on a dark sheet.
  static Color labelColor(BuildContext context, GtActionSheetAction action) {
    final palette = context.palette;
    if (action.isDestructive) return palette.error.base;
    if (context.isInDarkMode) return palette.opPrimaryInk;
    return palette.primary.base;
  }

  /// The style of a choice's label: 16/22 in [labelColor], heavier for the
  /// default choice.
  static TextStyle labelStyle(
    BuildContext context,
    GtActionSheetAction action,
  ) {
    return context.textStyles.bodyM(
      heightPx: 22,
      color: labelColor(context, action),
      weight: action.isDefault ? .w600 : null,
    );
  }

  /// The resolved Cancel label.
  String get resolvedCancelLabel => cancelLabel ?? 'cancel'.ctr();

  @override
  Widget build(BuildContext context) {
    if (context.isIos || context.isMacos) {
      return _GtCupertinoActionSheet(sheet: this);
    }
    return _GtMaterialActionSheet(sheet: this);
  }
}

/// The native iOS and macOS form of a [GtActionSheet].
class _GtCupertinoActionSheet extends GtStatelessWidget {
  /// The sheet whose content is drawn.
  final GtActionSheet sheet;

  /// Creates a [_GtCupertinoActionSheet].
  const _GtCupertinoActionSheet({required this.sheet});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final navigator = Navigator.of(context);

    Widget? title;
    if (sheet.title case String text when text.hasValue) {
      title = GtText(
        text,
        textAlign: .center,
        style: context.textStyles.bodyXs(
          weight: .w600,
          color: palette.text.strong,
        ),
      );
    }

    Widget? message;
    if (sheet.message case String text when text.hasValue) {
      message = GtText(
        text,
        textAlign: .center,
        style: context.textStyles.bodyXs(
          weight: .w500,
          color: palette.text.strong,
        ),
      );
    }

    return CupertinoActionSheet(
      title: title,
      message: message,
      actions: [
        for (final (index, action) in sheet.actions.indexed)
          CupertinoActionSheetAction(
            key: GtActionSheet.keyOf(action, index),
            isDefaultAction: action.isDefault,
            isDestructiveAction: action.isDestructive,
            onPressed: () => navigator.pop(action),
            child: GtText(
              action.label,
              textAlign: .center,
              style: GtActionSheet.labelStyle(context, action),
            ),
          ),
      ],
      cancelButton: CupertinoActionSheetAction(
        key: GtActionSheet.cancelKey,
        onPressed: navigator.pop,
        child: GtText(
          sheet.resolvedCancelLabel.upper,
          style: context.textStyles.button(color: palette.text.strong),
        ),
      ),
    );
  }
}

/// The design system bottom sheet form of a [GtActionSheet], used off iOS
/// and macOS.
///
/// Laid out as the native sheet is: the heading and message centred over the
/// choices, each a full-width row ruled off from the one above, and Cancel
/// beneath them in the button face.
class _GtMaterialActionSheet extends GtStatelessWidget {
  /// The sheet whose content is drawn.
  final GtActionSheet sheet;

  /// Creates a [_GtMaterialActionSheet].
  const _GtMaterialActionSheet({required this.sheet});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final navigator = Navigator.of(context);
    final rule = BorderSide(color: palette.stroke.soft, width: 0.5);

    final header = [
      if (sheet.title case String text when text.hasValue)
        GtText(
          text,
          textAlign: .center,
          style: context.textStyles.bodyM(
            weight: .w600,
            color: palette.text.strong,
          ),
        ),
      if (sheet.message case String text when text.hasValue)
        GtText(
          text,
          textAlign: .center,
          style: context.textStyles.bodyXs(
            weight: .w500,
            color: palette.text.sub,
          ),
        ),
    ];

    return Padding(
      padding: context.insets.fromLTRBDp(16.px, 16.px, 16.px, 8.px),
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        children: [
          if (header.isNotEmpty)
            Padding(
              padding: context.insets.onlyDp(bottom: 16.px),
              child: Column(
                spacing: context.spacingXs,
                crossAxisAlignment: .stretch,
                children: header,
              ),
            ),
          for (final (index, action) in sheet.actions.indexed)
            GtInkWell(
              key: GtActionSheet.keyOf(action, index),
              role: GtSemanticRole.button,
              onTap: () => navigator.pop(action),
              child: Container(
                constraints: BoxConstraints(minHeight: context.dp(48.px)),
                alignment: .center,
                padding: context.insets.symmetricDp(vertical: 11.px),
                decoration: BoxDecoration(border: Border(top: rule)),
                child: GtText(
                  action.label,
                  textAlign: .center,
                  style: GtActionSheet.labelStyle(context, action),
                ),
              ),
            ),
          DecoratedBox(
            decoration: BoxDecoration(border: Border(top: rule)),
            child: Padding(
              padding: context.insets.onlyDp(top: 8.px),
              child: GtTextButton(
                key: GtActionSheet.cancelKey,
                text: sheet.resolvedCancelLabel,
                textColor: palette.text.strong,
                onPressed: navigator.pop,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A mixin that provides a convenience method for presenting a
/// [GtActionSheet], as [GtConfirmDialogMixin.confirmAction] does for a
/// confirmation.
mixin GtActionSheetMixin {
  /// Presents an adaptive action sheet offering [actions], and runs the one
  /// the customer picks.
  ///
  /// On iOS and macOS the native action sheet rises from the bottom of the
  /// root navigator; elsewhere a floating design system bottom sheet does.
  /// Either way the caller's themes are carried across, so the sheet keeps
  /// the brand of the screen that opened it. See [GtActionSheet] for [title],
  /// [message] and [cancelLabel].
  ///
  /// The sheet closes before the chosen [GtActionSheetAction.onPressed] runs,
  /// so a choice that pushes a route or opens another sheet does so from the
  /// screen, not from over the action sheet. Tapping outside the sheet
  /// dismisses it like Cancel when [isDismissable] is true (the default).
  ///
  /// Resolves, once the choice has run, with the chosen action, or with null
  /// when the sheet was cancelled or dismissed.
  Future<GtActionSheetAction?> showActionSheet(
    BuildContext context, {
    required List<GtActionSheetAction> actions,
    String? title,
    String? message,
    String? cancelLabel,
    bool isDismissable = true,
  }) async {
    final sheet = GtActionSheet(
      key: ValueKey(('gt-action-sheet', title, message)),
      title: title,
      message: message,
      actions: actions,
      cancelLabel: cancelLabel,
    );

    final GtActionSheetAction? chosen;
    if (context.isIos || context.isMacos) {
      GtOverlay.closeCurrentOverlays();
      context.resetFocus();
      // `showCupertinoModalPopup` pushes onto the root navigator without the
      // [InheritedTheme.capture] the Material routes do, so a
      // [GtThemedScope] below it would be lost. Carrying the themes across by
      // hand keeps the sheet in the brand of the screen that opened it.
      final themes = context.capturedThemes();
      chosen = await showCupertinoModalPopup<GtActionSheetAction>(
        context: context,
        barrierDismissible: isDismissable,
        builder: (_) => themes.wrap(sheet),
      );
    } else {
      chosen = await GtBottomSheet<GtActionSheetAction>(
        context: context,
        modalWidget: sheet,
        isDismissable: isDismissable,
        canDragToClose: isDismissable,
        minHeightFraction: 0,
        floating: true,
      ).present(context);
    }

    chosen?.onPressed();
    return chosen;
  }
}
