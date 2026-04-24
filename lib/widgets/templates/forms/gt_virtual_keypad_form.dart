import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A template widget that displays a full-screen virtual keypad form.
///
/// This widget is typically used for PIN entry, passcodes, or amount inputs.
/// It combines a [GtDotFormField] for visual input representation and a
/// [GtKeyPadGrid] for user interaction.
class GtVirtualKeypadForm extends GtStatefulWidget {
  /// The main heading text displayed at the top of the form.
  final String title;

  final String? _subtitle;

  /// Optional helper text displayed below the input dots.
  final String? helperText;

  /// Optional error text displayed below the input dots. Overrides helper text.
  final String? errorText;

  final OnPressed? _onBioAuth;

  /// Controls the text being edited by the virtual keypad.
  final TextEditingController controller;

  /// An optional method that validates the input.
  final OnValidate<String?>? validator;

  final AppImageData? _avatar;

  /// The maximum number of characters allowed in the input.
  final int maxLength;

  /// A global key that uniquely identifies the form and allows validation.
  final GlobalKey<FormState> formKey;

  /// Callback invoked when the input text changes.
  final OnChanged<String?>? onChanged;

  /// Callback invoked when the input length reaches [maxLength].
  final OnChanged<String?>? onCompleted;

  /// An optional widget to display at the bottom of the screen (e.g., action buttons).
  final Widget? footer;

  /// Creates a standard virtual keypad form.
  ///
  /// Use this constructor when you need a simple title and subtitle layout
  /// without user avatars or biometric authentication options.
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

  /// Creates a virtual keypad form customized for user authentication.
  ///
  /// Displays an [avatar] and uses [name] as the title. It also supports an
  /// optional [onBioAuth] callback to enable biometric authentication from the keypad.
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

  /// The default avatar used if none is provided to [GtVirtualKeypadForm.withAvatar].
  static AppImageData get _defaultAvatar =>
      AppImageData(imageData: GtAssetImages.avatar);

  @override
  State<GtVirtualKeypadForm> createState() => _GtVirtualKeypadFormState();

  /// The avatar image data, if this form was created via [GtVirtualKeypadForm.withAvatar].
  AppImageData? get avatar => _avatar;

  /// The subtitle text, if this form was created via the default constructor.
  String? get subtitle => _subtitle;

  /// The biometric authentication callback, if provided.
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
