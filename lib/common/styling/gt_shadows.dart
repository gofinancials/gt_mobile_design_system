import 'package:flutter/widgets.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtShadows {
  final BuildContext context;

  const GtShadows(this.context);

  Color get _shadow => context.palette.staticColors.shadow;

  List<BoxShadow> xs([Color? color]) {
    return [
      BoxShadow(
        color: (color ?? _shadow).setOpacity(.04),
        blurRadius: 2,
        spreadRadius: 0,
        offset: Offset(0, 1),
      ),
      BoxShadow(
        color: (color ?? _shadow).setOpacity(.04),
        blurRadius: 4,
        spreadRadius: 0,
        offset: Offset(0, 2),
      ),
    ];
  }

  List<BoxShadow> sm([Color? color]) {
    return [
      BoxShadow(
        color: (color ?? _shadow).setOpacity(.16),
        blurRadius: 3,
        spreadRadius: -1.5,
        offset: Offset(0, 1),
      ),
      BoxShadow(
        color: (color ?? _shadow).setOpacity(.08),
        blurRadius: 5,
        spreadRadius: -2.5,
        offset: Offset(0, 5),
      ),
    ];
  }

  List<BoxShadow> md([Color? color]) {
    return [
      BoxShadow(
        color: (color ?? _shadow).setOpacity(.04),
        blurRadius: 48,
        spreadRadius: -24,
        offset: Offset(0, 48),
      ),
      BoxShadow(
        color: (color ?? _shadow).setOpacity(.04),
        blurRadius: 24,
        spreadRadius: -12,
        offset: Offset(0, 24),
      ),
    ];
  }

  List<BoxShadow> lg([Color? color]) {
    return [
      BoxShadow(
        color: (color ?? _shadow).setOpacity(.06),
        blurRadius: 96,
        spreadRadius: -32,
        offset: Offset(0, 96),
      ),
      BoxShadow(
        color: (color ?? _shadow).setOpacity(.08),
        blurRadius: 48,
        spreadRadius: -24,
        offset: Offset(0, 48),
      ),
    ];
  }
}
