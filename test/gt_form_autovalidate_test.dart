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

  /// Mounts [field] in a [Form] validating with [mode], keyed by [form] when
  /// given so a second mount updates the same form.
  Future<GlobalKey<FormState>> mount(
    WidgetTester tester,
    Widget field, {
    AutovalidateMode mode = .disabled,
    GlobalKey<FormState>? form,
  }) async {
    form ??= GlobalKey<FormState>();
    await tester.pumpWidget(
      GtThemeProvider(
        theme: kPersonalTheme,
        child: MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Form(key: form, autovalidateMode: mode, child: field),
            ),
          ),
        ),
      ),
    );
    return form;
  }

  /// Whether any form field on screen is showing an error.
  bool hasError(WidgetTester tester) {
    final fields = find.byWidgetPredicate((it) => it is FormField);
    return tester
        .stateList<FormFieldState<dynamic>>(fields)
        .any((it) => it.hasError);
  }

  /// Requires at least three characters.
  String? minThree(String? text) {
    if ((text?.length ?? 0) < 3) return "Too short";
    return null;
  }

  group('GtTextField', () {
    testWidgets('validates as the text is typed under a form opt-in', (
      tester,
    ) async {
      await mount(
        tester,
        GtTextField(validator: minThree),
        mode: .onUserInteraction,
      );
      expect(find.text("Too short"), findsNothing);

      await tester.enterText(find.byType(TextField), "ab");
      await tester.pumpAndSettle();
      expect(find.text("Too short"), findsOneWidget);

      await tester.enterText(find.byType(TextField), "abc");
      await tester.pumpAndSettle();
      expect(find.text("Too short"), findsNothing);
    });

    testWidgets('validates as the text is typed under a field opt-in', (
      tester,
    ) async {
      await mount(
        tester,
        GtTextField(validator: minThree, autovalidateMode: .onUserInteraction),
      );

      await tester.enterText(find.byType(TextField), "ab");
      await tester.pumpAndSettle();
      expect(find.text("Too short"), findsOneWidget);
    });

    testWidgets('waits for validate() by default', (tester) async {
      final form = await mount(tester, GtTextField(validator: minThree));

      await tester.enterText(find.byType(TextField), "ab");
      await tester.pumpAndSettle();
      expect(find.text("Too short"), findsNothing);

      form.currentState!.validate();
      await tester.pumpAndSettle();
      expect(find.text("Too short"), findsOneWidget);
    });

    testWidgets('validates text set on the controller, as a picker does', (
      tester,
    ) async {
      final controller = GtInputController();
      addTearDown(controller.dispose);
      await mount(
        tester,
        GtTextField(controller: controller, validator: minThree),
        mode: .onUserInteraction,
      );

      controller.text = "ab";
      await tester.pumpAndSettle();
      expect(find.text("Too short"), findsOneWidget);
    });

    testWidgets('reports the change before calling onChanged', (tester) async {
      final key = GlobalKey<FormState>();
      bool? touchedOnChange;
      await tester.pumpWidget(
        GtThemeProvider(
          theme: kPersonalTheme,
          child: MaterialApp(
            home: Scaffold(
              body: Form(
                key: key,
                autovalidateMode: .onUserInteraction,
                child: GtTextField(
                  onChanged: (_) {
                    final fields = find.byWidgetPredicate(
                      (it) => it is FormField,
                    );
                    touchedOnChange = tester
                        .state<FormFieldState<dynamic>>(fields)
                        .hasInteractedByUser;
                  },
                ),
              ),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), "a");
      expect(touchedOnChange, isTrue);
    });

    group('GtForm.onChanged', () {
      /// Mounts a [GtTextField] in a [GtForm] and returns how many times
      /// the form reported a change after one edit.
      Future<int> changesAfterEdit(
        WidgetTester tester, {
        AutovalidateMode formMode = .disabled,
        AutovalidateMode fieldMode = .disabled,
      }) async {
        int changes = 0;
        await tester.pumpWidget(
          GtThemeProvider(
            theme: kPersonalTheme,
            child: MaterialApp(
              home: Scaffold(
                body: GtForm(
                  formKey: GlobalKey<FormState>(),
                  autovalidateMode: formMode,
                  onChanged: () => changes++,
                  child: GtTextField(autovalidateMode: fieldMode),
                ),
              ),
            ),
          ),
        );
        await tester.enterText(find.byType(TextField), "a");
        await tester.pumpAndSettle();
        return changes;
      }

      testWidgets('stays quiet while validation is disabled', (tester) async {
        expect(await changesAfterEdit(tester), 0);
      });

      testWidgets('fires under a form opt-in', (tester) async {
        expect(await changesAfterEdit(tester, formMode: .onUserInteraction), 1);
      });

      testWidgets('fires under a field opt-in', (tester) async {
        expect(await changesAfterEdit(tester, fieldMode: .onUnfocus), 1);
      });
    });

    testWidgets('a reset clears the field without showing an error', (
      tester,
    ) async {
      final form = await mount(
        tester,
        GtTextField(validator: minThree),
        mode: .onUserInteraction,
      );

      await tester.enterText(find.byType(TextField), "ab");
      await tester.pumpAndSettle();
      expect(find.text("Too short"), findsOneWidget);

      form.currentState!.reset();
      await tester.pumpAndSettle();
      expect(find.text("Too short"), findsNothing);
      expect(find.text("ab"), findsNothing);
    });

    testWidgets('a controller changed during a build does not throw', (
      tester,
    ) async {
      final controller = GtInputController();
      addTearDown(controller.dispose);
      Widget field(String text) {
        return _SetTextOnUpdate(
          text: text,
          controller: controller,
          child: GtTextField(controller: controller, validator: minThree),
        );
      }

      final form = await mount(tester, field(""), mode: .onUserInteraction);
      await mount(tester, field("ab"), mode: .onUserInteraction, form: form);
      expect(tester.takeException(), isNull);

      await tester.pumpAndSettle();
      expect(find.text("Too short"), findsOneWidget);
    });
  });

  testWidgets('GtTextField validates on unfocus once its text has changed', (
    tester,
  ) async {
    final first = GtInputController();
    final second = GtInputController();
    addTearDown(first.dispose);
    addTearDown(second.dispose);
    await mount(
      tester,
      Column(
        children: [
          GtTextField(controller: first, validator: minThree),
          GtTextField(controller: second),
        ],
      ),
      mode: .onUnfocus,
    );

    await tester.enterText(find.byType(TextField).first, "ab");
    await tester.pumpAndSettle();
    expect(find.text("Too short"), findsNothing);

    second.focus();
    await tester.pumpAndSettle();
    expect(find.text("Too short"), findsOneWidget);
  });

  group('GtDobField', () {
    testWidgets('validates the date as it changes and after a reset', (
      tester,
    ) async {
      final dob = GtDobController();
      addTearDown(dob.dispose);
      final form = await mount(
        tester,
        GtDobField(controller: dob),
        mode: .onUserInteraction,
      );
      expect(hasError(tester), isFalse);

      dob.day = 5;
      await tester.pumpAndSettle();
      expect(hasError(tester), isTrue);

      dob
        ..month = 6
        ..year = 1990;
      await tester.pumpAndSettle();
      expect(hasError(tester), isFalse);

      form.currentState!.reset();
      await tester.pumpAndSettle();
      expect(dob.dob, isNull);
      expect(hasError(tester), isFalse);
    });
  });

  group('GtTransferField', () {
    GtTransferField transferField(
      GtInputController amount, {
      AutovalidateMode mode = .disabled,
    }) {
      return GtTransferField(
        amountController: amount,
        noteController: GtInputController(),
        firstParticipant: sender,
        secondParticipant: recipient,
        noteHint: "Note",
        autovalidateMode: mode,
      );
    }

    testWidgets('flags the amount as it is typed and clears it once valid', (
      tester,
    ) async {
      final amount = GtInputController();
      addTearDown(amount.dispose);
      await mount(tester, transferField(amount), mode: .onUserInteraction);
      final input = find.byType(TextField).first;

      await tester.enterText(input, "6000");
      await tester.pumpAndSettle();
      expect(hasError(tester), isTrue);

      await tester.enterText(input, "1000");
      await tester.pumpAndSettle();
      expect(hasError(tester), isFalse);
    });

    testWidgets('a field opt-in works without a form opt-in', (tester) async {
      final amount = GtInputController();
      addTearDown(amount.dispose);
      await mount(tester, transferField(amount, mode: .onUserInteraction));

      await tester.enterText(find.byType(TextField).first, "6000");
      await tester.pumpAndSettle();
      expect(hasError(tester), isTrue);
    });

    testWidgets('waits for validate() by default', (tester) async {
      final amount = GtInputController();
      addTearDown(amount.dispose);
      await mount(tester, transferField(amount));

      await tester.enterText(find.byType(TextField).first, "6000");
      await tester.pumpAndSettle();
      expect(hasError(tester), isFalse);
    });

    testWidgets('a reset does not flag the cleared amount', (tester) async {
      final amount = GtInputController();
      addTearDown(amount.dispose);
      final form = await mount(
        tester,
        transferField(amount, mode: .onUserInteraction),
      );

      await tester.enterText(find.byType(TextField).first, "6000");
      await tester.pumpAndSettle();
      form.currentState!.reset();
      await tester.pumpAndSettle();
      expect(amount.text, isEmpty);
      expect(hasError(tester), isFalse);
    });
  });

  group('GtFxTransferField', () {
    testWidgets('editing the target amount validates the source amount', (
      tester,
    ) async {
      final source = GtInputController(text: "6,000");
      final target = GtInputController();
      addTearDown(source.dispose);
      addTearDown(target.dispose);
      await mount(
        tester,
        GtFxTransferField(
          sourceAmountController: source,
          targetAmountController: target,
          noteController: GtInputController(),
          firstParticipant: sender,
          secondParticipant: recipient,
          noteHint: "Note",
        ),
        mode: .onUserInteraction,
      );
      expect(hasError(tester), isFalse);

      await tester.enterText(find.byType(TextField).at(1), "10");
      await tester.pumpAndSettle();
      expect(hasError(tester), isTrue);

      source.text = "1,000";
      await tester.pumpAndSettle();
      expect(hasError(tester), isFalse);
    });
  });

  group('GtDotFormField', () {
    testWidgets('validates keypad input under a field opt-in', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await mount(
        tester,
        GtDotFormField(
          controller: controller,
          length: 4,
          validator: minThree,
          autovalidateMode: .onUserInteraction,
        ),
      );

      controller.text = "1";
      await tester.pumpAndSettle();
      expect(find.text("Too short"), findsOneWidget);

      controller.text = "1234";
      await tester.pumpAndSettle();
      expect(find.text("Too short"), findsNothing);
    });
  });
}

/// Sets [text] on [controller] while it rebuilds, as a field syncing its
/// controller in `didUpdateWidget` does.
class _SetTextOnUpdate extends StatefulWidget {
  /// The text to set.
  final String text;

  /// The controller to set it on.
  final GtInputController controller;

  /// The widget below this one.
  final Widget child;

  /// Creates a [_SetTextOnUpdate].
  const _SetTextOnUpdate({
    required this.text,
    required this.controller,
    required this.child,
  });

  @override
  State<_SetTextOnUpdate> createState() => _SetTextOnUpdateState();
}

class _SetTextOnUpdateState extends State<_SetTextOnUpdate> {
  @override
  void didUpdateWidget(covariant _SetTextOnUpdate oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.controller.text = widget.text;
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
