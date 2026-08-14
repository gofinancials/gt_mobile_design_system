import 'package:flutter/widgets.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtReceiptActionStyle extends AppEquatable {
  final GtButtonVariant variant;
  final Color? color;
  final Color? textColor;

  const GtReceiptActionStyle({
    required this.variant,
    this.color,
    this.textColor,
  });

  const GtReceiptActionStyle.primary()
    : variant = .primary,
      color = null,
      textColor = null;

  const GtReceiptActionStyle.neutral()
    : variant = .neutral,
      color = null,
      textColor = null;

  @override
  List<Object?> get props => [variant, color, textColor];
}

class GtReceiptAction extends AppEquatable {
  final String label;
  final IconData icon;
  final OnPressed onTap;
  final GtReceiptActionStyle style;

  const GtReceiptAction({
    required this.label,
    required this.onTap,
    required this.icon,
    this.style = const .neutral(),
  });

  const GtReceiptAction.primary({
    required this.label,
    required this.onTap,
    required this.icon,
  }) : style = const .primary();

  Color? color(GtPalette palette) {
    if (style.color != null) return style.color;
    if (style.variant != .neutral) return null;
    return palette.bg.weak;
  }

  Color? textColor(GtPalette palette) {
    if (style.textColor != null) return style.textColor;
    if (style.variant != .neutral) return null;
    return palette.text.strong;
  }

  @override
  List<Object?> get props => [label, icon, style];
}

enum GtReceiptImageType { avatar, image }

class GtReceiptParticipant extends AppEquatable {
  final String title;
  final String? subtitle;
  final String? label;
  final AppImageData image;
  final AppImageData? tag;
  final GtReceiptImageType imageType;
  final List<GtReceiptTransaction> transactions;

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

enum GtReceiptStatus { processing, ongoing, success, failed }

class GtReceiptStatusData extends AppEquatable {
  final GtReceiptStatus status;
  final String? title;
  final OnPressed? onPressed;

  const GtReceiptStatusData({required this.status, this.title, this.onPressed});

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

  IconData? get icon => switch (status) {
    .ongoing => GtIcons.repeat,
    .success => GtIcons.checkBox,
    .failed => GtIcons.x,
    _ => null,
  };

  GtPillVariant get variant {
    return switch (status) {
      .processing => .away,
      .ongoing => .info,
      .success => .success,
      .failed => .error,
    };
  }

  Color? borderColor(GtPalette palette) {
    return switch (variant) {
      .away => palette.away.light,
      _ => variant.getBorderColor(palette),
    };
  }

  @override
  List<Object?> get props => [status, title];
}

class GtReceiptTransaction extends AppEquatable {
  final String title;
  final String subtitle;
  final String value;
  final AppImageData image;
  final AppImageData? tag;

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

class GtReceiptMessageData extends AppEquatable {
  final String message;
  final String? title;
  final TextStyle? style;

  const GtReceiptMessageData({required this.message, this.title, this.style});

  String get displayTitle => title ?? 'message'.ctr();

  @override
  List<Object?> get props => [message, title, style];
}

class GtReceiptTileData extends AppEquatable {
  final String label;
  final String value;
  final AppImageData? image;
  final OnPressed? onTap;

  const GtReceiptTileData({
    required this.label,
    required this.value,
    this.image,
    this.onTap,
  });

  @override
  List<Object?> get props => [label, value, image];
}

class GtReceiptDetails extends AppEquatable {
  final GtReceiptMessageData? message;
  final GtReceiptTileData? category;
  final List<GtReceiptTileData> tiles;

  const GtReceiptDetails({this.message, this.category, required this.tiles});

  @override
  List<Object?> get props => [message, category, tiles];
}
