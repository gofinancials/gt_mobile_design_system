/// PDF receipt building and export.
///
/// Deliberately not exported from `gt_mobile_ui.dart`: `pdf` pulls in `image`
/// and `archive`, which Veracode flags (flaw 1703, CWE-331). Apps that don't
/// render receipts should not compile them in, so import this library only
/// where receipts are needed.
library;

export 'common/documents/documents.dart';
