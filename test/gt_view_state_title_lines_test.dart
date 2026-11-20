import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

import 'helpers/test_app_config.dart';

void main() {
  setUpAll(registerTestAppConfig);

  const title = 'Account confirmation letter request declined';

  Future<void> pump(WidgetTester tester, Widget child) async {
    await tester.pumpWidget(
      GtThemeProvider(
        theme: kPersonalTheme,
        child: MaterialApp(home: Scaffold(body: child)),
      ),
    );
  }

  /// The line cap on the rendered title.
  int? titleLines(WidgetTester tester) {
    return tester.widget<Text>(find.text(title.toUpperCase())).maxLines;
  }

  testWidgets('the title keeps its two-line cap by default', (tester) async {
    await pump(tester, const GtViewStateWidget(title: title));
    expect(titleLines(tester), 2);

    await pump(tester, const GtStatusState.error(title: title));
    expect(titleLines(tester), 2);
  });

  testWidgets('titleMaxLines reaches the title from every constructor', (
    tester,
  ) async {
    final states = <String, Widget>{
      'view state': const GtViewStateWidget(title: title, titleMaxLines: 3),
      'default': const GtStatusState(
        variant: .success,
        title: title,
        titleMaxLines: 3,
      ),
      'success': const GtStatusState.success(title: title, titleMaxLines: 3),
      'error': const GtStatusState.error(title: title, titleMaxLines: 3),
      'custom': const GtStatusState.custom(
        title: title,
        graphic: SizedBox(height: 48),
        titleMaxLines: 3,
      ),
    };

    for (final MapEntry(key: name, value: state) in states.entries) {
      await pump(tester, state);
      expect(titleLines(tester), 3, reason: name);
    }
  });

  testWidgets('a null titleMaxLines never cuts the title', (tester) async {
    await pump(
      tester,
      const GtStatusState.error(title: title, titleMaxLines: null),
    );
    expect(titleLines(tester), isNull);
  });
}
