import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// The two sets of templates a [GtImageTemplatePicker] offers, in the order
/// its tabs show them.
enum GtImageTemplateSet {
  /// [GtNetworkImages.photoTemplates], led by the Upload tile.
  photos,

  /// [GtNetworkImages.illustrationTemplates].
  illustrations,
}

/// Lets the customer choose an image from the hosted templates, or upload
/// one of their own.
///
/// Two tabs share the width: Photos, which opens first, and Illustrations.
/// Each shows its templates three to a row. When [onUpload] is given, an
/// Upload tile leads the photos.
///
/// Illustrations follow the palette in scope. Under a palette with
/// [GtPalette.usesRedIllustration] set, the tiles show the red templates and
/// [onSelect] receives the red one, so what the customer picks is what they
/// saw.
///
/// The picker sizes itself to its content and does not scroll, so place it
/// in a scrolling body.
class GtImageTemplatePicker extends GtStatefulWidget {
  /// Called with the template the customer tapped.
  final OnChanged<AppImageData> onSelect;

  /// Called when the customer taps the Upload tile. Null hides the tile.
  final OnPressed? onUpload;

  /// Creates a [GtImageTemplatePicker].
  const GtImageTemplatePicker({
    required this.onSelect,
    this.onUpload,
    super.key,
  });

  @override
  State<GtImageTemplatePicker> createState() => _GtImageTemplatePickerState();
}

class _GtImageTemplatePickerState extends State<GtImageTemplatePicker> {
  final _controller = GtTabController<GtImageTemplateSet>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final tabs = [
      GtTabData(value: GtImageTemplateSet.photos, label: 'photos'.ctr()),
      GtTabData(
        value: GtImageTemplateSet.illustrations,
        label: 'illustrations'.ctr(),
      ),
    ];

    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      spacing: context.spacingSectionSm,
      children: [
        GtTabbar(
          tabs: tabs,
          controller: _controller,
          fill: true,
          style: GtTabPillStyle(
            variant: .primary,
            bgColor: palette.bg.weak,
            // Figma's stroke/soft-400 is #A3A3A3, which the DS names text.soft.
            textColor: palette.text.soft,
            textStyle: context.textStyles.button2s(),
          ),
        ),
        ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            final set = _controller.value?.value ?? GtImageTemplateSet.photos;
            return switch (set) {
              .photos => _GtTemplateGrid(
                templates: GtNetworkImages.photoTemplates,
                borderRadius: context.borderRadiusMd,
                onSelect: widget.onSelect,
                onUpload: widget.onUpload,
              ),
              .illustrations => _GtTemplateGrid(
                templates: GtNetworkImages.illustrationTemplates,
                borderRadius: context.borderRadiusXl,
                onSelect: widget.onSelect,
              ),
            };
          },
        ),
      ],
    );
  }
}

/// Three square tiles to a row, the Upload tile first when [onUpload] is set.
class _GtTemplateGrid extends GtStatelessWidget {
  final List<({String label, String value})> templates;
  final BorderRadius borderRadius;
  final OnChanged<AppImageData> onSelect;
  final OnPressed? onUpload;

  const _GtTemplateGrid({
    required this.templates,
    required this.borderRadius,
    required this.onSelect,
    this.onUpload,
  });

  @override
  Widget build(BuildContext context) {
    final gap = context.spacingLg;
    final upload = onUpload;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Floored so three tiles and two gaps never round past the width
        // and push the third tile onto the next row.
        final side = ((constraints.maxWidth - gap * 2) / 3).floorToDouble();

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            if (upload != null) _GtUploadTile(side: side, onPressed: upload),
            for (final (:label, :value) in templates)
              _GtTemplateTile(
                image: AppImageData(value.adapt(context), name: label),
                side: side,
                borderRadius: borderRadius,
                onSelect: onSelect,
              ),
          ],
        );
      },
    );
  }
}

class _GtTemplateTile extends GtStatelessWidget {
  final AppImageData image;
  final double side;
  final BorderRadius borderRadius;
  final OnChanged<AppImageData> onSelect;

  const _GtTemplateTile({
    required this.image,
    required this.side,
    required this.borderRadius,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    // A card expands to fill a Wrap's width, so the square is set here.
    return SizedBox.square(
      dimension: side,
      child: GtCard(
        onPressed: () => onSelect(image),
        borderRadius: borderRadius,
        padding: .zero,
        margin: .zero,
        child: ClipRRect(
          borderRadius: borderRadius,
          child: GtImage(
            image: image,
            width: side,
            height: side,
            fit: .cover,
            isDecorative: true,
          ),
        ),
      ),
    );
  }
}

class _GtUploadTile extends GtStatelessWidget {
  final double side;
  final OnPressed onPressed;

  const _GtUploadTile({required this.side, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final label = 'upload'.ctr();

    return SizedBox.square(
      dimension: side,
      child: GtCard(
        onPressed: onPressed,
        semanticsLabel: label,
        color: palette.bg.weak,
        borderRadius: context.borderRadiusMd,
        padding: .zero,
        margin: .zero,
        child: Column(
          mainAxisAlignment: .center,
          spacing: context.spacingXs,
          children: [
            GtIcon.withColor(
              GtIcons.image,
              size: context.dp(18.px),
              color: palette.icon.strong,
            ),
            GtText(
              label,
              style: context.textStyles.labelXs(
                weight: .w600,
                color: palette.text.strong,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
