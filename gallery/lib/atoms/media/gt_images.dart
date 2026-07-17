import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Images', type: GtImage)
Widget playgroundImageUseCase(BuildContext context) {
  return const _ImagesPlayground();
}

class _ImagesPlayground extends GtStatefulWidget {
  const _ImagesPlayground();

  @override
  State<_ImagesPlayground> createState() => _ImagesPlaygroundState();
}

class _ImagesPlaygroundState extends State<_ImagesPlayground> {
  late final GtTabController<String> _controller;
  late final List<GtTabData<String>> _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = [
      GtTabData(label: "GtImage", value: "gt_image"),
      GtTabData(label: "Network Image", value: "network"),
      GtTabData(label: "Asset Image", value: "asset"),
      GtTabData(label: "Memory Image", value: "memory"),
      GtTabData(label: "File Image", value: "file"),
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
    final bytes = base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=',
    );

    return Scaffold(
      backgroundColor: context.palette.bg.white,
      body: SafeArea(
        child: Padding(
          padding: context.insets.defaultAllInsets,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GtTabbar<String>(controller: _controller, tabs: _tabs),
              const GtGap.yMd(),
              Expanded(
                child: GtTabbarView<String>(
                  controller: _controller,
                  tabViews: {
                    "gt_image": GtWidgetDocPage(
                      title: "GtImage (Unified)",
                      description:
                          "A unified image widget that dynamically delegates rendering based on AppImageData.",
                      code:
                          '''
GtImage(
  image: AppImageData("${GtNetworkImages.sampleAvatar1}"),
  width: 80,
  height: 80,
)''',
                      child: GtImage(
                        image: AppImageData(GtNetworkImages.sampleAvatar1),
                        width: 80,
                        height: 80,
                      ),
                    ),
                    "network": GtWidgetDocPage(
                      title: "Network Image",
                      description:
                          "Loads a remote image URL using GtNetworkImage.",
                      code:
                          '''
GtImage(
  image: AppImageData("${GtNetworkImages.sampleAvatar1}"),
  width: 80,
  height: 80,
)''',
                      child: GtImage(
                        image: AppImageData.network(
                          GtNetworkImages.sampleAvatar1,
                        ),
                        width: 80,
                        height: 80,
                      ),
                    ),
                    "asset": GtWidgetDocPage(
                      title: "Asset Image",
                      description:
                          "Loads a bundled asset image using GtAssetImage.",
                      code:
                          '''
GtImage(
  image: AppImageData("${GtAssetImages.avatar}"),
  width: 80,
  height: 80,
)''',
                      child: GtImage(
                        image: AppImageData.asset(GtAssetImages.avatar),
                        width: 80,
                        height: 80,
                      ),
                    ),
                    "memory": GtWidgetDocPage(
                      title: "Memory Image",
                      description:
                          "Loads raw image bytes directly from memory using GtMemoryImage.",
                      code:
                          '''
GtImage(
  image: AppImageData($bytes),
  width: 80,
  height: 80,
)''',
                      child: Container(
                        color: Colors.amber,
                        child: GtImage(
                          image: AppImageData.bytes(bytes),
                          width: 80,
                          height: 80,
                        ),
                      ),
                    ),
                    "file": GtWidgetDocPage(
                      title: "File Image",
                      description:
                          "Loads an image from local storage. Fallback is shown when null.",
                      code: '''
GtImage(
  image: AppImageData(File.fromRawPath(bytes)),
  width: 80,
  height: 80,
)''',
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: context.palette.stroke.strong,
                          ),
                        ),
                        child: GtImage(image: null, width: 80, height: 80),
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
