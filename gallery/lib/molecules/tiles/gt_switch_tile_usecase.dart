import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtSwitchTile', type: GtSwitchTile)
Widget playgroundGtSwitchTileUseCase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Biometric Login',
  );
  final subtitle = context.knobs.string(
    label: 'Subtitle',
    initialValue: 'Use FaceID or Fingerprint to authenticate.',
  );
  final disabled = context.knobs.boolean(
    label: 'Disabled',
    initialValue: false,
  );
  final value = context.knobs.boolean(label: 'Value', initialValue: true);
  final activeColor = context.knobs.colorOrNull(
    label: 'Active Color',
    initialValue: null,
  );
  final hasIcon = context.knobs.boolean(label: 'Has Icon', initialValue: true);
  final leading = hasIcon ? const GtIcon(GtIcons.notificationUnread) : null;

  return GtWidgetDocPage(
    title: 'GtSwitchTile',
    description:
        'A settings/preferences toggle row with built-in selection using GtSwitch.',
    code:
        '''
GtSwitchTile(
  "Biometric Login",
  value: $value,
  onChanged: (value) {},
  disabled: $disabled,
  ${hasIcon ? 'leading: GtIcon(GtIcons.refreshSolid),' : ''}
  subtitle: "Use FaceID or Fingerprint to authenticate.",
)''',
    child: GtCard(
      padding: context.insets.allDp(16.px),
      variant: GtCardVariant.normal,
      child: GtSwitchTile(
        title,
        value: value,
        onChanged: (val) {},
        disabled: disabled,
        activeColor: activeColor,
        leading: leading,
        subtitle: subtitle.isEmpty ? null : subtitle,
      ),
    ),
  );
}
