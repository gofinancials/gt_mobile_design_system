import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/extensions/extensions.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A widget that displays a horizontal scrollable list of items under a shared title.
///
/// Typically used to present a categorized section of widgets, such as a carousel
/// of featured cards or recent items.
class GtSectionSlide extends GtStatelessWidget {
  /// The list of widgets to display within the horizontal scroll view.
  final List<Widget> children;

  /// The fixed height of the horizontal scroll area.
  ///
  /// Defaults to 300 logical pixels.
  final double scrollHeight;

  /// An optional widget used to separate the [children].
  ///
  /// If null, defaults to a medium horizontal gap (`GtGap.hMd()`).
  final GtGap? gutter;

  /// The title displayed above the section. This text is automatically converted to uppercase.
  final String title;

  /// Creates a [GtSectionSlide].
  const GtSectionSlide({
    required this.title,
    required this.children,
    this.scrollHeight = 300,
    this.gutter,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final key = PageStorageKey(
      "gt-lesson-section-slide$title-${children.length}",
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: context.insets.defaultHorizontalInsets,
          child: GtText(title.upper, style: context.textStyles.buttonS()),
        ),
        GtGap.yBase(),
        GtSizedBox(
          height: scrollHeight,
          child: ListView.separated(
            key: key,
            padding: context.insets.defaultHorizontalInsets,
            itemBuilder: (_, index) => children[index],
            separatorBuilder: (_, index) => gutter ?? const GtGap.hMd(),
            itemCount: children.length,
            scrollDirection: Axis.horizontal,
          ),
        ),
        GtGap.ySectionSm(),
      ],
    );
  }
}
