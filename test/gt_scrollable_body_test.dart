import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

const _viewportHeight = 480.0;
const _topKey = Key('top');
const _bottomKey = Key('bottom');

/// Hosts the body at a known height, so every assertion about filling the
/// viewport is made against a number the test set.
class _ScrollableBodyTestApp extends GtStatelessWidget {
  final Widget child;

  const _ScrollableBodyTestApp({required this.child});

  @override
  Widget build(BuildContext context) {
    return GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(height: _viewportHeight, width: 360, child: child),
          ),
        ),
      ),
    );
  }
}

/// A form-shaped body: a header, a [Spacer], and a pinned bottom action. Under
/// a raw scroll view the [Spacer] throws, which is the whole reason
/// `fillViewport` exists.
Widget _formBody({double headerHeight = 40}) {
  return Column(
    children: [
      SizedBox(key: _topKey, height: headerHeight),
      const Spacer(),
      const SizedBox(key: _bottomKey, height: 48),
    ],
  );
}

/// Finds [type] inside the body under test, so an unrelated widget of the same
/// type elsewhere in the tree cannot answer for it.
Finder _within(Type type) {
  return find.descendant(
    of: find.byType(GtScrollableBody),
    matching: find.byType(type),
  );
}

void main() {
  testWidgets('a short fill-viewport body stretches to exactly one viewport', (
    tester,
  ) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _ScrollableBodyTestApp(
        child: GtScrollableBody(
          controller: controller,
          fillViewport: true,
          child: _formBody(),
        ),
      ),
    );

    expect(tester.takeException(), isNull);

    final insets = tester
        .element(find.byType(GtScrollableBody))
        .insets
        .defaultAllInsets;
    final viewportTop = tester.getTopLeft(find.byType(GtScrollableBody)).dy;

    // The padding is inside the filled height, not around it: a body that fits
    // must not scroll by its own gutter.
    expect(controller.position.maxScrollExtent, 0);
    expect(
      tester.getBottomLeft(find.byKey(_bottomKey)).dy,
      moreOrLessEquals(viewportTop + _viewportHeight - insets.bottom),
    );
    expect(
      tester.getTopLeft(find.byKey(_topKey)).dy,
      moreOrLessEquals(viewportTop + insets.top),
    );
  });

  testWidgets('a tall fill-viewport body still scrolls', (tester) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _ScrollableBodyTestApp(
        child: GtScrollableBody(
          controller: controller,
          fillViewport: true,
          child: _formBody(headerHeight: _viewportHeight * 2),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(controller.position.maxScrollExtent, greaterThan(0));
  });

  testWidgets('without fillViewport a short body keeps its own height', (
    tester,
  ) async {
    await tester.pumpWidget(
      const _ScrollableBodyTestApp(
        child: GtScrollableBody(
          padding: EdgeInsets.zero,
          child: SizedBox(key: _bottomKey, height: 80),
        ),
      ),
    );

    expect(tester.getSize(find.byKey(_bottomKey)).height, 80);
    // Scoped to the body: neither composition is paid for off the flag, and a
    // LayoutBuilder someone else puts in the tree is not this test's business.
    expect(_within(IntrinsicHeight), findsNothing);
    expect(_within(LayoutBuilder), findsNothing);
  });

  testWidgets('padding defaults to the design system gutter', (tester) async {
    await tester.pumpWidget(
      const _ScrollableBodyTestApp(
        child: GtScrollableBody(child: SizedBox(key: _bottomKey, height: 80)),
      ),
    );

    final insets = tester
        .element(find.byType(GtScrollableBody))
        .insets
        .defaultAllInsets;
    final scrollView = tester.widget<SingleChildScrollView>(
      find.byType(SingleChildScrollView),
    );

    expect(scrollView.padding, insets);
    expect(insets.horizontal, greaterThan(0));
  });

  testWidgets('padding overrides the default on both branches', (tester) async {
    const override = EdgeInsets.all(24);

    for (final fillViewport in [false, true]) {
      await tester.pumpWidget(
        _ScrollableBodyTestApp(
          child: GtScrollableBody(
            padding: override,
            fillViewport: fillViewport,
            child: const SizedBox(key: _bottomKey, height: 80),
          ),
        ),
      );

      expect(
        tester.getTopLeft(find.byKey(_bottomKey)).dx,
        moreOrLessEquals(
          tester.getTopLeft(find.byType(GtScrollableBody)).dx + override.left,
        ),
        reason: 'fillViewport: $fillViewport',
      );
    }
  });

  testWidgets('physics reaches the scroll view', (tester) async {
    const physics = AlwaysScrollableScrollPhysics();

    await tester.pumpWidget(
      const _ScrollableBodyTestApp(
        child: GtScrollableBody(physics: physics, child: SizedBox(height: 80)),
      ),
    );

    expect(
      tester
          .widget<SingleChildScrollView>(find.byType(SingleChildScrollView))
          .physics,
      physics,
    );
  });

  testWidgets('a short body under always-scrollable physics can be pulled', (
    tester,
  ) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _ScrollableBodyTestApp(
        child: GtScrollableBody(
          controller: controller,
          physics: const AlwaysScrollableScrollPhysics(),
          fillViewport: true,
          child: _formBody(),
        ),
      ),
    );

    // maxScrollExtent is still zero — the body fits — but the position accepts
    // an overscroll drag, which is what a RefreshIndicator listens for.
    expect(controller.position.maxScrollExtent, 0);
    expect(
      controller.position.physics.shouldAcceptUserOffset(controller.position),
      isTrue,
    );
  });
}
