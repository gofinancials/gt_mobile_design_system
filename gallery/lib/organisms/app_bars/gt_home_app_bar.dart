import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtHomeAppbar', type: GtHomeAppBar)
Widget buildGtHomeAppbarUsecase(BuildContext context) {
  final showGradient = context.knobs.boolean(label: "Show Gradient");
  final color = showGradient
      ? context.palette.primary.alpha24
      : Colors.transparent;
  return Scaffold(
    appBar: GtHomeAppBar(
      onClickSearch: () {},
      onClickHide: () {},
      onClickNotification: () {},
    ),
    extendBodyBehindAppBar: true,
    body: CustomPaint(
      painter: GtHomeGradientPainter(color: color),
      child: Container(),
    ),
  );
}
