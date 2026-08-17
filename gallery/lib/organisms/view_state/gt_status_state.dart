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
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'successful !',
  );
  final subtitle = context.knobs.string(
    label: 'Subtitle',
    initialValue:
        'Your BVN was added successfully. You can now initiate transactions.',
  );
  final actionLabel = context.knobs.string(
    label: 'Action Label',
    initialValue: 'Go Home',
  );
  final useCustomGraphic = context.knobs.boolean(
    label: 'Use Custom Graphic',
    initialValue: false,
  );
  final graphic = useCustomGraphic ? const GtSpinner(size: 64) : null;
  final graphicCode = useCustomGraphic
      ? '  graphic: const GtSpinner(size: 64),\n'
      : '';

  Widget statusWidget;
  String codeSnippet;

  if (mode == 'success') {
    statusWidget = GtStatusState.success(
      title: title,
      subtitle: subtitle,
      graphic: graphic,
      actionLabel: actionLabel,
      actionSize: .small,
      actionAlignment: .center,
      onActionPressed: () {},
    );
    codeSnippet =
        '''GtStatusState.success(
  title: "$title",
  subtitle: "$subtitle",
$graphicCode  actionLabel: "$actionLabel",
  actionSize: .small,
  actionAlignment: .center,
  onActionPressed: () {},
)''';
  } else if (mode == 'error') {
    statusWidget = GtStatusState.error(
      title: title,
      subtitle: subtitle,
      graphic: graphic,
      actionLabel: actionLabel,
      actionSize: .small,
      actionAlignment: .center,
      onActionPressed: () {},
    );
    codeSnippet =
        '''GtStatusState.error(
  title: "$title",
  subtitle: "$subtitle",
$graphicCode  actionSize: .small,
  actionAlignment: .center,
  actionLabel: "$actionLabel",
  onActionPressed: () {},
)''';
  } else {
    statusWidget = GtStatusState.custom(
      title: title,
      subtitle: subtitle,
      icon: useCustomGraphic
          ? null
          : AppImageData(GtVectorIllustrations.maintenance),
      graphic: graphic,
      actionSize: .small,
      actionAlignment: .center,
      actionLabel: actionLabel,
      onActionPressed: () {},
    );
    codeSnippet =
        '''GtStatusState.custom(
  title: "$title",
  subtitle: "$subtitle",
  ${useCustomGraphic ? 'graphic: const GtSpinner(size: 64),' : 'icon: AppImageData(GtVectorIllustrations.maintenance),'}
  actionSize: .small,
  actionAlignment: .center,
  actionLabel: "$actionLabel",
  onActionPressed: () {},
)''';
  }

  return GtWidgetDocPage(
    title: 'GtStatusState',
    description:
        'Displays fullscreen or card status screens representing operation success, failure, or maintenance.',
    code: codeSnippet,
    child: GtCard(
      padding: context.insets.allDp(16.px),
      variant: GtCardVariant.normal,
      child: statusWidget,
    ),
  );
}
