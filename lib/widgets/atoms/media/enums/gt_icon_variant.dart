import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

enum GtIconVariant { strong, sub, soft, disabled, white }

extension GtIconVariantExtension on GtIconVariant? {
  Color getIconColor(BuildContext context) {
    return switch (this) {
      GtIconVariant.sub => context.palette.icon.sub,
      GtIconVariant.soft => context.palette.icon.soft,
      GtIconVariant.disabled => context.palette.icon.disabled,
      GtIconVariant.white => context.palette.icon.white,
      _ => context.palette.icon.strong,
    };
  }
}
