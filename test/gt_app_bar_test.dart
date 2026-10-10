import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

import 'helpers/test_app_config.dart';

/// Registers the package's typefaces, so titles are measured in the glyphs
/// they ship with rather than the test font's uniform squares.
Future<void> loadPackageFonts() async {
  const families = {
    'Youth': ['Youth-Bold.otf', 'Youth-Medium.otf'],
    'Runde': [
      'OpenRunde-Regular.otf',
      'OpenRunde-Medium.otf',
      'OpenRunde-Semibold.otf',
      'OpenRunde-Bold.otf',
    ],
  };
  for (final MapEntry(key: family, value: files) in families.entries) {
    final loader = FontLoader('packages/gt_mobile_ui/$family');
    for (final file in files) {
      final bytes = File('assets/fonts/$file').readAsBytesSync();
      loader.addFont(Future.value(ByteData.sublistView(bytes)));
    }
    await loader.load();
  }
}

void main() {
  setUpAll(() async {
    registerTestAppConfig();
    await loadPackageFonts();
  });

  Future<void> pumpAppBar(WidgetTester tester, String title) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      GtThemeProvider(
        theme: kPersonalTheme,
        child: MaterialApp(
          home: Scaffold(
            appBar: GtAppBar(
              title: title,
              leading: const SizedBox(),
              trailing: const SizedBox(),
            ),
          ),
        ),
      ),
    );
  }

  group('GtAppBar', () {
    // Figma's header-nav gives the title everything between two 32-dp
    // actions on a 375-pt screen: 375 - 2 * 16 - 2 * 32.
    testWidgets('gives the title the width between the two actions', (
      tester,
    ) async {
      await pumpAppBar(tester, 'TRANSFER');

      final title = tester.getRect(find.text('TRANSFER'));
      expect(title.width, 279);
      expect(title.center.dx, 375 / 2);
    });

    for (final title in [
      'INTERNATIONAL TRANSFER',
      'WHO ARE YOU SENDING TO?',
      'ENTER VERIFICATION CODE',
      'QR FOR QUICK PAYMENT',
    ]) {
      testWidgets('sets "$title" on one line at 375 pt', (tester) async {
        await pumpAppBar(tester, title);

        final text = tester.widget<Text>(find.text(title));
        final lineHeight = text.style!.fontSize! * text.style!.height!;
        expect(tester.getSize(find.text(title)).height, lineHeight);
      });
    }
  });
}
