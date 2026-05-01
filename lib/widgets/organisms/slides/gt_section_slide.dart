import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A widget that displays a horizontal scrollable list of items under a shared
/// title.
///
/// This widget is ideal for creating carousels or horizontally scrolling sections
/// within a page. It combines a [GtSectionHeader] with a `ListView.separated`
/// to present a collection of widgets in a compact and interactive way.
///
/// It supports two modes of creation:
/// 1. Directly providing a `List<Widget>` via the default constructor.
/// 2. Using a builder function via the `GtSectionSlide.builder` constructor for
///    lazily loaded or large lists.
///
/// The scroll view's height is fixed by [scrollHeight], and its children are
/// separated by [gutter].
class GtSectionSlide extends GtStatelessWidget {
  /// The list of widgets to display within the horizontal scroll view.
  ///
  /// This is used by the default constructor. For a builder-based approach,
  /// see [GtSectionSlide.builder].
  final List<Widget> children;

  /// The fixed height of the horizontal scroll area where [children] are displayed.
  ///
  /// Defaults to 300 logical pixels.
  final double scrollHeight;

  /// An optional widget used to separate the items in the scroll view.
  ///
  /// If null, defaults to a medium horizontal gap ([GtGap.hMd]).
  final GtGap? gutter;

  /// The title displayed above the section using a [GtSectionHeader].
  ///
  /// This text is automatically converted to uppercase.
  final String title;

  /// The builder function for creating items lazily.
  ///
  /// Used by the [GtSectionSlide.builder] constructor.
  final IndexedWidgetBuilder? _builder;

  /// The number of items to build.
  ///
  /// Used by the [GtSectionSlide.builder] constructor.
  final int? _itemCount;

  /// Creates a [GtSectionSlide] with an explicit list of [children].
  ///
  /// This is suitable for a small, fixed number of items. For larger or dynamic
  /// lists, consider using [GtSectionSlide.builder] for better performance.
  const GtSectionSlide({
    required this.title,
    required this.children,
    this.scrollHeight = 300,
    this.gutter,
    super.key,
  }) : _builder = null,
       _itemCount = null;

  /// Creates a [GtSectionSlide] that builds its children on demand.
  ///
  /// This constructor is ideal for lists that are long or whose content is
  /// expensive to build, as it creates children just as they are scrolled into view.
  ///
  /// The [builder] is called for each `index` from 0 to `itemCount - 1`.
  const GtSectionSlide.builder({
    required this.title,
    this.scrollHeight = 300,
    this.gutter,
    super.key,
    required IndexedWidgetBuilder builder,
    required int itemCount,
  }) : _builder = builder,
       _itemCount = itemCount,
       children = const [];

  @override
  Widget build(BuildContext context) {
    final itemCount = _itemCount ?? children.length;
    final key = PageStorageKey("gt-section-slide-$title-$itemCount");
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: context.insets.defaultHorizontalInsets,
          child: GtSectionHeader(title.upper),
        ),
        GtGap.yBase(),
        GtSizedBox(
          height: scrollHeight,
          child: ListView.separated(
            key: key,
            padding: context.insets.defaultHorizontalInsets,
            itemBuilder: _builder ?? (_, index) => children[index],
            separatorBuilder: (_, index) => gutter ?? const GtGap.hMd(),
            itemCount: itemCount,
            scrollDirection: Axis.horizontal,
          ),
        ),
        GtGap.ySectionSm(),
      ],
    );
  }
}
