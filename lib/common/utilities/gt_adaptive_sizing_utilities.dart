import 'dart:math';

import 'package:flutter/widgets.dart'
    show BuildContext, MediaQuery, EdgeInsets, RenderBox, Size, Offset;
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A utility class that extracts and caches common [MediaQuery] properties
/// for the given context, simplifying access to screen dimensions, pixel ratios,
/// and safe area insets.
final class GtMediaQueryData {
  late final EdgeInsets _insetsData;
  late final Size _sizeData;
  late final double _pxData;

  GtMediaQueryData(BuildContext context) {
    _insetsData = MediaQuery.viewInsetsOf(context);
    _pxData = MediaQuery.devicePixelRatioOf(context);
    _sizeData = MediaQuery.sizeOf(context);
  }

  /// The top padding (e.g., safe area for status bar).
  double get topInset => _insetsData.top;

  /// The bottom padding (e.g., safe area for system navigation).
  double get bottomInset => _insetsData.bottom;

  /// The shortest side of the screen (typically width on mobile portrait).
  double get shortestSide => _sizeData.shortestSide;

  /// The longest side of the screen (typically height on mobile portrait).
  double get longestSide => _sizeData.longestSide;

  /// The total width of the screen.
  double get width => _sizeData.width;

  /// The total height of the screen.
  double get height => _sizeData.height;

  /// The device pixel ratio.
  double get pixelRatio => _pxData;

  /// Alias for [pixelRatio].
  double get devicePixelRatio => _pxData;
}

/// A utility class for calculating layout dimensions as a fraction of the
/// screen size, adjusted dynamically based on the current device screen type
/// (mobile, tablet, laptop, monitor).
class GtFractionalSizer {
  late GtMediaQueryData _queryData;
  late GtScreenType screenType;

  /// Creates an instance of [GtFractionalSizer] using the provided [context].
  GtFractionalSizer(BuildContext context) {
    _queryData = GtMediaQueryData(context);
    screenType = GtScreenType(context);
  }

  /// The breakpoint multiplier applied to all fractional calculations.
  ///
  /// This reduces the effective fractional size on larger screens to prevent
  /// UI components from becoming comically large on tablets and desktop monitors.
  double get breakPointFraction {
    if (screenType.isMonitor) return 0.27;
    if (screenType.isLaptop) return 0.32;
    if (screenType.isTablet) return 0.53;
    return 1;
  }

  double get _shortest => _queryData.shortestSide;
  double get _longest => _queryData.longestSide;
  double get height => _queryData.height;
  double get width => _queryData.width;

  double _resolveFraction(double value) => value * breakPointFraction;

  /// Calculates a dimension based on a [fraction] of the screen's longest side.
  double getLongestSideFraction(double fraction) {
    if (fraction == 0) return 0;
    return _resolveFraction(_longest * fraction);
  }

  /// Calculates a dimension based on a [fraction] of the screen's shortest side.
  double getShortestSideFraction(double fraction) {
    if (fraction == 0) return 0;
    return _resolveFraction(_shortest * fraction);
  }

  /// Calculates a dimension based on a [fraction] of the screen's total height.
  double getHeightFraction(double fraction) {
    if (fraction == 0) return 0;
    return _resolveFraction(height * fraction);
  }

  /// Calculates a dimension based on a [fraction] of the screen's total width.
  double getWidthFraction(double fraction) {
    if (fraction == 0) return 0;
    return _resolveFraction(width * fraction);
  }
}

/// A mathematical utility for calculating device-independent pixels (DP) and
/// logical pixels (px) based on a reference design width and height.
class GtDpComputer {
  /// The reference design width.
  final double width;

  /// The reference design height.
  final double height;

  /// Creates a [GtDpComputer] using the standard reference design dimensions.
  GtDpComputer({this.width = 428, this.height = 926});

  double get _scale => (width + height) / 4.5;

  /// Converts a given [percentage] into device-independent pixels (DP).
  double dp(num? percentage) {
    return (_scale * ((percentage ?? 40) / 1000)).floorToDouble();
  }

  /// Converts a given [pixels] value into standard logical pixels based on the scale.
  double px(num? pixels) {
    return (1000 * ((pixels ?? 14)) / _scale).ceilToDouble();
  }
}

/// A context-aware wrapper around [GtDpComputer] that limits the scaling
/// reference dimensions to the actual screen size, ensuring sizes don't
/// over-scale on very large screens.
class GtContextSensitiveDpComputer {
  final BuildContext _context;

  /// The maximum target design width.
  final double designWidth;

  /// The maximum target design height.
  final double designHeight;

  /// Creates an instance using the provided [context] and optional design bounds.
  GtContextSensitiveDpComputer(
    this._context, {
    this.designWidth = 428,
    this.designHeight = 926,
  });

  double get _computedWidth {
    final x = MediaQuery.sizeOf(_context).shortestSide;
    return min(x, designWidth);
  }

  double get _computedHeight {
    final y = MediaQuery.sizeOf(_context).longestSide;
    return min(y, designHeight);
  }

  GtDpComputer get _dpComputer {
    return GtDpComputer(width: _computedWidth, height: _computedHeight);
  }

  /// Converts a given [value] into device-independent pixels (DP) using the context bounds.
  double dp(num? value) => _dpComputer.dp(value);
}

/// A utility for generating adaptive [EdgeInsets] using either fractional
/// screen dimensions or device-independent pixels (DP).
class GtInsets {
  late GtFractionalSizer _fracSizer;
  late GtContextSensitiveDpComputer _dpSizer;

  /// Creates an instance of [GtInsets] using the provided [context].
  GtInsets(BuildContext context) {
    _fracSizer = GtFractionalSizer(context);
    _dpSizer = GtContextSensitiveDpComputer(context);
  }

  /// Returns empty insets (`EdgeInsets.zero`).
  EdgeInsets get zero {
    return EdgeInsets.zero;
  }

  /// Creates insets with symmetrical [inset] applied to all edges as a fraction of the shortest side.
  EdgeInsets all(double inset) {
    return EdgeInsets.all(_fracSizer.getShortestSideFraction(inset));
  }

  /// Returns the default horizontal fractional insets for the design system.
  EdgeInsets get defaultHorizontalInsets {
    return symmetricDp(horizontal: 16.px);
  }

  /// Returns the default vertical fractional insets for the design system.
  EdgeInsets get defaultVerticalInsets {
    return symmetricDp(vertical: 8.px);
  }

  /// Returns the default horizontal and vertical fractional insets for the design system.
  EdgeInsets get defaultAllInsets {
    return symmetricDp(vertical: 8.px, horizontal: 16.px);
  }

  /// Creates insets with the specified fractional values applied to each edge.
  EdgeInsets only({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return EdgeInsets.only(
      top: _fracSizer.getLongestSideFraction(top),
      left: _fracSizer.getShortestSideFraction(left),
      bottom: _fracSizer.getShortestSideFraction(bottom),
      right: _fracSizer.getShortestSideFraction(right),
    );
  }

  /// Creates insets from left, top, right, and bottom fractional values.
  EdgeInsets fromLTRB(double left, double top, double right, double bottom) {
    return EdgeInsets.fromLTRB(
      _fracSizer.getShortestSideFraction(left),
      _fracSizer.getLongestSideFraction(top),
      _fracSizer.getShortestSideFraction(right),
      _fracSizer.getLongestSideFraction(bottom),
    );
  }

  /// Creates insets with symmetrical fractional values along the vertical and horizontal axes.
  EdgeInsets symmetric({double vertical = 0, double horizontal = 0}) {
    return EdgeInsets.symmetric(
      vertical: _fracSizer.getLongestSideFraction(vertical),
      horizontal: _fracSizer.getShortestSideFraction(horizontal),
    );
  }

  /// Creates insets with uniform DP [inset] applied to all edges.
  EdgeInsets allDp(double inset) {
    return EdgeInsets.all(_dpSizer.dp(inset));
  }

  /// Creates insets with the specified DP values applied to each edge.
  EdgeInsets onlyDp({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return EdgeInsets.only(
      top: _dpSizer.dp(top),
      left: _dpSizer.dp(left),
      bottom: _dpSizer.dp(bottom),
      right: _dpSizer.dp(right),
    );
  }

  /// Creates insets from left, top, right, and bottom DP values.
  EdgeInsets fromLTRBDp(double left, double top, double right, double bottom) {
    return EdgeInsets.fromLTRB(
      _dpSizer.dp(left),
      _dpSizer.dp(top),
      _dpSizer.dp(right),
      _dpSizer.dp(bottom),
    );
  }

  /// Creates insets with symmetrical DP values along the vertical and horizontal axes.
  EdgeInsets symmetricDp({double vertical = 0, double horizontal = 0}) {
    return EdgeInsets.symmetric(
      vertical: _dpSizer.dp(vertical),
      horizontal: _dpSizer.dp(horizontal),
    );
  }
}

/// A centralized utility class that provides access to adaptive sizing tools,
/// insets, and RenderBox properties for the current context.
class GtScaleUtil {
  /// The context used for resolving screen properties.
  final BuildContext context;

  /// The default text scale factor baseline.
  static const double textScaleFactor = 1;

  /// Creates an instance of [GtScaleUtil] for the given [context].
  GtScaleUtil.of(this.context);

  /// Provides access to the context-sensitive DP computer.
  GtContextSensitiveDpComputer get dpSizer {
    return GtContextSensitiveDpComputer(context);
  }

  /// Provides access to the fractional sizer.
  GtFractionalSizer get fracSizer => GtFractionalSizer(context);

  /// Provides access to adaptive edge insets.
  GtInsets get insets => GtInsets(context);

  /// Returns the global offset position of the current widget on the screen.
  Offset get position {
    final RenderBox box = context.findRenderObject() as RenderBox;
    return box.localToGlobal(Offset.zero);
  }

  /// Returns the local offset position of the current widget within its parent.
  Offset get localPosition {
    final RenderBox box = context.findRenderObject() as RenderBox;
    return box.globalToLocal(Offset.zero);
  }

  /// Returns the rendered size of the current widget.
  Size get size {
    final RenderBox box = context.findRenderObject() as RenderBox;
    return box.size;
  }
}

/// A utility class for determining the current device screen category
/// based on predefined width breakpoints.
class GtScreenType {
  final BuildContext _context;

  /// The width breakpoint above which a device is considered a tablet.
  final double tabletBreakpoint;

  /// The width breakpoint above which a device is considered a laptop.
  final double laptopBreakPoint;

  /// The width breakpoint above which a device is considered a monitor/desktop.
  final double monitorBreakPoint;

  /// Creates a [GtScreenType] instance.
  ///
  /// Uses predefined breakpoints derived from the design system's grid guidelines.
  GtScreenType(
    this._context, {
    this.tabletBreakpoint = 672.0,
    this.laptopBreakPoint = 1120.0,
    this.monitorBreakPoint = 1312.0,
  });

  /// Gets the full width of the current screen.
  double get width => MediaQuery.sizeOf(_context).width;

  /// Returns `true` if the screen width falls into the mobile category.
  bool get isMobile => width < tabletBreakpoint;

  /// Returns `true` if the screen width falls into the tablet category.
  bool get isTablet => width >= tabletBreakpoint && width < laptopBreakPoint;

  /// Returns `true` if the screen width falls into the laptop category.
  bool get isLaptop => width >= laptopBreakPoint && width < monitorBreakPoint;

  /// Returns `true` if the screen width falls into the large monitor category.
  bool get isMonitor => width >= monitorBreakPoint;
}
