import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

const _images = [
  (
    'Network Image',
    GtNetworkImages.sampleAvatar1,
    'GtNetworkImages.sampleAvatar1',
  ),
  ('Asset Image', GtAssetImages.avatar, 'GtAssetImages.avatar'),
  ('Texture', GtNetworkImages.avatarTexture1, 'GtNetworkImages.avatarTexture1'),
  ('3D Template', GtNetworkImages.avatar3d1, 'GtNetworkImages.avatar3d1'),
  ('Blank URL', '', "''"),
  ('None', null, null),
];

const _notes = [
  'The avatar only joins the semantics tree once onPressed makes it tappable; pass semanticsLabel naming the person or entity it stands for.',
  'A decorative avatar sitting beside a name that is already on screen should stay silent, so leave onPressed and semanticsLabel unset there.',
  'The image, the initials and the tag are excluded from the tree, so whatever the tag conveys has to be stated by the surrounding copy too.',
];

@widgetbook.UseCase(name: 'GtAvatar', type: GtAvatar)
Widget buildGtAvatarUseCase(BuildContext context) {
  return const _AvatarPlayground();
}

class _AvatarPlayground extends GtStatelessWidget {
  const _AvatarPlayground();

  @override
  Widget build(BuildContext context) {
    final image = context.knobs.object.dropdown(
      label: 'Image',
      options: _images,
      initialOption: _images.first,
      labelBuilder: (value) => value.$1,
    );
    final initials = context.knobs.string(
      label: 'Initials',
      initialValue: 'JD',
    );
    final isUserAvatar = context.knobs.boolean(
      label: 'Is User Avatar',
      initialValue: false,
    );
    final size = context.knobs.double.slider(
      label: 'Size',
      min: 20,
      max: 200,
      initialValue: 80,
    );
    final fit = context.knobs.object.dropdown(
      label: 'Fit',
      options: BoxFit.values,
      initialOption: BoxFit.cover,
      labelBuilder: (value) => value.name.capitalise(),
    );
    final alignments = _alignments();
    final alignment = context.knobs.object.dropdown(
      label: 'Alignment',
      options: alignments,
      initialOption: alignments.first,
      labelBuilder: (value) => value.$1,
    );
    final showBorder = context.knobs.boolean(
      label: 'Show Border',
      initialValue: false,
    );
    final borderColor = context.knobs.colorOrNull(
      label: 'Border Color',
      initialValue: null,
    );
    final forceGradiant = context.knobs.boolean(
      label: 'Force Gradient',
      initialValue: true,
    );
    final gradients = _gradients(context);
    final gradient = context.knobs.object.dropdown(
      label: 'Gradient',
      options: gradients,
      initialOption: gradients.first,
      labelBuilder: (value) => value.$1,
    );
    final bgColor = context.knobs.colorOrNull(
      label: 'Background Color',
      initialValue: null,
    );
    final initialsColor = context.knobs.colorOrNull(
      label: 'Initials Color',
      initialValue: null,
    );
    final styles = _initialsStyles(context);
    final initialsStyle = context.knobs.object.dropdown(
      label: 'Initials Style (overrides color)',
      options: styles,
      initialOption: styles.first,
      labelBuilder: (value) => value.$1,
    );
    final tags = _tagOptions(context);
    final tag = context.knobs.object.dropdown(
      label: 'Tag',
      options: tags,
      initialOption: tags.first,
      labelBuilder: (value) => value.$1,
    );
    final tagSize = context.knobs.doubleOrNull.slider(
      label: 'Tag Size',
      min: 8,
      max: 64,
      initialValue: 24,
      defaultToNull: true,
    );
    final showLoadingIndicator = context.knobs.boolean(
      label: 'Show Loading Indicator',
      initialValue: false,
    );
    final isInteractive = context.knobs.boolean(
      label: 'Interactive (onPressed)',
      initialValue: false,
    );
    final semanticsLabel = context.knobs.string(
      label: 'Semantics Label',
      initialValue: 'Jane Doe',
    );

    final avatarImage = image.$2 == null ? null : AppImageData(image.$2!);
    final avatarInitials = initials.isEmpty ? null : initials;

    return GtWidgetDocPage(
      title: 'GtAvatar',
      description:
          'A circular avatar showing a profile picture, fallback initials, an '
          'optional corner tag and an optional tap target. With no usable '
          'image it falls back to initials first, then, for a user avatar, '
          'the bundled placeholder.',
      accessibilityNotes: _notes,
      code:
          '''
GtAvatar(
  avatar: ${image.$3 == null ? 'null' : 'AppImageData(${image.$3})'},
  initials: ${avatarInitials == null ? 'null' : '"$avatarInitials"'},
  isUserAvatar: $isUserAvatar,
  size: $size,
  fit: BoxFit.${fit.name},
  showLoadingIndicator: $showLoadingIndicator,
  alignment: ${alignment.$2},
  showBorder: $showBorder,${_colorArg('borderColor', borderColor)}
  forceGradiant: $forceGradiant,${gradient.$3 == null ? '' : '\n  gradient: ${gradient.$3},'}${_colorArg('bgColor', bgColor)}${_colorArg('initialsColor', initialsColor)}${initialsStyle.$3 == null ? '' : '\n  initialsStyle: ${initialsStyle.$3},'}${tag.$3 == null ? '' : '\n  tag: ${tag.$3},'}${tagSize == null ? '' : '\n  tagSize: $tagSize,'}${isInteractive ? '\n  onPressed: () {},\n  semanticsLabel: "$semanticsLabel",' : ''}
)''',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: GtAvatar(
              avatar: avatarImage,
              initials: avatarInitials,
              isUserAvatar: isUserAvatar,
              size: size,
              fit: fit,
              alignment: alignment.$2,
              showBorder: showBorder,
              borderColor: borderColor,
              forceGradiant: forceGradiant,
              gradient: gradient.$2,
              bgColor: bgColor,
              initialsColor: initialsColor,
              initialsStyle: initialsStyle.$2,
              tag: tag.$2,
              tagSize: tagSize,
              showLoadingIndicator: showLoadingIndicator,
              onPressed: isInteractive ? () {} : null,
              semanticsLabel: semanticsLabel,
            ),
          ),
          const GtGap.ySectionSm(),
          const _Showcase(
            title: 'Fallback order',
            caption:
                'Each step applies only when the one before it has nothing to '
                'show. A blank URL counts as nothing, and initials outrank the '
                'bundled placeholder.',
            items: [
              (
                'Image',
                GtAvatar(
                  avatar: AppImageData(GtNetworkImages.sampleAvatar1),
                  initials: 'JD',
                  isUserAvatar: true,
                  size: 64,
                ),
              ),
              (
                'Initials',
                GtAvatar(
                  avatar: AppImageData(''),
                  initials: 'JD',
                  isUserAvatar: true,
                  size: 64,
                ),
              ),
              ('Placeholder', GtAvatar(isUserAvatar: true, size: 64)),
              ('Empty', GtAvatar(size: 64)),
            ],
          ),
          const GtGap.ySectionSm(),
          _Showcase(
            title: 'Tags',
            caption:
                'The tag sits at the bottom-right and is excluded from '
                'semantics, so state whatever it conveys in the surrounding '
                'copy.',
            items: [
              for (final (label, widget, _) in _tagOptions(context).skip(1))
                (
                  label,
                  GtAvatar(
                    avatar: const AppImageData(GtNetworkImages.sampleAvatar1),
                    size: 64,
                    tag: widget,
                  ),
                ),
              (
                'Interactive',
                GtAvatar(
                  avatar: const AppImageData(GtNetworkImages.sampleAvatar1),
                  size: 64,
                  semanticsLabel: 'Jane Doe',
                  onPressed: _noop,
                ),
              ),
            ],
          ),
          const GtGap.ySectionSm(),
          _Showcase(
            title: 'Surface',
            items: [
              (
                'Bordered',
                GtAvatar(initials: 'GT', size: 64, showBorder: true),
              ),
              (
                'Flat',
                GtAvatar(
                  initials: 'GT',
                  size: 64,
                  forceGradiant: false,
                  bgColor: context.palette.bg.sub,
                ),
              ),
              (
                'Ghost',
                GtAvatar(
                  initials: 'GT',
                  size: 64,
                  gradient: context.gradients.ghostGradient,
                ),
              ),
              (
                'Appbar',
                GtAvatar(
                  initials: 'GT',
                  size: 64,
                  gradient: context.gradients.appbarAvatarGradient,
                ),
              ),
            ],
          ),
          const GtGap.ySectionSm(),
          const _Showcase(
            title: 'Sizes',
            items: [
              ('24', GtAvatar(initials: 'GT', size: 24)),
              ('32', GtAvatar(initials: 'GT', size: 32)),
              ('48', GtAvatar(initials: 'GT', size: 48)),
              ('80', GtAvatar(initials: 'GT', size: 80)),
              ('120', GtAvatar(initials: 'GT', size: 120)),
            ],
          ),
        ],
      ),
    );
  }
}

void _noop() {}

class _Showcase extends GtStatelessWidget {
  final String title;
  final String? caption;
  final List<(String, Widget)> items;

  const _Showcase({required this.title, this.caption, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GtText(title, style: context.textStyles.subHeadS()),
        if (caption case String text) ...[
          const GtGap.yXs(),
          GtText(
            text,
            style: context.textStyles.bodyXs(color: context.palette.text.sub),
          ),
        ],
        const GtGap.yMd(),
        Wrap(
          spacing: 20,
          runSpacing: 20,
          crossAxisAlignment: WrapCrossAlignment.end,
          children: [
            for (final (label, child) in items)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  child,
                  const GtGap.yXs(),
                  GtText(
                    label,
                    style: context.textStyles.bodyXs(
                      color: context.palette.text.sub,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}

List<(String, Alignment)> _alignments() {
  return const [
    ('Center', Alignment.center),
    ('Top Left', Alignment.topLeft),
    ('Top Center', Alignment.topCenter),
    ('Bottom Center', Alignment.bottomCenter),
    ('Bottom Right', Alignment.bottomRight),
  ];
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

List<(String, TextStyle?, String?)> _initialsStyles(BuildContext context) {
  return [
    ('Default', null, null),
    ('Body L', context.textStyles.bodyL(), 'context.textStyles.bodyL()'),
    (
      'Sub Head S',
      context.textStyles.subHeadS(),
      'context.textStyles.subHeadS()',
    ),
    ('Display 3', context.textStyles.d3(), 'context.textStyles.d3()'),
  ];
}

List<(String, Widget?, String?)> _tagOptions(BuildContext context) {
  return [
    ('None', null, null),
    (
      'Bank Logo',
      const GtImage(image: AppImageData(GtVectors.logo), isDecorative: true),
      'GtImage(image: AppImageData(GtNetworkImages.avatar3d2), isDecorative: true)',
    ),
    (
      'Status Dot',
      DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: context.palette.information.base,
          border: Border.all(color: context.palette.stroke.white, width: 1.5),
        ),
      ),
      'DecoratedBox(decoration: BoxDecoration(shape: BoxShape.circle, color: context.palette.success.base))',
    ),
    (
      'Verified Icon',
      const GtIcon(GtIcons.verified, variant: .info),
      'GtIcon(GtIcons.verified, variant: .success)',
    ),
  ];
}

String _colorArg(String name, Color? color) {
  if (color == null) return '';
  return '\n  $name: Color(0x${color.toARGB32().toRadixString(16)}),';
}
