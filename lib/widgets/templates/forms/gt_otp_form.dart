import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtOtpForm extends GtStatefulWidget {
  final String title;
  final String subtitle;
  final GlobalKey<FormState> formKey;
  final OnPressed onResendCode;
  final OnChanged<String?>? onDone;
  final TextEditingController? controller;
  final GtCountdownController? countdownController;
  final int pinLength;

  const GtOtpForm({
    required this.formKey,
    required this.onResendCode,
    this.controller,
    required this.title,
    required this.subtitle,
    this.onDone,
    this.countdownController,
    this.pinLength = 6,
    super.key,
  });

  @override
  State<GtOtpForm> createState() => _GtOtpFormState();
}

class _GtOtpFormState extends State<GtOtpForm> with GtOtpFormMixin {
  @override
  Widget build(BuildContext context) {
    return GtForm(
      formKey: widget.formKey,
      key: const Key("gt-otp-code-form"),
      child: Padding(
        padding: context.insets.defaultAllInsets,
        child: Column(
          crossAxisAlignment: .stretch,
          mainAxisSize: .max,
          spacing: context.spacing.sectionSm,
          children: [
            GtPageHeader(
              key: const Key("gt-otp-form-page-header"),
              title: widget.title,
              subtitle: widget.subtitle,
            ),
            GtPinInput(
              key: const Key("gt-otp-form-pin-input"),
              length: widget.pinLength,
              controller: pinCtrl,
              onFieldSubmitted: widget.onDone,
            ),
            const GtGap.ySectionSm(),
            NumberListener(
              key: const Key("gt-otp-code-timer-listener"),
              valueListenable: countDown,
              builder: (count) {
                if ((count ?? 0) <= 0) {
                  return GtInkWell(
                    key: const Key("gt-otp-code-resend-button"),
                    onTap: () {
                      widget.onResendCode();
                      if (widget.countdownController == null) startCountDown();
                    },
                    child: Row(
                      spacing: context.spacingBase,
                      mainAxisAlignment: .center,
                      children: [
                        GtIcon(
                          GtIcons.refresh,
                          size: context.dp(22.px),
                          variant: .soft,
                        ),
                        GtText("otpCodeNotReceived".tr(), textAlign: .center),
                      ],
                    ),
                  );
                }

                final prefix = "otpGenerateNewCodeIn".tr();
                final suffix = (count ?? 0).asDurationString;

                return GtText(
                  "$prefix $suffix",
                  textAlign: .center,
                  key: const Key("gt-otp-code-timer-text"),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

mixin GtOtpFormMixin<T extends GtOtpForm> on State<T> {
  late final GtCountdownController countdownController;
  late final TextEditingController pinCtrl;

  ValueNotifier<int> get countDown => countdownController.countDown;

  @override
  void initState() {
    super.initState();
    countdownController = widget.countdownController ?? GtCountdownController();
    pinCtrl = widget.controller ?? TextEditingController();
    if (widget.countdownController == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        startCountDown();
      });
    }
  }

  @override
  void dispose() {
    if (widget.countdownController == null) countdownController.dispose();
    if (widget.controller == null) pinCtrl.dispose();
    super.dispose();
  }

  void startCountDown() {
    countdownController.startCountDown();
  }
}

class GtCountdownController {
  final int seconds;
  late final ValueNotifier<int> countDown;
  StreamSubscription<int>? _subscription;

  GtCountdownController({this.seconds = 60}) {
    countDown = ValueNotifier(seconds);
  }

  void startCountDown() {
    _subscription?.cancel();
    countDown.value = seconds;
    _subscription = _startCountDownSubscription();
  }

  StreamSubscription<int> _startCountDownSubscription() {
    return AppHelpers.countDown(
      seconds > 0 ? seconds - 1 : 0,
    ).asBroadcastStream().listen((count) {
      countDown.value = count;
    });
  }

  void dispose() {
    _subscription?.cancel();
    countDown.dispose();
  }
}
