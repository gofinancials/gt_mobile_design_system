import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Delivers a rendered PDF receipt to the user.
///
/// Sits on top of [GtPdfReceiptBuilder] and hands the resulting bytes to the
/// foundation plugins: [AppSharePlugin] for the native share sheet and
/// [AppFilePlugin] for the system save dialog. Callers that only want the bytes
/// — to upload them, cache them, or attach them to an email — should use
/// [render].
///
/// Example usage:
/// ```dart
/// const exporter = GtPdfReceiptExporter();
///
/// await exporter.share(context, data);
/// final result = await exporter.save(data);
/// if (result.hasError) showSaveFailed();
/// ```
class GtPdfReceiptExporter {
  /// The builder used to render receipts before export.
  final GtPdfReceiptBuilder builder;

  /// Creates a [GtPdfReceiptExporter].
  ///
  /// Supply a [builder] to export against a custom [GtPdfReceiptTheme];
  /// otherwise the design system's light theme is used.
  const GtPdfReceiptExporter({this.builder = const GtPdfReceiptBuilder()});

  /// Creates an exporter whose documents are themed from the live app
  /// [palette], so an exported receipt matches the screen it came from.
  GtPdfReceiptExporter.fromPalette(GtPalette palette)
    : builder = GtPdfReceiptBuilder(
        theme: GtPdfReceiptTheme.fromPalette(palette),
      );

  /// Renders [data] to PDF bytes without delivering them anywhere.
  Future<Uint8List> render(GtPdfReceiptData data) => builder.render(data);

  /// Renders [data] and opens the platform share sheet.
  ///
  /// The [context] positions the share popover on iPad and macOS, so pass the
  /// context of the widget the user tapped rather than a root one. Returns
  /// early without sharing if that context leaves the tree while the document
  /// is being rendered.
  ///
  /// [subject] becomes the email subject when the user picks a mail client, and
  /// defaults to the receipt title.
  Future<void> share(
    BuildContext context,
    GtPdfReceiptData data, {
    String? subject,
  }) async {
    final bytes = await render(data);
    if (!context.mounted) return;

    AppSharePlugin.shareFile(
      context,
      data: bytes,
      title: subject ?? data.title,
      fileName: data.resolvedFileName,
      mimeType: _mimeType,
    );
  }

  /// Renders [data] and opens the platform save dialog.
  ///
  /// The returned [FsResponse] carries an [FsError] when the user cancels — an
  /// empty error — or when writing fails. Check `hasError` before reporting
  /// success.
  ///
  /// [dialogTitle] labels the save dialog on the platforms that show one.
  Future<FsResponse> save(GtPdfReceiptData data, {String? dialogTitle}) async {
    final bytes = await render(data);

    return AppFilePlugin.saveFile(
      bytes,
      filename: data.resolvedFileName,
      dialogTitle: dialogTitle ?? data.title,
      ext: _extension,
    );
  }

  static const _extension = 'pdf';
  static const _mimeType = 'application/pdf';
}
