import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gallery/widgets/gt_widget_doc_page.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

void main() {
  testWidgets('renders selectable highlighted Dart code', (tester) async {
    await tester.pumpWidget(
      GtThemeProvider(
        theme: kPersonalTheme,
        child: MaterialApp(
          theme: kPersonalTheme.materialLight,
          home: const GtWidgetDocPage(
            title: 'Example',
            code: "final amount = value < 3 && value != '0'; // sample",
            child: SizedBox.shrink(),
          ),
        ),
      ),
    );

    expect(find.byType(SelectionArea), findsOneWidget);
    expect(find.byType(GtRichText), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
