import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

///
/// @category Templates
class GtTooltip extends GtOverlay {
  OverlayEntry? _entry;
  bool _inserted = false;

  GtTooltip.of(super.context);

  void show(
    String title, {
    required message,
    required Widget anchorWidget,
    required BuildContext anchorContext,
  }) {
    runThrowableTask(() {
      if (_entry != null || _inserted) return;
      super.closeExistingOverlays();

      _entry = OverlayEntry(
        opaque: false,
        builder: (context) {
          final pos = anchorContext.overlayPosition(context);
          return GestureDetector(
            onTap: close,
            child: Material(
              color: context.palette.bg.strong.setOpacity(0.17),
              child: GtTooltipWidget(
                title,
                message: message,
                anchorPosition: pos.anchorPosition,
                anchorRect: pos.anchorRect,
                onClose: close,
                anchorWidget: anchorWidget,
                overlayBoxConstraints: pos.overlayBoxConstraints,
              ),
            ),
          );
        },
      );
      _inserted = true;
      super.present(entry: _entry!, instance: this);
    }, onError: close);
  }

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

class GtTooltipWidget extends GtStatelessWidget {
  final String title;
  final String message;
  final Offset anchorPosition;
  final Rect anchorRect;
  final OnPressed onClose;
  final Widget anchorWidget;
  final BoxConstraints overlayBoxConstraints;

  const GtTooltipWidget(
    this.title, {
    required this.message,
    required this.anchorPosition,
    required this.onClose,
    required this.anchorWidget,
    required this.anchorRect,
    required this.overlayBoxConstraints,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final offset = anchorPosition;
    final size = anchorRect.size;
    final screenHeight = context.height;

    // Determine if the widget is in the upper half of the screen
    final isCloserToTop = offset.dy < (screenHeight / 2);

    // Vertical spacing
    final tipSpacing = context.dp(9.px);
    final cardSpacing = context.dp(15.px);

    // Calculate vertical positions based on the widget's location
    final topPositionForTip = offset.dy + size.height + tipSpacing;
    final topPositionForCard = offset.dy + size.height + cardSpacing;

    final bottomPositionForTip = (screenHeight - offset.dy) + tipSpacing;
    final bottomPositionForCard = (screenHeight - offset.dy) + cardSpacing;

    // Calculate horizontal positions to center the tip and keep the card on screen
    final tipOffset = anchorRect.left + (size.width * .9);

    return ConstrainedBox(
      constraints: overlayBoxConstraints,
      child: Stack(
        children: [
          Positioned.fromRect(rect: anchorRect, child: anchorWidget),
          Positioned(
            top: isCloserToTop ? topPositionForTip : null,
            bottom: !isCloserToTop ? bottomPositionForTip : null,
            left: tipOffset,
            child: Transform.rotate(
              angle: pi / 4,
              child: DecoratedBox(
                decoration: BoxDecoration(color: context.palette.bg.white),
                child: GtSquareBox(size: 20),
              ),
            ),
          ),
          Positioned(
            top: isCloserToTop ? topPositionForCard : null,
            bottom: !isCloserToTop ? bottomPositionForCard : null,
            left: anchorRect.left - context.dp(16.px),
            child: GtCard(
              padding: context.insets.allDp(12.px),
              borderRadius: context.borderRadiusXl,
              color: context.palette.bg.white,
              constraints: BoxConstraints(maxWidth: 272),
              child: GtBaseListTileTemplate(
                title: GtText(title),
                subtitle: GtText(
                  message,
                  style: context.textStyles.bodyXs(
                    color: context.palette.text.darkerSub,
                  ),
                ),
                spacing: context.spacingMd,
                leading: GtIcon(GtIcons.circleInfo, variant: .soft),
                trailing: GtCancelButton(onTap: onClose, size: 15),
                crossAxisAlignment: .start,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GtTooltipWrapper extends GtStatefulWidget {
  final Widget child;
  final String tooltipTitle;
  final String tooltipMessage;

  const GtTooltipWrapper({
    super.key,
    required this.child,
    required this.tooltipTitle,
    required this.tooltipMessage,
  });

  @override
  State<StatefulWidget> createState() => _GtTooltipWrapperState();
}

class _GtTooltipWrapperState extends State<GtTooltipWrapper> with RouteAware {
  GtTooltip? _tooltip;

  void _closeTooltip() => _tooltip?.close();

  @override
  void didPop() {
    _closeTooltip();
    super.didPop();
  }

  @override
  void didPushNext() {
    _closeTooltip();
    super.didPushNext();
  }

  @override
  void didPopNext() {
    _closeTooltip();
    super.didPopNext();
  }

  @override
  void dispose() {
    _closeTooltip();
    super.dispose();
  }

  @override
  Widget build(BuildContext parentContext) {
    return UnconstrainedBox(
      child: LayoutBuilder(
        key: ValueKey("gt-tooltip-layout-builder"),
        builder: (context, constraints) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_tooltip != null) return;
            _tooltip = GtTooltip.of(context);
          });
          return GestureDetector(
            key: Key("gt-tooltip-getsture-detector"),
            onTapDown: (details) {
              _tooltip?.show(
                widget.tooltipTitle,
                message: widget.tooltipMessage,
                anchorWidget: widget.child,
                anchorContext: context,
              );
            },
            child: widget.child,
          );
        },
      ),
    );
  }
}
