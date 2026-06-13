import 'package:gt_mobile_foundation/foundation.dart';

/// Represents a single data point in a [GtLineChart].
class GtLineChartItem extends AppEquatable {
  /// An optional label for the data point.
  final String? label;

  /// The date and time associated with this data point.
  final DateTime date;

  /// The numerical value of this data point.
  final num value;

  /// An optional formatter function to convert the value into a custom string representation.
  final TransformCall<String>? formatter;

  /// Creates a new [GtLineChartItem].
  const GtLineChartItem(
    this.value, {
    required this.date,
    this.label,
    this.formatter,
  });

  @override
  List<Object?> get props => [date, value, label];
}
