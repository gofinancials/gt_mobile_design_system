import 'package:gt_mobile_foundation/foundation.dart';

/// A single institution's transfer success rate, as presented by
/// [GtSuccessRateBody].
///
/// Mirrors the filtering contract of [GtDropdownData]: supply a
/// [filterDelegate] to control how a search query matches this entry, or leave
/// it null to fall back to a case-insensitive match against [name].
///
/// Example usage:
/// ```dart
/// GtSuccessRateData(
///   name: "Sterling Bank",
///   rate: 1,
///   logo: const AppImageData(GtVectors.logo),
///   filterDelegate: (query) =>
///       "Sterling Bank".includes(query) || "STL".includes(query),
/// )
/// ```
class GtSuccessRateData extends AppEquatable {
  /// The institution name displayed on the tile.
  final String name;

  /// The success rate as a fraction between `0.0` and `1.0`.
  ///
  /// Rendered as a percentage pill whose colour band is derived by
  /// [GtSuccessRateTile]: `>= .9` stable, `>= .8` away, `>= .7` warning,
  /// anything lower error.
  final double rate;

  /// The institution logo displayed at the leading edge.
  final AppImageData? logo;

  /// Invoked when the row is tapped. The row is inert when null.
  final OnPressed? onTap;

  final AppSearchDelegate<bool>? _filterDelegate;

  /// Creates a [GtSuccessRateData].
  const GtSuccessRateData({
    required this.name,
    required this.rate,
    this.logo,
    this.onTap,
    AppSearchDelegate<bool>? filterDelegate,
  }) : _filterDelegate = filterDelegate;

  /// Whether this entry should be included in the results for [query].
  ///
  /// An empty or null query always matches.
  bool filter(String? query) {
    if (_filterDelegate != null) return _filterDelegate(query.value);
    if (!query.hasValue) return true;
    return name.includes(query.value);
  }

  @override
  List<Object?> get props => [name, rate, logo];
}
