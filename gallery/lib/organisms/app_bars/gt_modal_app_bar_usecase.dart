import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtModalAppBar', type: GtModalAppBar)
Widget playgroundGtModalAppBarUseCase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Transfer Details',
  );
  final mode = context.knobs.object.dropdown<String>(
    label: 'Constructor Mode',
    options: ['standard', 'withLeadingTitleimage', 'extended', 'title'],
    initialOption: 'standard',
  );
  final titleMiddleEllipsis = context.knobs.boolean(
    label: 'Title Middle Ellipsis',
    initialValue: false,
  );
  final middleCode = titleMiddleEllipsis
      ? '\n  titleMiddleEllipsis: true,'
      : '';

  PreferredSizeWidget appBar;
  String modeCode;
  if (mode == 'title') {
    final showAction = context.knobs.boolean(
      label: 'Show Action',
      initialValue: true,
    );
    final action = showAction ? GtCancelButton() : null;
    appBar = GtModalAppBar.title(
      title: title,
      action: action,
      titleMiddleEllipsis: titleMiddleEllipsis,
    );
    modeCode =
        '''GtModalAppBar.title(
  title: "$title",
  action: ${showAction ? 'GtCancelButton()' : 'null'},$middleCode
)''';
  } else if (mode == 'extended') {
    final displayTitle = context.knobs.boolean(
      label: 'Display Title Style (24)',
      initialValue: false,
    );
    appBar = GtModalAppBar.extended(
      title: title,
      action: GtIconButton(icon: GtIcons.spark, onPressed: () {}),
      style: displayTitle ? context.textStyles.h5(heightPx: 24) : null,
      titleMiddleEllipsis: titleMiddleEllipsis,
    );
    modeCode =
        '''GtModalAppBar.extended(
  title: "$title",
  action: GtIconButton(icon: GtIcons.spark, onPressed: () {}),${displayTitle ? '\n  style: context.textStyles.h5(heightPx: 24),' : ''}$middleCode
)''';
  } else if (mode == 'withLeadingTitleimage') {
    appBar = GtModalAppBar.withLeadingTitleimage(
      title: title,
      titleLeading: GtNetworkImage(
        "https://res.cloudinary.com/jesse-dirisu/image/upload/v1530348058/samples/cloudinary-icon.png",
        height: 24,
        width: 24,
      ),
      titleMiddleEllipsis: titleMiddleEllipsis,
    );
    modeCode =
        '''GtModalAppBar.withLeadingTitleimage(
  title: "$title",
  titleLeading: GtNetworkImage(
    "https://res.cloudinary.com/jesse-dirisu/image/upload/v1530348058/samples/cloudinary-icon.png",
    height: 24,
    width: 24,
  ),$middleCode
)''';
  } else {
    appBar = GtModalAppBar(
      title: title,
      titleMiddleEllipsis: titleMiddleEllipsis,
    );
    modeCode =
        '''GtModalAppBar(
  title: "$title",$middleCode
)''';
  }

  return GtWidgetDocPage(
    title: 'GtModalAppBar',
    description:
        'An app bar tailored for modal bottom sheets and overlays, featuring title headers and close/action controls.',
    code: modeCode,
    child: appBar,
  );
}
