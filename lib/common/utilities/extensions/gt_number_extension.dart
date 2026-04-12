import 'package:flutter/cupertino.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// An extension on [num] providing convenient properties for generating
/// standard Flutter radii, border radii, and device-independent pixel conversions.
extension RadiiExtension on num {
  /// Creates a circular [Radius] using this number.
  Radius get radius => Radius.circular(toDouble());

  /// Creates a uniform circular [BorderRadius] for all four corners using this number.
  BorderRadius get circularBorderRadius => BorderRadius.circular(toDouble());

  /// Creates a [BorderRadius] with this number applied only to the top corners.
  BorderRadius get topBorderRadius {
    return BorderRadius.vertical(top: radius);
  }

  /// Creates a [BorderRadius] with this number applied only to the bottom corners.
  BorderRadius get bottomBorderRadius {
    return BorderRadius.vertical(bottom: radius);
  }

  /// Creates a [BorderRadius] with this number applied only to the left corners.
  BorderRadius get leftBorderRadius {
    return BorderRadius.horizontal(left: radius);
  }

  /// Creates a [BorderRadius] with this number applied only to the right corners.
  BorderRadius get rightBorderRadius {
    return BorderRadius.horizontal(right: radius);
  }

  /// Creates a [BorderRadius] with this number applied to the top-left and bottom-right corners.
  BorderRadius get diagonalTopLeftBottomRightBorderRadius {
    return BorderRadius.only(topLeft: radius, bottomRight: radius);
  }

  /// Creates a [BorderRadius] with this number applied to the top-right and bottom-left corners.
  BorderRadius get diagonalTopRightBottomLeftBorderRadius {
    return BorderRadius.only(topRight: radius, bottomLeft: radius);
  }

  GtDpComputer get _dpComputer => GtDpComputer();

  /// Converts this number to device-independent pixels (DP).
  ///
  /// This is typically used to ensure consistent sizing across different screen densities.
  double get dp => _dpComputer.dp(px);

  /// Converts this number to standard logical pixels (px).
  double get px => _dpComputer.px(this);
}
