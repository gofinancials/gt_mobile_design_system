import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

import 'helpers/test_app_config.dart';

void main() {
  setUpAll(registerTestAppConfig);

  const longAmount = "9999999999";

  final sender = GtTransferParticipantData(
    label: "From",
    image: AppImageData(GtVectors.dashedPlaceholder),
    balance: 5000,
    validate: true,
  );
  final recipient = GtTransferParticipantData.empty(label: "To");

  /// Mounts [field] in a 360-wide column.
  Future<void> mount(WidgetTester tester, Widget field) {
    return tester.pumpWidget(
      GtThemeProvider(
        theme: kPersonalTheme,
        child: MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 360,
                child: SingleChildScrollView(child: field),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// How far the [index]th input would have to scroll to show all its text.
  double overflowOf(WidgetTester tester, {int index = 0}) {
    final scrollable = find.descendant(
      of: find.byType(EditableText).at(index),
      matching: find.byType(Scrollable),
    );
    return tester.state<ScrollableState>(scrollable).position.maxScrollExtent;
  }

  /// The font size the [index]th input draws its text in.
  double? fontSizeOf(WidgetTester tester, {int index = 0}) {
    return tester
        .widget<TextField>(find.byType(TextField).at(index))
        .style
        ?.fontSize;
  }

  testWidgets('a plain GtTextField scrolls a value wider than itself', (
    tester,
  ) async {
    await mount(tester, GtTextField());

    await tester.enterText(find.byType(TextField), longAmount * 3);
    await tester.pumpAndSettle();
    expect(overflowOf(tester), greaterThan(0));
  });

  group('GtTransferField', () {
    Widget transferField() {
      return GtTransferField(
        amountController: GtInputController(),
        noteController: GtInputController(),
        firstParticipant: sender,
        secondParticipant: recipient,
        noteHint: "Note",
      );
    }

    testWidgets('keeps the amount style while the amount fits', (tester) async {
      await mount(tester, transferField());
      final original = fontSizeOf(tester);

      await tester.enterText(find.byType(TextField).first, "1000");
      await tester.pumpAndSettle();
      expect(fontSizeOf(tester), original);
    });

    testWidgets('shrinks a wide amount to fit instead of scrolling', (
      tester,
    ) async {
      await mount(tester, transferField());
      final original = fontSizeOf(tester)!;

      await tester.enterText(find.byType(TextField).first, longAmount);
      await tester.pumpAndSettle();
      expect(fontSizeOf(tester), lessThan(original));
      expect(overflowOf(tester), 0);

      await tester.enterText(find.byType(TextField).first, "1");
      await tester.pumpAndSettle();
      expect(fontSizeOf(tester), original);
    });
  });

  testWidgets('GtFxTransferField shrinks both amounts to fit', (tester) async {
    await mount(
      tester,
      GtFxTransferField(
        sourceAmountController: GtInputController(),
        targetAmountController: GtInputController(),
        noteController: GtInputController(),
        firstParticipant: sender,
        secondParticipant: recipient,
        noteHint: "Note",
      ),
    );
    final original = fontSizeOf(tester)!;

    for (final index in [0, 1]) {
      await tester.enterText(find.byType(TextField).at(index), longAmount);
      await tester.pumpAndSettle();
      expect(fontSizeOf(tester, index: index), lessThan(original));
      expect(overflowOf(tester, index: index), 0);
    }
  });
}
