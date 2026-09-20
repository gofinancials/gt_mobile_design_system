import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class _CardListTestApp extends GtStatelessWidget {
  final Widget child;

  const _CardListTestApp({required this.child});

  @override
  Widget build(BuildContext context) {
    return GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(home: Scaffold(body: child)),
    );
  }
}

/// A row that remembers whether its element was retained across a rebuild.
class _StatefulRow extends StatefulWidget {
  final String label;

  const _StatefulRow(this.label);

  @override
  State<_StatefulRow> createState() => _StatefulRowState();
}

class _StatefulRowState extends State<_StatefulRow> {
  @override
  Widget build(BuildContext context) => GtText(widget.label);
}

GtCardListView<String> _listOf(List<String> items, {Color? backgroundColor}) {
  return GtCardListView<String>(
    items: items,
    backgroundColor: backgroundColor,
    itemKey: (item) => ValueKey(item),
    itemBuilder: (context, item, index) => _StatefulRow(item),
  );
}

List<GtCardListTileType> _tileTypes(WidgetTester tester) {
  return tester
      .widgetList<GtCardListTile>(find.byType(GtCardListTile))
      .map((tile) => tile.type)
      .toList();
}

void main() {
  testWidgets('GtCardListView groups its rows into one card surface', (
    tester,
  ) async {
    await tester.pumpWidget(
      _CardListTestApp(child: _listOf(const ['a', 'b', 'c'])),
    );

    expect(_tileTypes(tester), [
      GtCardListTileType.starter,
      GtCardListTileType.divider,
      GtCardListTileType.medial,
      GtCardListTileType.divider,
      GtCardListTileType.terminus,
    ]);
  });

  testWidgets('GtCardListView rounds every corner of a sole row', (
    tester,
  ) async {
    await tester.pumpWidget(_CardListTestApp(child: _listOf(const ['a'])));

    expect(_tileTypes(tester), [GtCardListTileType.sole]);
  });

  testWidgets('GtCardListView draws its separator as a divider tile', (
    tester,
  ) async {
    await tester.pumpWidget(_CardListTestApp(child: _listOf(const ['a', 'b'])));

    final separator = tester.widget<GtCardListTile>(
      find.byWidgetPredicate(
        (widget) =>
            widget is GtCardListTile &&
            widget.type == GtCardListTileType.divider,
      ),
    );

    expect(separator.child, isA<GtGap>());
    expect(
      find.descendant(
        of: find.byWidget(separator),
        matching: find.byType(GtCard),
      ),
      findsOneWidget,
    );
  });

  testWidgets('GtCardListView tints its separators alongside its rows', (
    tester,
  ) async {
    await tester.pumpWidget(
      _CardListTestApp(
        child: _listOf(const ['a', 'b'], backgroundColor: Colors.red),
      ),
    );

    final tiles = tester.widgetList<GtCardListTile>(
      find.byType(GtCardListTile),
    );

    expect(
      tiles.map((tile) => tile.type),
      contains(GtCardListTileType.divider),
    );
    expect(
      tiles.every((tile) => tile.backgroundColor == Colors.red),
      isTrue,
      reason: 'a separator left on the variant default shows as a stripe',
    );
  });

  testWidgets('GtCardListView retains a row element when its index moves', (
    tester,
  ) async {
    await tester.pumpWidget(
      _CardListTestApp(child: _listOf(const ['a', 'b', 'c'])),
    );

    State<_StatefulRow> stateOf(String label) {
      return tester.state<_StatefulRowState>(
        find.byWidgetPredicate(
          (widget) => widget is _StatefulRow && widget.label == label,
        ),
      );
    }

    final b = stateOf('b');
    final c = stateOf('c');

    await tester.pumpWidget(_CardListTestApp(child: _listOf(const ['b', 'c'])));

    expect(stateOf('b'), same(b));
    expect(stateOf('c'), same(c));
  });

  testWidgets('GtCardListSliver builds only the rows the viewport reaches', (
    tester,
  ) async {
    final items = List.generate(200, (index) => 'item-$index');

    await tester.pumpWidget(
      _CardListTestApp(
        child: CustomScrollView(
          slivers: [
            GtCardListSliver<String>(
              items: items,
              itemKey: (item) => ValueKey(item),
              itemBuilder: (context, item, index) =>
                  GtSizedBox(height: 64, child: GtText(item)),
            ),
          ],
        ),
      ),
    );

    expect(find.byType(GtCardListTile), findsWidgets);
    expect(
      tester.widgetList<GtCardListTile>(find.byType(GtCardListTile)).length,
      lessThan(60),
    );
  });

  testWidgets('GtCardListSliver groups its rows into one card surface', (
    tester,
  ) async {
    await tester.pumpWidget(
      _CardListTestApp(
        child: CustomScrollView(
          slivers: [
            GtCardListSliver<String>(
              items: const ['a', 'b'],
              itemKey: (item) => ValueKey(item),
              itemBuilder: (context, item, index) => GtText(item),
            ),
          ],
        ),
      ),
    );

    expect(_tileTypes(tester), [
      GtCardListTileType.starter,
      GtCardListTileType.divider,
      GtCardListTileType.terminus,
    ]);
  });
}
