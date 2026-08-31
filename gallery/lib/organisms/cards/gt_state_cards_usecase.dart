import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

const _illustrationOptions = [
  (name: 'emptyState', path: GtVectorIllustrations.emptyState),
  (name: 'empty', path: GtVectorIllustrations.empty),
  (name: 'notFound', path: GtVectorIllustrations.notFound),
  (name: 'search', path: GtVectorIllustrations.search),
  (name: 'details', path: GtVectorIllustrations.details),
];

const _iconOptions = [
  (name: 'userSearch', icon: GtIcons.userSearch),
  (name: 'search', icon: GtIcons.search),
  (name: 'fileContent', icon: GtIcons.fileContent),
  (name: 'bankCard', icon: GtIcons.bankCard),
  (name: 'notificationSolid', icon: GtIcons.notificationSolid),
];

@widgetbook.UseCase(name: 'GtEmptyStateCard', type: GtEmptyStateCard)
Widget playgroundGtEmptyStateCardUseCase(BuildContext context) {
  final mode = context.knobs.object.dropdown<String>(
    label: 'Card Mode',
    options: ['icon', 'image'],
    initialOption: 'icon',
  );
  final description = context.knobs.string(
    label: 'Description',
    initialValue: 'You currently do not have any team member here',
  );
  final variant = context.knobs.object.dropdown<GtCardVariant>(
    label: 'Variant',
    options: GtCardVariant.values,
    initialOption: GtCardVariant.normal,
    labelBuilder: (v) => v.name,
  );
  final spacing = context.knobs.double.slider(
    label: 'Spacing',
    initialValue: 8.0,
    min: 0.0,
    max: 32.0,
  );
  final hasFooter = context.knobs.boolean(
    label: 'Show Footer',
    initialValue: false,
  );
  final footerText = context.knobs.string(
    label: 'Footer Button Text',
    initialValue: 'Add Team Member',
  );

  final selectedIconItem = context.knobs.objectOrNull
      .dropdown<({String name, IconData icon})?>(
        label: 'Icon',
        options: [..._iconOptions, null],
        initialOption: _iconOptions.first,
        labelBuilder: (option) => option == null ? 'None (null)' : option.name,
      );

  final iconSize = context.knobs.double.slider(
    label: 'Icon Size',
    initialValue: 24.0,
    min: 16.0,
    max: 64.0,
  );

  final selectedIllustration = context.knobs.object
      .dropdown<({String name, String path})>(
        label: 'Illustration',
        options: _illustrationOptions,
        initialOption: _illustrationOptions.first,
        labelBuilder: (option) => option.name,
      );

  final imageSize = context.knobs.double.slider(
    label: 'Image Size',
    initialValue: 80.0,
    min: 40.0,
    max: 160.0,
  );

  final footerWidget = hasFooter
      ? GtRaisedButton(text: footerText, size: .xsmall, onPressed: () {})
      : null;

  Widget cardWidget;
  String codeSnippet;

  if (mode == 'image') {
    cardWidget = GtEmptyStateCard.image(
      image: GtSvg(
        selectedIllustration.path,
        width: imageSize.px,
        height: imageSize.px,
      ),
      description: description,
      variant: variant,
      spacing: spacing,
      footer: footerWidget,
    );
    codeSnippet =
        '''
GtEmptyStateCard.image(
  image: GtSvg(
    GtVectorIllustrations.${selectedIllustration.name},
    width: ${imageSize.toInt()},
    height: ${imageSize.toInt()},
  ),
  description: "$description",
  variant: GtCardVariant.${variant.name},
  spacing: ${spacing.toInt()},${hasFooter ? '\n  footer: GtRaisedButton(\n    text: "$footerText",\n    size: .xsmall,\n    onPressed: () {},\n  ),' : ''}
)''';
  } else {
    cardWidget = GtEmptyStateCard(
      icon: selectedIconItem?.icon,
      iconSize: iconSize,
      description: description,
      variant: variant,
      spacing: spacing,
      footer: footerWidget,
    );
    final iconSnippet = selectedIconItem == null
        ? 'null'
        : 'GtIcons.${selectedIconItem.name}';
    codeSnippet =
        '''
GtEmptyStateCard(
  icon: $iconSnippet,
  iconSize: ${iconSize.toInt()},
  description: "$description",
  variant: GtCardVariant.${variant.name},
  spacing: ${spacing.toInt()},${hasFooter ? '\n  footer: GtRaisedButton(\n    text: "$footerText",\n    size: .xsmall,\n    onPressed: () {},\n  ),' : ''}
)''';
  }

  return GtWidgetDocPage(
    title: 'GtEmptyStateCard',
    description:
        'A static card displaying empty state placeholder messages and status icons or illustrations.',
    code: codeSnippet,
    child: cardWidget,
  );
}

@widgetbook.UseCase(
  name: 'GtActionableEmptyStateCard',
  type: GtActionableEmptyStateCard,
)
Widget playgroundGtActionableEmptyStateCardUseCase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'No transfers yet',
  );
  final description = context.knobs.string(
    label: 'Description',
    initialValue: 'Your bulk transfers will appear after you create one',
  );
  final buttontext = context.knobs.string(
    label: 'Button Text',
    initialValue: 'NEW bulk transfer',
  );
  final variant = context.knobs.object.dropdown<GtCardVariant>(
    label: 'Variant',
    options: GtCardVariant.values,
    initialOption: GtCardVariant.normal,
    labelBuilder: (v) => v.name,
  );

  return GtWidgetDocPage(
    title: 'GtActionableEmptyStateCard',
    description:
        'An empty state card featuring a main button action to prompt workflow initiation.',
    code:
        '''
GtActionableEmptyStateCard(
  icon: GtIcons.fileContent,
  title: "$title",
  description: "$description",
  buttontext: "$buttontext",
  variant: GtCardVariant.${variant.name},
  onPressed: () {},
)''',
    child: GtActionableEmptyStateCard(
      icon: GtIcons.fileContent,
      title: title,
      description: description,
      buttontext: buttontext,
      variant: variant,
      onPressed: () {},
    ),
  );
}
