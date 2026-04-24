import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Platform style used by [showGtSheetModal].
enum GtSheetModalPlatform {
  /// Uses Material [showModalBottomSheet].
  android,

  /// Uses Cupertino [showCupertinoSheet].
  ios,
}

/// Shows a platform-aware sheet:
/// - [GtSheetModalPlatform.android] -> [showModalBottomSheet]
/// - [GtSheetModalPlatform.ios] -> [showCupertinoSheet]
Future<T?> showGtSheetModal<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  GtSheetModalPlatform platform = GtSheetModalPlatform.android,
  bool isScrollControlled = true,
  bool enableDrag = true,
  bool showDragHandle = false,
  bool iosUseNestedNavigation = false,
  double? iosTopGap,
}) {
  final capturedThemes = InheritedTheme.capture(from: context, to: null);
  final gtTheme = GtThemeProvider.maybeOf(context);
  final modalBuilder = _buildSheetContent(
    builder: builder,
    capturedThemes: capturedThemes,
    gtTheme: gtTheme,
  );

  return switch (platform) {
    GtSheetModalPlatform.android => showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      enableDrag: enableDrag,
      showDragHandle: showDragHandle,
      backgroundColor: Colors.transparent,
      builder: modalBuilder,
    ),
    GtSheetModalPlatform.ios => showCupertinoSheet<T>(
      context: context,
      builder: modalBuilder,
      useNestedNavigation: iosUseNestedNavigation,
      enableDrag: enableDrag,
      topGap: iosTopGap,
      showDragHandle: showDragHandle,
    ),
  };
}

/// Rebuilds sheet content with captured inherited themes and optional
/// [GtThemeProvider] so modal routes can resolve design-system tokens.
WidgetBuilder _buildSheetContent({
  required WidgetBuilder builder,
  required CapturedThemes capturedThemes,
  required GtTheme? gtTheme,
}) {
  return (sheetContext) {
    Widget child = capturedThemes.wrap(builder(sheetContext));
    if (gtTheme != null) {
      child = GtThemeProvider(theme: gtTheme, child: child);
    }
    return child;
  };
}
