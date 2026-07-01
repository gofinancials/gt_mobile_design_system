import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

enum GtTransferParticipantImageType { avatar, image }

class GtTransferParticipantData<T> extends AppEquatable {
  final String? name;
  final String currency;
  final double? balance;
  final String label;
  final AppImageData image;
  final AppImageData? tag;
  final GtTransferParticipantImageType imageType;
  final T? data;
  final bool validate;
  final OnPressed? onTap;

  const GtTransferParticipantData({
    this.name,
    this.balance,
    required this.label,
    required this.image,
    required this.validate,
    this.imageType = .avatar,
    this.currency = AppStrings.naira,
    this.data,
    this.tag,
    this.onTap,
  });

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

  GtTransferParticipantData<T> copyWith({
    String? name,
    double? balance,
    String? label,
    AppImageData? image,
    bool? isSender,
    T? data,
    GtTransferParticipantImageType? imageType,
    String? currency,
    bool? validate,
  }) {
    return GtTransferParticipantData<T>(
      name: name ?? this.name,
      balance: balance ?? this.balance,
      label: label ?? this.label,
      image: image ?? this.image,
      data: data ?? this.data,
      imageType: imageType ?? this.imageType,
      currency: currency ?? this.currency,
      validate: validate ?? this.validate,
    );
  }

  String? get formattedBalance {
    if (balance == null && !validate) return null;
    final prefix = "balance".ctr();

    return "$prefix ${(balance ?? 0).asCurrency(currency)}";
  }

  @override
  List<Object?> get props => [
    name,
    balance,
    label,
    image,
    data,
    imageType,
    currency,
    validate,
  ];
}
