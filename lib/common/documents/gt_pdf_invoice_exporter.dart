import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/documents.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Delivers a rendered PDF invoice to the user.
///
/// The invoice counterpart of [GtPdfReceiptExporter]: it renders with
/// [GtPdfInvoiceBuilder] and hands the bytes to [AppSharePlugin] for the native
/// share sheet and [AppFilePlugin] for the system save dialog. Callers that
/// only want the bytes should use [render].
///
/// Example usage:
/// ```dart
/// final exporter = GtPdfInvoiceExporter.fromPalette(context.palette);
///
/// await exporter.share(context, data);
/// final result = await exporter.save(data);
/// if (result.hasError) showSaveFailed();
/// ```
class GtPdfInvoiceExporter {
  /// The builder used to render invoices before export.
  final GtPdfInvoiceBuilder builder;

  /// Creates a [GtPdfInvoiceExporter].
  ///
  /// Supply a [builder] to export against a custom [GtPdfReceiptTheme];
  /// otherwise the design system's light theme is used.
  const GtPdfInvoiceExporter({this.builder = const GtPdfInvoiceBuilder()});

  /// Creates an exporter whose documents are themed from the live app
  /// [palette], so an exported invoice matches the screen it came from.
  GtPdfInvoiceExporter.fromPalette(GtPalette palette)
    : builder = GtPdfInvoiceBuilder(
        theme: GtPdfReceiptTheme.fromPalette(palette),
      );

  /// Renders [data] to PDF bytes without delivering them anywhere.
  Future<Uint8List> render(GtPdfInvoiceData data) => builder.render(data);

  /// Renders [data] and opens the native share sheet with the PDF attached.
  ///
  /// [subject] is used by share targets that support one, such as email, and
  /// defaults to [GtPdfInvoiceData.title].
  Future<void> share(
    BuildContext context,
    GtPdfInvoiceData data, {
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

  /// Renders [data] and opens the system save dialog for the PDF.
  ///
  /// Resolves with the plugin's [FsResponse], so callers can tell a saved
  /// file from a cancelled dialog or a failure.
  Future<FsResponse> save(GtPdfInvoiceData data, {String? dialogTitle}) async {
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
