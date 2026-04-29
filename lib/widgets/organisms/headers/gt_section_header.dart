import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A header widget typically used to introduce a section of content.
///
/// It displays a primary [title] on the left and an optional [trailing] widget
/// (such as a "See All" button or an icon) on the right.
class GtSectionHeader extends GtStatelessWidget {
  /// An optional widget displayed at the trailing edge of the header.
  ///
  /// Often used for actions related to the section, like a text button or an icon.
  final Widget? trailing;

  /// The main title text of the header.
  ///
  /// This text is automatically converted to uppercase.
  final String title;

  /// Creates a [GtSectionHeader].
  const GtSectionHeader(this.title, {this.trailing, super.key});

  @override
  Widget build(BuildContext context) {
    Widget child = GtText(title.upper, style: context.textStyles.buttonS());

    if (trailing != null) {
      child = Row(
        crossAxisAlignment: .center,
        spacing: context.spacingMd,
        children: [
          Expanded(child: child),
          ?trailing,
        ],
      );
    }
    return child;
  }
}
