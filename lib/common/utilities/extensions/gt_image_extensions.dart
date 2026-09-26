import 'dart:io';

import 'package:gt_mobile_foundation/foundation.dart';

/// Validation helpers for a nullable [AppImageData].
extension AppImageExtension on AppImageData? {
  /// Whether this holds something worth handing to an image widget.
  ///
  /// A `null` wrapper, an empty string and a zero-length file all read as
  /// invalid, so an avatar built from a blank URL falls through to its
  /// placeholder instead of rendering nothing.
  ///
  /// A file whose path has gone away reads as invalid rather than throwing:
  /// this is called from `build`, where a [FileSystemException] would take the
  /// frame down over a stale reference.
  ///
  /// *Note: the file branch stats the file synchronously on every call. That
  /// is cheap for one avatar and wasteful for a long list of them, so cache
  /// the result upstream before drawing file-backed avatars in a list row.*
  bool get hasValidData {
    if (this == null) return false;
    if (this?.imageData case String string) return string.hasValue;
    if (this?.imageData case File file) {
      try {
        return file.lengthSync() > 0;
      } on FileSystemException {
        return false;
      }
    }
    return this?.imageData != null;
  }
}
