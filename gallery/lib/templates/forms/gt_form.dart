import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final formKey = GlobalKey<FormState>();
final controller = TextEditingController();

final formKey2 = GlobalKey<FormState>();
final controller2 = TextEditingController();

void showToast(String text, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: GtText(
        text,
        style: context.textStyles.bodyM(color: context.palette.text.white),
      ),
      backgroundColor: context.palette.bg.strong,
    ),
  );
}

@widgetbook.UseCase(name: 'GtVirtualKeypadForm', type: GtVirtualKeypadForm)
Widget buildGtVirtualKeypadFormUsecase(BuildContext context) {
  return GtVirtualKeypadForm(
    title: context.knobs.string(
      label: "Title",
      initialValue: "CONFIRM TRANSACTION PIN",
    ),
    subtitle: context.knobs.string(
      label: "Subtitle",
      initialValue:
          "Confirm your secure PIN that will be used to authorize all your transactions in app",
    ),
    maxLength: 6,
    controller: controller,
    formKey: formKey,
    helperText: context.knobs.stringOrNull(label: "Helper text"),
    errorText: context.knobs.stringOrNull(label: "Error text"),
    onChanged: (value) => AppLogger.info("UPDATED VALUE: $value"),
    onCompleted: (value) => showToast("Complete VALUE: $value", context),
  );
}

@widgetbook.UseCase(
  name: 'GtVirtualKeypadForm [Avatar]',
  type: GtVirtualKeypadForm,
)
Widget buildGtVirtualKeypadFormAvatarUsecase(BuildContext context) {
  final avatar = context.knobs.object.dropdown<(String, AppImageData?)>(
    label: "Avatar",
    options: [
      ("None", null),
      ("Avatar 1", AppImageData(imageData: GtNetworkImages.sampleAvatar1)),
      ("Avatar 2", AppImageData(imageData: GtNetworkImages.sampleAvatar2)),
    ],
    labelBuilder: (value) => value.$1,
  );
  final footer = context.knobs.object.dropdown<(String, Widget?)>(
    label: "Footer",
    options: [
      ("None", null),
      (
        "Forgot passcode",
        GtTextButton(
          onPressed: () {
            showToast("Clicked forgot passcode", context);
          },
          text: "Forgot passcode?",
          size: .small,
        ),
      ),
    ],
    labelBuilder: (value) => value.$1,
  );
  final trailing = context.knobs.object.dropdown<(String, Widget?)>(
    label: "Action",
    options: [
      ("None", null),
      (
        "Logout",
        GtRaisedButton(
          onPressed: () {
            showToast("Clicked logout", context);
          },
          alignment: .centerRight,
          text: "logout",
          size: .small,
          variant: .secondary,
          leading: GtIcons.circleInfo,
        ),
      ),
    ],
    labelBuilder: (value) => value.$1,
  );

  return GtVirtualKeypadForm.withAvatar(
    name: context.knobs.string(label: "Name", initialValue: "Hi, Tyson"),
    avatar: avatar.$2,
    maxLength: 6,
    controller: controller2,
    formKey: formKey2,
    helperText: context.knobs.stringOrNull(label: "Helper text"),
    errorText: context.knobs.stringOrNull(label: "Error text"),
    onChanged: (value) => AppLogger.info("UPDATED VALUE: $value"),
    onCompleted: (value) => showToast("Complete VALUE: $value", context),
    footer: footer.$2,
    action: trailing.$2,
    onBioAuth: () {
      showToast("Biometric Auth Attempted", context);
    },
  );
}
