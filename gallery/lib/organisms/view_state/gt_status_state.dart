import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtStatusState', type: GtStatusState)
Widget playgroundGtStatusStateUseCase(BuildContext context) {
  final mode = context.knobs.object.dropdown<String>(
    label: 'Status Mode',
    options: ['success', 'error', 'custom'],
    initialOption: 'success',
  );
  final title = context.knobs.string(label: 'Title', initialValue: 'successful !');
  final subtitle = context.knobs.string(
    label: 'Subtitle',
    initialValue: 'Your BVN was added successfully. You can now initiate transactions.',
  );
  final actionLabel = context.knobs.string(label: 'Action Label', initialValue: 'Go Home');

  Widget statusWidget;
  String codeSnippet;

  if (mode == 'success') {
    statusWidget = GtStatusState.success(
      title: title,
      subtitle: subtitle,
      actionLabel: actionLabel,
      onActionPressed: () {},
    );
    codeSnippet = '''GtStatusState.success(
  title: "$title",
  subtitle: "$subtitle",
  actionLabel: "$actionLabel",
  onActionPressed: () {},
)''';
  } else if (mode == 'error') {
    statusWidget = GtStatusState.error(
      title: title,
      subtitle: subtitle,
      actionLabel: actionLabel,
      onActionPressed: () {},
    );
    codeSnippet = '''GtStatusState.error(
  title: "$title",
  subtitle: "$subtitle",
  actionLabel: "$actionLabel",
  onActionPressed: () {},
)''';
  } else {
    statusWidget = GtStatusState.custom(
      title: title,
      subtitle: subtitle,
      icon: AppImageData(GtVectorIllustrations.maintenance),
      actionLabel: actionLabel,
      onActionPressed: () {},
    );
    codeSnippet = '''GtStatusState.custom(
  title: "$title",
  subtitle: "$subtitle",
  icon: AppImageData(GtVectorIllustrations.maintenance),
  actionLabel: "$actionLabel",
  onActionPressed: () {},
)''';
  }

  return GtWidgetDocPage(
    title: 'GtStatusState',
    description: 'Displays fullscreen or card status screens representing operation success, failure, or maintenance.',
    code: codeSnippet,
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
        child: GtCard(
          padding: context.insets.allDp(16.px),
          variant: GtCardVariant.normal,
          child: statusWidget,
        ),
      ),
    ),
  );
}
