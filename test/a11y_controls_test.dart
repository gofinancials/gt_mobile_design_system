import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

import 'helpers/semantics_matchers.dart';

/// A minimal valid 1x1 transparent PNG.
///
/// Image widgets resolve their bytes through a real codec even in tests, so an
/// empty byte list throws before any semantics are produced.
final _transparentPixelPng = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAACklEQVR4nGMAAQAABQABDQottAAAAABJRU5ErkJggg==',
);

void main() {
  Widget buildTestWidget(Widget child) {
    return GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(
        home: Scaffold(body: Center(child: child)),
      ),
    );
  }

  group('GtCheckBox', () {
    testWidgets('announces as a checkbox with its checked state', (
      tester,
    ) async {
      await withSemantics(tester, () async {
        await tester.pumpWidget(
          buildTestWidget(
            GtCheckBox<String>(
              value: 'terms',
              isActive: true,
              semanticsLabel: 'Accept terms',
              onChanged: (_) {},
            ),
          ),
        );

        expectSemantics(
          tester,
          find.byType(GtCheckBox<String>),
          label: 'Accept terms',
          isChecked: true,
          // Regression guard: GtInkWell defaulted every surface to
          // isSemanticButton, so this used to announce as "Accept terms,
          // button" with no checked state at all.
          isButton: false,
        );
      });
    });

    testWidgets('reports the unchecked state rather than omitting it', (
      tester,
    ) async {
      await withSemantics(tester, () async {
        await tester.pumpWidget(
          buildTestWidget(
            GtCheckBox<String>(
              value: 'terms',
              isActive: false,
              semanticsLabel: 'Accept terms',
              onChanged: (_) {},
            ),
          ),
        );

        expectSemantics(
          tester,
          find.byType(GtCheckBox<String>),
          isChecked: false,
        );
      });
    });

    testWidgets('announces as disabled when disabled', (tester) async {
      await withSemantics(tester, () async {
        await tester.pumpWidget(
          buildTestWidget(
            GtCheckBox<String>(
              value: 'terms',
              isActive: false,
              disabled: true,
              semanticsLabel: 'Accept terms',
              onChanged: (_) {},
            ),
          ),
        );

        expectSemantics(
          tester,
          find.byType(GtCheckBox<String>),
          isEnabled: false,
        );
      });
    });

    testWidgets('responds to touch across the minimum tap target', (
      tester,
    ) async {
      var changes = 0;

      await tester.pumpWidget(
        buildTestWidget(
          GtCheckBox<String>(
            value: 'terms',
            isActive: false,
            onChanged: (_) => changes++,
          ),
        ),
      );

      // The control paints at 20dp; the platform minimum is 44dp.
      expectMinimumTapTarget(tester, find.byType(GtCheckBox<String>));

      final center = tester.getCenter(find.byType(GtCheckBox<String>));
      await tester.tapAt(center + const Offset(18, 0));
      await tester.pumpAndSettle();

      expect(changes, 1);
    });
  });

  group('GtRadio', () {
    testWidgets('announces as a mutually exclusive radio', (tester) async {
      await withSemantics(tester, () async {
        await tester.pumpWidget(
          buildTestWidget(
            GtRadio<String>(
              value: 'savings',
              groupValue: 'savings',
              semanticsLabel: 'Savings account',
              onChanged: (_) {},
            ),
          ),
        );

        expectSemantics(
          tester,
          find.byType(GtRadio<String>),
          label: 'Savings account',
          isChecked: true,
          isInMutuallyExclusiveGroup: true,
          isButton: false,
        );
      });
    });

    testWidgets('reports unselected when it is not the group value', (
      tester,
    ) async {
      await withSemantics(tester, () async {
        await tester.pumpWidget(
          buildTestWidget(
            GtRadio<String>(
              value: 'savings',
              groupValue: 'current',
              semanticsLabel: 'Savings account',
              onChanged: (_) {},
            ),
          ),
        );

        expectSemantics(
          tester,
          find.byType(GtRadio<String>),
          isChecked: false,
          isInMutuallyExclusiveGroup: true,
        );
      });
    });

    testWidgets('responds to touch across the minimum tap target', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          GtRadio<String>(
            value: 'savings',
            groupValue: 'current',
            onChanged: (_) {},
          ),
        ),
      );

      expectMinimumTapTarget(tester, find.byType(GtRadio<String>));
    });
  });

  group('GtSwitch', () {
    testWidgets('carries an accessible name alongside its toggled state', (
      tester,
    ) async {
      await withSemantics(tester, () async {
        await tester.pumpWidget(
          buildTestWidget(
            GtSwitch(
              value: true,
              semanticsLabel: 'Biometric login',
              onChanged: (_) {},
            ),
          ),
        );

        expectSemantics(
          tester,
          find.byType(GtSwitch),
          label: 'Biometric login',
          isToggled: true,
        );
      });
    });

    testWidgets('presents as one stop carrying both name and state', (
      tester,
    ) async {
      await withSemantics(tester, () async {
        await tester.pumpWidget(
          buildTestWidget(
            GtSwitch(
              value: false,
              semanticsLabel: 'Biometric login',
              onChanged: (_) {},
            ),
          ),
        );

        // The name and the switch come from two different annotations, and a
        // focusable child does not fold into an enclosing one by itself. If
        // merging regressed, the user would meet the label and the control as
        // two separate swipe stops.
        final node = semanticsNodeOf(tester, find.byType(GtSwitch));
        final data = node.getSemanticsData();

        expect(data.label, 'Biometric login');
        expect(data.flagsCollection.isToggled.toBoolOrNull(), isFalse);

        node.visitChildren((child) {
          expect(
            child.isMergedIntoParent,
            isTrue,
            reason: 'switch should be a single stop, not two',
          );
          return true;
        });
      });
    });

    testWidgets('announces as disabled when disabled', (tester) async {
      await withSemantics(tester, () async {
        await tester.pumpWidget(
          buildTestWidget(
            GtSwitch(
              value: false,
              disabled: true,
              semanticsLabel: 'Biometric login',
              onChanged: (_) {},
            ),
          ),
        );

        expectSemantics(tester, find.byType(GtSwitch), isEnabled: false);
      });
    });
  });

  group('images', () {
    testWidgets('an unlabelled image contributes no semantics', (tester) async {
      await withSemantics(tester, () async {
        await tester.pumpWidget(
          buildTestWidget(
            GtMemoryImage(_transparentPixelPng, width: 40, height: 40),
          ),
        );

        // Image defaults to excludeFromSemantics: false, so every unlabelled
        // image used to be an "image" stop carrying no information at all.
        expectNoSemantics(tester, find.byType(GtMemoryImage));
      });
    });

    testWidgets('a labelled image announces as an image with its label', (
      tester,
    ) async {
      await withSemantics(tester, () async {
        await tester.pumpWidget(
          buildTestWidget(
            GtMemoryImage(
              _transparentPixelPng,
              width: 40,
              height: 40,
              semanticsLabel: 'Receipt preview',
            ),
          ),
        );

        expectSemantics(
          tester,
          find.byType(GtMemoryImage),
          label: 'Receipt preview',
        );
      });
    });

    testWidgets('an explicitly decorative image stays silent', (tester) async {
      await withSemantics(tester, () async {
        await tester.pumpWidget(
          buildTestWidget(
            GtMemoryImage(
              _transparentPixelPng,
              width: 40,
              height: 40,
              semanticsLabel: 'Receipt preview',
              isDecorative: true,
            ),
          ),
        );

        expectNoSemantics(tester, find.byType(GtMemoryImage));
      });
    });
  });

  group('indicators', () {
    testWidgets('progress exposes its position as a percentage', (
      tester,
    ) async {
      await withSemantics(tester, () async {
        await tester.pumpWidget(
          buildTestWidget(
            const GtProgress(value: 0.45, semanticsLabel: 'Upload progress'),
          ),
        );

        expectSemantics(
          tester,
          find.byType(GtProgress),
          label: 'Upload progress',
          value: '45',
        );
      });
    });

    testWidgets('indeterminate progress claims no position', (tester) async {
      const progress = GtProgress(semanticsLabel: 'Loading');
      expect(progress.semanticsValue, isNull);
    });

    testWidgets('dots announce position instead of staying invisible', (
      tester,
    ) async {
      await withSemantics(tester, () async {
        await tester.pumpWidget(
          buildTestWidget(
            const GtDots(1, length: 5, semanticsLabel: 'Page 2 of 5'),
          ),
        );

        expectSemantics(tester, find.byType(GtDots), label: 'Page 2 of 5');
      });
    });

    testWidgets('count indicator replaces the bare digit with its meaning', (
      tester,
    ) async {
      await withSemantics(tester, () async {
        await tester.pumpWidget(
          buildTestWidget(
            const GtCountIndicator(12, semanticsLabel: '12 unread messages'),
          ),
        );

        // The badge renders "9+" once the count passes nine, which is a poor
        // thing to hear in place of the real number.
        expectSemantics(
          tester,
          find.byType(GtCountIndicator),
          label: '12 unread messages',
        );
      });
    });
  });

  group('headings', () {
    testWidgets('text with a heading level announces as a heading', (
      tester,
    ) async {
      await withSemantics(tester, () async {
        await tester.pumpWidget(
          buildTestWidget(const GtText('Transaction summary', headingLevel: 1)),
        );

        final data = semanticsDataOf(tester, find.byType(GtText));

        // Text is semantic on its own, but nothing marked it as *structure*,
        // so heading-by-heading navigation skipped the whole design system.
        expect(data.flagsCollection.isHeader, isTrue);
        expect(data.headingLevel, 1);
        expect(data.label, 'Transaction summary');
      });
    });

    testWidgets('plain text stays a non-heading', (tester) async {
      await withSemantics(tester, () async {
        await tester.pumpWidget(buildTestWidget(const GtText('Body copy')));

        final data = semanticsDataOf(tester, find.byType(GtText));
        expect(data.flagsCollection.isHeader, isFalse);
        expect(data.headingLevel, 0);
      });
    });

    testWidgets('rejects a level outside 1-6', (tester) async {
      expect(() => GtText('Bad', headingLevel: 7), throwsAssertionError);
      expect(() => GtText('Bad', headingLevel: 0), throwsAssertionError);
    });

    testWidgets('the app bar title is the screen heading', (tester) async {
      await withSemantics(tester, () async {
        await tester.pumpWidget(
          buildTestWidget(const GtTitleAppBar(title: 'Transfers')),
        );

        final data = semanticsDataOf(tester, find.text('TRANSFERS'));
        expect(data.flagsCollection.isHeader, isTrue);
        expect(data.headingLevel, 1);
      });
    });
  });

  group('button tap targets', () {
    testWidgets('a small button still responds across the platform minimum', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          GtRaisedButton(
            text: 'Edit',
            size: GtButtonSize.pill,
            onPressed: () {},
          ),
        ),
      );

      // The pill size paints 24dp tall against a 44dp platform minimum, and
      // baseStyle switches off Material's own tap-target padding.
      expectMinimumTapTarget(tester, find.byType(GtRaisedButton));
    });

    testWidgets('a large button is left alone', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          GtRaisedButton(
            text: 'Continue',
            size: GtButtonSize.large,
            onPressed: () {},
          ),
        ),
      );

      // Already above the minimum, so no slop should be introduced.
      expect(find.byType(GtTapTarget), findsNothing);
    });
  });
}
