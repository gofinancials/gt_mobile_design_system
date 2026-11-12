import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

import 'helpers/test_app_config.dart';

/// Loads Open Runde, so captions measure as they do in the app rather than in
/// the test font, whose every glyph is a full em square.
Future<void> _loadRunde() async {
  final loader = FontLoader('packages/gt_mobile_ui/Runde');
  for (final file in [
    'OpenRunde-Regular.otf',
    'OpenRunde-Medium.otf',
    'OpenRunde-Semibold.otf',
    'OpenRunde-Bold.otf',
  ]) {
    final bytes = File('assets/fonts/$file').readAsBytesSync();
    loader.addFont(Future.value(ByteData.sublistView(bytes)));
  }
  await loader.load();
}

void main() {
  setUpAll(() async {
    registerTestAppConfig();
    await _loadRunde();
  });

  const labels = ['Details', 'Send', 'Move', 'Recharge'];

  GtActionButton button(String label) {
    return GtActionButton(
      onPressed: () {},
      backgroundColor: Colors.blue,
      icon: Icons.send,
      label: label,
    );
  }

  /// Mounts a bar of [labels] in a box [width] wide and hands back the centre
  /// of each button, left to right.
  Future<List<double>> centres(
    WidgetTester tester,
    List<String> labels, {
    double width = 375,
    EdgeInsetsGeometry padding = .zero,
  }) async {
    tester.view.physicalSize = Size(width, 400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      GtThemeProvider(
        theme: kPersonalTheme,
        child: MaterialApp(
          home: Scaffold(
            body: Align(
              alignment: .topLeft,
              child: SizedBox(
                width: width,
                child: GtActionButtonBar(
                  padding: padding,
                  buttons: [for (final label in labels) button(label)],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SingleChildScrollView), findsNothing);
    return [
      for (final element in find.byType(GtActionButton).evaluate())
        tester.getCenter(find.byWidget(element.widget)).dx,
    ];
  }

  for (final count in [1, 2, 3, 4]) {
    testWidgets('centres each of $count buttons in an equal share of the row', (
      tester,
    ) async {
      final result = await centres(tester, labels.take(count).toList());
      final share = 375 / count;

      expect(result, [
        for (var index = 0; index < count; index++)
          moreOrLessEquals(share * (index + .5), epsilon: .01),
      ]);
    });
  }

  testWidgets('four buttons sit as Home\'s quick actions, four 65-wide items '
      'edge to edge, with no padding', (tester) async {
    final result = await centres(tester, labels, width: 260);

    expect(result, [
      for (var index = 0; index < 4; index++)
        moreOrLessEquals(32.5 + 65 * index, epsilon: .01),
    ]);
  });

  testWidgets('shares what padding leaves', (tester) async {
    final result = await centres(
      tester,
      labels.take(2).toList(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
    );

    expect(result, [
      moreOrLessEquals(16 + 343 / 4, epsilon: .01),
      moreOrLessEquals(16 + 343 * 3 / 4, epsilon: .01),
    ]);
  });

  testWidgets('shares at most 450 wide, centred in a wider box', (
    tester,
  ) async {
    final result = await centres(tester, labels, width: 800);
    const start = (800 - 450) / 2;

    expect(result, [
      for (var index = 0; index < 4; index++)
        moreOrLessEquals(start + 112.5 * (index + .5), epsilon: .01),
    ]);
  });

  testWidgets('keeps a gap between neighbouring captions that fill their '
      'shares', (tester) async {
    await centres(tester, [
      'Pay your bills',
      'Send to banks',
      'Buy some airtime',
      'Move your money',
    ], width: 300);

    final captions = [
      for (final element in find.byType(GtText).evaluate())
        tester.getRect(find.byWidget(element.widget)),
    ];
    for (var index = 1; index < captions.length; index++) {
      expect(captions[index].left, greaterThan(captions[index - 1].right));
    }
  });
}
