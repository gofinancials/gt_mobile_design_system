import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';

/// A single continuous stroke drawn on a [GtSignaturePadController].
@immutable
class GtSignatureStroke {
  /// The ordered canvas-local points that make up this stroke.
  final List<Offset> points;

  /// Creates an immutable signature stroke from [points].
  GtSignatureStroke(Iterable<Offset> points)
    : points = List<Offset>.unmodifiable(points);

  /// Returns a new stroke with [point] appended.
  GtSignatureStroke add(Offset point) {
    return GtSignatureStroke([...points, point]);
  }
}

/// Immutable drawing and history state managed by [GtSignaturePadController].
@immutable
class GtSignaturePadValue {
  /// Completed strokes currently visible on the canvas.
  final List<GtSignatureStroke> strokes;

  /// Strokes available to restore through redo.
  final List<GtSignatureStroke> redoStrokes;

  /// Whether a pointer is currently adding points to the latest stroke.
  final bool isDrawing;

  /// Whether the current drawing is being encoded as a PNG.
  final bool isCapturing;

  /// The raw bytes of an imported or uploaded signature image.
  final Uint8List? image;

  /// Creates signature pad state.
  GtSignaturePadValue({
    Iterable<GtSignatureStroke> strokes = const [],
    Iterable<GtSignatureStroke> redoStrokes = const [],
    this.isDrawing = false,
    this.isCapturing = false,
    this.image,
  }) : strokes = List<GtSignatureStroke>.unmodifiable(strokes),
       redoStrokes = List<GtSignatureStroke>.unmodifiable(redoStrokes);

  /// Whether no signature marks or images are currently visible.
  bool get isEmpty => strokes.isEmpty && image == null;

  /// Whether at least one signature mark or uploaded image is currently visible.
  bool get hasSignature => !isEmpty;

  /// Whether the signature is backed by an imported image.
  bool get isImage => image != null;

  /// Whether the latest visible stroke can be removed.
  bool get canUndo => strokes.isNotEmpty;

  /// Whether the latest undone stroke can be restored.
  bool get canRedo => redoStrokes.isNotEmpty;
}

/// Controls the drawing, history, and PNG output of a signature pad.
///
/// The controller is the source of truth for the scribble and imported signature images.
/// It also owns the foundation [ScreenShotService] used to rasterize the keyed drawing boundary.
/// [bytes] and [base64] synchronously expose the latest completed capture or imported image;
/// [toUint8List] and [toBase64] request a fresh asynchronous capture.
class GtSignaturePadController extends ValueNotifier<GtSignaturePadValue> {
  static const double _minimumPointDistanceSquared = .25;

  final ScreenShotService _screenShotService;
  final ValueNotifier<Uint8List?> _imageNotifier = ValueNotifier(null);

  int _captureGeneration = 0;
  bool _isDisposed = false;

  /// Creates an empty signature controller.
  GtSignaturePadController({ScreenShotService? screenShotService})
    : _screenShotService = screenShotService ?? ScreenShotService(),
      super(GtSignaturePadValue());

  /// The boundary key used by [ScreenShotService] to capture only the drawing.
  ///
  /// Consumers normally do not need this; [GtSignaturePad] binds it for them.
  GlobalKey get repaintBoundaryKey => _screenShotService.screenShotKey;

  /// Emits whenever a newly encoded PNG becomes available or the pad clears.
  ValueListenable<Uint8List?> get imageListenable => _imageNotifier;

  /// The latest PNG-encoded or imported signature, or `null` before capture or after clear.
  ///
  /// A defensive copy is returned so caller mutation cannot corrupt the cache.
  Uint8List? get bytes {
    if (value.image != null) return _copyBytes(value.image);
    return _copyBytes(_imageNotifier.value);
  }

  /// The latest PNG-encoded or imported signature as base64, or `null` when unavailable.
  String? get base64 {
    final data = bytes;
    return data == null ? null : base64Encode(data);
  }

  /// Whether the pad currently contains at least one visible stroke or imported image.
  bool get hasSignature => value.hasSignature;

  /// Whether the current signature is backed by an imported image.
  bool get isImage => value.isImage;

  /// Whether a visible stroke can be removed.
  bool get canUndo => value.canUndo;

  /// Whether an undone stroke can be restored.
  bool get canRedo => value.canRedo;

  /// Sets an imported signature image and clears existing strokes.
  void setImage(Uint8List? image) {
    _invalidateCapture();
    value = GtSignaturePadValue(image: image);
    _setImage(image);
  }

  /// Opens the device's native image selector and sets the selected image as signature.
  ///
  /// Returns `true` if an image was picked and loaded successfully.
  Future<bool> pickImage({int? imageQuality}) async {
    final response = await AppImagePlugin.pickImage(imageQuality: imageQuality);
    if (response.hasFile && response.file != null) {
      final bytes = await response.file!.readAsBytes();
      setImage(bytes);
      return true;
    }
    return false;
  }

  /// Starts a new continuous stroke at [point].
  void beginStroke(Offset point) {
    _invalidateCapture();
    value = GtSignaturePadValue(
      strokes: [
        ...value.strokes,
        GtSignatureStroke([point]),
      ],
      isDrawing: true,
      image: null,
    );
  }

  /// Adds [point] to the active stroke.
  ///
  /// Points that are too close to the previous point are ignored to keep the
  /// path compact without changing its visible shape.
  void appendPoint(Offset point) {
    if (!value.isDrawing || value.strokes.isEmpty) return;

    final activeStroke = value.strokes.last;
    final previousPoint = activeStroke.points.last;
    if ((point - previousPoint).distanceSquared <
        _minimumPointDistanceSquared) {
      return;
    }

    value = GtSignaturePadValue(
      strokes: [
        ...value.strokes.take(value.strokes.length - 1),
        activeStroke.add(point),
      ],
      isDrawing: true,
      image: null,
    );
  }

  /// Completes the active stroke and schedules its PNG capture.
  void endStroke() {
    if (!value.isDrawing) return;
    value = GtSignaturePadValue(strokes: value.strokes);
    _scheduleCapture();
  }

  /// Removes the most recently drawn stroke.
  void undo() {
    if (!canUndo) return;

    _invalidateCapture();
    final removedStroke = value.strokes.last;
    value = GtSignaturePadValue(
      strokes: value.strokes.take(value.strokes.length - 1),
      redoStrokes: [...value.redoStrokes, removedStroke],
    );
    _scheduleCapture();
  }

  /// Restores the most recently undone stroke.
  void redo() {
    if (!canRedo) return;

    _invalidateCapture();
    final restoredStroke = value.redoStrokes.last;
    value = GtSignaturePadValue(
      strokes: [...value.strokes, restoredStroke],
      redoStrokes: value.redoStrokes.take(value.redoStrokes.length - 1),
    );
    _scheduleCapture();
  }

  /// Removes the drawing and all undo/redo history.
  void clear() {
    _invalidateCapture();
    value = GtSignaturePadValue();
    _setImage(null);
  }

  /// Captures the current signature as PNG bytes.
  ///
  /// If an imported image is active, its bytes are returned directly.
  /// The drawing surface must be mounted in a [GtSignaturePad]. If it is not,
  /// the latest cached bytes are returned instead. [pixelRatio] defaults to the
  /// mounted surface's device pixel ratio through [ScreenShotService].
  Future<Uint8List?> toUint8List({double? pixelRatio}) async {
    if (value.image != null) return bytes;
    if (!hasSignature) {
      _setImage(null);
      return null;
    }

    final captureContext = repaintBoundaryKey.currentContext;
    if (captureContext == null) return bytes;

    final generation = ++_captureGeneration;
    _setCapturing(true);
    final image = await _screenShotService.captureScreen(
      captureContext,
      pixelRatio: pixelRatio,
    );

    if (_isDisposed || generation != _captureGeneration) return bytes;
    _setImage(image);
    _setCapturing(false);
    return bytes;
  }

  /// Captures the current signature and returns its PNG bytes as base64.
  Future<String?> toBase64({double? pixelRatio}) async {
    final image = await toUint8List(pixelRatio: pixelRatio);
    return image == null ? null : base64Encode(image);
  }

  void _scheduleCapture() {
    if (!hasSignature) {
      _setImage(null);
      return;
    }

    final scheduledGeneration = ++_captureGeneration;
    _setCapturing(true);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_isDisposed || scheduledGeneration != _captureGeneration) return;
      await toUint8List();
    });
  }

  void _invalidateCapture() {
    _captureGeneration++;
  }

  void _setCapturing(bool isCapturing) {
    if (_isDisposed || value.isCapturing == isCapturing) return;
    value = GtSignaturePadValue(
      strokes: value.strokes,
      redoStrokes: value.redoStrokes,
      isDrawing: value.isDrawing,
      isCapturing: isCapturing,
      image: value.image,
    );
  }

  void _setImage(Uint8List? image) {
    if (_isDisposed) return;
    _imageNotifier.value = _copyBytes(image);
  }

  static Uint8List? _copyBytes(Uint8List? image) {
    return image == null ? null : Uint8List.fromList(image);
  }

  @override
  void dispose() {
    _isDisposed = true;
    _captureGeneration++;
    _imageNotifier.dispose();
    super.dispose();
  }
}
