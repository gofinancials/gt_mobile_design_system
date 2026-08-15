import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

import 'helpers/test_app_config.dart';

GtLessonSlideData _slide(
  String title, {
  Color? foregroundColor,
  Color? contentColor,
}) {
  return GtLessonSlideData.withText(
    title: title,
    header: GtLessonSlideHeader(title: title, subTitle: 'Sub $title'),
    data: 'Body copy for $title, long enough to give the slide a duration.',
    foregroundColor: foregroundColor,
    contentColor: contentColor,
  );
}

Widget _wrap(GtLessonslideController controller) {
  return GtThemeProvider(
    theme: kPersonalTheme,
    child: MaterialApp(
      home: GtLessonSlides(
        controller: controller,
        onCancel: () {},
        onCompleted: () {},
      ),
    ),
  );
}

void main() {
  setUpAll(registerTestAppConfig);

  group('GtLessonSlides teardown', () {
    testWidgets('unmounting mid-animation does not leave an active ticker', (
      tester,
    ) async {
      final controller = GtLessonslideController(
        slides: [_slide('LESSON 1'), _slide('LESSON 2')],
      );
      addTearDown(controller.dispose);

      await tester.pumpWidget(_wrap(controller));
      // Let the progress animation get under way before tearing down.
      await tester.pump(const Duration(milliseconds: 200));

      await tester.pumpWidget(const SizedBox());
      await tester.pump();

      expect(tester.takeException(), isNull);
    });

    testWidgets('disposing the controller in the same frame as the unmount '
        'does not notify after dispose', (tester) async {
      final controller = GtLessonslideController(slides: [_slide('LESSON 1')]);

      await tester.pumpWidget(_wrap(controller));
      await tester.pump(const Duration(milliseconds: 200));

      await tester.pumpWidget(const SizedBox());
      controller.dispose();
      // Drains the post-frame callback that `reset` schedules.
      await tester.pump();

      expect(tester.takeException(), isNull);
    });

    testWidgets('clears onStoryCompleted so the controller drops the screen', (
      tester,
    ) async {
      final controller = GtLessonslideController(slides: [_slide('LESSON 1')]);
      addTearDown(controller.dispose);

      await tester.pumpWidget(_wrap(controller));
      expect(controller.onStoryCompleted, isNotNull);

      await tester.pumpWidget(const SizedBox());
      expect(controller.onStoryCompleted, isNull);
    });
  });

  group('GtLessonSlides colors', () {
    testWidgets('leaves every color at the palette default when unset', (
      tester,
    ) async {
      final controller = GtLessonslideController(slides: [_slide('LESSON 1')]);
      addTearDown(controller.dispose);

      await tester.pumpWidget(_wrap(controller));

      final appBar = tester.widget<GtAppBar>(find.byType(GtAppBar));
      final cancel = tester.widget<GtCancelButton>(find.byType(GtCancelButton));
      final slideTitle = tester.widget<GtLessonSlideTitle>(
        find.byType(GtLessonSlideTitle),
      );

      expect(appBar.titleColor, isNull);
      expect(cancel.color, isNull);
      expect(slideTitle.color, isNull);

      final context = tester.element(find.byType(GtLessonSlideTitle));
      final rendered = tester.widget<GtText>(
        find.descendant(
          of: find.byType(GtLessonSlideTitle),
          matching: find.byType(GtText),
        ).first,
      );
      expect(rendered.style?.color, context.palette.text.strong);
    });

    testWidgets('applies foregroundColor to the app bar and cancel button', (
      tester,
    ) async {
      const foreground = Color(0xFF00FF00);
      final controller = GtLessonslideController(
        slides: [_slide('LESSON 1', foregroundColor: foreground)],
      );
      addTearDown(controller.dispose);

      await tester.pumpWidget(_wrap(controller));

      final appBar = tester.widget<GtAppBar>(find.byType(GtAppBar));
      final cancel = tester.widget<GtCancelButton>(find.byType(GtCancelButton));

      expect(appBar.titleColor, foreground);
      expect(cancel.color, foreground);
    });

    testWidgets('applies contentColor to the slide header and body', (
      tester,
    ) async {
      const content = Color(0xFFFF00FF);
      final controller = GtLessonslideController(
        slides: [_slide('LESSON 1', contentColor: content)],
      );
      addTearDown(controller.dispose);

      await tester.pumpWidget(_wrap(controller));

      final slideTitle = tester.widget<GtLessonSlideTitle>(
        find.byType(GtLessonSlideTitle),
      );
      expect(slideTitle.color, content);

      final headerText = tester.widget<GtText>(
        find.descendant(
          of: find.byType(GtLessonSlideTitle),
          matching: find.byType(GtText),
        ).first,
      );
      expect(headerText.style?.color, content);

      final body = tester.widget<GtRichText>(find.byType(GtRichText));
      expect(body.style?.color, content);
    });

    testWidgets('keeps foregroundColor and contentColor independent', (
      tester,
    ) async {
      const foreground = Color(0xFF112233);
      const content = Color(0xFF445566);
      final controller = GtLessonslideController(
        slides: [
          _slide(
            'LESSON 1',
            foregroundColor: foreground,
            contentColor: content,
          ),
        ],
      );
      addTearDown(controller.dispose);

      await tester.pumpWidget(_wrap(controller));

      final appBar = tester.widget<GtAppBar>(find.byType(GtAppBar));
      final slideTitle = tester.widget<GtLessonSlideTitle>(
        find.byType(GtLessonSlideTitle),
      );

      expect(
        appBar.titleColor,
        foreground,
        reason: 'the app bar sits on the slide background',
      );
      expect(
        slideTitle.color,
        content,
        reason: 'the header sits on the content card, a different surface',
      );
    });
  });

  group('GtLessonslideController', () {
    test('advances and resets index within bounds', () {
      final controller = GtLessonslideController(
        slides: [_slide('ONE'), _slide('TWO')],
      );
      addTearDown(controller.dispose);

      controller.next();
      expect(controller.currentIndex, 1);

      controller.prev();
      expect(controller.currentIndex, 0);

      controller.prev();
      expect(controller.currentIndex, 0, reason: 'must not go below zero');
    });

    test('calls onStoryCompleted instead of advancing past the last slide', () {
      var completed = 0;
      final controller = GtLessonslideController(
        slides: [_slide('ONE')],
        onStoryCompleted: () => completed++,
      );
      addTearDown(controller.dispose);

      controller.next();

      expect(completed, 1);
      expect(controller.currentIndex, 0);
    });

    test('updateSlides rewinds to the first slide', () {
      final controller = GtLessonslideController(
        slides: [_slide('ONE'), _slide('TWO')],
      );
      addTearDown(controller.dispose);

      controller.next();
      controller.updateSlides([_slide('THREE')]);

      expect(controller.currentIndex, 0);
      expect(controller.currentSlide.title, 'THREE');
    });

    test('detachProgress ignores a stale animation', () {
      final controller = GtLessonslideController(slides: [_slide('ONE')]);
      addTearDown(controller.dispose);

      const vsync = TestVSync();
      final active = AnimationController(
        vsync: vsync,
        duration: Durations.long1,
      );
      final stale = AnimationController(
        vsync: vsync,
        duration: Durations.long1,
      );
      addTearDown(active.dispose);
      addTearDown(stale.dispose);

      controller.attachProgress(active);
      controller.detachProgress(stale);

      expect(
        controller.animationController,
        same(active),
        reason: 'a stale indicator must not detach the live slide',
      );
    });
  });
}
