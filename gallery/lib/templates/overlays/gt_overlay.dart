import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtToast', type: GtToast)
Widget buildGtToastUsecase(BuildContext context) {
  final icon = context.knobs.object.dropdown<(String, IconData?)>(
    label: "Toast Icon",
    options: [
      ("None", null),
      ("Copy", GtIcons.copyFilled),
      ("Gear", GtIcons.gear),
    ],
    labelBuilder: (value) => value.$1,
  );
  final title = context.knobs.string(
    label: "Title",
    initialValue: "Yaayy! a toast to life!!!",
  );
  final duration = context.knobs.duration(
    label: "Duration",
    initialValue: 3000.milliseconds,
  );
  final type = context.knobs.object.dropdown<(String, GtPillVariant?)>(
    label: "Type",
    options: [
      ("None", null),
      ("Success", .success),
      ("Error", .error),
      ("Warning", .warning),
      ("Info", .info),
    ],
    labelBuilder: (value) => value.$1,
  );
  return Scaffold(
    appBar: GtTitleAppBar(title: "GtToast Playground"),
    body: Padding(
      padding: context.insets.defaultAllInsets,
      child: Column(
        mainAxisAlignment: .center,
        crossAxisAlignment: .stretch,
        children: [
          GtRaisedButton(
            onPressed: () {
              context.showToast(
                title,
                icon: icon.$2,
                duration: duration.inMilliseconds,
                type: type.$2,
              );
            },
            text: "Show Toast",
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'GtAlert', type: GtAlert)
Widget buildGtAlertUsecase(BuildContext context) {
  final title = context.knobs.string(
    label: "Title",
    initialValue: "Processing Error",
  );
  final message = context.knobs.string(
    label: "Title",
    initialValue:
        "Something went wrong while handling the request. Try again later",
  );
  final duration = context.knobs.duration(
    label: "Duration",
    initialValue: 3000.milliseconds,
  );
  final type = context.knobs.object.dropdown<(String, GtNotificationVariant?)>(
    label: "Type",
    options: [
      ("None", null),
      ("Success", .success),
      ("Error", .error),
      ("Warning", .warning),
      ("Info", .info),
    ],
    labelBuilder: (value) => value.$1,
  );
  return Scaffold(
    appBar: GtTitleAppBar(title: "GtAlert Playground"),
    body: Padding(
      padding: context.insets.defaultAllInsets,
      child: Column(
        mainAxisAlignment: .center,
        crossAxisAlignment: .stretch,
        children: [
          GtRaisedButton(
            onPressed: () {
              context.showAlert(
                title,
                message: message,
                duration: duration.inMilliseconds,
                type: type.$2,
              );
            },
            text: "Show Alert",
          ),
        ],
      ),
    ),
  );
}

// @widgetbook.UseCase(name: 'GtTooltipWidget', type: GtTooltipWidget)
// Widget buildGtToolTipUsecase(BuildContext context) {
//   return Scaffold(
//     appBar: GtTitleAppBar(title: "GtTooltip Playground"),
//     body: Padding(
//       padding: context.insets.defaultAllInsets,
//       child: Builder(
//         builder: (context) {
//           return Column(
//             crossAxisAlignment: .stretch,
//             mainAxisAlignment: .center,
//             spacing: context.spacingsection4xl,
//             children: [
//               GtTooltipWrapper(
//                 key: ValueKey("Click me to see tooltip 1"),
//                 tooltipTitle: "View and add accounts",
//                 tooltipMessage:
//                     "You can view your other accounts and open a new one",
//                 child: GtText(
//                   "Click me to see tooltip 1".upper,
//                   style: context.textStyles.h6(),
//                   textAlign: .center,
//                 ),
//               ),
//               GtTooltipWrapper(
//                 key: ValueKey("Click me to see tooltip 2"),
//                 tooltipTitle: "View and add accounts",
//                 tooltipMessage:
//                     "You can view your other accounts and open a new one",
//                 child: GtText(
//                   "Click me to see tooltip 2".upper,
//                   style: context.textStyles.h6(),
//                   textAlign: .center,
//                 ),
//               ),
//               GtTooltipWrapper(
//                 key: ValueKey("Click me to see tooltip 3"),
//                 tooltipTitle: "View and add accounts",
//                 tooltipMessage:
//                     "You can view your other accounts and open a new one",
//                 child: GtText(
//                   "Click me to see tooltip 3".upper,
//                   style: context.textStyles.h6(),
//                   textAlign: .center,
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     ),
//   );
// }
