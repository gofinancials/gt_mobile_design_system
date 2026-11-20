import 'package:gt_mobile_foundation/foundation.dart';

/// A single institution's transfer success rate, as presented by
/// [GtSuccessRateBody].
///
/// Mirrors the filtering contract of [GtDropdownData]: supply a
/// [filterDelegate] to control how a search query matches this entry, or leave
/// it null to fall back to a case-insensitive match against [name].
///
/// An institution with no known rate, such as one the gateway's availability
/// list leaves out or one whose rates failed to load, is still listed: leave
/// [rate] null and its row reads "N/A". While the rates are being fetched, set
/// [isLoading] so the row draws a placeholder pill instead.
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
///
/// The recipient's bank while its rate loads, then with none to show:
/// ```dart
/// GtSuccessRateData(name: "Sterling Bank", isLoading: true)
/// GtSuccessRateData(name: "Sterling Bank")
/// ```
class GtSuccessRateData extends AppEquatable {
  /// The institution name displayed on the tile.
  final String name;

  /// The success rate as a fraction between `0.0` and `1.0`, or null when no
  /// rate is available for this institution.
  ///
  /// Rendered as a percentage pill whose colour band is derived by
  /// [GtSuccessRateTile]: `>= .9` stable, `>= .8` away, `>= .7` warning,
  /// anything lower error. A null rate renders a neutral "N/A" pill.
  final double? rate;

  /// Whether the rate is still being fetched. Defaults to false.
  ///
  /// Only the pill is drawn as a skeleton; the name and logo stay real, so the
  /// row holds its place while the rates load.
  final bool isLoading;

  /// What is announced while [isLoading] is set, such as "Loading rate".
  ///
  /// See [GtSkeleton.semanticsLabel].
  final String? loadingSemanticsLabel;

  /// The institution logo displayed at the leading edge.
  final AppImageData? logo;

  /// Invoked when the row is tapped. The row is inert when null.
  final OnPressed? onTap;

  final AppSearchDelegate<bool>? _filterDelegate;

  /// Creates a [GtSuccessRateData].
  const GtSuccessRateData({
    required this.name,
    this.rate,
    this.isLoading = false,
    this.loadingSemanticsLabel,
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
  List<Object?> get props => [name, rate, isLoading, logo];
}
