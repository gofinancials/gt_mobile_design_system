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

const _images = [
  (
    'Network Image',
    GtNetworkImages.sampleAvatar1,
    'GtNetworkImages.sampleAvatar1',
  ),
  ('Asset Image', GtAssetImages.avatar, 'GtAssetImages.avatar'),
  ('Texture', GtNetworkImages.avatarTexture1, 'GtNetworkImages.avatarTexture1'),
  ('3D Template', GtNetworkImages.avatar3d1, 'GtNetworkImages.avatar3d1'),
  ('None', null, null),
];

const _avatarNotes = [
  'The avatar only joins the semantics tree once onPressed makes it tappable; pass semanticsLabel naming the person or entity it stands for.',
  'A decorative avatar sitting beside a name that is already on screen should stay silent, so leave onPressed and semanticsLabel unset there.',
  'The image, the initials and the tag are excluded from the tree, so whatever the tag conveys has to be stated by the surrounding copy too.',
];

const _squareAvatarNotes = [
  'The box only joins the semantics tree once onEdit is set; pass semanticsLabel describing the action, not the picture.',
  'The edit pen carries no label of its own, so semanticsLabel is the only announcement a screen reader gets for it.',
  'Initials are a visual fallback and are excluded from the tree; the name they abbreviate must already be on screen.',
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
    // Shared Knobs
    final fit = context.knobs.object.dropdown(
      label: "Avatar Fit",
      options: BoxFit.values,
      initialOption: BoxFit.cover,
      labelBuilder: (value) => value.name.capitalise(),
    );
    final image = context.knobs.object.dropdown(
      label: "Image",
      options: _images,
      initialOption: _images.first,
      labelBuilder: (value) => value.$1,
    );
    final initials = context.knobs.string(
      label: "Initials",
      initialValue: "JD",
    );

    // GtAvatar Knobs
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
    final borderColor = context.knobs.colorOrNull(
      label: "Border Color",
      initialValue: null,
    );
    final isUserAvatar = context.knobs.boolean(
      label: "Is User Avatar",
      initialValue: false,
    );
    final forceGradiant = context.knobs.boolean(
      label: "Force Gradient",
      initialValue: true,
    );
    final gradients = _gradients(context);
    final gradient = context.knobs.object.dropdown(
      label: "Gradient",
      options: gradients,
      initialOption: gradients.first,
      labelBuilder: (value) => value.$1,
    );
    final bgColor = context.knobs.colorOrNull(
      label: "Background Color",
      initialValue: null,
    );
    final initialsColor = context.knobs.colorOrNull(
      label: "Initials Color",
      initialValue: null,
    );
    final tags = _tagOptions(context);
    final tag = context.knobs.object.dropdown(
      label: "Tag",
      options: tags,
      initialOption: tags.first,
      labelBuilder: (value) => value.$1,
    );
    final tagSize = context.knobs.doubleOrNull.slider(
      label: "Tag Size",
      min: 8,
      max: 64,
      initialValue: 24,
      defaultToNull: true,
    );
    final isInteractive = context.knobs.boolean(
      label: "Interactive (onPressed)",
      initialValue: false,
    );
    final semanticsLabel = context.knobs.string(
      label: "Semantics Label",
      initialValue: "Jane Doe",
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
    final squareInitialsColor = context.knobs.colorOrNull(
      label: "Square Initials Color",
      initialValue: null,
    );
    final squareIsUserAvatar = context.knobs.boolean(
      label: "Square User Avatar",
      initialValue: true,
    );
    final squareIsEditable = context.knobs.boolean(
      label: "Square Editable (onEdit)",
      initialValue: true,
    );
    final squareSemanticsLabel = context.knobs.string(
      label: "Square Semantics Label",
      initialValue: "Change profile photo",
    );

    final avatarImage = image.$2 == null ? null : AppImageData(image.$2!);
    final avatarInitials = initials.isEmpty ? null : initials;

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
                          "A circular avatar component displaying a user profile picture, fallback initials, an optional corner tag and an optional tap target.",
                      accessibilityNotes: _avatarNotes,
                      code:
                          '''
GtAvatar(
  avatar: ${image.$3 == null ? 'null' : 'AppImageData(${image.$3})'},
  initials: ${avatarInitials == null ? 'null' : '"$avatarInitials"'},
  size: $size,
  fit: BoxFit.${fit.name},
  showBorder: $showBorder,${_colorArg('borderColor', borderColor)}
  isUserAvatar: $isUserAvatar,
  forceGradiant: $forceGradiant,${gradient.$2 == null ? '' : '\n  gradient: ${gradient.$3},'}${_colorArg('bgColor', bgColor)}${_colorArg('initialsColor', initialsColor)}${tag.$2 == null ? '' : '\n  tag: ${tag.$3},'}${tagSize == null ? '' : '\n  tagSize: $tagSize,'}${isInteractive ? '\n  onPressed: () {},\n  semanticsLabel: "$semanticsLabel",' : ''}
)''',
                      child: Center(
                        child: GtAvatar(
                          avatar: avatarImage,
                          initials: avatarInitials,
                          size: size,
                          fit: fit,
                          showBorder: showBorder,
                          borderColor: borderColor,
                          isUserAvatar: isUserAvatar,
                          forceGradiant: forceGradiant,
                          gradient: gradient.$2,
                          bgColor: bgColor,
                          initialsColor: initialsColor,
                          tag: tag.$2,
                          tagSize: tagSize,
                          onPressed: isInteractive ? () {} : null,
                          semanticsLabel: semanticsLabel,
                        ),
                      ),
                    ),
                    "square_avatar": (_) => GtWidgetDocPage(
                      title: "GtSquareAvatar",
                      description:
                          "A square, rounded avatar commonly used for business profile headers or list representations. Without an image it falls back to initials first, then the user placeholder icon, then the default artwork.",
                      accessibilityNotes: _squareAvatarNotes,
                      code:
                          '''
GtSquareAvatar(
  avatar: ${image.$3 == null ? 'null' : 'AppImageData(${image.$3})'},
  initials: ${avatarInitials == null ? 'null' : '"$avatarInitials"'},
  size: $squareSize,
  fit: BoxFit.${fit.name},
  showBorder: $squareShowBorder,
  showGradient: $squareShowGradient,
  isUserAvatar: $squareIsUserAvatar,${_colorArg('bgColor', squareBgColor)}${_colorArg('initialsColor', squareInitialsColor)}${squareEditPenSize == null ? '' : '\n  editPenSize: $squareEditPenSize,'}${squareUserIconSize == null ? '' : '\n  userIconSize: $squareUserIconSize,'}${squareIsEditable ? '\n  onEdit: () {},\n  semanticsLabel: "$squareSemanticsLabel",' : ''}
)''',
                      child: Center(
                        child: GtSquareAvatar(
                          avatar: avatarImage,
                          initials: avatarInitials,
                          size: squareSize,
                          fit: fit,
                          showBorder: squareShowBorder,
                          showGradient: squareShowGradient,
                          isUserAvatar: squareIsUserAvatar,
                          bgColor: squareBgColor,
                          initialsColor: squareInitialsColor,
                          editPenSize: squareEditPenSize,
                          userIconSize: squareUserIconSize,
                          onEdit: squareIsEditable ? () {} : null,
                          semanticsLabel: squareSemanticsLabel,
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

List<(String, Gradient?, String?)> _gradients(BuildContext context) {
  return [
    ('Default', null, null),
    (
      'Avatar',
      context.gradients.avatarGradient,
      'context.gradients.avatarGradient',
    ),
    (
      'Appbar Avatar',
      context.gradients.appbarAvatarGradient,
      'context.gradients.appbarAvatarGradient',
    ),
    (
      'Ghost',
      context.gradients.ghostGradient,
      'context.gradients.ghostGradient',
    ),
  ];
}

List<(String, Widget?, String?)> _tagOptions(BuildContext context) {
  return [
    ('None', null, null),
    (
      'Bank Logo',
      const GtImage(
        image: AppImageData(GtNetworkImages.avatar3d2),
        isDecorative: true,
      ),
      'GtImage(image: AppImageData(GtNetworkImages.avatar3d2), isDecorative: true)',
    ),
    (
      'Status Dot',
      DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: context.palette.success.base,
          border: Border.all(color: context.palette.stroke.white, width: 1.5),
        ),
      ),
      'DecoratedBox(decoration: BoxDecoration(shape: BoxShape.circle, color: context.palette.success.base))',
    ),
    (
      'Verified Icon',
      const GtIcon(GtIcons.verified, variant: .success),
      'GtIcon(GtIcons.verified, variant: .success)',
    ),
  ];
}

String _colorArg(String name, Color? color) {
  if (color == null) return '';
  return '\n  $name: Color(0x${color.toARGB32().toRadixString(16)}),';
}
