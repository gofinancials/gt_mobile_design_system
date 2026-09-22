import 'dart:io';

import 'package:gt_mobile_foundation/foundation.dart';

extension AppImageExtension on AppImageData? {
  bool get hasValidData {
    if (this == null) return false;
    if (this?.imageData case String string) return string.hasValue;
    if (this?.imageData case File file) return file.lengthSync() > 0;
    return this?.imageData != null;
  }
}
