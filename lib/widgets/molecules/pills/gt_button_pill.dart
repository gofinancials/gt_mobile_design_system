import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A specialized pill widget intended for tags or interactive-looking badges.
///
/// Features slightly larger padding and a larger icon size compared to [GtStatusPill].
/// Supports tapping interactions by utilizing [onTap].
class GtButtonPill extends GtStatelessWidget {
  /// The text to display on the button.
  final String text;

  /// The visual variant determining the color scheme of the button pill.
  final GtPillVariant? variant;

  /// An optional leading icon to display. Rendered at size 14.
  final IconData? icon;

  /// An optional trailing icon to display after the text. Rendered at size 14.
  final IconData? trailing;

  /// The alignment of the content within the button pill.
  final Alignment? alignment;

  /// An optional callback triggered when the user taps on the pill.
  final OnPressed? onTap;

  /// Whether to display a drop shadow beneath the button pill to indicate depth.
  final bool showShadow;

  /// The overall size configuration of the button pill.
  final GtPillSize size;

  /// An alternative accessibility label for the button.
  final String? semanticsLabel;

  /// Additional accessibility guidance for the button's action.
  final String? semanticHint;

  /// Creates a [GtButtonPill].
  const GtButtonPill({
    super.key,
    required this.text,
    this.variant,
    this.icon,
    this.trailing,
    this.alignment,
    this.onTap,
    this.showShadow = false,
    this.size = .normal,
    this.semanticsLabel,
    this.semanticHint,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textColor = variant.getTextColor(palette);
    final bgColor = variant.getBgColor(palette);

    Widget? iconWidget;
    Widget? trailingWidget;

    if (icon != null) {
      iconWidget = GtIcon.withColor(icon!, color: textColor, size: 14);
    }

    if (trailing != null) {
      trailingWidget = GtIcon.withColor(trailing!, color: textColor, size: 14);
    }

    final padding = switch (size) {
      .larger => 8.px,
      _ => 6.px,
    };

    final pill = GtPill(
      text: text.upper,
      bgColor: bgColor,
      borderColor: bgColor,
      icon: iconWidget,
      textColor: textColor,
      padding: context.insets.allDp(padding),
      trailing: trailingWidget,
      alignment: alignment,
      showShadow: showShadow,
      variant: variant ?? .strong,
      semanticsLabel: onTap == null ? semanticsLabel : null,
    );

    if (onTap == null) return pill;

    return GtTapTarget(
      child: GtInkWell(
        role: .button,
        borderRadius: context.borderRadiusSm,
        onTap: onTap,
        semanticsLabel: semanticsLabel,
        semanticHint: semanticHint,
        excludeDescendantSemantics: semanticsLabel != null,
        child: pill,
      ),
    );
  }
}

/// A specialized pill widget designed to copy a specific value to the clipboard when tapped.
///
/// It visually resembles a standard [GtPill] but inherently handles the copy-to-clipboard
/// interaction and provides default text and icon styling.
class GtCopyPill extends GtStatelessWidget {
  /// The underlying value that will be copied to the clipboard when the pill is tapped.
  final String value;

  /// The text to display on the pill. If not provided, defaults to a localized 'copy' string.
  final String? text;

  /// An optional custom leading widget (typically an icon). Defaults to a file copy icon.
  final Widget? leading;

  /// The visual variant determining the color scheme of the pill. Defaults to [GtPillVariant.strong].
  final GtPillVariant variant;

  /// An alternative accessibility label for the copy action.
  final String? semanticsLabel;

  /// Additional accessibility guidance for the copy action.
  final String? semanticHint;

  /// Creates a [GtCopyPill].
  const GtCopyPill(
    this.value, {
    super.key,
    this.text,
    this.leading,
    this.variant = .strong,
    this.semanticsLabel,
    this.semanticHint,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textColor = variant.getTextColor(palette);
    final bgColor = variant.getBgColor(palette);
    final defaultLeading = GtIcon(
      GtIcons.fileFilled,
      size: 13,
      variant: .disabled,
    );

    final label = text?.upper ?? "copy".utr();

    return GtTapTarget(
      child: GtInkWell(
        role: .button,
        borderRadius: context.borderRadiusSm,
        semanticsLabel: semanticsLabel,
        semanticHint: semanticHint,
        excludeDescendantSemantics: semanticsLabel != null,
        onTap: () {
          context.copyTextToClipboard(value);
        },
        child: GtPill(
          icon: leading ?? defaultLeading,
          text: label,
          textStyle: context.textStyles.buttonXxs(color: textColor),
          variant: variant,
          textColor: textColor,
          bgColor: bgColor,
          padding: context.insets.allDp(4.px),
        ),
      ),
    );
  }
}

// /// A specialized pill widget designed to copy a specific value to the clipboard when tapped.
// ///
// /// It visually resembles a standard [GtPill] but inherently handles the copy-to-clipboard
// /// interaction and provides default text and icon styling.
// class GtAccountCopyPill extends GtStatelessWidget {
//   /// The underlying value that will be copied to the clipboard when the pill is tapped.
//   final String value;

//   /// The text to display on the pill. If not provided, defaults to a localized 'copy' string.
//   final String? text;

//   /// An optional custom leading widget (typically an icon). Defaults to a file copy icon.
//   final Widget? icon;

//   /// The visual variant determining the color scheme of the pill. Defaults to [GtPillVariant.strong].
//   final GtPillVariant variant;

//   /// An alternative accessibility label for the copy action.
//   final String? semanticsLabel;

//   /// Additional accessibility guidance for the copy action.
//   final String? semanticHint;

//   /// Creates a [GtCopyPill].
//   const GtAccountCopyPill(
//     this.value, {
//     super.key,
//     this.text,
//     this.variant = .strong,
//     this.semanticsLabel,
//     this.semanticHint,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final palette = context.palette;
//     final textColor = variant.getTextColor(palette);
//     final bgColor = variant.getBgColor(palette);
//     final defaultLeading = GtIcon(
//       GtIcons.fileFilled,
//       size: 13,
//       variant: .disabled,
//     );

//     final label = text?.upper ?? "copy".utr();

//     return GtTapTarget(
//       child: GtInkWell(
//         role: .button,
//         borderRadius: context.borderRadiusSm,
//         semanticsLabel: semanticsLabel,
//         semanticHint: semanticHint,
//         excludeDescendantSemantics: semanticsLabel != null,
//         onTap: () {
//           context.copyTextToClipboard(value);
//         },
//         child: Container(
//           padding: context.insets.symmetricDp(horizontal: 8.px, vertical: 6.px),
//           decoration: BoxDecoration(
//             color: context.palette.primary.alpha10,
//             border: Border.all(
//               width: 1,
//               color: context.palette.primary.alpha10,
//             ),
//             borderRadius: context.borderRadiusMd,
//             boxShadow: [
//               BoxShadow(
//                 color: Color(0x070E121B),
//                 blurRadius: 4,
//                 offset: Offset(0, 2),
//                 spreadRadius: 0,
//               ),
//               BoxShadow(
//                 color: Color(0x261FC16B),
//                 blurRadius: 24,
//                 offset: Offset(0, 6),
//                 spreadRadius: 0,
//               ),
//             ],
//           ),

//           child: Row(
//             mainAxisSize: .min,
//             mainAxisAlignment: .start,
//             crossAxisAlignment: .center,
//             spacing: context.spacingSm,
//             children: [
//               GtText(
//                 label,
//                 textAlign: .center,
//                 style: context.textStyles.button2s(
//                   color: context.palette.primary.dark,
//                 ),
//               ),
//               GtIcon.withColor(
//                 GtIcons.copyFilled,
//                 color: context.palette.primary.dark,
//                 size: context.dp(14.px),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
