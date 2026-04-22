import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A list tile used for export or share actions, prominently displaying a title
/// and an optional subtitle along with a share icon.
class GtExportListTile extends GtStatelessWidget {
  /// The primary text displayed prominently in the tile.
  final String title;

  /// Optional secondary text displayed below the [title].
  final String? subtitle;

  /// The callback triggered when the tile is tapped. Provides light haptic feedback.
  final OnPressed onTap;

  /// Creates a [GtExportListTile].
  const GtExportListTile(
    this.title, {
    super.key,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    TextStyle titleStyle = context.textStyles.subHeadM();
    TextStyle? subStyle;

    if (subtitle.hasValue) {
      titleStyle = context.textStyles.subHeadS();
      subStyle = context.textStyles.bodyXs(color: palette.text.soft);
    }

    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap.call();
      },
      child: Padding(
        padding: context.insets.symmetricDp(vertical: 12.px),
        child: Row(
          spacing: context.spacingBase,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: context.spacingXs,
                children: [
                  GtText(title, style: titleStyle),
                  if (subtitle.hasValue) GtText(subtitle, style: subStyle),
                ],
              ),
            ),
            GtIcon(
              GtIcons.shareIos,
              size: 20,
              alignment: Alignment.centerRight,
              variant: .soft,
            ),
          ],
        ),
      ),
    );
  }
}

/// A list tile for displaying connected devices or sessions.
///
/// Can optionally include a remove button using the [GtDeviceListTile.removable] constructor.
class GtDeviceListTile extends GtStatelessWidget {
  /// The primary name or label of the device.
  final String title;

  /// Additional details about the device, such as its status or location.
  final String subtitle;

  /// The icon representing the device type.
  final IconData icon;
  final OnPressed? _onRemove;
  final String? _buttonText;

  /// Creates a standard [GtDeviceListTile] without a remove button.
  const GtDeviceListTile(
    this.title, {
    super.key,
    required this.subtitle,
    required this.icon,
  }) : _onRemove = null,
       _buttonText = null;

  /// Creates a [GtDeviceListTile] that includes a destructive action button.
  ///
  /// Requires an [onRemove] callback and [buttonText] to display on the button.
  const GtDeviceListTile.removable(
    this.title, {
    super.key,
    required this.subtitle,
    required this.icon,
    required OnPressed onRemove,
    required String buttonText,
  }) : _onRemove = onRemove,
       _buttonText = buttonText;

  @override
  Widget build(BuildContext context) {
    Widget child = GtIconListTile(title, subtitle: subtitle, icon: icon);

    if (_onRemove != null) {
      child = Row(
        spacing: context.spacingMd,
        children: [
          Expanded(child: child),
          GtRaisedButton(
            onPressed: _onRemove,
            text: _buttonText,
            variant: .destructiveAlt,
            size: .pill,
            alignment: Alignment.centerRight,
          ),
        ],
      );
    }

    return child;
  }
}
