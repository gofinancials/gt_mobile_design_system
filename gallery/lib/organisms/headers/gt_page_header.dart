import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Interactive preview for [GtPageHeader] (screen title + optional subtitle).
@widgetbook.UseCase(
  name: 'Page header',
  type: GtPageHeader,
  path: '[Organisms]/Headers',
)
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
    body: SafeArea(
      child: SingleChildScrollView(
        padding: context.insets.symmetricDp(
          horizontal: context.grid.singleColumn.margins.px,
          vertical: 16.px,
        ),
        child: GtPageHeader(
          title: title,
          subtitle: hasSubtitle && subtitle.trim().isNotEmpty ? subtitle : null,
        ),
      ),
    ),
  );
}


