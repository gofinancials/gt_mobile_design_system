import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

import 'helpers/test_app_config.dart';

void main() {
  setUpAll(registerTestAppConfig);

  final sender = GtTransferParticipantData(
    label: "From",
    image: AppImageData(GtVectors.dashedPlaceholder),
    balance: 5000,
    validate: true,
  );
  final recipient = GtTransferParticipantData.empty(label: "To");
  final unvalidatedSender = GtTransferParticipantData(
    label: "From",
    image: AppImageData(GtVectors.dashedPlaceholder),
    balance: 5000,
    validate: false,
  );

  /// Mounts [field] in a form and returns whether it validates.
  Future<bool> validate(WidgetTester tester, Widget field) async {
    final form = GlobalKey<FormState>();
    await tester.pumpWidget(
      GtThemeProvider(
        theme: kPersonalTheme,
        child: MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Form(key: form, child: field),
            ),
          ),
        ),
      ),
    );
    final isValid = form.currentState!.validate();
    await tester.pump();
    return isValid;
  }

  GtTransferField transferField(
    String amount, {
    num? min,
    num? max,
    GtTransferParticipantData? from,
  }) {
    return GtTransferField(
      amountController: GtInputController(text: amount),
      noteController: GtInputController(),
      firstParticipant: from ?? sender,
      secondParticipant: recipient,
      noteHint: "Note",
      min: min,
      max: max,
    );
  }

  GtFxTransferField fxTransferField(
    String amount, {
    num? min,
    num? max,
    GtTransferParticipantData? from,
  }) {
    return GtFxTransferField(
      sourceAmountController: GtInputController(text: amount),
      targetAmountController: GtInputController(),
      noteController: GtInputController(),
      firstParticipant: from ?? sender,
      secondParticipant: recipient,
      noteHint: "Note",
      min: min,
      max: max,
    );
  }

  group('GtTransferField amount limits', () {
    testWidgets('a minimum alone caps the amount at the balance', (
      tester,
    ) async {
      expect(await validate(tester, transferField("1,000", min: 100)), isTrue);
      expect(await validate(tester, transferField("6,000", min: 100)), isFalse);
    });

    testWidgets('a maximum above the balance caps at the balance', (
      tester,
    ) async {
      expect(await validate(tester, transferField("4,000", max: 9000)), isTrue);
      expect(
        await validate(tester, transferField("6,000", max: 9000)),
        isFalse,
      );
    });

    testWidgets('a maximum below the balance caps at the maximum', (
      tester,
    ) async {
      expect(await validate(tester, transferField("2,000", max: 3000)), isTrue);
      expect(
        await validate(tester, transferField("4,000", max: 3000)),
        isFalse,
      );
    });
  });

  group('GtFxTransferField amount limits', () {
    testWidgets('a minimum alone caps the amount at the balance', (
      tester,
    ) async {
      expect(
        await validate(tester, fxTransferField("1,000", min: 100)),
        isTrue,
      );
      expect(
        await validate(tester, fxTransferField("6,000", min: 100)),
        isFalse,
      );
    });
  });
  group('amount validation when no participant is validated', () {
    testWidgets('GtTransferField accepts any amount', (tester) async {
      for (final field in [
        transferField("9,000", from: unvalidatedSender),
        transferField("9,000", min: 100, max: 500, from: unvalidatedSender),
        transferField("", from: unvalidatedSender),
      ]) {
        expect(await validate(tester, field), isTrue);
      }
    });

    testWidgets('GtFxTransferField accepts any amount', (tester) async {
      for (final field in [
        fxTransferField("9,000", from: unvalidatedSender),
        fxTransferField("9,000", min: 100, max: 500, from: unvalidatedSender),
      ]) {
        expect(await validate(tester, field), isTrue);
      }
    });
  });
}
