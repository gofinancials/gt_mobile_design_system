import 'package:flutter/material.dart';
import 'package:gallery/widgets/gallery_page_header.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Interactive preview for [GtPageHeader] (screen title + optional subtitle).
@widgetbook.UseCase(name: 'Page header', type: GtPageHeader)
Widget playgroundGtPageHeaderUseCase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Almost there!',
  );
  final hasSubtitle = context.knobs.boolean(
    label: 'Show subtitle',
    initialValue: true,
  );
  final subtitle = context.knobs.string(
    label: 'Subtitle',
    initialValue: 'See balances and recent activity in one place.',
  );

  return Scaffold(
    body: Padding(
      padding: context.insets.symmetricDp(
        horizontal: context.grid.singleColumn.margins.px,
      ),
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          GalleryPageHeader(title: "Headers", rider: "headers Playground"),
          const GtGap.yXl(),
          GtPageHeader(
            title: title,
            subtitle: hasSubtitle && subtitle.trim().isNotEmpty
                ? subtitle
                : null,
          ),
        ],
      ),
    ),
  );
}
