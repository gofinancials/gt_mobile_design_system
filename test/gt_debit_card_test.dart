import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class _DebitCardTestApp extends GtStatelessWidget {
  final Widget child;

  const _DebitCardTestApp({required this.child});

  @override
  Widget build(BuildContext context) {
    return GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(
        home: Scaffold(body: Center(child: child)),
      ),
    );
  }
}

/// The share of each issuer drawing's height its circles fill.
const _circleShare = {
  GtDebitCardIssuer.mastercard: 1.0,
  GtDebitCardIssuer.premiumMastercard: 29.8 / 37.1,
};

void main() {
  for (final dimension in GtDebitCardDimension.values) {
    testWidgets(
      'the premium Mastercard circles match the plain mark (${dimension.name})',
      (tester) async {
        final circles = <GtDebitCardIssuer, double>{};
        for (final issuer in _circleShare.keys) {
          await tester.pumpWidget(
            _DebitCardTestApp(
              child: GtDebitCard(
                label: 'USD',
                issuer: issuer,
                dimension: dimension,
              ),
            ),
          );
          final logo = find.byWidgetPredicate(
            (widget) => widget is GtImage && widget.image == issuer.logo,
          );
          final height = tester.getSize(logo).height;
          circles[issuer] = height * _circleShare[issuer]!;
        }

        expect(
          circles[GtDebitCardIssuer.premiumMastercard],
          moreOrLessEquals(circles[GtDebitCardIssuer.mastercard]!, epsilon: .1),
        );
      },
    );
  }

  testWidgets('a custom card logo keeps the slot height', (tester) async {
    final logo = AppImageData(GtVectors.visaCard);
    await tester.pumpWidget(
      _DebitCardTestApp(
        child: GtDebitCard(
          label: 'USD',
          issuer: .premiumMastercard,
          cardLogo: logo,
        ),
      ),
    );

    final plain = find.byWidgetPredicate(
      (widget) => widget is GtImage && widget.image == logo,
    );
    expect(
      tester.getSize(plain).height,
      moreOrLessEquals(
        tester.element(plain).dp(GtDebitCardDimension.regular.issuerLogoHeight),
        epsilon: .1,
      ),
    );
  });
}
