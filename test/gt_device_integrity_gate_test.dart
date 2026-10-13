import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Holds each check until the test answers it. The completer is made inside
/// the check, so it belongs to the test's fake-async zone and a pump runs it.
class _PendingService implements AppDeviceIntegrityService {
  final List<bool> calls = [];
  Completer<AppDeviceIntegrityVerdict>? reply;

  @override
  Future<AppDeviceIntegrityVerdict> evaluate({required bool enforced}) {
    calls.add(enforced);
    return (reply = Completer()).future;
  }
}

class _GateTestApp extends StatelessWidget {
  final AppDeviceIntegrityService service;
  final bool enforced;
  final OnPressedAsync onExit;

  const _GateTestApp({
    required this.service,
    required this.onExit,
    this.enforced = true,
  });

  @override
  Widget build(BuildContext context) {
    return GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(
        builder: (context, child) => GtDeviceIntegrityGate(
          enforced: enforced,
          blockedTitle: 'Security check failed',
          blockedSubtitle: 'This device does not meet the requirements',
          exitLabel: 'Close app',
          service: service,
          onExit: onExit,
          child: child!,
        ),
        home: const Scaffold(body: Text('Home')),
      ),
    );
  }
}

void main() {
  late _PendingService service;
  late int exits;

  setUp(() {
    service = _PendingService();
    exits = 0;
  });

  Future<void> pumpGate(WidgetTester tester, {bool enforced = true}) {
    return tester.pumpWidget(
      _GateTestApp(
        service: service,
        enforced: enforced,
        onExit: () async => exits++,
      ),
    );
  }

  /// Answers the pending check and draws the result.
  Future<void> answer(
    WidgetTester tester,
    AppDeviceIntegrityVerdict verdict,
  ) async {
    service.reply!.complete(verdict);
    await tester.pump();
  }

  testWidgets('keeps the app built but offstage while it checks', (
    tester,
  ) async {
    await pumpGate(tester);

    expect(find.byType(GtSpinner), findsOneWidget);
    expect(find.text('Home', skipOffstage: false), findsOneWidget);
    expect(find.text('Home'), findsNothing);
    expect(service.calls, [true]);
  });

  testWidgets('shows the app once the device passes', (tester) async {
    await pumpGate(tester);

    await answer(tester, const AppDeviceIntegrityVerdict(enforced: true));

    expect(find.text('Home'), findsOneWidget);
    expect(find.byType(GtSpinner), findsNothing);
    expect(find.byType(GtStatusState), findsNothing);
  });

  testWidgets('drops the app for the blocked screen, which closes the app', (
    tester,
  ) async {
    await pumpGate(tester);

    await answer(
      tester,
      const AppDeviceIntegrityVerdict(enforced: true, rooted: true),
    );

    expect(find.text('Home', skipOffstage: false), findsNothing);
    expect(find.text('SECURITY CHECK FAILED'), findsOneWidget);
    expect(
      find.text(
        'This device does not meet the requirements',
        findRichText: true,
      ),
      findsOneWidget,
    );

    await tester.tap(find.byType(GtRaisedButton));
    expect(exits, 1);
  });

  testWidgets('checks again only when enforcement changes', (tester) async {
    await pumpGate(tester);
    await answer(tester, const AppDeviceIntegrityVerdict(enforced: true));

    await pumpGate(tester);
    expect(service.calls, [true]);

    await pumpGate(tester, enforced: false);
    expect(service.calls, [true, false]);
  });
}
