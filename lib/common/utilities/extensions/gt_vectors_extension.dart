import 'package:gt_mobile_foundation/foundation.dart';
import 'package:vector_graphics/vector_graphics.dart';

/// A utility extension on [String] to streamline loading vector graphics.
///
/// This extension allows any string representing a URL or a local asset path
/// to be directly converted into a [BytesLoader] required by `vector_graphics`.
extension AppVectorsExtension on String {
  /// Converts this string into a [BytesLoader] for rendering vector graphics.
  ///
  /// If the string matches a URL pattern, it returns a [NetworkBytesLoader].
  /// Otherwise, it treats the string as a local asset path and returns an
  /// [AssetBytesLoader]. An optional [package] can be specified for local assets.
  BytesLoader vectorBytes([String? package]) {
    if (AppRegex.urlRegex.hasMatch(this)) {
      return NetworkBytesLoader(Uri.parse(this));
    }
    return AssetBytesLoader(this, packageName: package);
  }
}
