import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

Widget _app(Widget child) => GtThemeProvider(
  theme: kPersonalTheme,
  child: MaterialApp(
    home: Scaffold(body: Center(child: child)),
  ),
);

Object? _drawnImage(WidgetTester tester) => tester
    .widgetList<GtImage>(find.byType(GtImage))
    .firstOrNull
    ?.image
    ?.imageData;

bool _hasUserGlyph(WidgetTester tester) => tester
    .widgetList<GtIcon>(find.byType(GtIcon))
    .any((icon) => icon.icon == GtIcons.userSolid);

void main() {
  group('GtSquareAvatar', () {
    testWidgets('an empty user avatar draws the glyph, not the 3D artwork', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(const GtSquareAvatar(isUserAvatar: true, size: 64)),
      );
      await tester.pump();

      expect(_hasUserGlyph(tester), isTrue);
      expect(find.byType(GtImage), findsNothing);
    });

    testWidgets('a non-user avatar still defaults to the 3D artwork', (
      tester,
    ) async {
      await tester.pumpWidget(_app(const GtSquareAvatar(size: 64)));
      await tester.pump();

      expect(_drawnImage(tester), GtNetworkImages.avatar3d2);
    });

    testWidgets('initials outrank the glyph on a user avatar', (tester) async {
      await tester.pumpWidget(
        _app(
          const GtSquareAvatar(isUserAvatar: true, initials: 'JD', size: 64),
        ),
      );
      await tester.pump();

      expect(find.text('JD'), findsOneWidget);
      expect(_hasUserGlyph(tester), isFalse);
      expect(find.byType(GtImage), findsNothing);
    });

    testWidgets('an invalid avatar does not suppress the initials', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          const GtSquareAvatar(
            avatar: AppImageData(''),
            initials: 'JD',
            size: 64,
          ),
        ),
      );
      await tester.pump();

      expect(find.text('JD'), findsOneWidget);
      expect(find.byType(GtImage), findsNothing);
    });

    testWidgets('a valid avatar still wins', (tester) async {
      await tester.pumpWidget(
        _app(
          const GtSquareAvatar(
            avatar: AppImageData('https://example.com/a.png'),
            initials: 'JD',
            size: 64,
          ),
        ),
      );
      await tester.pump();

      expect(_drawnImage(tester), 'https://example.com/a.png');
    });
  });

  group('GtAvatar', () {
    testWidgets('an empty user avatar draws the bundled asset', (tester) async {
      await tester.pumpWidget(
        _app(const GtAvatar(isUserAvatar: true, size: 64)),
      );
      await tester.pump();

      expect(_drawnImage(tester), GtAssetImages.avatar);
    });

    testWidgets('initials outrank the bundled asset', (tester) async {
      await tester.pumpWidget(
        _app(const GtAvatar(isUserAvatar: true, initials: 'JD', size: 64)),
      );
      await tester.pump();

      expect(find.text('JD'), findsOneWidget);
      expect(find.byType(GtImage), findsNothing);
    });

    testWidgets('an invalid avatar is not painted over the initials', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          const GtAvatar(avatar: AppImageData(''), initials: 'JD', size: 64),
        ),
      );
      await tester.pump();

      expect(find.text('JD'), findsOneWidget);
      expect(find.byType(GtImage), findsNothing);
    });
  });

  group('initials styling', () {
    TextStyle? styleOf(WidgetTester tester) => tester
        .widgetList<GtText>(find.byType(GtText))
        .firstWhere((text) => text.data == 'JD')
        .style;

    testWidgets('initialsColor tints the default style', (tester) async {
      await tester.pumpWidget(
        _app(const GtAvatar(initials: 'JD', initialsColor: Color(0xFFFF0000))),
      );
      expect(styleOf(tester)?.color, const Color(0xFFFF0000));
    });

    testWidgets('initialsStyle overrides initialsColor on both avatars', (
      tester,
    ) async {
      const override = TextStyle(color: Color(0xFF00FF00), fontSize: 30);

      await tester.pumpWidget(
        _app(
          const GtAvatar(
            initials: 'JD',
            initialsColor: Color(0xFFFF0000),
            initialsStyle: override,
          ),
        ),
      );
      expect(styleOf(tester)?.color, const Color(0xFF00FF00));

      await tester.pumpWidget(
        _app(
          const GtSquareAvatar(
            initials: 'JD',
            initialsColor: Color(0xFFFF0000),
            initialsStyle: override,
          ),
        ),
      );
      expect(styleOf(tester)?.color, const Color(0xFF00FF00));
    });
  });

  group('AppImageExtension.hasValidData', () {
    test('a missing file reads as invalid rather than throwing', () {
      final missing = AppImageData(File('/definitely/not/here.png'));
      expect(missing.hasValidData, isFalse);
    });

    test('an empty string is invalid and a populated one is valid', () {
      expect(const AppImageData('').hasValidData, isFalse);
      expect(
        const AppImageData('https://example.com/a.png').hasValidData,
        isTrue,
      );
    });
  });
}
