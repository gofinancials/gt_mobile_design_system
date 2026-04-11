/// Represents the properties of a single grid configuration.
/// Note: The design specifies "Stretched / Flex" for columns, meaning
/// the UI implementation should dynamically fill the remaining space
/// after margins and gutters are applied.
class GtGridLayout {
  final int columns;
  final double margins;
  final double gutter;

  const GtGridLayout({
    required this.columns,
    required this.gutter,
    this.margins = 16.0,
  });
}

/// Represents the mobile grid system (targeting 320px to 511px widths).
///
/// Uses semantic naming based on column count. Default values are pulled
/// directly from the design system layout guide.
class GtGrid {
  /// Single-Column layout.
  /// Margins: 16px | Gutter: Auto (0px)
  final GtGridLayout singleColumn;

  /// Double-Column layout.
  /// Margins: 16px | Gutter: 16px
  final GtGridLayout doubleColumn;

  /// Triple-Column layout.
  /// Margins: 16px | Gutter: 16px
  final GtGridLayout tripleColumn;

  /// 4-Column layout.
  /// Margins: 16px | Gutter: 8px
  final GtGridLayout fourColumn;

  /// 8-Column layout.
  /// Margins: 16px | Gutter: 8px
  final GtGridLayout eightColumn;

  const GtGrid({
    /// Gutter "Auto" in design, practically 0 since there are no adjacent columns
    this.singleColumn = const GtGridLayout(columns: 1, gutter: 0.0),
    this.doubleColumn = const GtGridLayout(columns: 2, gutter: 16.0),
    this.tripleColumn = const GtGridLayout(columns: 3, gutter: 16.0),
    this.fourColumn = const GtGridLayout(columns: 4, gutter: 8.0),
    this.eightColumn = const GtGridLayout(columns: 8, gutter: 8.0),
  });
}
