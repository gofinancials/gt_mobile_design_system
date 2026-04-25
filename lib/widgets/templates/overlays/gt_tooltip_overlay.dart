import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtTooltip extends GtOverlay {
  OverlayEntry? _entry;
  bool _inserted = false;

  GtTooltip.of(super.context);

  void show(
    String title, {
    required message,
    required Offset anchorPosition,
    required Size anchorSize,
    required Widget anchorWidget,
  }) {
    runThrowableTask(() {
      if (_entry != null || _inserted) return;
      super.closeExistingOverlays();

      _entry = OverlayEntry(
        opaque: false,
        builder: (context) {
          return GestureDetector(
            onTap: close,
            child: Material(
              color: context.palette.bg.strong.setOpacity(0.17),
              child: GtTooltipWidget(
                title,
                message: message,
                anchorPosition: anchorPosition,
                anchorSize: anchorSize,
                onClose: close,
                anchorWidget: anchorWidget,
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
  final Size anchorSize;
  final OnPressed onClose;
  final Widget anchorWidget;

  const GtTooltipWidget(
    this.title, {
    required this.message,
    required this.anchorPosition,
    required this.onClose,
    required this.anchorWidget,
    required this.anchorSize,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final offset = anchorPosition;
    final size = anchorSize;
    final screenHeight = context.height;
    final screenWidth = context.width;

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
    final tipSize = context.dp(20.px);
    final anchorCenterX = offset.dx + (size.width / 2);
    final tipLeftPosition = anchorCenterX - (tipSize / 2);

    // Determine if the widget is in the left half of the screen
    final isCloserToLeft = anchorCenterX < (screenWidth / 2);

    final maxCardWidth = 280.0;
    final edgePadding = context.dp(16.px);

    double? cardLeftPosition;
    double? cardRightPosition;

    if (isCloserToLeft) {
      final maxLeft = max(
        edgePadding,
        screenWidth - maxCardWidth - edgePadding,
      );
      cardLeftPosition = offset.dx.clamp(edgePadding, maxLeft);
    } else {
      final maxRight = max(
        edgePadding,
        screenWidth - maxCardWidth - edgePadding,
      );
      final anchorRightDistance = screenWidth - (offset.dx + size.width);
      cardRightPosition = anchorRightDistance.clamp(edgePadding, maxRight);
    }

    return Stack(
      children: [
        Positioned(
          left: offset.dx,
          top: offset.dy,
          width: size.width,
          height: size.height,
          child: anchorWidget,
        ),
        Positioned(
          top: isCloserToTop ? topPositionForTip : null,
          bottom: !isCloserToTop ? bottomPositionForTip : null,
          left: tipLeftPosition,
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
          left: cardLeftPosition,
          right: cardRightPosition,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxCardWidth),
            child: GtCard(
              padding: context.insets.allDp(12.px),
              borderRadius: context.borderRadiusXl,
              color: context.palette.bg.white,
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
        ),
      ],
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
    return LayoutBuilder(
      key: Key("gt-tooltip-layout-builder"),
      builder: (context, constraints) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_tooltip != null) return;
          _tooltip = GtTooltip.of(context);
        });
        return GestureDetector(
          key: Key("gt-tooltip-getsture-detector"),
          onTapDown: (details) {
            final size = context.size ?? Size.zero;

            _tooltip?.show(
              widget.tooltipTitle,
              message: widget.tooltipMessage,
              anchorPosition: context.position,
              anchorSize: size,
              anchorWidget: widget.child,
            );
          },
          child: widget.child,
        );
      },
    );
  }
}
