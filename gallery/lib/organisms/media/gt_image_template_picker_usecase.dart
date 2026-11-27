import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

const _designLink =
    'https://www.figma.com/design/EE0KNJdpCKsQGoLFyLrC2v/Personal?node-id=36847-92874';

@widgetbook.UseCase(
  name: 'Inline',
  type: GtImageTemplatePicker,
  designLink: _designLink,
)
Widget gtImageTemplatePickerUseCase(BuildContext context) {
  return const _InlinePreview();
}

@widgetbook.UseCase(
  name: 'In a sheet',
  type: GtImageTemplatePicker,
  designLink: _designLink,
)
Widget gtImageTemplatePickerSheetUseCase(BuildContext context) {
  return const _SheetPreview();
}

class _InlinePreview extends GtStatefulWidget {
  const _InlinePreview();

  @override
  State<_InlinePreview> createState() => _InlinePreviewState();
}

class _InlinePreviewState extends State<_InlinePreview> {
  String _event = 'Nothing picked yet';

  @override
  Widget build(BuildContext context) {
    final showUpload = context.knobs.boolean(
      label: 'Upload tile',
      initialValue: true,
    );

    return GtWidgetDocPage(
      title: 'GtImageTemplatePicker',
      description:
          'Photos and Illustrations tabs over the hosted Stash image '
          'templates, with an optional Upload tile. Pick the Sterling Pro '
          'theme to see the red illustrations.',
      code:
          '''
GtImageTemplatePicker(
  onSelect: (image) => upload(image),
  onUpload: ${showUpload ? 'pickFromGallery' : 'null'},
)''',
      child: Column(
        crossAxisAlignment: .stretch,
        mainAxisSize: .min,
        spacing: context.spacingLg,
        children: [
          GtText(_event),
          GtImageTemplatePicker(
            onSelect: (image) => setState(() => _event = '${image.name}'),
            onUpload: showUpload
                ? () => setState(() => _event = 'Upload tapped')
                : null,
          ),
        ],
      ),
    );
  }
}

class _SheetPreview extends GtStatefulWidget {
  const _SheetPreview();

  @override
  State<_SheetPreview> createState() => _SheetPreviewState();
}

class _SheetPreviewState extends State<_SheetPreview> with GtBottomSheetMixin {
  AppImageData? _picked;

  Future<void> _choose() async {
    final picked = await showSheet<AppImageData>(
      context,
      isScrollable: true,
      useRootNavigator: false,
      child: const _ChooseImageSheet(),
    );
    if (!mounted || picked == null) return;
    setState(() => _picked = picked);
  }

  @override
  Widget build(BuildContext context) {
    final picked = _picked;

    return GtWidgetDocPage(
      title: 'GtImageTemplatePicker in a sheet',
      description:
          'As Stash hosts it: tapping a template closes the sheet with that '
          'image, with no confirm button.',
      code: '''
showSheet<AppImageData>(
  context,
  isScrollable: true,
  child: SingleChildScrollView(
    child: Column(
      children: [
        GtModalAppBar(title: 'choose image'),
        GtImageTemplatePicker(
          onSelect: (image) => Navigator.pop(context, image),
          onUpload: pickFromGallery,
        ),
      ],
    ),
  ),
);''',
      child: Column(
        crossAxisAlignment: .center,
        mainAxisSize: .min,
        spacing: context.spacingLg,
        children: [
          if (picked != null)
            ClipRRect(
              borderRadius: context.borderRadiusXl,
              child: GtImage(
                image: picked,
                width: 120,
                height: 120,
                isDecorative: true,
              ),
            ),
          GtRaisedButton(text: 'Choose image', onPressed: _choose),
        ],
      ),
    );
  }
}

class _ChooseImageSheet extends GtStatelessWidget {
  const _ChooseImageSheet();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: context.insets.defaultAllInsets,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .stretch,
          spacing: context.spacingSectionSm,
          children: [
            GtModalAppBar(title: 'choose image'),
            GtImageTemplatePicker(
              onSelect: (image) => Navigator.of(context).pop(image),
              onUpload: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
