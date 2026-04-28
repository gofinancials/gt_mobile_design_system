/// A generic data model representing a single selectable item within a wheel scroll picker.
///
/// This class encapsulates the underlying data value, its display label, and its positional
/// index, which is used by components like the `WheelScrollSheet` to render and track selections.
class GtWheelScrollData<T> {
  /// The actual underlying data value of type [T] that this item represents.
  final T data;

  /// The formatted string label displayed to the user in the UI.
  final String label;

  /// The positional index of this item within the scroll wheel data source.
  final int index;

  /// Creates a new [GtWheelScrollData] instance.
  const GtWheelScrollData({
    required this.data,
    required this.label,
    required this.index,
  });

  @override
  int get hashCode => Object.hash(data, label, index);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! GtWheelScrollData) return false;
    return data == other.data && label == other.label && index == other.index;
  }
}
