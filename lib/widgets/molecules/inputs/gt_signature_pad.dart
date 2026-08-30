import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A controller-driven drawing surface for capturing a customer's signature.
///
/// The drawing gesture is not an accessible input method for screen-reader or
/// limited-mobility users. [onSecondaryAction] is therefore required and is
/// exposed as a labelled, keyboard-reachable upload action.
///
/// {@category Molecules}
class GtSignaturePad extends GtStatefulWidget {
  /// Default canvas height from the onboarding signature design.
  static const double defaultHeight = 207;

  /// Default logical stroke width.
  static const double defaultStrokeWidth = 2;

  /// Controller that owns scribble, history, and encoded image state.
  ///
  /// When omitted, the widget creates and disposes an internal controller.
  final GtSignaturePadController? controller;

  /// Called after a completed drawing state is encoded, and with `null` when
  /// an existing signature is cleared.
  final OnChanged<Uint8List?>? onChanged;

  /// Primary empty-state instruction.
  final String title;

  /// Supporting empty-state instruction.
  final String subtitle;

  /// Visual rendered inside the secondary action target.
  ///
  /// This is treated as presentation only; [onSecondaryAction] owns activation
  /// and [secondaryActionSemanticLabel] owns its accessible name. It defaults
  /// to the design-system upload-folder glyph.
  final Widget? secondaryAction;

  /// Opens the accessible alternative signature input, such as a file picker.
  ///
  /// When omitted, tapping the secondary action automatically opens the native
  /// device image picker via [AppImagePlugin.pickImage].
  final OnPressed? onSecondaryAction;

  /// Accessible name announced for the secondary action.
  final String secondaryActionSemanticLabel;

  /// Height in design pixels, converted through `context.dp(height.px)`.
  final double? height;

  /// Signature stroke color. Defaults to the theme's strong text color.
  final Color? strokeColor;

  /// Canvas fill color. Defaults to the theme's soft background color.
  final Color? backgroundColor;

  /// Stroke width in design pixels, converted through `context.dp(width.px)`.
  final double strokeWidth;

  /// Called when the built-in clear action removes the current signature.
  final OnPressed? onClear;

  /// Whether drawing and history/upload actions are interactive.
  final bool isEnabled;

  /// Accessible name for the drawing surface.
  final String semanticsLabel;

  /// Accessible explanation of the drawing surface and its alternative.
  final String semanticsHint;

  /// Accessible name for the built-in undo action.
  final String undoSemanticLabel;

  /// Accessible name for the built-in redo action.
  final String redoSemanticLabel;

  /// Accessible name for the built-in clear action.
  final String clearSemanticLabel;

  /// Creates a signature pad.
  const GtSignaturePad({
    super.key,
    this.controller,
    this.onChanged,
    required this.title,
    required this.subtitle,
    this.secondaryAction,
    this.onSecondaryAction,
    this.secondaryActionSemanticLabel = 'Upload a signature instead',
    this.height,
    this.strokeColor,
    this.backgroundColor,
    this.strokeWidth = defaultStrokeWidth,
    this.onClear,
    this.isEnabled = true,
    required this.semanticsLabel,
    required this.semanticsHint,
    required this.undoSemanticLabel,
    required this.redoSemanticLabel,
    required this.clearSemanticLabel,
  }) : assert(height == null || height > 0),
       assert(strokeWidth > 0),
       assert(title.length > 0),
       assert(subtitle.length > 0),
       assert(secondaryActionSemanticLabel.length > 0),
       assert(semanticsLabel.length > 0),
       assert(semanticsHint.length > 0),
       assert(undoSemanticLabel.length > 0),
       assert(redoSemanticLabel.length > 0),
       assert(clearSemanticLabel.length > 0);

  @override
  State<GtSignaturePad> createState() => _GtSignaturePadState();
}

class _GtSignaturePadState extends State<GtSignaturePad> {
  late GtSignaturePadController _controller;

  @override
  void initState() {
    super.initState();
    _attachController(widget.controller ?? GtSignaturePadController());
  }

  @override
  void didUpdateWidget(covariant GtSignaturePad oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller == widget.controller) return;

    _controller.imageListenable.removeListener(_notifyImageChanged);
    if (oldWidget.controller == null) _controller.dispose();
    _attachController(widget.controller ?? GtSignaturePadController());
  }

  @override
  void dispose() {
    _controller.imageListenable.removeListener(_notifyImageChanged);
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  void _attachController(GtSignaturePadController controller) {
    _controller = controller;
    _controller.imageListenable.addListener(_notifyImageChanged);
  }

  void _notifyImageChanged() {
    widget.onChanged?.call(_controller.bytes);
  }

  Offset _boundedPoint(Offset point, Size size) {
    return Offset(
      point.dx.clamp(0, size.width).toDouble(),
      point.dy.clamp(0, size.height).toDouble(),
    );
  }

  void _clear() {
    if (!widget.isEnabled) return;
    _controller.clear();
    widget.onClear?.call();
  }

  Future<void> _handleSecondaryAction() async {
    if (!widget.isEnabled) return;
    if (widget.onSecondaryAction != null) {
      widget.onSecondaryAction!();
    } else {
      await _controller.pickImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final canvasHeight =
        widget.height ?? context.dp(GtSignaturePad.defaultHeight.px);
    final canvasColor = widget.backgroundColor ?? palette.bg.soft;
    final signatureColor = widget.strokeColor ?? palette.text.strong;

    return GtDisabledOverlay(
      !widget.isEnabled,
      child: GtSizedBox(
        width: double.infinity,
        height: canvasHeight,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final canvasSize = constraints.biggest;
            return Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                Positioned.fill(
                  child: RepaintBoundary(
                    key: _controller.repaintBoundaryKey,
                    child: ColoredBox(
                      color: canvasColor,
                      child: Semantics(
                        label: widget.semanticsLabel,
                        hint: widget.semanticsHint,
                        enabled: widget.isEnabled,
                        child: MouseRegion(
                          cursor: widget.isEnabled
                              ? SystemMouseCursors.precise
                              : SystemMouseCursors.forbidden,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onPanStart: widget.isEnabled
                                ? (details) {
                                    _controller.beginStroke(
                                      _boundedPoint(
                                        details.localPosition,
                                        canvasSize,
                                      ),
                                    );
                                  }
                                : null,
                            onPanUpdate: widget.isEnabled
                                ? (details) {
                                    _controller.appendPoint(
                                      _boundedPoint(
                                        details.localPosition,
                                        canvasSize,
                                      ),
                                    );
                                  }
                                : null,
                            onPanEnd: widget.isEnabled
                                ? (_) => _controller.endStroke()
                                : null,
                            onPanCancel: widget.isEnabled
                                ? _controller.endStroke
                                : null,
                            child: CustomPaint(
                              painter: GtSignaturePainter(
                                controller: _controller,
                                strokeColor: signatureColor,
                                strokeWidth: widget.strokeWidth,
                              ),
                              child: const SizedBox.expand(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                GenericListener<GtSignaturePadValue>(
                  valueListenable: _controller,
                  builder: (state) {
                    final image = state.image;
                    if (image == null) return const SizedBox.shrink();
                    return Positioned.fill(
                      child: Padding(
                        padding: context.insets.allDp(12.px),
                        child: GtImage(
                          image: AppImageData.bytes(image),
                          fit: BoxFit.contain,
                          isDecorative: true,
                        ),
                      ),
                    );
                  },
                ),
                GenericListener<GtSignaturePadValue>(
                  valueListenable: _controller,
                  builder: (state) {
                    if (!state.isEmpty) return const SizedBox.shrink();
                    return Positioned.fill(
                      child: IgnorePointer(child: _Placeholder(widget: widget)),
                    );
                  },
                ),
                PositionedDirectional(
                  start: 0,
                  top: context.dp(context.spacing.xs.px),
                  child: _SignatureActionTarget(
                    semanticsLabel: widget.secondaryActionSemanticLabel,
                    isEnabled: widget.isEnabled,
                    onPressed: _handleSecondaryAction,
                    child:
                        widget.secondaryAction ??
                        GtIcon(GtIcons.uploadFolder, size: context.dp(20.px)),
                  ),
                ),
                GenericListener<GtSignaturePadValue>(
                  valueListenable: _controller,
                  builder: (state) {
                    if (!state.canUndo && !state.canRedo && !state.isImage) {
                      return const SizedBox.shrink();
                    }
                    return PositionedDirectional(
                      end: context.dp(context.spacing.sm.px),
                      top: 0,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (state.strokes.isNotEmpty ||
                              state.redoStrokes.isNotEmpty) ...[
                            _SignatureHistoryAction(
                              icon: GtIcons.rotateAnticlockwise,
                              semanticsLabel: widget.undoSemanticLabel,
                              isEnabled: widget.isEnabled && state.canUndo,
                              onPressed: _controller.undo,
                            ),
                            _SignatureHistoryAction(
                              icon: GtIcons.rotateAnticlockwise,
                              flipHorizontally: true,
                              semanticsLabel: widget.redoSemanticLabel,
                              isEnabled: widget.isEnabled && state.canRedo,
                              onPressed: _controller.redo,
                            ),
                          ],
                          _SignatureHistoryAction(
                            icon: GtIcons.trash,
                            semanticsLabel: widget.clearSemanticLabel,
                            isEnabled: widget.isEnabled && state.hasSignature,
                            onPressed: _clear,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Placeholder extends GtStatelessWidget {
  final GtSignaturePad widget;

  const _Placeholder({required this.widget});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: context.insets.symmetricDp(
          horizontal: context.spacing.sectionMd.px,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GtText(
              widget.title,
              style: context.textStyles.subHeadS(
                color: context.palette.text.strong,
                weight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const GtGap.ySm(),
            const GtGap.yXs(),
            GtText(
              widget.subtitle,
              style: context.textStyles.subHeadXs(
                color: context.palette.text.darkerSub,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _SignatureActionTarget extends GtStatelessWidget {
  final Widget child;
  final String semanticsLabel;
  final bool isEnabled;
  final OnPressed onPressed;

  const _SignatureActionTarget({
    required this.child,
    required this.semanticsLabel,
    required this.isEnabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: context.dp(GtTapTarget.defaultMinSize.width.px),
      child: GtInkWell(
        role: .button,
        semanticsLabel: semanticsLabel,
        excludeDescendantSemantics: true,
        isEnabled: isEnabled,
        onTap: onPressed,
        child: Center(child: ExcludeSemantics(child: child)),
      ),
    );
  }
}

class _SignatureHistoryAction extends GtStatelessWidget {
  final IconData icon;
  final String semanticsLabel;
  final bool isEnabled;
  final OnPressed onPressed;
  final bool flipHorizontally;

  const _SignatureHistoryAction({
    required this.icon,
    required this.semanticsLabel,
    required this.isEnabled,
    required this.onPressed,
    this.flipHorizontally = false,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    Widget iconWidget = GtIcon.withColor(
      icon,
      size: context.dp(14.px),
      color: isEnabled ? palette.icon.sub : palette.icon.disabled,
    );
    if (flipHorizontally) {
      iconWidget = Transform.flip(flipX: true, child: iconWidget);
    }

    return SizedBox.square(
      dimension: context.dp(GtTapTarget.defaultMinSize.width.px),
      child: Center(
        child: SizedBox.square(
          dimension: context.dp(28.px),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: palette.bg.weak,
              shape: BoxShape.circle,
            ),
            child: GtInkWell(
              role: .button,
              semanticsLabel: semanticsLabel,
              excludeDescendantSemantics: true,
              isEnabled: isEnabled,
              customBorder: const CircleBorder(),
              onTap: onPressed,
              child: Center(child: ExcludeSemantics(child: iconWidget)),
            ),
          ),
        ),
      ),
    );
  }
}
