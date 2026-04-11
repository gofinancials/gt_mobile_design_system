import 'package:flutter/cupertino.dart';

extension RadiiExtension on num {
  Radius get radius => Radius.circular(toDouble());
  BorderRadius get circularBorderRadius => BorderRadius.circular(toDouble());
  BorderRadius get horizontalBorderRadius {
    return BorderRadius.horizontal(left: radius, right: radius);
  }

  BorderRadius get verticalBorderRadius {
    return BorderRadius.vertical(top: radius, bottom: radius);
  }
}
