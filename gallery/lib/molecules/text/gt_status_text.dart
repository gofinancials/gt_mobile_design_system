import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
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

@widgetbook.UseCase(name: 'Access status', type: GtStatusText)
Widget playgroundGtStatusTextUseCase(BuildContext context) {
  final status = context.knobs.object.dropdown<GtAccessStatus>(
    label: 'Access status',
    options: GtAccessStatus.values,
    initialOption: GtAccessStatus.fullAccess,
    labelBuilder: _accessStatusLabel,
  );

  final labelOverride = context.knobs.string(
    label: 'Label override',
    initialValue: '',
  );

  final codeSnippet = '''
GtStatusText(
  status: GtAccessStatus.${status.name},
  label: ${labelOverride.trim().isEmpty ? 'null' : '"$labelOverride"'},
)''';

  return GtWidgetDocPage(
    title: 'GtStatusText',
    description: 'Displays access status representation using an icon and label side-by-side.',
    code: codeSnippet,
    child: Center(
      child: GtStatusText(
        status: status,
        label: labelOverride.trim().isEmpty ? null : labelOverride.trim(),
      ),
    ),
  );
}
