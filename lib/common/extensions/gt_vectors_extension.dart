import 'package:gt_mobile_foundation/foundation.dart';
import 'package:vector_graphics/vector_graphics.dart';

extension AppVectorsExtension on String {
  BytesLoader vectorBytes([String? package]) {
    if (AppRegex.urlRegex.hasMatch(this)) {
      return NetworkBytesLoader(Uri.parse(this));
    }
    return AssetBytesLoader(this, packageName: package);
  }
}
