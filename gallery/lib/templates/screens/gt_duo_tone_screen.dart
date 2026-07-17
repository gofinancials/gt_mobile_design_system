import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/data/models/media_data.dart';
import 'package:gt_mobile_foundation/extensions/extensions.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtDuotoneScreen', type: GtDuotoneScreen)
Widget buildGtDuotoneScreenDoc(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtDuotoneScreen',
    description: 'A screen layout utilizing a two-tone color contrast header layout with illustration badges and footer metadata.',
    code: '''
GtDuotoneScreen(
  title: "saving smart",
  description: "Why saving matters and how to build good habits.",
  illustration: AppImageData.asset(GtVectorIllustrations.grow),
  buttonText: "get started",
  onTap: () => handleGetStarted(),
  variant: GtCardVariant.featured,
)''',
    child: GtEmptyStateCard(
      description: 'Select "GtDuotoneScreen Gallery" in the sidebar to view the interactive duotone screen in full screen.',
      icon: GtIcons.alarmClock,
    ),
  );
}

@widgetbook.UseCase(name: 'GtDuotoneScreen Gallery', type: GtDuotoneScreen)
Widget buildGtDuotoneScreenUsecase(BuildContext context) {
  void showToast() {
    context.showToast("Clicked Button", type: GtPillVariant.highlighted);
  }

  final title = context.knobs.string(
    label: "Title",
    initialValue: "saving smart",
  );
  final description = context.knobs.string(
    label: "Description",
    initialValue: "Why saving matters and how to build good habits.",
  );
  final illustrations = [
    AppImageData.asset(GtVectorIllustrations.grow),
    AppImageData.asset(GtVectorIllustrations.security),
    AppImageData.asset(GtVectorIllustrations.vault),
  ];
  final illustration = context.knobs.object.dropdown(
    label: "Illustration",
    options: [
      ("Grow", illustrations[0]),
      ("Security", illustrations[1]),
      ("Vault", illustrations[2]),
    ],
    initialOption: ("Grow", illustrations[0]),
    labelBuilder: (value) => value.$1,
  );
  final variant = context.knobs.object.dropdown(
    label: "Variant",
    options: GtCardVariant.values,
    initialOption: GtCardVariant.featured,
    labelBuilder: (value) => value.name.capitalise(),
  );
  final buttonText = context.knobs.string(
    label: "Button Text",
    initialValue: "get started",
  );
  final footer = context.knobs.object.dropdown<(String, Widget?)>(
    label: "Footer",
    options: const [
      ("None", null),
      (
        "GtLessonInfoTile",
        GtLessonInfoTile(
          progress: "3/10",
          progressDuration: "5 Mins",
          alignment: WrapAlignment.center,
          crossAlignment: WrapCrossAlignment.center,
        ),
      ),
    ],
    labelBuilder: (value) => value.$1,
  );

  return GtDuotoneScreen(
    title: title,
    description: description,
    illustration: illustration.$2,
    buttonText: buttonText,
    onTap: showToast,
    variant: variant,
    footer: footer.$2,
    titleMaxLines: context.knobs.object.dropdown(
      label: "Title Max Lines",
      options: const [1, 2, 3],
      initialOption: 2,
    ),
    titleOverflow: context.knobs.object.dropdown(
      label: "Title Overflow",
      options: TextOverflow.values,
      initialOption: TextOverflow.ellipsis,
    ),
  );
}
