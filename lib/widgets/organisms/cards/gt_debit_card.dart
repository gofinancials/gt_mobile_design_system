import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Debit-card selection card with top text content and a bottom-stacked image.
///
/// Layout structure:
/// - Foreground row (title/subtitle + trailing chevron).
/// - Decorative/preview image pinned to the bottom-right.
class GtPaymentCardSelectionCard extends GtStatelessWidget {
  /// Main card title.
  final String title;

  /// Optional supporting subtitle below the title.
  final String subtitle;

  /// Card preview/illustration displayed at the bottom-right of the container.
  final AppImageData? image;

  /// Tap callback for the whole card.
  final OnPressed? onPressed;

  /// Optional custom background color.
  ///
  /// Defaults to [GtPaletteBgColors.weak].
  final Color? backgroundColor;

  /// Optional fee badge text (e.g. "N1000" or "FREE").
  final String feeLabel;

  /// Creates a [GtPaymentCardSelectionCard].
  const GtPaymentCardSelectionCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.image,
    this.onPressed,
    this.backgroundColor,
    required this.feeLabel,
  });

  /// Button style token for the card title.
  TextStyle _titleStyle(BuildContext context) {
    return context.textStyles.button(color: context.palette.text.strong);
  }

  /// Body 2XS style token for the optional subtitle.
  TextStyle _subtitleStyle(BuildContext context) {
    return context.textStyles
        .body2Xs(color: GtColors.neutral400.value)
        .copyWith(height: 1.45);
  }

  /// White label text shown inside the fee badge.
  TextStyle _feeLabelStyle(BuildContext context) {
    return context.textStyles.buttonXs(color: context.palette.text.white);
  }

  @override
  Widget build(BuildContext context) {
    final radius = context.borderRadius2Xl;
    final borderRadius = BorderRadius.only(
      topLeft: radius.topLeft,
      topRight: radius.topRight,
      bottomLeft: radius.bottomLeft,
    );

    return GtCard(
      padding: .zero,
      constraints: BoxConstraints(minHeight: context.dp(190.px)),
      border: .none,
      borderRadius: borderRadius,
      color: backgroundColor,
      child: Stack(
        children: [
          if (image != null)
            Positioned(
              right: 0,
              bottom: 0,
              child: FractionalTranslation(
                translation: Offset(.015, 0),
                child: GtImage(
                  image: image,
                  width: context.dp(132.px),
                  height: context.dp(99.px),
                  fit: BoxFit.contain,
                  useDefaultSize: false,
                  isDecorative: true,
                ),
              ),
            ),
          Padding(
            padding: context.insets.allDp(16.px),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: .start,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: .min,
                        crossAxisAlignment: .start,
                        children: [
                          GtText(title.upper, style: _titleStyle(context)),
                          if (subtitle.hasValue) ...[
                            GtGap.yXs(),
                            GtText(
                              subtitle.value.capitalise(true),
                              style: _subtitleStyle(context),
                            ),
                          ],
                          GtGap.yMd(),
                          Container(
                            padding: context.insets.symmetricDp(
                              horizontal: 5.px,
                              vertical: 3.px,
                            ),
                            decoration: BoxDecoration(
                              color: context.palette.bg.strong,
                              borderRadius: 5.circularBorderRadius,
                            ),
                            child: GtText(
                              feeLabel,
                              style: _feeLabelStyle(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GtGap.hBase(),
                    GtIcon(
                      GtIcons.chevronRight,
                      variant: .soft,
                      size: context.dp(18.px),
                      alignment: Alignment.topRight,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Represents the visual tier or product variation of a payment card.
enum GtDebitCardType {
  /// Virtual digital card with a specialized patterned background.
  virtual,

  /// Standard Classic debit card tier.
  classic,

  /// Business corporate debit card tier.
  business,

  /// Premium Prime debit card tier.
  prime,

  /// High-tier World debit card featuring a multi-stop gradient.
  world,

  /// Kids debit card featuring a colorful decorative pattern.
  kid;

  /// Returns the background image provider associated with this card type, if any.
  ImageProvider? get backgroundImage => switch (this) {
    virtual => CachedNetworkImageProvider(GtNetworkImages.virtualCardBg),
    kid => CachedNetworkImageProvider(GtNetworkImages.kidsPattern),
    _ => null,
  };

  /// Returns the vector chip asset corresponding to the card tier.
  AppImageData? get chipImage => switch (this) {
    world => AppImageData(GtVectors.premiumChip),
    kid => AppImageData(GtVectors.chip),
    _ => AppImageData(GtVectors.simChip),
  };

  /// Returns the base background color resolved against the active [GtPalette].
  Color backgroundColor(GtPalette palette) => switch (this) {
    classic => palette.cardColors.classic,
    business => palette.cardColors.business,
    prime => palette.cardColors.prime,
    world => palette.cardColors.worldStop1,
    kid => palette.highlighted.base,
    virtual => palette.stable.base,
  };

  /// Returns the foreground icon/text color for the frozen overlay against the card.
  Color overlayColor(GtPalette palette) => switch (this) {
    prime => palette.staticColors.black,
    _ => backgroundColor(palette),
  };

  /// Returns the background gradient if this card type uses a gradient fill.
  Gradient? gradient(GtPalette palette) => switch (this) {
    world => palette.cardColors.worldGradient,
    _ => null,
  };

  /// Returns the primary text color for the cardholder label against this card type.
  Color textColor(GtPalette palette) => switch (this) {
    prime => palette.staticColors.black,
    _ => palette.staticColors.white,
  };

  /// Indicates whether this type represents a digital-only virtual card.
  bool get isVirtual => this == .virtual;
}

/// Represents the payment card processing network or issuer.
enum GtDebitCardIssuer {
  /// Mastercard payment network.
  mastercard,

  /// Mastercard payment network.
  premiumMastercard,

  /// Visa payment network.
  visa,

  /// Verve payment network.
  verve,

  /// AfriGO domestic card scheme.
  afrigo;

  /// Returns the branding logo asset for this issuer.
  AppImageData get logo => switch (this) {
    mastercard => AppImageData(GtVectors.masterCard),
    premiumMastercard => AppImageData(GtVectors.mastercardPremium),
    visa => AppImageData(GtVectors.visaCard),
    verve => AppImageData(GtVectors.verveCard),
    afrigo => AppImageData(GtVectors.afrigoCard),
  };
}

/// Represents standardized dimensional presets for debit card widgets.
enum GtDebitCardDimension {
  /// Compact presentation suitable for small lists, mini selectors, or badges.
  compact,

  /// Full-size card presentation suitable for wallets, details screens, and hero sections.
  regular;

  /// Width constraint for this card dimension.
  double get width => switch (this) {
    compact => 72.px,
    regular => 249.px,
  };

  /// Height constraint for this card dimension.
  double get height => switch (this) {
    compact => 46.px,
    regular => 159.px,
  };

  /// Internal padding for this card dimension.
  double get padding => switch (this) {
    compact => 4.63.px,
    regular => 16.px,
  };

  /// Height allocated for the issuing bank logo.
  double get bankLogoHeight => switch (this) {
    compact => 5.px,
    regular => 16.px,
  };

  /// Rendered width of the EMV chip graphic.
  double get chipWidth => switch (this) {
    compact => 10.px,
    regular => 35.px,
  };

  /// Rendered height of the payment issuer network logo.
  double get issuerLogoHeight => switch (this) {
    compact => 7.px,
    regular => 24.px,
  };
}

/// A widget representing a physical or virtual debit card visually.
///
/// Layout structure:
/// - Background color, gradient, or pattern image matching [type].
/// - Top row: Virtual card pill badge (if virtual) and bank logo.
/// - Middle: EMV chip graphic matching card tier.
/// - Bottom row: Card label / holder's name and payment network logo.
/// - Optional frozen state: Frosted overlay with snowflake icon and "FROZEN" indicator.
class GtDebitCard extends GtStatelessWidget {
  /// The label or cardholder name displayed on the bottom-left of the card.
  final String label;

  /// The logo of the card provider (e.g., MasterCard, Visa). Defaults to [issuer]'s logo.
  final AppImageData? cardLogo;

  /// The logo of the issuing bank. Defaults to the Sterling Bank logo.
  final AppImageData? bankLogo;

  /// An optional background image provider for the card, overriding [type]'s default.
  final ImageProvider? backgroundImage;

  /// The alignment of the card within its parent widget. Defaults to [Alignment.center].
  final AlignmentGeometry alignment;

  /// Optional constraints to override the default dimensions of the card.
  final Size? size;

  /// An optional override for the card background color.
  final Color? backgroundColor;

  /// An optional override for text colors on the card, such as the card label.
  final Color? textColor;

  /// Tap callback for the whole card.
  final OnPressed? onPressed;

  /// The card tier or styling variant (e.g., Classic, Business, Prime, World, Virtual, Kid).
  final GtDebitCardType type;

  /// The payment network or issuer logo (e.g., MasterCard, Visa, Verve, AfriGO).
  final GtDebitCardIssuer issuer;

  /// The dimensional preset ([GtDebitCardDimension.regular] or [GtDebitCardDimension.compact]).
  final GtDebitCardDimension dimension;

  /// Whether the card is in a frozen state, displaying a frosted overlay.
  final bool isFrozen;

  /// Creates a [GtDebitCard].
  const GtDebitCard({
    super.key,
    required this.label,
    this.cardLogo,
    this.bankLogo,
    this.backgroundImage,
    this.onPressed,
    this.alignment = .center,
    this.size,
    this.backgroundColor,
    this.textColor,
    this.type = .classic,
    this.issuer = .mastercard,
    this.dimension = .regular,
    this.isFrozen = false,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider? bgImage = backgroundImage ?? type.backgroundImage;
    AppImageData defaultCardLogo = issuer.logo;
    AppImageData defaultBankLogo = AppImageData(GtVectors.sterling);
    Color? defaultBgColor = type.backgroundColor(context.palette);
    Color? defaultTextColor = type.textColor(context.palette);
    DecorationImage? decorationImage;
    BorderRadius? borderRadius = switch (dimension) {
      .regular => context.borderRadius2Xl,
      .compact => context.borderRadiusXs,
    };
    TextStyle labelTextStyle = switch (dimension) {
      .regular => context.textStyles.button2s(
        color: textColor ?? defaultTextColor,
      ),
      _ => context.textStyles.buttonXxs(color: textColor ?? defaultTextColor),
    };

    if (bgImage is NetworkImage) {
      bgImage = CachedNetworkImageProvider(bgImage.url);
    }

    if (bgImage case ImageProvider image) {
      decorationImage = DecorationImage(
        image: image,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
      );
    }

    return Align(
      alignment: alignment,
      child: GtCard(
        onPressed: onPressed,
        padding: .zero,
        constraints: BoxConstraints(
          maxHeight: size?.height ?? context.dp(dimension.height),
          maxWidth: size?.width ?? context.dp(dimension.width),
        ),
        image: decorationImage,
        border: .none,
        borderRadius: borderRadius,
        color: backgroundColor ?? defaultBgColor,
        gradient: type.gradient(context.palette),
        child: Stack(
          children: [
            Padding(
              padding: context.insets.allDp(dimension.padding),
              child: Column(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: .center,
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      if (type.isVirtual)
                        _VirtualCardChip(
                          dimension,
                          key: Key("virtual-debit-card-chip-$label"),
                        ),
                      const Spacer(),
                      GtImage(
                        image: bankLogo ?? defaultBankLogo,
                        useDefaultSize: false,
                        alignment: .centerRight,
                        height: context.dp(dimension.bankLogoHeight),
                        isDecorative: true,
                      ),
                    ],
                  ),
                  GtImage(
                    image: type.chipImage,
                    useDefaultSize: false,
                    isDecorative: true,
                    width: context.dp(dimension.chipWidth),
                    alignment: .centerLeft,
                  ),
                  Row(
                    crossAxisAlignment: .end,
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Flexible(
                        child: GtText(
                          label.upper,
                          maxLines: 1,
                          style: labelTextStyle,
                        ),
                      ),
                      GtImage(
                        image: cardLogo ?? defaultCardLogo,
                        alignment: .centerRight,
                        useDefaultSize: false,
                        isDecorative: true,
                        height: context.dp(dimension.issuerLogoHeight),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isFrozen) ...[
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: context.palette.staticColors.white.setOpacity(.7),
                  ),
                ),
              ),

              Positioned.fill(
                child: _FrozenCardOverlay(
                  dimension,
                  backgroundColor ?? type.overlayColor(context.palette),
                  key: Key("frozent-card-overlay-$label"),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _VirtualCardChip extends GtStatelessWidget {
  final GtDebitCardDimension dimension;

  const _VirtualCardChip(this.dimension, {super.key});
  @override
  Widget build(BuildContext context) {
    final insets = context.insets;

    final radius = switch (dimension) {
      .compact => 1.45.px,
      _ => 5.px,
    };

    return Container(
      padding: switch (dimension) {
        .compact => insets.symmetricDp(horizontal: 1.45.px, vertical: .96.px),
        _ => insets.allDp(5.px),
      },
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.dp(radius)),
        color: context.palette.bg.weak,
      ),
      child: FittedBox(
        fit: .scaleDown,
        child: GtText(
          "virtual".utr(),
          textAlign: .center,
          style: context.textStyles.buttonXs(),
        ),
      ),
    );
  }
}

class _FrozenCardOverlay extends GtStatelessWidget {
  final GtDebitCardDimension dimension;
  final Color color;

  const _FrozenCardOverlay(this.dimension, this.color, {super.key});
  @override
  Widget build(BuildContext context) {
    final iconSize = switch (dimension) {
      .compact => 16.px,
      _ => 22.px,
    };
    final lineHeight = switch (dimension) {
      .compact => 12.0,
      _ => 24.0,
    };

    return Column(
      crossAxisAlignment: .center,
      mainAxisAlignment: .center,
      children: [
        GtIcon.withColor(
          GtIcons.snowFlake,
          size: context.dp(iconSize),
          color: color,
        ),
        Flexible(
          child: GtText(
            "frozen".ctr(),
            style: context.textStyles.subHeadXs(
              color: color,
              heightPx: lineHeight,
            ),
            textAlign: .center,
          ),
        ),
      ],
    );
  }
}
