import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:printing/printing.dart';

/// Rasterises a generated PDF so a use case can show the document on screen.
///
/// The design system builds PDFs but deliberately ships no viewer: on a device
/// the finished file is handed to the platform, which opens it in whatever the
/// customer already uses. The gallery depends on `printing` purely to draw
/// those bytes here, so a document can be read, checked for page breaks and
/// iterated on without leaving Widgetbook. Nothing in this file is part of the
/// published suite.
///
/// The document is re-rendered on every rebuild, which is what makes the
/// preview track the knobs above it. Rendering is cheap enough for a receipt;
/// heavier documents should be previewed behind an explicit refresh instead.
///
/// The action bar is off by default. A use case that already exposes the
/// suite's own share and download buttons should keep it that way — printing's
/// buttons deliver the file through its own plugin, which is not the path the
/// app takes.
///
/// Example usage:
/// ```dart
/// GalleryPdfPreview(
///   render: () => exporter.render(data),
///   fileName: data.resolvedFileName,
/// )
/// ```
class GalleryPdfPreview extends StatelessWidget {
  /// Produces the bytes to display.
  final Future<Uint8List> Function() render;

  /// The name printing's own share and print actions give the file.
  final String? fileName;

  /// The height of the scrolling page view.
  final double height;

  /// Whether to offer printing's print button.
  final bool allowPrinting;

  /// Whether to offer printing's share button.
  final bool allowSharing;

  /// Creates a [GalleryPdfPreview].
  const GalleryPdfPreview({
    required this.render,
    this.fileName,
    this.height = 520,
    this.allowPrinting = false,
    this.allowSharing = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return SizedBox(
      height: height,
      child: PdfPreview(
        build: (_) => render(),
        // The page geometry belongs to GtPdfReceiptTheme, so the reader gets
        // no say over it — a preview that could be switched to Letter would
        // be previewing a document the app never produces.
        canChangePageFormat: false,
        canChangeOrientation: false,
        canDebug: false,
        allowPrinting: allowPrinting,
        allowSharing: allowSharing,
        useActions: allowPrinting || allowSharing,
        pdfFileName: fileName,
        shouldRepaint: true,
        padding: EdgeInsets.zero,
        previewPageMargin: EdgeInsets.all(context.spacingBase),
        scrollViewDecoration: BoxDecoration(color: palette.bg.soft),
        pdfPreviewPageDecoration: BoxDecoration(
          color: palette.bg.white,
          boxShadow: [
            BoxShadow(
              color: palette.bg.strong.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        actionBarTheme: PdfActionBarTheme(
          backgroundColor: palette.bg.white,
          iconColor: palette.text.strong,
          elevation: 0,
        ),
        loadingWidget: Center(child: GtSpinner(color: palette.primary.base)),
        onError: (context, error) => _PreviewUnavailable(error: error),
      ),
    );
  }
}

/// Shown when the platform cannot rasterise the document.
///
/// Reachable in the gallery: previewing on web pulls pdf.js from a CDN, so an
/// offline session lands here rather than on a blank panel.
class _PreviewUnavailable extends StatelessWidget {
  final Object error;

  const _PreviewUnavailable({required this.error});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.palette.bg.soft,
      child: Center(
        child: Padding(
          padding: context.insets.defaultAllInsets,
          child: Column(
            mainAxisSize: .min,
            children: [
              GtText(
                'Preview unavailable on this platform',
                style: context.textStyles.subHeadS(),
                textAlign: .center,
              ),
              const GtGap.ySm(),
              GtText(
                '$error',
                style: context.textStyles.bodyS(
                  color: context.palette.text.sub,
                ),
                textAlign: .center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
