import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final _tabs = [
  GtTabData(label: "GtAvatar", value: "avatar"),
  GtTabData(label: "GtSquareAvatar", value: "square_avatar"),
];
final _controller = GtTabController<String>(initialValue: _tabs.first);

@widgetbook.UseCase(name: 'GtAvatar', type: GtAvatar)
Widget buildGtAvatarUseCase(BuildContext context) {
  return const _AvatarPlayground();
}

class _AvatarPlayground extends GtStatefulWidget {
  const _AvatarPlayground();

  @override
  State<_AvatarPlayground> createState() => _AvatarPlaygroundState();
}

class _AvatarPlaygroundState extends State<_AvatarPlayground> {
  @override
  Widget build(BuildContext context) {
    // GtAvatar Knobs
    final fit = context.knobs.object.dropdown(
      label: "Avatar Fit",
      options: BoxFit.values,
      initialOption: BoxFit.cover,
      labelBuilder: (value) => value.name.capitalise(),
    );
    final size = context.knobs.double.slider(
      label: "Avatar Size",
      min: 20,
      max: 200,
      initialValue: 80,
    );
    final showBorder = context.knobs.boolean(
      label: "Show Border",
      initialValue: false,
    );
    final initials = context.knobs.string(
      label: "Initials",
      initialValue: "JD",
    );
    final imageType = context.knobs.object.dropdown(
      label: "Image Type",
      options: const ["Network", "Asset", "None"],
      initialOption: "Network",
    );

    AppImageData? avatarImage;
    if (imageType == "Network") {
      avatarImage = AppImageData.network(GtNetworkImages.sampleAvatar1);
    } else if (imageType == "Asset") {
      avatarImage = AppImageData.asset(GtAssetImages.avatar);
    }

    // GtSquareAvatar Knobs
    final squareSize = context.knobs.double.slider(
      label: "Square Avatar Size",
      min: 80,
      max: 300,
      initialValue: 150,
    );
    final squareShowBorder = context.knobs.boolean(
      label: "Square Show Border",
      initialValue: false,
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
                    "avatar": GtWidgetDocPage(
                      title: "GtAvatar",
                      description:
                          "A circular avatar component displaying user profile picture or fallback initials.",
                      code:
                          '''
GtAvatar(
  avatar: AppImageData("${avatarImage?.imageData}"),
  initials: "$initials",
  size: $size,
  showBorder: $showBorder,
  fit: BoxFit.${fit.name},
)''',
                      child: Center(
                        child: GtAvatar(
                          avatar: avatarImage,
                          showBorder: showBorder,
                          initials: initials.isEmpty ? null : initials,
                          fit: fit,
                          size: size,
                        ),
                      ),
                    ),
                    "square_avatar": GtWidgetDocPage(
                      title: "GtSquareAvatar",
                      description:
                          "A square, rounded avatar commonly used for business profile headers or list representations.",
                      code:
                          '''
GtSquareAvatar(
  avatar: AppImageData("${GtNetworkImages.avatarTexture1}"),
  size: $squareSize,
  showBorder: $squareShowBorder,
  fit: BoxFit.${fit.name},
  onEdit: () {},
)''',
                      child: Center(
                        child: GtSquareAvatar(
                          showBorder: squareShowBorder,
                          avatar: AppImageData(GtNetworkImages.avatarTexture1),
                          fit: fit,
                          onEdit: () {},
                          size: squareSize,
                        ),
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
