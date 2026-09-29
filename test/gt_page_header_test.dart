import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

void main() {
  Widget buildTestWidget(Widget child) {
    return GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(home: Scaffold(body: child)),
    );
  }

  GtText textOf(WidgetTester tester, String data) =>
      tester.widget<GtText>(find.widgetWithText(GtText, data));

  testWidgets('keeps the default styles when no override is passed', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestWidget(const GtPageHeader(title: 'Title', subtitle: 'Sub')),
    );
    final context = tester.element(find.byType(GtPageHeader));

    expect(textOf(tester, 'TITLE').style, context.textStyles.h5());
    expect(textOf(tester, 'Sub').style, context.textStyles.bodyS());
    expect(
      tester.widget<Column>(find.byType(Column).first).crossAxisAlignment,
      CrossAxisAlignment.stretch,
    );
  });

  testWidgets('replaces the defaults wholesale with the overrides', (
    tester,
  ) async {
    const titleStyle = TextStyle(fontSize: 32);
    const subtitleStyle = TextStyle(fontSize: 14, color: Color(0xFF5C5C5C));

    await tester.pumpWidget(
      buildTestWidget(
        const GtPageHeader(
          title: 'Title',
          subtitle: 'Sub',
          titleColor: Colors.red,
          subTitleColor: Colors.blue,
          textAlign: TextAlign.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          titleStyle: titleStyle,
          subtitleStyle: subtitleStyle,
        ),
      ),
    );

    expect(textOf(tester, 'TITLE').style, titleStyle);
    expect(textOf(tester, 'Sub').style, subtitleStyle);
    expect(textOf(tester, 'Sub').textAlign, TextAlign.center);
    expect(
      tester.widget<Column>(find.byType(Column).first).crossAxisAlignment,
      CrossAxisAlignment.center,
    );
  });

  testWidgets('applies the subtitle override to the rich subtitle', (
    tester,
  ) async {
    const subtitleStyle = TextStyle(fontSize: 14, color: Color(0xFF5C5C5C));

    await tester.pumpWidget(
      buildTestWidget(
        const GtPageHeader.rich(
          title: 'Title',
          subtitle: 'Sub',
          subtitleStyle: subtitleStyle,
        ),
      ),
    );

    expect(
      tester.widget<GtRichText>(find.byType(GtRichText)).style,
      subtitleStyle,
    );
  });
}
