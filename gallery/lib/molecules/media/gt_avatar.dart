import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtAvatar', type: GtAvatar)
Widget buildGtAvatarUsecase(BuildContext context) {
  final fit = context.knobs.object.dropdown(
    label: "Avatar Fit",
    options: BoxFit.values,
    initialOption: BoxFit.cover,
    labelBuilder: (value) => value.name.capitalise(),
  );
  final alignment = context.knobs.object.dropdown<(String, Alignment)>(
    label: "Avatar Alignment",
    options: [
      ("Centre", Alignment.center),
      ("Left", Alignment.centerLeft),
      ("Right", Alignment.centerRight),
    ],
    initialOption: ("Centre", Alignment.center),
    labelBuilder: (value) => value.$1,
  );
  final images = context.knobs.object
      .dropdown<(String, AppImageData?, bool, Widget?, String?)>(
        label: "Image",
        options: [
          ("None", null, false, null, null),
          ("Initials", null, false, null, "JD"),
          (
            "Simple Image",
            AppImageData(imageData: GtNetworkImages.sampleAvatar1),
            false,
            null,
            null,
          ),
          (
            "Avatar with border and tag",
            AppImageData(imageData: GtNetworkImages.sampleAvatar2),
            true,
            GtSvg(GtVectors.logo),
            null,
          ),
        ],
        labelBuilder: (value) => value.$1,
      );

  return Scaffold(
    appBar: GtTitleAppBar(title: "GtEditAvatar Widget"),
    body: Center(
      child: GtAvatar(
        avatar: images.$2,
        showBorder: images.$3,
        tag: images.$4,
        initials: images.$5,
        fit: fit,
        alignment: alignment.$2,
        size: context.knobs.double.slider(
          label: "Avatar Size",
          min: 20,
          max: 200,
          initialValue: 36,
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'GtEditAvatar', type: GtEditAvatar)
Widget buildGtEditAvatarUsecase(BuildContext context) {
  final fit = context.knobs.object.dropdown(
    label: "Avatar Fit",
    options: BoxFit.values,
    initialOption: BoxFit.cover,
    labelBuilder: (value) => value.name.capitalise(),
  );
  final alignment = context.knobs.object.dropdown<(String, Alignment)>(
    label: "Avatar Alignment",
    options: [
      ("Centre", Alignment.center),
      ("Left", Alignment.centerLeft),
      ("Right", Alignment.centerRight),
    ],
    initialOption: ("Centre", Alignment.center),
    labelBuilder: (value) => value.$1,
  );
  final images = context.knobs.object.dropdown<(String, AppImageData?)>(
    label: "Image",
    options: [
      ("None", null),
      (
        "Sample 1",
        AppImageData(imageData: "https://images.unsplash.com/photo-1728577740843-5f29c7586afe?q=80&w=1160&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
      ),
      (
        "Sample 2",
        AppImageData(imageData: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
      ),
      (
        "Sample 3",
        AppImageData(imageData: "https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=928&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
      ),
      (
        "Sample 4",
        AppImageData(imageData: "https://plus.unsplash.com/premium_photo-1671656349322-41de944d259b?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
      ),
    ],
    labelBuilder: (value) => value.$1,
  );

  return Scaffold(
    appBar: GtTitleAppBar(title: "GtEditAvatar Widget"),
    body: Center(
      child: GtEditAvatar(
        avatar: images.$2,
        fit: fit,
        alignment: alignment.$2,
        onEdit: () {},
        size: context.knobs.double.slider(
          label: "Avatar Size",
          min: 100,
          max: 400,
          initialValue: 180,
        ),
      ),
    ),
  );
}
