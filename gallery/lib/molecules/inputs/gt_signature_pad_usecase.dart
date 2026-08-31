import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'GtSignaturePad',
  type: GtSignaturePad,
  designLink:
      'https://www.figma.com/design/EE0KNJdpCKsQGoLFyLrC2v/Personal?node-id=5838-32397&m=dev',
)
Widget playgroundGtSignaturePadUseCase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Tap to draw your signature',
  );
  final subtitle = context.knobs.string(
    label: 'Subtitle',
    initialValue: 'Use your finger or a stylus to sign here',
  );
  final height = context.knobs.double.slider(
    label: 'Height',
    initialValue: GtSignaturePad.defaultHeight,
    min: 160,
    max: 320,
  );
  final strokeWidth = context.knobs.double.slider(
    label: 'Stroke width',
    initialValue: GtSignaturePad.defaultStrokeWidth,
    min: 1,
    max: 8,
  );
  final isEnabled = context.knobs.boolean(label: 'Enabled', initialValue: true);

  return GtWidgetDocPage(
    title: 'GtSignaturePad',
    description: '''
<b>GtSignaturePad</b> captures freehand signature strokes and supports native image selection via <b>AppImagePlugin</b>.
The controller manages drawing, undo/redo history, and imported images, exposing the result as bytes or base64.''',
    accessibilityNotes: const [
      'Drawing is a pointer-only interaction and is not usable with a screen reader or for every motor ability.',
      'The secondary upload action opens the native device image picker, or an accessible alternative if overridden.',
      'Keep the upload action label specific to the accepted signature format and workflow.',
    ],
    code: '''
final signatureController = GtSignaturePadController();

GtSignaturePad(
  controller: signatureController,
  title: l10n.signaturePadTitle,
  subtitle: l10n.signaturePadSubtitle,
  // Automatically opens native image picker when onSecondaryAction is omitted:
  secondaryActionSemanticLabel: l10n.uploadSignatureLabel,
  semanticsLabel: l10n.signatureCanvasLabel,
  semanticsHint: l10n.signatureCanvasHint,
  undoSemanticLabel: l10n.undoSignatureLabel,
  redoSemanticLabel: l10n.redoSignatureLabel,
  clearSemanticLabel: l10n.clearSignatureLabel,
  onChanged: (pngBytes) {},
);

// Programmatic image import via AppImagePlugin:
await signatureController.pickImage();
// Or direct bytes:
signatureController.setImage(imageBytes);

final bytes = signatureController.bytes;
final base64 = signatureController.base64;
final freshBytes = await signatureController.toUint8List();
final freshBase64 = await signatureController.toBase64();''',
    child: _SignaturePadPreview(
      title: title,
      subtitle: subtitle,
      height: height,
      strokeWidth: strokeWidth,
      isEnabled: isEnabled,
    ),
  );
}

class _SignaturePadPreview extends GtStatefulWidget {
  final String title;
  final String subtitle;
  final double height;
  final double strokeWidth;
  final bool isEnabled;

  const _SignaturePadPreview({
    required this.title,
    required this.subtitle,
    required this.height,
    required this.strokeWidth,
    required this.isEnabled,
  });

  @override
  State<_SignaturePadPreview> createState() => _SignaturePadPreviewState();
}

class _SignaturePadPreviewState extends State<_SignaturePadPreview> {
  final GtSignaturePadController _controller = GtSignaturePadController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GtSignaturePad(
          controller: _controller,
          title: widget.title,
          subtitle: widget.subtitle,
          height: widget.height,
          strokeWidth: widget.strokeWidth,
          isEnabled: widget.isEnabled,
          secondaryActionSemanticLabel: 'Upload a signature instead',
          semanticsLabel: 'Signature drawing area',
          semanticsHint:
              'Draw with a finger or stylus, or use the upload signature action.',
          undoSemanticLabel: 'Undo signature stroke',
          redoSemanticLabel: 'Redo signature stroke',
          clearSemanticLabel: 'Clear signature',
        ),
        const GtGap.yBase(),
        GenericListener<GtSignaturePadValue>(
          valueListenable: _controller,
          builder: (state) {
            final status = switch ((
              state.isImage,
              state.hasSignature,
              state.isCapturing,
            )) {
              (_, _, true) => 'Encoding PNG…',
              (true, _, _) => 'Signature imported from image · ready',
              (false, true, false) => 'Signature drawn · undo available',
              (false, false, false) when state.canRedo =>
                'Signature undone · redo available',
              _ => 'Waiting for a signature (draw or tap upload)',
            };
            return GtText(
              status,
              style: context.textStyles.bodyXs(
                color: context.palette.text.darkerSub,
              ),
            );
          },
        ),
      ],
    );
  }
}
