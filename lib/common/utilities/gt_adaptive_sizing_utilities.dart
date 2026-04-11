import 'dart:math';

import 'package:flutter/widgets.dart'
    show BuildContext, MediaQuery, EdgeInsets, RenderBox, Size, Offset;

final class GtMediaQueryData {
  late final EdgeInsets _insetsData;
  late final Size _sizeData;
  late final double _pxData;

  GtMediaQueryData(BuildContext context) {
    _insetsData = MediaQuery.viewInsetsOf(context);
    _pxData = MediaQuery.devicePixelRatioOf(context);
    _sizeData = MediaQuery.sizeOf(context);
  }

  double get topInset => _insetsData.top;
  double get bottomInset => _insetsData.bottom;
  double get shortestSide => _sizeData.shortestSide;
  double get longestSide => _sizeData.longestSide;
  double get width => _sizeData.width;
  double get height => _sizeData.height;
  double get pixelRatio => _pxData;
  double get devicePixelRatio => _pxData;
}

class GtFractionalSizer {
  late GtMediaQueryData _queryData;
  late GtScreenType screenType;

  GtFractionalSizer(BuildContext context) {
    _queryData = GtMediaQueryData(context);
    screenType = GtScreenType(context);
  }

  double get breakPointFraction {
    if (screenType.isMonitor) return 0.27;
    if (screenType.isLaptop) return 0.32;
    if (screenType.isTablet) return 0.53;
    return 1;
  }

  double get _shortest => _queryData.shortestSide;
  double get _longest => _queryData.longestSide;
  double get _height => _queryData.height;
  double get _width => _queryData.width;

  double _resolveFraction(double value) => value * breakPointFraction;

  double getLongestSideFraction(double fraction) {
    if (fraction == 0) return 0;
    return _resolveFraction(_longest * fraction);
  }

  double getShortestSideFraction(double fraction) {
    if (fraction == 0) return 0;
    return _resolveFraction(_shortest * fraction);
  }

  double getHeightFraction(double fraction) {
    if (fraction == 0) return 0;
    return _resolveFraction(_height * fraction);
  }

  double getWidthFraction(double fraction) {
    if (fraction == 0) return 0;
    return _resolveFraction(_width * fraction);
  }
}

class GtDpiIndependentSizer {
  late num _scale;

  double _x(BuildContext context) {
    final x = MediaQuery.sizeOf(context).shortestSide;
    return min(x, 428);
  }

  double _y(BuildContext context) {
    final y = MediaQuery.sizeOf(context).longestSide;
    return min(y, 926);
  }

  GtDpiIndependentSizer(BuildContext context) {
    final y = _y(context);
    final x = _x(context);
    _scale = (x + y) / 4.5;
  }

  double dp(double? percentage) {
    return (_scale * ((percentage ?? 40) / 1000)).floorToDouble();
  }

  double px(double? pixels) {
    return (1000 * ((pixels ?? 14)) / _scale).ceilToDouble();
  }
}

class GtInsets {
  late GtFractionalSizer _fracSizer;
  late GtDpiIndependentSizer _dpSizer;

  GtInsets(BuildContext context) {
    _fracSizer = GtFractionalSizer(context);
    _dpSizer = GtDpiIndependentSizer(context);
  }

  EdgeInsets get zero {
    return EdgeInsets.zero;
  }

  EdgeInsets all(double inset) {
    return EdgeInsets.all(_fracSizer.getShortestSideFraction(inset));
  }

  EdgeInsets get defaultHorizontalInsets {
    return symmetric(horizontal: 5);
  }

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

  EdgeInsets fromLTRB(double left, double top, double right, double bottom) {
    return EdgeInsets.fromLTRB(
      _fracSizer.getShortestSideFraction(left),
      _fracSizer.getLongestSideFraction(top),
      _fracSizer.getShortestSideFraction(right),
      _fracSizer.getLongestSideFraction(bottom),
    );
  }

  EdgeInsets symmetric({double vertical = 0, double horizontal = 0}) {
    return EdgeInsets.symmetric(
      vertical: _fracSizer.getLongestSideFraction(vertical),
      horizontal: _fracSizer.getShortestSideFraction(horizontal),
    );
  }

  EdgeInsets allDp(double inset) {
    return EdgeInsets.all(_dpSizer.dp(inset));
  }

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

  EdgeInsets fromLTRBDp(double left, double top, double right, double bottom) {
    return EdgeInsets.fromLTRB(
      _dpSizer.dp(left),
      _dpSizer.dp(top),
      _dpSizer.dp(right),
      _dpSizer.dp(bottom),
    );
  }

  EdgeInsets symmetricDp({double vertical = 0, double horizontal = 0}) {
    return EdgeInsets.symmetric(
      vertical: _dpSizer.dp(vertical),
      horizontal: _dpSizer.dp(horizontal),
    );
  }
}

class GtScaleUtil {
  final BuildContext context;
  static const double textScaleFactor = 1;

  GtScaleUtil.of(this.context);

  GtDpiIndependentSizer get dpSizer => GtDpiIndependentSizer(context);
  GtFractionalSizer get fracSizer => GtFractionalSizer(context);
  GtInsets get insets => GtInsets(context);

  Offset get position {
    final RenderBox box = context.findRenderObject() as RenderBox;
    return box.localToGlobal(Offset.zero);
  }

  Size get size {
    final RenderBox box = context.findRenderObject() as RenderBox;
    return box.size;
  }
}

class GtScreenType {
  final BuildContext _context;
  final double tabletBreakpoint;
  final double laptopBreakPoint;
  final double monitorBreakPoint;

  GtScreenType(
    this._context, {
    this.tabletBreakpoint = 672.0,
    this.laptopBreakPoint = 1120.0,
    this.monitorBreakPoint = 1312.0,
  });

  double get width => MediaQuery.sizeOf(_context).width;

  bool get isMobile => width < tabletBreakpoint;
  bool get isTablet => width >= tabletBreakpoint && width < laptopBreakPoint;
  bool get isLaptop => width >= laptopBreakPoint && width < monitorBreakPoint;
  bool get isMonitor => width >= monitorBreakPoint;
}
