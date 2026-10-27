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
    'Momo': ['MomoTrustDisplay.ttf'],
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

  // Personal's page frames: a 44 status bar, then the 32 header row at y 68.
  Future<void> pumpRoutedBar(
    WidgetTester tester,
    PreferredSizeWidget bar,
  ) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    tester.view.padding = const FakeViewPadding(top: 44);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      GtThemeProvider(
        theme: kPersonalTheme,
        child: MaterialApp(
          home: Scaffold(
            appBar: bar,
            body: const SizedBox.expand(key: Key('body')),
          ),
        ),
      ),
    );
  }

  group('primary app bars', () {
    final bars = <String, PreferredSizeWidget Function()>{
      'GtAppBar': () => const GtAppBar(title: 'TRANSFER'),
      'GtTitleAppBar': () => const GtTitleAppBar(title: 'TRANSFER'),
      'GtActionAppBar': () =>
          GtActionAppBar(leading: GtBackButton(size: .large)),
    };

    for (final MapEntry(key: name, value: bar) in bars.entries) {
      testWidgets('$name sets its row 24 below the status bar', (tester) async {
        await pumpRoutedBar(tester, bar());

        final row = tester.getRect(
          find
              .descendant(
                of: find.byType(Container),
                matching: find.byWidgetPredicate((w) => w is Table || w is Row),
              )
              .first,
        );
        expect(row.top, 68);
        expect(tester.getTopLeft(find.byKey(const Key('body'))).dy, row.bottom);
      });
    }

    testWidgets('a two-line title stays inside the bar, above the body', (
      tester,
    ) async {
      await pumpRoutedBar(
        tester,
        const GtAppBar(title: 'INTERNATIONAL TRANSFER', titleSize: .large),
      );

      final title = tester.getRect(find.text('INTERNATIONAL TRANSFER'));
      expect(title.height, 64);
      expect(title.top, 68);
      expect(title.bottom, tester.getRect(find.byType(GtAppBar)).bottom);
      expect(tester.getTopLeft(find.byKey(const Key('body'))).dy, title.bottom);
    });

    testWidgets('a non-primary bar ignores the status bar and adds no gap', (
      tester,
    ) async {
      await pumpRoutedBar(
        tester,
        const GtAppBar(title: 'TRANSFER', primary: false),
      );

      expect(tester.getRect(find.byType(Table)).top, 0);
    });

    testWidgets('padding replaces the gap but still clears the status bar', (
      tester,
    ) async {
      await pumpRoutedBar(
        tester,
        const GtAppBar(title: 'TRANSFER', padding: EdgeInsets.all(8)),
      );

      final row = tester.getRect(find.byType(Table));
      expect(row.top, 44 + 8);
      expect(row.left, 8);
    });
  });

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
