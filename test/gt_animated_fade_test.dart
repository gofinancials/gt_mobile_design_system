import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class _AnimatedFadeTestApp extends GtStatelessWidget {
  final bool disableAnimations;
  final bool showFirst;

  const _AnimatedFadeTestApp({
    this.disableAnimations = false,
    this.showFirst = true,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(disableAnimations: disableAnimations),
        child: Scaffold(
          body: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: 320,
              child: GtAnimatedFade(
                showFirst: showFirst,
                child1: Container(key: const Key('first'), height: 80),
                child2: Container(key: const Key('second'), height: 40),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  testWidgets('both fade children retain the full available width', (
    tester,
  ) async {
    await tester.pumpWidget(const _AnimatedFadeTestApp());

    expect(tester.getSize(find.byKey(const Key('first'))).width, 320);
    expect(tester.getSize(find.byKey(const Key('second'))).width, 320);
  });

  testWidgets('shows only the selected child when animations are disabled', (
    tester,
  ) async {
    await tester.pumpWidget(
      const _AnimatedFadeTestApp(disableAnimations: true, showFirst: false),
    );

    expect(find.byType(AnimatedCrossFade), findsNothing);
    expect(find.byKey(const Key('first')), findsNothing);
    expect(find.byKey(const Key('second')), findsOneWidget);
  });

  testWidgets('can enable reduced motion while a cross-fade is mounted', (
    tester,
  ) async {
    await tester.pumpWidget(const _AnimatedFadeTestApp());
    await tester.pumpWidget(
      const _AnimatedFadeTestApp(disableAnimations: true, showFirst: false),
    );
    await tester.pump();

    expect(find.byType(AnimatedCrossFade), findsNothing);
    expect(find.byKey(const Key('second')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
