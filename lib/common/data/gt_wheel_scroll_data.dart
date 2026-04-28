class GtWheelScrollData<T> {
  final T data;
  final String label;
  final int index;

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
