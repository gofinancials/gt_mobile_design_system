import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Centralized [ImageFilter] presets for [BackdropFilter] and related effects.
///
/// Uses [BuildContext] so blur radii can be scaled with [BuildContext.dp] like
/// other design tokens.
class GtBackdropFilters {
  /// The [BuildContext] used for responsive blur sigma values.
  final BuildContext context;

  /// Creates an instance of [GtBackdropFilters].
  const GtBackdropFilters(this.context);

  /// Strong frosted-glass blur used by floating navigation and similar chrome.
  ///
  /// Matches the historical 18px sigma used for iOS-style bottom bars.
  ImageFilter bottomNavFrost() {
    final sigma = context.dp(18.px);
    return ImageFilter.blur(sigmaX: sigma, sigmaY: sigma);
  }
}
