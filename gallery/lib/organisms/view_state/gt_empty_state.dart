import 'package:flutter/material.dart';
import 'package:gallery/widgets/gallery_page_header.dart';
import 'package:gt_mobile_foundation/data/models/media_data.dart';
import 'package:gt_mobile_foundation/typedefs/typedefs.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// A use case for the [GtEmptyState] component.
@widgetbook.UseCase(name: 'Empty state', type: GtEmptyState)
Widget playgroundGtEmptyStateUseCase(BuildContext context) {
  final state = context.knobs.object
      .dropdown<
        (String, String, String, String, String?, OnPressed?, GtButtonVariant?)
      >(
        label: 'Illustration',
        initialOption: (
          'Empty State',
          GtVectorIllustrations.empty,
          "You're all caught up",
          'No new notifications at the moment.',
          null,
          null,
          null,
        ),
        options: [
          (
            'Search',
            GtVectorIllustrations.search,
            'No search results',
            'Try a different keyword or adjust your filters.',
            null,
            null,
            null,
          ),
          (
            'Not Found',
            GtVectorIllustrations.notFound,
            'Page not found',
            "We couldn't find what you're looking for.",
            null,
            null,
            null,
          ),
          (
            'Empty State With Black Button',
            GtVectorIllustrations.empty,
            "You're all caught up",
            'No new notifications at the moment.',
            "Add Beneficiary",
            () {},
            GtButtonVariant.black,
          ),
          (
            'Empty State With Primary Button',
            GtVectorIllustrations.empty,
            "You're all caught up",
            'No new notifications at the moment.',
            'Add Beneficiary',
            () {},
            GtButtonVariant.primary,
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
          GtEmptyState(
            icon: AppImageData(state.$2),
            title: state.$3,
            subtitle: state.$4,
            actionText: state.$5,
            onActionPressed: state.$6,
            buttonVariant: state.$7,
          ),
        ],
      ),
    ),
  );
}
