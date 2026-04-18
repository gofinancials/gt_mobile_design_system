import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

enum GtIconVariant {
  strong,
  sub,
  soft,
  disabled,
  white,
  featured,
  info,
  success,
  warning,
  error,
  highlighted,
  stable,
  verified,
  away,
}

extension GtIconVariantExtension on GtIconVariant? {
  Color getIconColor(BuildContext context) {
    return switch (this) {
      .sub => context.palette.icon.sub,
      .soft => context.palette.icon.soft,
      .disabled => context.palette.icon.disabled,
      .white => context.palette.icon.white,
      .featured => context.palette.feature.base,
      .info => context.palette.information.base,
      .success => context.palette.success.base,
      .warning => context.palette.warning.base,
      .error => context.palette.error.base,
      .highlighted => context.palette.highlighted.base,
      .stable => context.palette.stable.base,
      .verified => context.palette.success.base,
      .away => context.palette.away.base,
      _ => context.palette.icon.strong,
    };
  }
}
