import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// How a transfer participant's [GtTransferParticipantData.image] is drawn.
enum GtTransferParticipantImageType {
  /// A circular [GtAvatar], with the participant's initials behind the image.
  avatar,

  /// A plain [GtImage] with nothing behind it.
  image,
}

/// One leg of a transfer, as shown by [GtTransferField] and
/// [GtFxTransferField]: who or what the money moves from or to.
class GtTransferParticipantData<T> extends AppEquatable {
  /// The participant's name, shown as the leg's title.
  ///
  /// When null, [label] takes the title's place instead.
  final String? name;

  /// The currency [balance] is formatted in. Defaults to naira.
  final String currency;

  /// The participant's balance, shown beneath the title.
  ///
  /// It stays the real figure while [obscureBalance] is set, since the amount
  /// is still checked against it.
  final double? balance;

  /// Whether [formattedBalance] shows a mask in place of the [balance].
  /// Defaults to false.
  ///
  /// Set it when the customer has hidden their balances. Only the display is
  /// masked; [balance] still validates the amount entered, and the amount's
  /// error no longer quotes the balance as a maximum.
  final bool obscureBalance;

  /// A short role for the leg, such as "From" or "To".
  final String label;

  /// The picture drawn at the start of the leg, as [imageType] directs.
  final AppImageData image;

  /// The picture drawn in place of [image] when it fails to load.
  ///
  /// Drawn at the same size and in the same shape as [image]. Supply it
  /// wherever [image] comes from the network, above all with
  /// [GtTransferParticipantImageType.image], which has no initials behind it
  /// and otherwise leaves an empty space on failure.
  final AppImageData? errorImage;

  /// An optional badge overlaid on the avatar.
  ///
  /// Only drawn with [GtTransferParticipantImageType.avatar].
  final AppImageData? tag;

  /// How [image] is drawn. Defaults to [GtTransferParticipantImageType.avatar].
  final GtTransferParticipantImageType imageType;

  /// The caller's own model for this participant, carried along untouched.
  final T? data;

  /// Whether the amount entered is checked against this participant's
  /// [balance], which is then always reported, reading null as zero.
  final bool validate;

  /// Called when the leg is tapped, typically to pick a different participant.
  final OnPressed? onTap;

  /// Whether a title too long for the leg is shortened from the middle,
  /// keeping its head and tail, rather than from the end. Defaults to false.
  ///
  /// Set it when the [name] ends in what tells participants apart, such as an
  /// account number. See [GtText.middleEllipsis].
  final bool middleEllipsis;

  /// Creates a [GtTransferParticipantData].
  const GtTransferParticipantData({
    this.name,
    this.balance,
    required this.label,
    required this.image,
    required this.validate,
    this.imageType = .avatar,
    this.currency = AppStrings.naira,
    this.data,
    this.errorImage,
    this.tag,
    this.onTap,
    this.middleEllipsis = false,
    this.obscureBalance = false,
  });

  /// Creates a leg with no participant chosen yet, drawn as a dashed
  /// placeholder labelled [label].
  factory GtTransferParticipantData.empty({
    OnPressed? onTap,
    required String label,
  }) {
    return GtTransferParticipantData<T>(
      label: label,
      image: AppImageData(GtVectors.dashedPlaceholder),
      imageType: .image,
      validate: false,
      onTap: onTap,
    );
  }

  /// Returns a copy of this data with the given fields replaced.
  ///
  /// Every field is carried over unless replaced, including [tag],
  /// [onTap], [middleEllipsis] and [obscureBalance].
  GtTransferParticipantData<T> copyWith({
    String? name,
    double? balance,
    String? label,
    AppImageData? image,
    AppImageData? errorImage,
    AppImageData? tag,
    bool? isSender,
    T? data,
    GtTransferParticipantImageType? imageType,
    String? currency,
    bool? validate,
    OnPressed? onTap,
    bool? middleEllipsis,
    bool? obscureBalance,
  }) {
    return GtTransferParticipantData<T>(
      name: name ?? this.name,
      balance: balance ?? this.balance,
      label: label ?? this.label,
      image: image ?? this.image,
      errorImage: errorImage ?? this.errorImage,
      tag: tag ?? this.tag,
      data: data ?? this.data,
      imageType: imageType ?? this.imageType,
      currency: currency ?? this.currency,
      validate: validate ?? this.validate,
      onTap: onTap ?? this.onTap,
      middleEllipsis: middleEllipsis ?? this.middleEllipsis,
      obscureBalance: obscureBalance ?? this.obscureBalance,
    );
  }

  /// The [balance] formatted in [currency] behind a localised prefix, or null
  /// when there is no balance to report and [validate] is off.
  ///
  /// While [obscureBalance] is set, the figure is replaced by a mask.
  String? get formattedBalance {
    if (balance == null && !validate) return null;
    final prefix = "balance".ctr();

    String amount = (balance ?? 0).asCurrency(currency);
    if (obscureBalance) {
      amount = AppTextFormatter.maskedCurrency(balance, symbol: currency);
    }

    return "$prefix $amount";
  }

  @override
  List<Object?> get props => [
    name,
    balance,
    label,
    image,
    errorImage,
    tag,
    data,
    imageType,
    currency,
    validate,
    middleEllipsis,
    obscureBalance,
  ];
}
