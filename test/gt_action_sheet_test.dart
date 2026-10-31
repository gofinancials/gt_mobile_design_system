import 'package:flutter/foundation.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

import 'helpers/test_app_config.dart';

/// A screen with the action sheet mixin, exposing its context to the test.
class _Host extends StatefulWidget {
  final void Function(_HostState host) onReady;

  const _Host({required this.onReady});

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> with GtActionSheetMixin {
  @override
  Widget build(BuildContext context) {
    widget.onReady(this);
    return const SizedBox.expand();
  }
}

void main() {
  setUpAll(registerTestAppConfig);

  const allPlatforms = TargetPlatformVariant({
    TargetPlatform.android,
    TargetPlatform.iOS,
    TargetPlatform.macOS,
  });

  bool isNative() {
    final platform = debugDefaultTargetPlatformOverride;
    return platform == TargetPlatform.iOS || platform == TargetPlatform.macOS;
  }

  /// Mounts a host on a phone-sized view, inside a [GtThemedScope] for
  /// [kFlexTheme] while the app itself is on [kPersonalTheme].
  Future<_HostState> pumpHost(WidgetTester tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    late _HostState host;
    await tester.pumpWidget(
      GtThemeProvider(
        theme: kPersonalTheme,
        child: MaterialApp(
          theme: kPersonalTheme.materialLight,
          home: GtThemedScope(
            theme: kFlexTheme,
            child: Scaffold(body: _Host(onReady: (value) => host = value)),
          ),
        ),
      ),
    );
    return host;
  }

  /// Opens the sheet and waits for it to settle, handing back its result.
  Future<Future<GtActionSheetAction?>> open(
    WidgetTester tester,
    _HostState host, {
    required List<GtActionSheetAction> actions,
    String? title,
    String? message,
  }) async {
    final result = host.showActionSheet(
      host.context,
      title: title,
      message: message,
      actions: actions,
      cancelLabel: 'Cancel',
    );
    await tester.pumpAndSettle();
    return result;
  }

  testWidgets('draws the native sheet on iOS and macOS only', (tester) async {
    final host = await pumpHost(tester);
    await open(
      tester,
      host,
      actions: [GtActionSheetAction(label: 'Export as PDF', onPressed: () {})],
    );

    expect(find.byType(GtActionSheet), findsOneWidget);
    expect(
      find.byType(CupertinoActionSheet),
      isNative() ? findsOneWidget : findsNothing,
    );
  }, variant: allPlatforms);

  testWidgets('shows the title, message, choices and cancel', (tester) async {
    final host = await pumpHost(tester);
    await open(
      tester,
      host,
      title: 'Export',
      message: 'How would you like to export your statement?',
      actions: [
        GtActionSheetAction(label: 'Export as PDF', onPressed: () {}),
        GtActionSheetAction(label: 'Export as Excel (CSV)', onPressed: () {}),
      ],
    );

    expect(find.text('Export'), findsOneWidget);
    expect(
      find.text('How would you like to export your statement?'),
      findsOneWidget,
    );
    expect(find.text('Export as PDF'), findsOneWidget);
    expect(find.text('Export as Excel (CSV)'), findsOneWidget);
    expect(find.byKey(GtActionSheet.cancelKey), findsOneWidget);
  }, variant: allPlatforms);

  testWidgets('closes before running the chosen action, then resolves with '
      'it', (tester) async {
    final host = await pumpHost(tester);
    var ran = 0;
    var hostWasCurrent = false;
    final pdf = GtActionSheetAction(
      label: 'Export as PDF',
      onPressed: () {
        ran++;
        // The sheet's route has left the navigator, so a choice that pushes
        // a route does so from the screen, not from over the sheet.
        hostWasCurrent = ModalRoute.of(host.context)?.isCurrent ?? false;
      },
    );

    final result = await open(
      tester,
      host,
      actions: [
        GtActionSheetAction(label: 'Take a photo', onPressed: () {}),
        pdf,
      ],
    );
    await tester.tap(find.byKey(const ValueKey('gt-action-sheet-action-1')));
    await tester.pumpAndSettle();

    expect(await result, same(pdf));
    expect(ran, 1);
    expect(hostWasCurrent, isTrue);
    expect(find.byType(GtActionSheet), findsNothing);
  }, variant: allPlatforms);

  testWidgets('cancel closes the sheet without running anything', (
    tester,
  ) async {
    final host = await pumpHost(tester);
    var ran = false;

    final result = await open(
      tester,
      host,
      actions: [
        GtActionSheetAction(label: 'Delete', onPressed: () => ran = true),
      ],
    );
    await tester.tap(find.byKey(GtActionSheet.cancelKey));
    await tester.pumpAndSettle();

    expect(await result, isNull);
    expect(ran, isFalse);
    expect(find.byType(GtActionSheet), findsNothing);
  }, variant: allPlatforms);

  testWidgets('a tap outside dismisses the sheet like cancel', (tester) async {
    final host = await pumpHost(tester);
    var ran = false;

    final result = await open(
      tester,
      host,
      actions: [
        GtActionSheetAction(label: 'Delete', onPressed: () => ran = true),
      ],
    );
    await tester.tapAt(const Offset(187, 60));
    await tester.pumpAndSettle();

    expect(await result, isNull);
    expect(ran, isFalse);
    expect(find.byType(GtActionSheet), findsNothing);
  }, variant: allPlatforms);

  testWidgets('keys a choice by its own key when it carries one', (
    tester,
  ) async {
    final host = await pumpHost(tester);
    var ran = false;
    const key = Key('upload-from-files');

    await open(
      tester,
      host,
      actions: [
        GtActionSheetAction(label: 'Take a photo', onPressed: () {}),
        GtActionSheetAction(
          key: key,
          label: 'Choose a file',
          onPressed: () => ran = true,
        ),
      ],
    );

    expect(
      find.byKey(const ValueKey('gt-action-sheet-action-1')),
      findsNothing,
    );
    await tester.tap(find.byKey(key));
    await tester.pumpAndSettle();
    expect(ran, isTrue);
  }, variant: allPlatforms);

  testWidgets('keeps the brand of the screen that opened it', (tester) async {
    final host = await pumpHost(tester);
    await open(
      tester,
      host,
      actions: [GtActionSheetAction(label: 'Export as PDF', onPressed: () {})],
    );

    final context = tester.element(find.byType(GtActionSheet));
    expect(GtThemeProvider.of(context), same(kFlexTheme));
    expect(
      Theme.of(context).extension<GtPalette>(),
      same(kFlexTheme.lightPalette),
    );
  }, variant: allPlatforms);

  testWidgets('sets choices in the brand colour, and a destructive one in '
      'the error colour', (tester) async {
    final host = await pumpHost(tester);
    await open(
      tester,
      host,
      actions: [
        GtActionSheetAction(
          label: 'Export as PDF',
          isDefault: true,
          onPressed: () {},
        ),
        GtActionSheetAction(
          label: 'Delete',
          isDestructive: true,
          onPressed: () {},
        ),
      ],
    );

    final palette = kFlexTheme.lightPalette;
    GtText label(String text) => tester.widget<GtText>(
      find.ancestor(of: find.text(text), matching: find.byType(GtText)),
    );
    final pdf = label('Export as PDF');
    final delete = label('Delete');

    expect(pdf.style?.color, palette.primary.base);
    expect(pdf.style?.fontWeight, FontWeight.w600);
    expect(delete.style?.color, palette.error.base);
  }, variant: allPlatforms);
}
