import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

import 'helpers/test_app_config.dart';

void main() {
  setUpAll(registerTestAppConfig);

  const resendButton = Key("gt-otp-code-resend-button");
  const timerText = Key("gt-otp-code-timer-text");

  Future<void> pumpForm(
    WidgetTester tester,
    GtCountdownController controller,
  ) async {
    await tester.pumpWidget(
      GtThemeProvider(
        theme: kPersonalTheme,
        child: MaterialApp(
          home: Scaffold(
            body: GtOtpForm(
              formKey: GlobalKey<FormState>(),
              title: "Enter OTP",
              subtitle: "We sent you a code.",
              countdownController: controller,
              onResendCode: () {},
            ),
          ),
        ),
      ),
    );
  }

  /// Lets the countdown's pending one-second delay run out, so no timer is
  /// left when the test ends.
  Future<void> drain(WidgetTester tester, GtCountdownController controller) {
    controller.dispose();
    return tester.pump(const Duration(seconds: 1));
  }

  group('GtCountdownController.stop', () {
    testWidgets('ends the countdown at 0 and keeps it there', (tester) async {
      final controller = GtCountdownController()..startCountDown();
      await tester.pump(const Duration(seconds: 3));
      expect(controller.countDown.value, greaterThan(0));

      controller.stop();
      expect(controller.countDown.value, 0);

      await tester.pump(const Duration(seconds: 3));
      expect(controller.countDown.value, 0);

      await drain(tester, controller);
    });

    testWidgets('startCountDown restarts after a stop', (tester) async {
      final controller = GtCountdownController(seconds: 30)..startCountDown();
      await tester.pump(const Duration(seconds: 2));
      controller.stop();

      controller.startCountDown();
      expect(controller.countDown.value, 30);

      await tester.pump(const Duration(seconds: 3));
      expect(controller.countDown.value, lessThan(30));
      expect(controller.countDown.value, greaterThan(0));

      await drain(tester, controller);
    });

    testWidgets('does nothing harmful before a countdown starts', (
      tester,
    ) async {
      final controller = GtCountdownController()..stop();
      expect(controller.countDown.value, 0);
      controller.dispose();
    });
  });

  group('GtOtpForm', () {
    testWidgets('shows the resend button as soon as its countdown stops', (
      tester,
    ) async {
      final controller = GtCountdownController()..startCountDown();
      await pumpForm(tester, controller);
      await tester.pump(const Duration(seconds: 2));

      expect(find.byKey(timerText), findsOneWidget);
      expect(find.byKey(resendButton), findsNothing);

      controller.stop();
      await tester.pump();

      expect(find.byKey(timerText), findsNothing);
      expect(find.byKey(resendButton), findsOneWidget);

      await tester.pump(const Duration(seconds: 3));
      expect(find.byKey(resendButton), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await drain(tester, controller);
    });
  });
}
