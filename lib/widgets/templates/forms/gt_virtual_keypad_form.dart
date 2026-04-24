import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtVirtualKeypadForm extends GtStatefulWidget {
  final String title;
  final String? _subtitle;
  final String? helperText;
  final String? errorText;
  final OnPressed? _onBioAuth;
  final TextEditingController controller;
  final OnValidate<String?>? validator;
  final AppImageData? _avatar;
  final int maxLength;
  final GlobalKey<FormState> formKey;
  final OnChanged<String?>? onChanged;
  final OnChanged<String?>? onCompleted;
  final Widget? footer;

  const GtVirtualKeypadForm({
    super.key,
    required this.title,
    required String subtitle,
    required this.maxLength,
    required this.controller,
    this.helperText,
    this.errorText,
    this.validator,
    required this.formKey,
    this.onChanged,
    this.onCompleted,
    this.footer,
  }) : _subtitle = subtitle,
       _onBioAuth = null,
       _avatar = null;

  GtVirtualKeypadForm.withAvatar({
    super.key,
    required String name,
    required this.maxLength,
    required this.controller,
    this.helperText,
    this.errorText,
    OnPressed? onBioAuth,
    AppImageData? avatar,
    this.validator,
    required this.formKey,
    this.onChanged,
    this.onCompleted,
    this.footer,
  }) : _subtitle = null,
       _onBioAuth = onBioAuth,
       title = name,
       _avatar = avatar ?? _defaultAvatar;

  static AppImageData get _defaultAvatar =>
      AppImageData(imageData: GtAssetImages.avatar);

  @override
  State<GtVirtualKeypadForm> createState() => _GtVirtualKeypadFormState();

  AppImageData? get avatar => _avatar;
  String? get subtitle => _subtitle;
  OnPressed? get onBioAuth => _onBioAuth;
}

class _GtVirtualKeypadFormState extends State<GtVirtualKeypadForm> {
  @override
  Widget build(BuildContext context) {
    return GtForm(
      formKey: widget.formKey,
      child: Scaffold(
        appBar: const GtAppBar(),
        key: Key("gt-virtual-keypad-form"),
        body: Padding(
          padding: context.insets.defaultAllInsets,
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              if (widget.avatar == null) ...[
                GtPageHeader(
                  title: widget.title.upper,
                  subtitle: widget.subtitle,
                  spacingPx: context.spacing.md,
                ),
                GtGap.ySection3xl(),
                GtGap.yBase(),
              ] else ...[
                GtGap.ySectionXl(),
                GtAvatar(
                  avatar: widget.avatar,
                  size: context.dp(64.px),
                  isUserAvatar: true,
                ),
                GtGap.ySectionSm(),
                GtText(
                  widget.title.upper,
                  style: context.textStyles.h5(),
                  maxLines: 1,
                  textAlign: .center,
                ),
                GtGap.ySection3xl(),
              ],
              GtDotFormField(
                controller: widget.controller,
                length: widget.maxLength,
                errorText: widget.errorText,
                helperText: widget.helperText,
                validator: widget.validator,
              ),
              Expanded(
                child: GtKeyPadGrid(
                  alignment: .bottomCenter,
                  controller: widget.controller,
                  limit: widget.maxLength,
                  onBioAuth: widget.onBioAuth,
                  onChanged: widget.onChanged,
                  onCompleted: widget.onCompleted,
                ),
              ),
              if (widget.footer != null)
                SafeArea(top: false, child: widget.footer!),
            ],
          ),
        ),
      ),
    );
  }
}
