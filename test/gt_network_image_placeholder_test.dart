import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

const _url = GtNetworkImages.sampleAvatar1;

Widget _app(Widget child) => GtThemeProvider(
  theme: kPersonalTheme,
  child: MaterialApp(
    home: Scaffold(body: Center(child: child)),
  ),
);

bool _hasSpinner(WidgetTester tester) =>
    find.byType(GtSpinner).evaluate().isNotEmpty;

void main() {
  group('GtNetworkImage', () {
    testWidgets('spins by default, so a lone image still signals loading', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(const GtNetworkImage(_url, width: 120, height: 120)),
      );
      await tester.pump();

      expect(_hasSpinner(tester), isTrue);
    });

    testWidgets('falls through when the caller has something behind it', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          const GtNetworkImage(
            _url,
            width: 120,
            height: 120,
            showLoadingIndicator: false,
          ),
        ),
      );
      await tester.pump();

      expect(_hasSpinner(tester), isFalse);
    });

    testWidgets('placeholder artwork outranks both', (tester) async {
      await tester.pumpWidget(
        _app(
          const GtNetworkImage(
            _url,
            width: 120,
            height: 120,
            placeHolderPath: GtAssetImages.avatar,
            showLoadingIndicator: false,
          ),
        ),
      );
      await tester.pump();

      expect(_hasSpinner(tester), isFalse);
      expect(find.byType(GtAssetImage), findsOneWidget);
    });
  });

  group('GtImage', () {
    testWidgets('forwards the opt-out to the network image', (tester) async {
      await tester.pumpWidget(
        _app(
          const GtImage(
            image: AppImageData(_url),
            width: 120,
            height: 120,
            showLoadingIndicator: false,
          ),
        ),
      );
      await tester.pump();

      expect(_hasSpinner(tester), isFalse);
    });
  });

  group('avatars while their image loads', () {
    testWidgets('GtAvatar leaves the initials visible', (tester) async {
      await tester.pumpWidget(
        _app(
          const GtAvatar(avatar: AppImageData(_url), initials: 'JD', size: 36),
        ),
      );
      await tester.pump();

      expect(find.text('JD'), findsOneWidget);
      expect(_hasSpinner(tester), isFalse);
    });

    testWidgets('GtSquareAvatar leaves the initials visible', (tester) async {
      await tester.pumpWidget(
        _app(
          const GtSquareAvatar(
            avatar: AppImageData(_url),
            initials: 'JD',
            size: 72,
          ),
        ),
      );
      await tester.pump();

      expect(find.text('JD'), findsOneWidget);
      expect(_hasSpinner(tester), isFalse);
    });

    testWidgets('either avatar can opt back into the spinner', (tester) async {
      await tester.pumpWidget(
        _app(
          const GtAvatar(
            avatar: AppImageData(_url),
            initials: 'JD',
            size: 96,
            showLoadingIndicator: true,
          ),
        ),
      );
      await tester.pump();
      expect(_hasSpinner(tester), isTrue);

      await tester.pumpWidget(
        _app(
          const GtSquareAvatar(
            avatar: AppImageData(_url),
            initials: 'JD',
            size: 96,
            showLoadingIndicator: true,
          ),
        ),
      );
      await tester.pump();
      expect(_hasSpinner(tester), isTrue);
    });

    testWidgets('an empty user avatar keeps its glyph while loading', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          const GtSquareAvatar(
            avatar: AppImageData(_url),
            isUserAvatar: true,
            size: 72,
          ),
        ),
      );
      await tester.pump();

      expect(_hasSpinner(tester), isFalse);
    });
  });
}
