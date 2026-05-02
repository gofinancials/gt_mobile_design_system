import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/data/models/media_data.dart';
import 'package:gt_mobile_foundation/extensions/extensions.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

@widgetbook.UseCase(name: 'GtDuotoneScreen', type: GtDuotoneScreen)
Widget buildGtDuotoneScreenUsecase(BuildContext context) {
  void showToast() {
    context.showToast("Clicked Button", type: .highlighted);
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
    AppImageData(imageData: GtVectorIllustrations.grow),
    AppImageData(imageData: GtVectorIllustrations.security),
    AppImageData(imageData: GtVectorIllustrations.vault),
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
    label: "Fotter",
    options: [
      ("None", null),
      (
        "GtLessonInfoTile",
        GtLessonInfoTile(
          progress: "3/10",
          progressDuration: "5 Mins",
          alignment: .center,
          crossAlignment: .center,
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
  );
}
