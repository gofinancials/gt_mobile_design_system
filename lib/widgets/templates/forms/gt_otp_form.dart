import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A template widget that displays an OTP (One-Time Password) verification form.
///
/// This form features a [GtPageHeader] for the title and instructions, a
/// [GtPinInput] for entering the OTP code, and a countdown timer that reveals
/// a resend button once the countdown elapses.
class GtOtpForm extends GtStatefulWidget {
  /// The main heading text displayed at the top of the form.
  final String title;

  /// The descriptive subtitle or instructions displayed below the [title].
  final String subtitle;

  /// A global key that uniquely identifies the form and allows validation.
  final GlobalKey<FormState> formKey;

  /// Callback invoked when the user taps the resend code button.
  final OnPressed onResendCode;

  /// Callback invoked when the user finishes submitting the PIN input.
  final OnChanged<String?>? onDone;

  /// An optional text editing controller for the PIN input.
  ///
  /// If omitted, a controller will be created and managed internally.
  final TextEditingController? controller;

  /// An optional countdown controller for managing the resend timer.
  ///
  /// If omitted, a [GtCountdownController] will be created and managed internally.
  final GtCountdownController? countdownController;

  /// A list of autofill hints for the PIN input field.
  ///
  /// Defaults to `[AutofillHints.oneTimeCode]`.
  final List<String>? autofillHints;

  /// The length of the OTP PIN code.
  ///
  /// Defaults to 6.
  final int pinLength;

  /// Creates a [GtOtpForm].
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
    this.autofillHints = const [AutofillHints.oneTimeCode],
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
          children: [
            GtPageHeader(
              key: const Key("gt-otp-form-page-header"),
              title: widget.title,
              subtitle: widget.subtitle,
            ),
            const GtGap.ySectionSm(),
            GtPinInput(
              key: const Key("gt-otp-form-pin-input"),
              length: widget.pinLength,
              controller: pinCtrl,
              onFieldSubmitted: widget.onDone,
              autofillHints: widget.autofillHints,
            ),
            const GtGap.ySectionXl(),
            NumberListener(
              key: const Key("gt-otp-code-timer-listener"),
              valueListenable: countDown,
              builder: (count) {
                if ((count ?? 0) <= 0) {
                  return GtInkWell(
                    role: .button,
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

/// A mixin that provides countdown timer and text editing controller management
/// for [GtOtpForm] state implementations.
mixin GtOtpFormMixin<T extends GtOtpForm> on State<T> {
  /// The countdown controller managing the resend timer.
  late final GtCountdownController countdownController;

  /// The text editing controller for the OTP pin input.
  late final TextEditingController pinCtrl;

  /// A [ValueNotifier] that notifies listeners of remaining seconds on the countdown timer.
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

  /// Starts or restarts the countdown timer.
  void startCountDown() {
    countdownController.startCountDown();
  }
}

/// A controller that manages a countdown timer and notifies listeners
/// of the remaining time in seconds.
class GtCountdownController {
  /// The duration in seconds to count down from.
  final int seconds;

  /// A [ValueNotifier] that holds the current remaining seconds of the countdown.
  late final ValueNotifier<int> countDown;

  StreamSubscription<int>? _subscription;

  /// Creates a [GtCountdownController] with the specified [seconds] duration.
  ///
  /// Defaults to 60 seconds.
  GtCountdownController({this.seconds = 60}) {
    countDown = ValueNotifier(seconds);
  }

  /// Starts or restarts the countdown timer from [seconds].
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

  /// Disposes the countdown controller and cancels any active subscriptions.
  void dispose() {
    _subscription?.cancel();
    countDown.dispose();
  }
}
