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

/// A widget representing a physical or virtual debit card visually.
///
/// Layout structure:
/// - Background image or pattern.
/// - Top row containing the card chip and bank logo.
/// - Bottom row containing the cardholder's name and the card provider's logo.
class GtDebitCard extends GtStatelessWidget {
  /// The name of the cardholder displayed on the card.
  final String holderName;

  /// The logo of the card provider (e.g., MasterCard, Visa). Defaults to MasterCard.
  final AppImageData? cardLogo;

  /// The logo of the issuing bank. Defaults to the Sterling Bank logo.
  final AppImageData? bankLogo;

  /// An optional background image provider for the card. Defaults to a standard pattern.
  final ImageProvider? backgroundImage;

  /// The alignment of the card within its parent widget. Defaults to [Alignment.center].
  final AlignmentGeometry alignment;

  /// Optional constraints to override the default dimensions of the card.
  final Size? size;

  /// The color of the text displayed on the card, such as the holder's name.
  final Color? textColor;

  /// Tap callback for the whole card.
  final OnPressed? onPressed;

  /// Creates a [GtDebitCard].
  const GtDebitCard({
    super.key,
    required this.holderName,
    this.cardLogo,
    this.bankLogo,
    this.backgroundImage,
    this.onPressed,
    this.alignment = .center,
    this.size,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider? bgImage = backgroundImage;
    AppImageData defaultCardLogo = AppImageData(GtVectors.masterCard);
    AppImageData defaultBankLogo = AppImageData(GtVectors.sterling);
    bgImage ??= const NetworkImage(GtNetworkImages.kidsPattern);
    if (bgImage is NetworkImage) {
      bgImage = CachedNetworkImageProvider(bgImage.url);
    }

    final leftOffset = context.dp(8.px);

    return Align(
      alignment: alignment,
      child: GtCard(
        padding: context.insets.fromLTRBDp(12.px, 20.px, 12.px, 11.px),
        constraints: BoxConstraints(
          maxHeight: size?.height ?? context.dp(157.px),
          maxWidth: size?.width ?? context.dp(249.px),
        ),
        image: DecorationImage(
          image: bgImage,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
        border: .none,
        borderRadius: context.borderRadiusXl,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              left: leftOffset,
              child: Row(
                crossAxisAlignment: .center,
                mainAxisAlignment: .spaceBetween,
                children: [
                  FractionalTranslation(
                    translation: Offset(0, 1.4),
                    child: GtSvg(GtVectors.chip),
                  ),
                  GtImage(
                    image: bankLogo ?? defaultBankLogo,
                    useDefaultSize: false,
                    alignment: .centerRight,
                    height: 20,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: leftOffset,
              child: Row(
                crossAxisAlignment: .center,
                mainAxisAlignment: .spaceBetween,
                children: [
                  Flexible(
                    child: GtText(
                      holderName.upper,
                      maxLines: 1,
                      style: context.textStyles.buttonS(
                        color: textColor ?? context.palette.staticColors.black,
                      ),
                    ),
                  ),
                  GtImage(
                    image: cardLogo ?? defaultCardLogo,
                    alignment: .centerRight,
                    useDefaultSize: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
