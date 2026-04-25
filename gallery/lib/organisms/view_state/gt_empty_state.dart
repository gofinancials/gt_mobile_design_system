import 'package:flutter/material.dart';
import 'package:gallery/widgets/gallery_page_header.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// A use case for the [GtEmptyState] component.
@widgetbook.UseCase(name: 'Empty state', type: GtEmptyState)
Widget playgroundGtEmptyStateUseCase(BuildContext context) {
  final state = context.knobs.object.dropdown<(String, String, String, String)>(
    label: 'Illustration',
    initialOption: (
      'Empty State',
      GtVectorIllustrations.empty,
      "You're all caught up",
      'No new notifications at the moment.',
    ),
    options: [
      (
        'Search',
        GtVectorIllustrations.search,
        'No search results',
        'Try a different keyword or adjust your filters.',
      ),
      (
        'Not Found',
        GtVectorIllustrations.notFound,
        'Page not found',
        "We couldn't find what you're looking for.",
      ),
      (
        'Empty State',
        GtVectorIllustrations.empty,
        "You're all caught up",
        'No new notifications at the moment.',
      ),
    ],
    labelBuilder: (value) => value.$1,
  );

  return Scaffold(
    body: Padding(
      padding: context.insets.defaultHorizontalInsets,
      child: Column(
        crossAxisAlignment: .stretch,
        spacing: context.spacingLg,
        children: [
          const GalleryPageHeader(
            title: 'Empty State',
            rider: 'Reusable empty-state component.',
          ),
          const GtGap.yXl(),
          GtEmptyState(icon: state.$2, title: state.$3, subtitle: state.$4),
        ],
      ),
    ),
  );
}
