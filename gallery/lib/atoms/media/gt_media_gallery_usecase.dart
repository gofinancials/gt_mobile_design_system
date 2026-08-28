import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/extensions/string_extensions.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Central Media Gallery', type: GtImage)
Widget centralMediaGalleryUseCase(BuildContext context) {
  return const _MediaGalleryPage();
}

class _MediaGalleryPage extends GtStatefulWidget {
  const _MediaGalleryPage();

  @override
  State<_MediaGalleryPage> createState() => _MediaGalleryPageState();
}

class _MediaGalleryPageState extends State<_MediaGalleryPage> {
  late final GtTabController<String> _controller;
  late final List<GtTabData<String>> _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = [
      GtTabData(label: "Icons (GtIcons)", value: "icons"),
      GtTabData(label: "Vectors (GtVectors)", value: "vectors"),
      GtTabData(
        label: "Illustrations (GtVectorIllustrations)",
        value: "illustrations",
      ),
      GtTabData(label: "Network Images", value: "network"),
      GtTabData(label: "Asset Images", value: "asset"),
    ];
    _controller = GtTabController<String>(initialValue: _tabs.first);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final iconFonts = GtIcons.all;
    final vectors = GtVectors.all;
    final illustrations = GtVectorIllustrations.all;
    final networkImages = GtNetworkImages.all;
    final assetImages = GtAssetImages.all;

    return Scaffold(
      backgroundColor: context.palette.bg.white,
      body: SafeArea(
        child: Padding(
          padding: context.insets.defaultHorizontalInsets,
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              Padding(
                padding: context.insets.symmetricDp(vertical: 16.px),
                child: const GalleryPageHeader(
                  title: "Media Gallery",
                  rider:
                      "A central gallery containing all icons, SVGs, illustrations, and raster images.",
                ),
              ),
              GtTabbar<String>(controller: _controller, tabs: _tabs),
              const GtGap.yMd(),
              Expanded(
                child: GtTabbarView<String>.lazy(
                  controller: _controller,
                  tabs: _tabs,
                  tabBuilders: {
                    "icons": (_) => _MediaGrid(
                      items: iconFonts,
                      builder: (item) => GtIcon(item.value, size: 32),
                    ),
                    "vectors": (_) => _MediaGrid(
                      items: vectors,
                      builder: (item) =>
                          GtSvg(item.value, width: 32, height: 32),
                    ),
                    "illustrations": (_) => _MediaGrid(
                      items: illustrations,
                      builder: (item) =>
                          GtSvg(item.value, width: 64, height: 64),
                    ),
                    "network": (_) => _MediaGrid(
                      items: networkImages,
                      builder: (item) => GtNetworkImage(
                        item.value,
                        width: 64,
                        height: 64,
                        fit: BoxFit.contain,
                      ),
                    ),
                    "asset": (_) => _MediaGrid(
                      items: assetImages,
                      builder: (item) => GtAssetImage(
                        item.value,
                        width: 64,
                        height: 64,
                        fit: BoxFit.contain,
                      ),
                    ),
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MediaGrid extends GtStatefulWidget {
  final List<({String label, dynamic value})> items;
  final Widget Function(({String label, dynamic value}) item) builder;

  const _MediaGrid({required this.items, required this.builder});

  @override
  State<_MediaGrid> createState() => _MediaGridState();
}

class _MediaGridState extends State<_MediaGrid> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.items
        .where(
          (item) => item.label.toLowerCase().contains(_query.toLowerCase()),
        )
        .toList();

    return Column(
      children: [
        GtSearchField(
          autoFocus: false,
          onChange: (val) {
            setState(() {
              _query = val.value;
            });
          },
        ),
        const GtGap.yMd(),
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 140,
              mainAxisSpacing: context.spacingLg,
              crossAxisSpacing: context.spacingLg,
              childAspectRatio: 0.85,
            ),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final item = filtered[index];
              return GtCard(
                variant: GtCardVariant.normal,
                padding: context.insets.symmetricDp(
                  vertical: 14.px,
                  horizontal: 8.px,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: Center(child: widget.builder(item))),
                    const GtGap.ySm(),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: GtInfoPill(text: item.label, variant: .primary),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
