import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/documents.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Delivers a rendered PDF account statement to the user.
///
/// The statement counterpart of [GtPdfReceiptExporter]: it renders with
/// [GtPdfStatementBuilder], off the main isolate, and hands the bytes to
/// [AppSharePlugin] for the native share sheet and [AppFilePlugin] for the
/// system save dialog. Callers that only want the bytes should use [render].
///
/// Example usage:
/// ```dart
/// final exporter = GtPdfStatementExporter.fromPalette(
///   context.themeData.lightPalette,
/// );
///
/// await exporter.share(context, data);
/// final result = await exporter.save(data);
/// if (result.hasError) showSaveFailed();
/// ```
class GtPdfStatementExporter {
  /// The builder used to render statements before export.
  final GtPdfStatementBuilder builder;

  /// Creates a [GtPdfStatementExporter].
  ///
  /// Supply a [builder] to export against a custom [GtPdfReceiptTheme];
  /// otherwise the design system's light theme is used.
  const GtPdfStatementExporter({this.builder = const GtPdfStatementBuilder()});

  /// Creates an exporter whose documents are themed from [palette].
  ///
  /// The page takes the palette's own background, so pass the brand's light
  /// palette (`context.themeData.lightPalette`) for a white document in the
  /// brand's colours. Passing the live `context.palette` makes the statement
  /// follow the app into dark mode, and should only be done on purpose.
  GtPdfStatementExporter.fromPalette(GtPalette palette)
    : builder = GtPdfStatementBuilder(
        theme: GtPdfReceiptTheme.fromPalette(palette),
      );

  /// Renders [data] to PDF bytes without delivering them anywhere.
  Future<Uint8List> render(GtPdfStatementData data) => builder.render(data);

  /// Renders [data] and opens the native share sheet with the PDF attached.
  ///
  /// [subject] is used by share targets that support one, such as email, and
  /// defaults to [GtPdfStatementData.documentTitle].
  Future<void> share(
    BuildContext context,
    GtPdfStatementData data, {
    String? subject,
  }) async {
    final bytes = await render(data);
    if (!context.mounted) return;

    AppSharePlugin.shareFile(
      context,
      data: bytes,
      title: subject ?? data.documentTitle,
      fileName: data.resolvedFileName,
      mimeType: _mimeType,
    );
  }

  /// Renders [data] and opens the system save dialog for the PDF.
  ///
  /// Resolves with the plugin's [FsResponse], so callers can tell a saved
  /// file from a cancelled dialog or a failure.
  Future<FsResponse> save(
    GtPdfStatementData data, {
    String? dialogTitle,
  }) async {
    final bytes = await render(data);

    return AppFilePlugin.saveFile(
      bytes,
      filename: data.resolvedFileName,
      dialogTitle: dialogTitle ?? data.documentTitle,
      ext: _extension,
    );
  }

  static const _extension = 'pdf';
  static const _mimeType = 'application/pdf';
}
