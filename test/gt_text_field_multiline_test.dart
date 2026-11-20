import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

const _fieldKey = Key('note');

class _FieldTestApp extends GtStatelessWidget {
  final Widget child;

  const _FieldTestApp({required this.child});

  @override
  Widget build(BuildContext context) {
    return GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(
        home: Scaffold(
          body: Align(alignment: .topCenter, child: child),
        ),
      ),
    );
  }
}

/// Pumps an empty multiline field and returns its height.
Future<double> _emptyHeight(WidgetTester tester, {int? minLines}) async {
  await tester.pumpWidget(
    _FieldTestApp(
      child: minLines == null
          ? const GtTextField.multiline(key: _fieldKey, hintText: 'Note')
          : GtTextField.multiline(
              key: _fieldKey,
              hintText: 'Note',
              minLines: minLines,
            ),
    ),
  );
  return tester.getSize(find.byKey(_fieldKey)).height;
}

void main() {
  testWidgets('multiline opens one line tall by default', (tester) async {
    await _emptyHeight(tester);

    expect(tester.widget<TextField>(find.byType(TextField)).minLines, 1);
  });

  testWidgets('minLines opens an empty multiline field taller', (tester) async {
    final oneLine = await _emptyHeight(tester, minLines: 1);
    final eightLines = await _emptyHeight(tester, minLines: 8);

    expect(tester.widget<TextField>(find.byType(TextField)).minLines, 8);
    expect(eightLines, greaterThan(oneLine));
  });

  test('minLines asserts against a maxLines below it', () {
    expect(
      () => GtTextField.multiline(minLines: 4, maxLines: 2),
      throwsAssertionError,
    );
    expect(() => GtTextField.multiline(minLines: 0), throwsAssertionError);
  });
}
