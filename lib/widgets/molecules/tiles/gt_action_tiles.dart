import 'package:flutter/material.dart';
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

  /// Optional vertical spacing override.
  final double? verticalSpacing;

  /// Optional horizontal spacing override.
  final double? horizontalSpacing;

  /// Optional padding override.
  final EdgeInsetsGeometry? padding;

  /// Overrides title style. Null preserves the current default.
  final TextStyle? titleStyle;

  /// Overrides subtitle style. Null preserves the current default.
  final TextStyle? subtitleStyle;

  /// Creates a [GtExportListTile].
  const GtExportListTile(
    this.title, {
    super.key,
    this.subtitle,
    required this.onTap,
    this.verticalSpacing,
    this.horizontalSpacing,
    this.padding,
    this.titleStyle,
    this.subtitleStyle,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    TextStyle defaultTitleStyle = context.textStyles.subHeadM();
    TextStyle? defaultSubStyle;

    if (subtitle.hasValue) {
      defaultTitleStyle = context.textStyles.subHeadS();
      defaultSubStyle = context.textStyles.bodyXs(color: palette.text.soft);
    }

    return GtInkWell(
      role: .button,
      borderRadius: .zero,
      onTap: onTap,
      child: Padding(
        padding: padding ?? context.insets.symmetricDp(vertical: 12.px),
        child: Row(
          spacing: horizontalSpacing ?? context.spacingBase,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: verticalSpacing ?? context.spacingXs,
                children: [
                  GtText(title, style: titleStyle ?? defaultTitleStyle),
                  if (subtitle.hasValue)
                    GtText(subtitle, style: subtitleStyle ?? defaultSubStyle),
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

  /// Optional callback for removing the device.
  final OnPressed? _onRemove;

  /// Optional text for the remove button.
  final String? _buttonText;

  /// Optional horizontal spacing override.
  final double? horizontalSpacing;

  /// Creates a standard [GtDeviceListTile] without a remove button.
  const GtDeviceListTile(
    this.title, {
    super.key,
    required this.subtitle,
    required this.icon,
    this.horizontalSpacing,
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
    this.horizontalSpacing,
  }) : _onRemove = onRemove,
       _buttonText = buttonText;

  @override
  Widget build(BuildContext context) {
    Widget child = GtIconListTile(title, subtitle: subtitle, icon: icon);

    if (_onRemove != null) {
      child = Row(
        spacing: horizontalSpacing ?? context.spacingMd,
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
