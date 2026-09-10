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
          context.copyText(value);
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

/// Defines the product styling and copy-icon position for a
/// [GtAccountCopyPill].
///
/// Variants without the `Trailing` suffix place the copy icon before the
/// account number. Their `Trailing` counterparts place it after the number.
enum GtAccountCopyPillVariant {
  /// Personal-account colors with a trailing copy icon.
  personalTrailing,

  /// Personal-account colors with a leading copy icon.
  personal,

  /// Flex-account colors with a trailing copy icon.
  flexTrailing,

  /// Flex-account colors with a leading copy icon.
  flex,

  /// Kids-account colors with a trailing copy icon.
  kidsTrailing,

  /// Kids-account colors with a leading copy icon.
  kids,

  /// Pro-account colors with a trailing copy icon.
  proTrailing,

  /// Pro-account colors with a leading copy icon.
  pro,

  /// Go-account colors with a trailing copy icon.
  goTrailing,

  /// Go-account colors with a leading copy icon.
  go;

  /// Resolves the account-number and copy-icon color from [colors].
  Color textColor(GtPaletteRawColors colors) => switch (this) {
    .personalTrailing => colors.tealBlue700,
    .personal => colors.tealBlue800,
    .flexTrailing => colors.green700,
    .flex => colors.green800,
    .kidsTrailing => colors.purple700,
    .kids => colors.purple800,
    .proTrailing => colors.maroon700,
    .pro => colors.maroon800,
    .goTrailing => colors.teal700,
    .go => colors.teal800,
  };

  /// Resolves the product-tinted background color from [colors].
  Color bgColor(GtPaletteRawColors colors) {
    if (isGo) return colors.tealAlpha8;
    if (isPro) return colors.maroonAlpha8;
    if (isKids) return colors.purpleAlpha8;
    if (isFlex) return colors.greenAlpha8;
    return colors.tealBlueAlpha8;
  }

  List<Color> _colorsList(GtPaletteRawColors colors) => switch (this) {
    .personalTrailing || .personal => [colors.navyAlpha3, colors.greenAlpha15],
    .flexTrailing || .flex => [colors.greenAlpha3, colors.greenAlpha15],
    .kidsTrailing || .kids => [colors.purpleAlpha3, colors.purpleAlpha15],
    .proTrailing || .pro => [colors.maroonAlpha3, colors.maroonAlpha15],
    .goTrailing || .go => [colors.tealAlpha3, colors.tealAlpha15],
  };

  /// Resolves the two-layer product-tinted elevation shadow from [colors].
  List<BoxShadow> shadows(GtPaletteRawColors colors) {
    final colorsList = _colorsList(colors);
    return [
      BoxShadow(
        color: colorsList[0],
        blurRadius: 4,
        offset: Offset(0, 2),
        spreadRadius: 0,
      ),
      BoxShadow(
        color: colorsList[1],
        blurRadius: 24,
        offset: Offset(0, 6),
        spreadRadius: 0,
      ),
    ];
  }

  /// Whether the copy icon appears after the account number.
  bool get isTrailing => name.endsWith("Trailing");

  /// Whether this variant uses the Personal account palette.
  bool get isPersonal => this == .personal || this == .personalTrailing;

  /// Whether this variant uses the Flex account palette.
  bool get isFlex => this == .flex || this == .flexTrailing;

  /// Whether this variant uses the Kids account palette.
  bool get isKids => this == .kids || this == .kidsTrailing;

  /// Whether this variant uses the Pro account palette.
  bool get isPro => this == .pro || this == .proTrailing;

  /// Whether this variant uses the Go account palette.
  bool get isGo => this == .go || this == .goTrailing;
}

/// Displays an account number in a product-themed pill and copies it when
/// tapped.
///
/// The selected [variant] controls the colors, the shadow, and whether the copy
/// icon sits before or after the text. The whole pill is a button-sized tap
/// target that writes [accountNumber] to the clipboard.
///
/// **What is shown and what is copied are separate.** [accountNumber] is always
/// what lands on the clipboard; [label] only changes what is drawn. Surfaces
/// that want a decorated caption — `"Savings • 0123456789"` — must pass the
/// bare number as [accountNumber] and the decorated string as [label],
/// otherwise the decoration is copied along with the number.
///
/// Every part of the [variant]'s styling can be overridden individually —
/// [backgroundColor], [borderColor], [textColor], [style], [showIcon],
/// [showShadow] and [borderStyle] — which is how the same pill serves both a
/// standalone badge and a flat caption under a balance.
///
/// Provide [semanticsLabel] when the visible text alone does not make the copy
/// action clear to assistive technologies. Use [semanticHint] for optional
/// supporting guidance.
///
/// {@category molecules}
/// {@category pills}
class GtAccountCopyPill extends GtStatelessWidget {
  /// The value written to the clipboard when the pill is tapped.
  ///
  /// Also the visible text — **uppercased** — while [label] is `null`. Once
  /// [label] is supplied this is copy-only and never rendered, so keep it the
  /// bare number rather than a decorated string.
  final String accountNumber;

  /// Overrides the visible text without affecting what is copied.
  ///
  /// Rendered **verbatim**, unlike [accountNumber], which is uppercased on the
  /// way in — supply the exact casing you want. It is also the fallback
  /// accessibility label when [semanticsLabel] is `null`.
  final String? label;

  /// An alternative accessibility label for the copy action.
  ///
  /// Falls back to [label], then to [accountNumber], so the pill is never
  /// announced unlabelled. Supply this where the number alone does not say
  /// which account it belongs to, or that tapping copies it.
  final String? semanticsLabel;

  /// Additional accessibility guidance for the copy action.
  final String? semanticHint;

  /// The product color scheme and copy-icon position.
  ///
  /// Resolves the text, background and shadow colors, and whether the icon is
  /// leading or trailing — see [GtAccountCopyPillVariant]. Still required when
  /// every color is overridden, because it also decides the icon side.
  final GtAccountCopyPillVariant variant;

  /// Overrides the [variant]'s background color.
  ///
  /// Also becomes the default [borderColor], so setting this alone keeps the
  /// border invisible against the fill.
  final Color? backgroundColor;

  /// Overrides the border color.
  ///
  /// Defaults to the resolved background color, which makes the border
  /// invisible — set this together with [borderStyle] to draw an outline.
  final Color? borderColor;

  /// Overrides the [variant]'s text color.
  ///
  /// Ignored by the text once [style] carries a color of its own, since [style]
  /// replaces the default text style wholesale.
  ///
  /// *Note: the copy icon is painted with this field directly rather than the
  /// color resolved from [variant], so leaving it `null` gives the icon the
  /// default strong icon color instead of the product color the text uses. Set
  /// it explicitly, or [showIcon] to `false`, wherever that mismatch shows.*
  final Color? textColor;

  /// Replaces the text style outright.
  ///
  /// Defaults to [GtTextStyles.button2s] tinted with the resolved text color.
  /// Because it is a replacement rather than a merge, a style without a `color`
  /// leaves the text uncolored — carry [textColor] into it yourself.
  final TextStyle? style;

  /// Whether the copy icon is drawn.
  ///
  /// Defaults to `true`. [variant] decides which side it lands on; this only
  /// decides whether it appears at all. Hiding it leaves the pill reading as a
  /// plain caption, so make sure the copy affordance is discoverable some other
  /// way.
  final bool showIcon;

  /// Whether the [variant]'s two-layer product-tinted elevation is drawn.
  ///
  /// Defaults to `true`. Turn it off where the pill sits on an already-elevated
  /// surface, or is being used as flat inline text.
  final bool showShadow;

  /// The border's line style.
  ///
  /// Defaults to [BorderStyle.solid]. It only shows once [borderColor] differs
  /// from the resolved background — the default border is solid but invisible.
  /// [BorderStyle.none] removes the border entirely.
  final BorderStyle borderStyle;

  /// Creates an account-number copy pill.
  const GtAccountCopyPill(
    this.accountNumber, {
    super.key,
    this.label,
    required this.variant,
    this.semanticsLabel,
    this.semanticHint,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.style,
    this.showIcon = true,
    this.showShadow = true,
    this.borderStyle = .solid,
  });

  @override
  Widget build(BuildContext context) {
    Widget? leading, trailing;

    final palette = context.palette;
    final txtColor = textColor ?? variant.textColor(palette.raw);
    final bgColor = backgroundColor ?? variant.bgColor(palette.raw);
    final shadows = showShadow ? variant.shadows(palette.raw) : null;

    final icon = GtIcon.withColor(
      GtIcons.copyFilled,
      size: context.dp(14.px),
      color: textColor,
    );

    if (variant.isTrailing && showIcon) trailing = icon;
    if (!variant.isTrailing && showIcon) leading = icon;

    return GtTapTarget(
      child: GtInkWell(
        role: .button,
        borderRadius: context.borderRadiusSm,
        semanticsLabel: semanticsLabel ?? label ?? accountNumber,
        semanticHint: semanticHint,
        excludeDescendantSemantics: semanticsLabel.hasValue,
        onTap: () {
          context.copyText(accountNumber);
        },
        child: Container(
          padding: context.insets.allDp(6.px),
          decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(
              color: borderColor ?? bgColor,
              style: borderStyle,
            ),
            borderRadius: context.borderRadiusMd,
            boxShadow: shadows,
          ),
          child: Row(
            mainAxisSize: .min,
            mainAxisAlignment: .start,
            crossAxisAlignment: .center,
            spacing: context.spacingSm,
            children: [
              ?leading,
              GtText(
                label ?? accountNumber.upper,
                textAlign: .center,
                style: style ?? context.textStyles.button2s(color: txtColor),
              ),
              ?trailing,
            ],
          ),
        ),
      ),
    );
  }
}
