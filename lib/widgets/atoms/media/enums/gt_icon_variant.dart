import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

enum GtIconVariant { strong, sub, soft, disabled, white }

extension GtIconVariantExtension on GtIconVariant? {
  Color getIconColor(BuildContext context) {
    return switch (this) {
      .sub => context.palette.icon.sub,
      .soft => context.palette.icon.soft,
      .disabled => context.palette.icon.disabled,
      .white => context.palette.icon.white,
      _ => context.palette.icon.strong,
    };
  }
}
