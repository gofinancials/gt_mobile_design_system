import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtHomeAppbar', type: GtHomeAppBar)
Widget buildGtHomeAppbarUsecase(BuildContext context) {
  final showGradient = context.knobs.boolean(label: "Show Gradient");
  final color = showGradient
      ? context.palette.primary.alpha24
      : Colors.transparent;
  return Scaffold(
    appBar: GtHomeAppBar(
      onClickSearch: () {},
      onClickHide: () {},
      onClickNotification: () {},
    ),
    extendBodyBehindAppBar: true,
    body: CustomPaint(
      painter: GtHomeGradientPainter(color: color),
      child: Container(),
    ),
  );
}

@widgetbook.UseCase(name: 'GtTitleAppbar', type: GtTitleAppBar)
Widget buildGtTitleAppbarUsecase(BuildContext context) {
  int count = context.knobs.object.dropdown(
    label: "Trailing Option",
    initialOption: 0,
    options: [0, 1, 2],
    labelBuilder: (value) {
      return switch (value) {
        2 => "Double",
        1 => "Single",
        _ => "None",
      };
    },
  );

  final head = count >= 1 ? GtIcon(GtIcons.scan, size: 24) : null;
  final tail = count >= 2 ? GtIcon(GtIcons.add, size: 24) : null;

  return Scaffold(
    appBar: GtTitleAppBar(
      title: context.knobs.string(label: "Title", initialValue: "Products"),
      trailing: GtOptionalWidgetPair(head: head, tail: tail),
    ),
  );
}

@widgetbook.UseCase(name: 'GtAppbar', type: GtAppBar)
Widget buildGtAppbarUsecase(BuildContext context) {
  final leading = context.knobs.object.dropdown<(String, Widget?)>(
    label: "Leading Icon",
    initialOption: null,
    options: [
      ("None", null),
      ("Back", GtBackButton(routeStackSensitive: false)),
      ("Close", GtCancelButton(alignment: .centerLeft)),
      ("Spinner", GtSpinner(alignment: .centerLeft)),
    ],
    labelBuilder: (value) => value.$1,
  );
  final trailing = context.knobs.object.dropdown<(String, Widget?)>(
    label: "Trailing Icon",
    initialOption: null,
    options: [
      ("None", null),
      ("Settings", GtIcon(GtIcons.gear, size: 24)),
      ("Alarm", GtIcon(GtIcons.alert, size: 24)),
      ("Notification Bell", GtIcon(GtIcons.bell, size: 24)),
    ],
    labelBuilder: (value) => value.$1,
  );
  final size = context.knobs.object.dropdown(
    label: "Title Size",
    initialOption: GtAppBarTitleSize.medium,
    options: GtAppBarTitleSize.values,
    labelBuilder: (value) => value.name.capitalise(),
  );

  return Scaffold(
    appBar: GtAppBar(
      leading: leading.$2,
      title: context.knobs.string(label: "Title", initialValue: "Products"),
      trailing: trailing.$2,
      titleSize: size,
    ),
  );
}

@widgetbook.UseCase(name: 'GtActionAppbar', type: GtActionAppBar)
Widget buildGtActionAppbarUsecase(BuildContext context) {
  final leading = context.knobs.object.dropdown<(String, Widget?)>(
    label: "Leading Icon",
    initialOption: ("Back", GtBackButton(routeStackSensitive: false)),
    options: [
      ("None", null),
      ("Back", GtBackButton(routeStackSensitive: false)),
      ("Close", GtCancelButton(alignment: .centerLeft)),
      ("Spinner", GtSpinner(alignment: .centerLeft)),
    ],
    labelBuilder: (value) => value.$1,
  );
  int count = context.knobs.object.dropdown(
    label: "Trailing Option",
    initialOption: 2,
    options: [0, 1, 2],
    labelBuilder: (value) {
      return switch (value) {
        2 => "Double",
        1 => "Single",
        _ => "None",
      };
    },
  );
  final size = context.knobs.object.dropdown(
    label: "Title Size",
    initialOption: GtAppBarTitleSize.medium,
    options: GtAppBarTitleSize.values,
    labelBuilder: (value) => value.name.capitalise(),
  );

  final head = count >= 1 ? GtSpinner(value: .75) : null;
  final tail = count >= 2
      ? GtRaisedButton(
          onPressed: () {},
          text: "Help",
          leading: GtIcons.sparkle,
          variant: .secondary,
          size: .small,
        )
      : null;
  GtOptionalWidgetPair? trailing;

  if (head != null || tail != null) {
    trailing = GtOptionalWidgetPair(head: head, tail: tail);
  }

  return Scaffold(
    appBar: GtActionAppBar(leading: leading.$2, trailing: trailing),
  );
}

@widgetbook.UseCase(name: 'GtTitleAppbar', type: GtModalAppBar)
Widget buildGtModalAppbarUsecase(BuildContext context) {
  final leading = GtNetworkImage(
    "https://res.cloudinary.com/jesse-dirisu/image/upload/v1530348058/samples/cloudinary-icon.png",
    height: 24,
    width: 24,
  );

  showModal({String? title, Widget? titleLeading}) {
    showModalBottomSheet(
      context: context,

      builder: (context) {
        return Material(
          type: .transparency,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: 50.topBorderRadius,
              color: context.palette.bg.white,
            ),
            child: Column(
              mainAxisAlignment: .start,
              crossAxisAlignment: .stretch,
              children: [
                if (titleLeading == null)
                  GtModalAppBar(title: title)
                else
                  GtModalAppBar.withLeadingTitleimage(
                    title: title ?? "Schedule",
                    titleLeading: titleLeading,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  final title = context.knobs.string(label: "Title", initialValue: "Schedule");

  return Scaffold(
    appBar: GtTitleAppBar(title: "Modal AppBar Examples"),
    body: Padding(
      padding: context.insets.defaultHorizontalInsets,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: context.spacingLg,
        children: [
          GtRaisedButton(
            onPressed: showModal,
            text: "Show Simple Modal AppBar",
          ),
          GtRaisedButton(
            onPressed: () => showModal(title: title),
            text: "Show Titled Modal AppBar",
            variant: .away,
          ),
          GtRaisedButton(
            onPressed: () => showModal(title: title, titleLeading: leading),
            text: "Show Prefixed Titled Modal AppBar",
            variant: .black,
          ),
        ],
      ),
    ),
  );
}
