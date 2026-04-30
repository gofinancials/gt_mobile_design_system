import 'package:flutter/material.dart';
import 'package:gallery/widgets/gallery_page_header.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

String _accessStatusLabel(GtAccessStatus s) {
  return switch (s) {
    GtAccessStatus.fullAccess => 'Full access',
    GtAccessStatus.noAccess => 'No access',
    GtAccessStatus.viewOnly => 'View only',
  };
}

/// Widgetbook preview for [GtStatusText] (access status icon + label row).
@widgetbook.UseCase(name: 'Access status', type: GtStatusText)
Widget playgroundGtStatusTextUseCase(BuildContext context) {
  final status = context.knobs.object.dropdown<GtAccessStatus>(
    label: 'Access status',
    options: GtAccessStatus.values,
    initialOption: GtAccessStatus.fullAccess,
    labelBuilder: _accessStatusLabel,
  );

  final labelOverride = context.knobs.string(
    label: 'Label override ',
    initialValue: '',
  );

  return Scaffold(
    body: Padding(
      padding: context.insets.symmetricDp(
        horizontal: context.grid.singleColumn.margins.px,
      ),
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          GalleryPageHeader(
            title: 'Status text',
            rider: 'Representation of access status as an icon and label.',
          ),
          const GtGap.yXl(),
          GtStatusText(
            status: status,
            label: labelOverride.trim().isEmpty ? null : labelOverride.trim(),
          ),
        ],
      ),
    ),
  );
}
