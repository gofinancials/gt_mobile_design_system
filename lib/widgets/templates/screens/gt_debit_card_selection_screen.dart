import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Supported debit-card variants rendered by [GtDebitCardSelectionScreen].
///
/// @category Templates
enum GtDebitCardVariant { physical, virtual }

extension _GtDebitCardVariantDefaults on GtDebitCardVariant {
  String get title => switch (this) {
    .physical => 'physicalCard'.ctr(),
    .virtual => 'virtual'.ctr(),
  };

  String get subtitle => switch (this) {
    .physical => 'physicalCardDescription'.tr(),
    .virtual => 'virtualCardDescription'.tr(),
  };

  String get feeLabel => switch (this) {
    .physical => 1000.asCurrency(AppStrings.naira),
    .virtual => 'free'.utr(),
  };

  AppImageData get image => switch (this) {
    .physical => AppImageData(imageData: GtNetworkImages.physicalCard),
    .virtual => AppImageData(imageData: GtNetworkImages.virtualCard),
  };
}

/// Selection template for debit-card related flows.
///
/// The layout uses a top-right close action and a standardized heading area,
/// then renders standardized debit-card options.
class GtDebitCardSelectionScreen extends GtStatelessWidget {
  /// Main page title shown in the header.
  final String title;

  /// Optional support text displayed under [title].
  final String? subtitle;

  /// Callback when any card option is selected.
  final ValueChanged<GtDebitCardVariant>? onVariantSelected;

  /// Optional callback for the top-right close action.
  ///
  /// When omitted, [GtCancelButton] falls back to default pop behavior.
  final OnPressed? onClose;

  /// Optional screen background color.
  ///
  /// Defaults to [GtPalette.bg.white].
  final Color? backgroundColor;

  /// Creates a [GtDebitCardSelectionScreen].
  const GtDebitCardSelectionScreen({
    super.key,
    required this.title,
    this.subtitle,
    this.onVariantSelected,
    this.onClose,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? context.palette.bg.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: const GtAppBar(),
      body: Container(
        color: bgColor,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: context.insets.defaultHorizontalInsets,
            child: Column(
              crossAxisAlignment: .stretch,
              spacing: context.spacingMd,
              children: [
                GtGap.yMd(),
                GtHeader(title: title, subtitle: subtitle),
                GtGap.yMd(),
                for (final v in GtDebitCardVariant.values)
                  GtDebitCard(
                    title: v.title,
                    subtitle: v.subtitle,
                    feeLabel: v.feeLabel,
                    image: v.image,
                    onPressed: () => onVariantSelected?.call(v),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Lightweight header wrapper for selection templates.
///
/// This class centralizes header usage so all selection screens use the same
/// `GtPageHeader` primitive and spacing behavior.
class GtHeader extends GtStatelessWidget {
  /// Header title text.
  final String title;

  /// Optional subtitle text.
  final String? subtitle;

  /// Creates a [GtHeader].
  const GtHeader({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return GtPageHeader(
      title: title,
      subtitle: subtitle,
      textAlign: TextAlign.start,
      titleColor: context.palette.text.strong,
      subTitleColor: context.palette.text.strong,
    );
  }
}
