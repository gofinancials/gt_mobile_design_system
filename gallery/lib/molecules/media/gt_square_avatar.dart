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
  'The box only joins the semantics tree once onEdit is set; pass semanticsLabel describing the action, not the picture.',
  'The edit pen carries no label of its own, so semanticsLabel is the only announcement a screen reader gets for it.',
  'Initials are a visual fallback and are excluded from the tree; the name they abbreviate must already be on screen.',
];

@widgetbook.UseCase(name: 'GtSquareAvatar', type: GtSquareAvatar)
Widget buildGtSquareAvatarUseCase(BuildContext context) {
  return const _SquareAvatarPlayground();
}

class _SquareAvatarPlayground extends GtStatelessWidget {
  const _SquareAvatarPlayground();

  @override
  Widget build(BuildContext context) {
    final image = context.knobs.object.dropdown(
      label: 'Image',
      options: _images,
      initialOption: _images.last,
      labelBuilder: (value) => value.$1,
    );
    final initials = context.knobs.string(label: 'Initials', initialValue: '');
    final isUserAvatar = context.knobs.boolean(
      label: 'Is User Avatar',
      initialValue: true,
    );
    final size = context.knobs.double.slider(
      label: 'Size',
      min: 40,
      max: 300,
      initialValue: 150,
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
    final radii = _radii(context);
    final radius = context.knobs.object.dropdown(
      label: 'Border Radius',
      options: radii,
      initialOption: radii.first,
      labelBuilder: (value) => value.$1,
    );
    final showBorder = context.knobs.boolean(
      label: 'Show Border',
      initialValue: false,
    );
    final showGradient = context.knobs.boolean(
      label: 'Show Gradient',
      initialValue: true,
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
    final userIconSize = context.knobs.doubleOrNull.slider(
      label: 'User Icon Size',
      min: 12,
      max: 120,
      initialValue: 48,
      defaultToNull: true,
    );
    final showLoadingIndicator = context.knobs.boolean(
      label: 'Show Loading Indicator',
      initialValue: false,
    );
    final isEditable = context.knobs.boolean(
      label: 'Editable (onEdit)',
      initialValue: true,
    );
    final editPenSize = context.knobs.doubleOrNull.slider(
      label: 'Edit Pen Size',
      min: 16,
      max: 80,
      initialValue: 32,
      defaultToNull: true,
    );
    final semanticsLabel = context.knobs.string(
      label: 'Semantics Label',
      initialValue: 'Change profile photo',
    );

    final avatarImage = image.$2 == null ? null : AppImageData(image.$2!);
    final avatarInitials = initials.isEmpty ? null : initials;

    return GtWidgetDocPage(
      title: 'GtSquareAvatar',
      description:
          'A square, rounded avatar used for business profile headers and '
          'list rows. With no usable image it falls back to initials first, '
          'then, for a user avatar, the glyph; anything else gets the default '
          'artwork.',
      accessibilityNotes: _notes,
      code:
          '''
GtSquareAvatar(
  avatar: ${image.$3 == null ? 'null' : 'AppImageData(${image.$3})'},
  initials: ${avatarInitials == null ? 'null' : '"$avatarInitials"'},
  isUserAvatar: $isUserAvatar,
  size: $size,
  fit: BoxFit.${fit.name},
  showLoadingIndicator: $showLoadingIndicator,
  alignment: ${alignment.$2},
  showBorder: $showBorder,
  showGradient: $showGradient,${radius.$3 == null ? '' : '\n  borderRadius: ${radius.$3},'}${_colorArg('bgColor', bgColor)}${_colorArg('initialsColor', initialsColor)}${initialsStyle.$3 == null ? '' : '\n  initialsStyle: ${initialsStyle.$3},'}${userIconSize == null ? '' : '\n  userIconSize: $userIconSize,'}${editPenSize == null ? '' : '\n  editPenSize: $editPenSize,'}${isEditable ? '\n  onEdit: () {},\n  semanticsLabel: "$semanticsLabel",' : ''}
)''',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: GtSquareAvatar(
              avatar: avatarImage,
              initials: avatarInitials,
              isUserAvatar: isUserAvatar,
              size: size,
              fit: fit,
              alignment: alignment.$2,
              borderRadius: radius.$2,
              showBorder: showBorder,
              showGradient: showGradient,
              bgColor: bgColor,
              initialsColor: initialsColor,
              initialsStyle: initialsStyle.$2,
              userIconSize: userIconSize,
              editPenSize: editPenSize,
              showLoadingIndicator: showLoadingIndicator,
              onEdit: isEditable ? () {} : null,
              semanticsLabel: semanticsLabel,
            ),
          ),
          const GtGap.ySectionSm(),
          const _Showcase(
            title: 'Fallback order',
            caption:
                'Each step applies only when the one before it has nothing to '
                'show. A blank URL counts as nothing, and a user avatar never '
                'reaches for the default artwork.',
            items: [
              (
                'Image',
                GtSquareAvatar(
                  avatar: AppImageData(GtNetworkImages.sampleAvatar1),
                  initials: 'JD',
                  isUserAvatar: true,
                  size: 72,
                ),
              ),
              (
                'Initials',
                GtSquareAvatar(
                  avatar: AppImageData(''),
                  initials: 'JD',
                  isUserAvatar: true,
                  size: 72,
                ),
              ),
              ('User glyph', GtSquareAvatar(isUserAvatar: true, size: 72)),
              ('Default artwork', GtSquareAvatar(size: 72)),
            ],
          ),
          const GtGap.ySectionSm(),
          _Showcase(
            title: 'Shape and surface',
            items: [
              (
                'Squared',
                GtSquareAvatar(
                  initials: 'GT',
                  size: 72,
                  borderRadius: context.borderRadiusXs,
                ),
              ),
              (
                'Rounded',
                GtSquareAvatar(
                  initials: 'GT',
                  size: 72,
                  borderRadius: context.borderRadius2Xl,
                ),
              ),
              (
                'Bordered',
                GtSquareAvatar(initials: 'GT', size: 72, showBorder: true),
              ),
              (
                'No gradient',
                GtSquareAvatar(
                  initials: 'GT',
                  size: 72,
                  showGradient: false,
                  bgColor: context.palette.bg.sub,
                ),
              ),
            ],
          ),
          const GtGap.ySectionSm(),
          const _Showcase(
            title: 'Sizes',
            items: [
              ('40', GtSquareAvatar(initials: 'GT', size: 40)),
              ('64', GtSquareAvatar(initials: 'GT', size: 64)),
              ('96', GtSquareAvatar(initials: 'GT', size: 96)),
              (
                'Editable',
                GtSquareAvatar(
                  isUserAvatar: true,
                  size: 96,
                  semanticsLabel: 'Change profile photo',
                  onEdit: _noop,
                ),
              ),
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

List<(String, BorderRadius?, String?)> _radii(BuildContext context) {
  return [
    ('Default', null, null),
    ('Xs', context.borderRadiusXs, 'context.borderRadiusXs'),
    ('Md', context.borderRadiusMd, 'context.borderRadiusMd'),
    ('2Xl', context.borderRadius2Xl, 'context.borderRadius2Xl'),
    ('Full', context.borderRadiusFull, 'context.borderRadiusFull'),
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

String _colorArg(String name, Color? color) {
  if (color == null) return '';
  return '\n  $name: Color(0x${color.toARGB32().toRadixString(16)}),';
}
