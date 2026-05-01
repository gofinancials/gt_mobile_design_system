import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A utility class for configuring and presenting adaptive bottom sheets.
///
/// Supports standard static sheets as well as draggable/scrollable sheets.
class GtBottomSheet<T> {
  /// Creates a standard [GtBottomSheet] containing the given [modalWidget].
  GtBottomSheet({
    required this.context,
    required this.modalWidget,
    this.isDismissable = true,
    this.canDragToClose = true,
    this.isScrollable = false,
    this.canPop = true,
    this.useRootNavigator = false,
    double maxHeightFraction = .9,
  }) : _builder = null,
       maxChildSize = maxHeightFraction,
       minChildSize = .3,
       initialChildSize = .9,
       _isDraggble = false;

  /// Creates a draggable [GtBottomSheet] whose size can be adjusted by the user.
  ///
  /// The [builder] provides a [ScrollController] that should be attached to the
  /// primary scrollable view within the sheet. Constrained by [minChildSize],
  /// [initialChildSize], and [maxChildSize].
  GtBottomSheet.draggable({
    required this.context,
    required ValueBuilder<ScrollController> builder,
    this.minChildSize = .3,
    this.initialChildSize = .7,
    this.maxChildSize = .9,
    this.useRootNavigator = false,
  }) : _isDraggble = true,
       modalWidget = const Offstage(),
       isScrollable = true,
       canPop = true,
       canDragToClose = true,
       isDismissable = true,
       _builder = builder,
       assert(maxChildSize >= .1 && maxChildSize <= 1),
       assert(minChildSize >= 0 && minChildSize <= 1),
       assert(initialChildSize >= .1 && initialChildSize <= 1);

  /// The builder used for draggable sheets to provide a [ScrollController].
  final ValueBuilder<ScrollController>? _builder;

  /// The build context used to access the theme and design tokens.
  final BuildContext context;

  /// The content displayed inside a standard (non-draggable) bottom sheet.
  final Widget modalWidget;

  /// The initial fractional size of the draggable sheet relative to the screen height.
  final double initialChildSize;

  /// The maximum fractional size of the sheet relative to the screen height.
  final double maxChildSize;

  /// The minimum fractional size of the draggable sheet relative to the screen height.
  final double minChildSize;

  /// Whether the user can dismiss the sheet by tapping the scrim background.
  final bool isDismissable;

  /// Whether the user can dismiss the sheet by dragging it downwards.
  final bool canDragToClose;

  /// Whether the sheet should be pushed onto the root navigator instead of the nested one.
  final bool useRootNavigator;

  /// Internal flag tracking if the sheet is in draggable mode.
  final bool _isDraggble;

  /// Whether the system back button or back gesture can close the sheet.
  final bool canPop;

  /// Whether the underlying standard sheet behaves as a scroll-controlled sheet.
  final bool isScrollable;

  /// The color of the modal barrier that darkens the background behind the sheet.
  Color get barrierColor => context.palette.faded.darker.setOpacity(.45);

  /// Presents the configured bottom sheet.
  ///
  /// Adapts automatically between mobile and desktop configurations. Returns a
  /// [Future] that resolves to the value `T` passed when popping the sheet.
  Future<T?> present(BuildContext context) async {
    GtOverlay.closeCurrentOverlays();
    GtRouter.openedModal();

    if (!context.isMobile) return _presentDesktopSheet(context);
    return _presentMobileSheet(context);
  }

  Future<T?> _presentMobileSheet(BuildContext context) async {
    Widget child = Builder(
      builder: (context) {
        if (_isDraggble) {
          return DraggableScrollableSheet(
            initialChildSize: initialChildSize,
            maxChildSize: maxChildSize,
            minChildSize: minChildSize,
            builder: (context, scrollController) {
              return _GtSheetContainer(child: _builder!(scrollController));
            },
          );
        }
        return GtPopScope(
          canPop: canPop,
          child: _GtSheetContainer(
            constraints: BoxConstraints(
              maxHeight: context.height * maxChildSize,
              minHeight: context.height * minChildSize,
            ),
            child: modalWidget,
          ),
        );
      },
    );

    if (!context.isIos) {
      return showCupertinoSheet<T>(
        context: context,
        builder: (context) => child,
        useNestedNavigation: useRootNavigator,
        enableDrag: canDragToClose,
        showDragHandle: canDragToClose,
      );
    }

    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissable,
      enableDrag: canDragToClose,
      isScrollControlled: isScrollable,
      backgroundColor: Colors.transparent,
      barrierColor: barrierColor,
      useRootNavigator: useRootNavigator,
      constraints: BoxConstraints.expand(width: double.infinity),
      builder: (context) => child,
    );
  }

  Future<T?> _presentDesktopSheet(BuildContext context) async {
    return showAdaptiveDialog<T>(
      context: context,
      barrierDismissible: isDismissable,
      barrierColor: barrierColor,
      useRootNavigator: useRootNavigator,
      anchorPoint: context.position,
      builder: (context) {
        final constraints = BoxConstraints(
          maxWidth: 500,
          maxHeight: context.height * maxChildSize,
          minHeight: context.height * minChildSize,
        );
        if (_isDraggble) {
          return DraggableScrollableSheet(
            initialChildSize: initialChildSize,
            maxChildSize: maxChildSize,
            minChildSize: minChildSize,
            builder: (context, scrollController) {
              return _GtSheetContainer(
                constraints: constraints,
                alignment: .center,
                borderRadius: context.borderRadius4Xl,
                child: _builder!(scrollController),
              );
            },
          );
        }
        return GtPopScope(
          canPop: canPop,
          child: _GtSheetContainer(
            constraints: constraints,
            alignment: .center,
            borderRadius: context.borderRadius4Xl,
            child: modalWidget,
          ),
        );
      },
    );
  }
}

/// Internal wrapper widget that styles the sheet container (background, corners, margins).
class _GtSheetContainer extends GtStatelessWidget {
  final BorderRadius? borderRadius;
  final BoxConstraints? constraints;
  final AlignmentGeometry alignment;
  final Widget child;

  const _GtSheetContainer({
    this.borderRadius,
    this.constraints,
    this.alignment = .bottomCenter,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final defaultRadius = BorderRadius.vertical(top: context.radius4Xl);
    return Material(
      type: .transparency,
      child: Align(
        alignment: alignment,
        child: Container(
          margin: !context.isMobile ? context.insets.defaultAllInsets : .zero,
          decoration: BoxDecoration(
            color: context.palette.bg.white,
            borderRadius: borderRadius ?? defaultRadius,
          ),
          constraints: constraints,
          child: child,
        ),
      ),
    );
  }
}
