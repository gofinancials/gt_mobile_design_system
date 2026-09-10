import 'package:flutter/widgets.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// The look of a [GtReceiptAction]'s button: a [GtButtonVariant] plus optional
/// colour overrides.
class GtReceiptActionStyle extends AppEquatable {
  /// The button variant the action renders with.
  final GtButtonVariant variant;

  /// Overrides the button's background colour.
  final Color? color;

  /// Overrides the button's label colour.
  final Color? textColor;

  /// Creates a [GtReceiptActionStyle].
  const GtReceiptActionStyle({
    required this.variant,
    this.color,
    this.textColor,
  });

  /// A [GtButtonVariant.primary] style without colour overrides.
  const GtReceiptActionStyle.primary()
    : variant = .primary,
      color = null,
      textColor = null;

  /// A [GtButtonVariant.neutral] style without colour overrides. The default
  /// for [GtReceiptAction].
  const GtReceiptActionStyle.neutral()
    : variant = .neutral,
      color = null,
      textColor = null;

  @override
  List<Object?> get props => [variant, color, textColor];
}

/// An action button offered on a receipt or transfer detail screen, such as
/// "Send again" or "View receipt". Rendered by [GtReceiptActionButton].
class GtReceiptAction extends AppEquatable {
  /// The button's label.
  final String label;

  /// The icon drawn ahead of [label].
  final IconData icon;

  /// Invoked when the button is tapped.
  final OnPressed onTap;

  /// The button's variant and colour overrides. Defaults to
  /// [GtReceiptActionStyle.neutral].
  final GtReceiptActionStyle style;

  /// Creates a [GtReceiptAction].
  const GtReceiptAction({
    required this.label,
    required this.onTap,
    required this.icon,
    this.style = const .neutral(),
  });

  /// Creates a [GtReceiptAction] in the [GtReceiptActionStyle.primary] style.
  const GtReceiptAction.primary({
    required this.label,
    required this.onTap,
    required this.icon,
  }) : style = const .primary();

  /// The button's background colour: the [style] override when set, the weak
  /// background for a neutral action, and otherwise `null` so the variant's
  /// own colour applies.
  Color? color(GtPalette palette) {
    if (style.color != null) return style.color;
    if (style.variant != .neutral) return null;
    return palette.bg.weak;
  }

  /// The button's label colour: the [style] override when set, strong text for
  /// a neutral action, and otherwise `null` so the variant's own colour
  /// applies.
  Color? textColor(GtPalette palette) {
    if (style.textColor != null) return style.textColor;
    if (style.variant != .neutral) return null;
    return palette.text.strong;
  }

  @override
  List<Object?> get props => [label, icon, style];
}

/// How a [GtReceiptParticipant]'s image is drawn.
enum GtReceiptImageType {
  /// A circular [GtAvatar] that falls back to initials and can carry a tag.
  avatar,

  /// A plain [GtImage], such as an account or wallet illustration.
  image,
}

/// A party to a transaction: the sender or recipient on a [GtReceiptBody], or
/// the recipient on a [GtTransferDetailBody].
class GtReceiptParticipant extends AppEquatable {
  /// The participant's name.
  final String title;

  /// A secondary line beneath [title], such as a bank and account number.
  final String? subtitle;

  /// The caption above [title] on a [GtReceiptBody]. Defaults to "From" or
  /// "To" by position.
  final String? label;

  /// The participant's avatar or image, drawn according to [imageType].
  final AppImageData image;

  /// A small badge, such as a bank logo, drawn over the corner of an avatar.
  /// Only used with [GtReceiptImageType.avatar].
  final AppImageData? tag;

  /// How [image] is drawn. Defaults to [GtReceiptImageType.image].
  final GtReceiptImageType imageType;

  /// The individual transactions behind this side of the receipt, listed in
  /// an expandable breakdown on [GtReceiptBody].
  final List<GtReceiptTransaction> transactions;

  /// Creates a [GtReceiptParticipant].
  const GtReceiptParticipant({
    required this.title,

    required this.image,
    this.subtitle,
    this.label,
    this.transactions = const [],
    this.imageType = .image,
    this.tag,
  });

  @override
  List<Object?> get props => [
    title,
    subtitle,
    label,
    image,
    tag,
    imageType,
    transactions,
  ];
}

/// The outcome shown on a receipt's status pill.
enum GtReceiptStatus {
  /// Still being processed. The pill shows a spinner.
  processing,

  /// In progress over time. The pill shows a repeat icon.
  ongoing,

  /// Completed successfully.
  success,

  /// Did not complete.
  failed,
}

/// The status pill at the head of a [GtReceiptBody] or [GtConfirmationBody],
/// rendered by [GtReceiptStatusPill].
class GtReceiptStatusData extends AppEquatable {
  /// The outcome, which selects the pill's variant, icon and default title.
  final GtReceiptStatus status;

  /// Overrides the pill's text. See [displayTitle].
  final String? title;

  /// Invoked when the pill is tapped. When null the pill is inert.
  final OnPressed? onPressed;

  /// Creates a [GtReceiptStatusData].
  const GtReceiptStatusData({required this.status, this.title, this.onPressed});

  /// The pill's text: [title] when supplied, otherwise the translated name of
  /// [status].
  String get displayTitle {
    if (title.hasValue) return title!;
    final statusText = switch (status) {
      .processing => 'processing',
      .ongoing => 'ongoing',
      .success => 'successful',
      .failed => 'failed',
    };
    return statusText.ctr();
  }

  /// The pill's leading icon, or `null` while processing, when the pill shows
  /// a spinner instead.
  IconData? get icon => switch (status) {
    .ongoing => GtIcons.repeat,
    .success => GtIcons.checkBox,
    .failed => GtIcons.x,
    _ => null,
  };

  /// The pill variant for [status].
  GtPillVariant get variant {
    return switch (status) {
      .processing => .away,
      .ongoing => .info,
      .success => .success,
      .failed => .error,
    };
  }

  /// The pill's border colour: the light away shade while processing,
  /// otherwise the variant's own border.
  Color? borderColor(GtPalette palette) {
    return switch (variant) {
      .away => palette.away.light,
      _ => variant.getBorderColor(palette),
    };
  }

  @override
  List<Object?> get props => [status, title];
}

/// One line of a [GtReceiptParticipant]'s transaction breakdown.
class GtReceiptTransaction extends AppEquatable {
  /// The transaction's name, such as "Airtime Top-up".
  final String title;

  /// A secondary line beneath [title], such as the provider and number.
  final String subtitle;

  /// The formatted amount, such as "₦ 5,000.00".
  final String value;

  /// The avatar image, with the initials of [title] as its fallback.
  final AppImageData image;

  /// A small badge drawn over the corner of the avatar.
  final AppImageData? tag;

  /// Creates a [GtReceiptTransaction].
  const GtReceiptTransaction({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.image,
    this.tag,
  });

  @override
  List<Object?> get props => [title, subtitle, value, image, tag];
}

/// The sender's note, shown in its own card on a [GtReceiptBody].
class GtReceiptMessageData extends AppEquatable {
  /// The note itself.
  final String message;

  /// Overrides the card's heading. See [displayTitle].
  final String? title;

  /// Overrides the style of [message].
  final TextStyle? style;

  /// Creates a [GtReceiptMessageData].
  const GtReceiptMessageData({required this.message, this.title, this.style});

  /// The card's heading: [title] when supplied, otherwise the `message`
  /// translation.
  String get displayTitle => title ?? 'message'.ctr();

  @override
  List<Object?> get props => [message, title, style];
}

/// Where [GtReceiptDetailTile] places a [GtReceiptTileData.image] relative to
/// the value.
enum GtReceiptTileImagePosition {
  /// Before the value, as on the category row of [GtTransferDetailBody].
  leading,

  /// After the value. The default.
  trailing,
}

/// A label/value row on a receipt, confirmation or transfer detail card,
/// rendered by [GtReceiptDetailTile].
class GtReceiptTileData extends AppEquatable {
  /// The row's label, such as "Reference".
  final String label;

  /// The row's value, already formatted for display.
  final String value;

  /// An image drawn beside [value], such as a category icon.
  final AppImageData? image;

  /// Invoked when the row is tapped, typically to copy [value]. When null the
  /// row is inert.
  final OnPressed? onTap;

  /// Invoked when the info icon drawn after [label] is tapped.
  ///
  /// When non-null, [GtReceiptDetailTile] renders a [GtIcons.info] glyph beside
  /// the label, typically to explain a fee or levy. When null, no icon is
  /// drawn.
  final OnPressed? onInfoTap;

  /// Overrides the label announced for the info icon.
  ///
  /// Defaults to the `moreInfoAbout` translation, passed [label] as `label`.
  final String? infoSemanticsLabel;

  /// Creates a [GtReceiptTileData].
  const GtReceiptTileData({
    required this.label,
    required this.value,
    this.image,
    this.onTap,
    this.onInfoTap,
    this.infoSemanticsLabel,
  });

  /// The label announced for the info icon.
  String get displayInfoSemanticsLabel {
    return infoSemanticsLabel ?? 'moreInfoAbout'.tr({'label': label});
  }

  @override
  List<Object?> get props => [label, value, image, infoSemanticsLabel];
}

/// The cards beneath the participants on a [GtReceiptBody]. Each card is
/// omitted when it has nothing to show.
class GtReceiptDetails extends AppEquatable {
  /// The sender's note, shown in its own card.
  final GtReceiptMessageData? message;

  /// The transaction category, shown in its own card with a larger image.
  final GtReceiptTileData? category;

  /// The remaining rows, such as reference, session ID and fee, grouped in
  /// one card.
  final List<GtReceiptTileData> tiles;

  /// Creates a [GtReceiptDetails].
  const GtReceiptDetails({this.message, this.category, required this.tiles});

  @override
  List<Object?> get props => [message, category, tiles];
}
