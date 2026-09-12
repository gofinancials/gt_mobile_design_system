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
  late final GtTabController<String> _controller;

  @override
  void initState() {
    super.initState();
    _controller = GtTabController<String>(initialValue: _tabs.first);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
    final image = context.knobs.object.dropdown(
      label: "Image",
      options: [
        ('Network Image', AppImageData(GtNetworkImages.sampleAvatar1)),
        ('Asset Image', AppImageData(GtAssetImages.avatar)),
        ('Texture', AppImageData(GtNetworkImages.avatarTexture1)),
        ('None', null),
      ],
      initialOption: (
        'Network Image',
        AppImageData(GtNetworkImages.sampleAvatar1),
      ),
      labelBuilder: (value) => value.$1,
    );

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
    final squareShowGradient = context.knobs.boolean(
      label: "Square Show Gradient",
      initialValue: true,
    );
    final squareBgColor = context.knobs.colorOrNull(
      label: "Square Background Color",
      initialValue: null,
    );
    final squareEditPenSize = context.knobs.doubleOrNull.slider(
      label: "Square Edit Pen Size",
      min: 16,
      max: 80,
      initialValue: 32,
      defaultToNull: true,
    );
    final squareUserIconSize = context.knobs.doubleOrNull.slider(
      label: "Square User Icon Size",
      min: 12,
      max: 120,
      initialValue: 48,
      defaultToNull: true,
    );

    return Scaffold(
      backgroundColor: context.palette.bg.white,
      body: SafeArea(
        child: Padding(
          padding: context.insets.defaultAllInsets,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GtTabbar<String>(
                controller: _controller,
                tabs: _tabs,
                key: PageStorageKey("gt-avatar-tabbar"),
              ),
              const GtGap.yMd(),
              Expanded(
                child: GtTabbarView<String>.lazy(
                  key: PageStorageKey("gt-avatar-tabs"),
                  controller: _controller,
                  tabs: _tabs,
                  tabBuilders: {
                    "avatar": (_) => GtWidgetDocPage(
                      title: "GtAvatar",
                      description:
                          "A circular avatar component displaying user profile picture or fallback initials.",
                      code:
                          '''
GtAvatar(
  avatar: AppImageData("${image.$2?.imageData}"),
  initials: "$initials",
  size: $size,
  showBorder: $showBorder,
  fit: BoxFit.${fit.name},
)''',
                      child: Center(
                        child: GtAvatar(
                          avatar: image.$2,
                          showBorder: showBorder,
                          initials: initials.isEmpty ? null : initials,
                          fit: fit,
                          size: size,
                        ),
                      ),
                    ),
                    "square_avatar": (_) => GtWidgetDocPage(
                      title: "GtSquareAvatar",
                      description:
                          "A square, rounded avatar commonly used for business profile headers or list representations.",
                      code:
                          '''
GtSquareAvatar(
  avatar: AppImageData("${image.$2?.imageData ?? ''}"),
  size: $squareSize,
  showBorder: $squareShowBorder,
  showGradient: $squareShowGradient,${squareBgColor != null ? "\n  bgColor: Color(0x${squareBgColor.toARGB32().toRadixString(16)})," : ""}${squareEditPenSize != null ? "\n  editPenSize: $squareEditPenSize," : ""}${squareUserIconSize != null ? "\n  userIconSize: $squareUserIconSize," : ""}
  fit: BoxFit.${fit.name},
  onEdit: () {},
)''',
                      child: Center(
                        child: GtSquareAvatar(
                          showBorder: squareShowBorder,
                          showGradient: squareShowGradient,
                          bgColor: squareBgColor,
                          editPenSize: squareEditPenSize,
                          userIconSize: squareUserIconSize,
                          avatar: image.$2,
                          fit: fit,
                          onEdit: () {},
                          size: squareSize,
                          isUserAvatar: context.knobs.boolean(
                            label: "Square User Avatar",
                            initialValue: true,
                          ),
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
