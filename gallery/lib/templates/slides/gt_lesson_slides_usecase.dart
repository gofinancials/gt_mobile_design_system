import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// The deck shapes the gallery can build, one per content permutation the
/// template supports.
enum _LessonDeck {
  mixed('Mixed (image + text + header)'),
  images('Images only'),
  text('Text only'),
  headerOnly('Header only'),
  overflow('Long content (overflow)'),
  video('Audio-visual — video'),
  youtube('Audio-visual — YouTube'),
  audio('Audio-visual — audio');

  const _LessonDeck(this.label);

  final String label;

  /// Whether this deck spins up a real platform media player.
  bool get isAudioVisual => this == video || this == youtube || this == audio;
}

/// The per-slide styling knobs, gathered so every builder below takes one
/// argument instead of six.
class _SlideStyle {
  final Color? color;
  final Gradient? gradient;
  final Color? foregroundColor;
  final Color? contentColor;
  final Alignment imageAlignment;
  final double imageSize;

  const _SlideStyle({
    this.color,
    this.gradient,
    this.foregroundColor,
    this.contentColor,
    required this.imageAlignment,
    required this.imageSize,
  });
}

const _backgrounds = [
  GtColors.pink100,
  GtColors.purple100,
  GtColors.sky100,
  GtColors.green100,
  GtColors.orange100,
  GtColors.teal100,
  GtColors.yellow100,
  GtColors.blue100,
];

const _illustrations = [
  GtVectorIllustrations.vault,
  GtVectorIllustrations.cash,
  GtVectorIllustrations.grow,
  GtVectorIllustrations.coins,
  GtVectorIllustrations.target,
  GtVectorIllustrations.chart,
  GtVectorIllustrations.gift,
  GtVectorIllustrations.wallet,
];

const _lessons = [
  ('WHAT IS SAVING', 'Saving means keeping some of your money to use later '
      'instead of spending it all at once.'),
  ('WHY SAVING MATTERS', 'Saving helps you plan ahead, buy things you really '
      'want, and handle unexpected needs.'),
  ('START SMALL', 'Even a little set aside each week adds up faster than most '
      'people expect.'),
  ('MAKE IT A HABIT', 'The easiest savings are the ones you never have to '
      'think about.'),
  ('KNOW YOUR GOAL', 'A target gives every naira you keep back a job to do.'),
  ('BEAT INFLATION', 'Money left idle quietly loses value; put it somewhere '
      'that works.'),
  ('BUILD A BUFFER', 'Three months of expenses turns an emergency into an '
      'inconvenience.'),
  ('KEEP GOING', 'Consistency beats size — the streak matters more than the '
      'amount.'),
];

/// A deliberately long header, for checking the title's two-line clamp and the
/// subtitle's four-line clamp.
const _longLesson = (
  'A DELIBERATELY LONG LESSON TITLE THAT SHOULD CLAMP TO TWO LINES AND THEN '
      'ELLIPSIS RATHER THAN PUSHING THE CONTENT AREA OFF SCREEN',
  'This subtitle is long on purpose. It should wrap up to four lines and then '
      'ellipsis. Saving means keeping some of your money to use later instead '
      'of spending it all at once, which helps you plan ahead, buy the things '
      'you really want, and handle unexpected needs without borrowing. Past '
      'this point the text must be truncated rather than overflow.',
);

const _videoUrl =
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4';
const _youtubeUrl = 'https://www.youtube.com/watch?v=dQw4w9WgXcQ';
const _audioUrl =
    'https://flutter.github.io/assets-for-api-docs/assets/audio/rooster.mp3';

GtLessonSlideHeader _header(int index) {
  final (title, subTitle) = _lessons[index % _lessons.length];
  return GtLessonSlideHeader(title: title, subTitle: subTitle);
}

GtLessonSlideData _imageSlide(int index, _SlideStyle style) {
  return GtLessonSlideData.withImage(
    title: 'LESSON ${index + 1}',
    data: AppImageData(_illustrations[index % _illustrations.length]),
    alignment: style.imageAlignment,
    imageSize: style.imageSize,
    header: _header(index),
    color: style.color ?? _backgrounds[index % _backgrounds.length].value,
    gradient: style.gradient,
    foregroundColor: style.foregroundColor,
    contentColor: style.contentColor,
  );
}

GtLessonSlideData _textSlide(int index, _SlideStyle style) {
  final (_, body) = _lessons[index % _lessons.length];
  return GtLessonSlideData.withText(
    title: 'LESSON ${index + 1}',
    data: '$body\n\n$body',
    header: _header(index),
    color: style.color ?? _backgrounds[index % _backgrounds.length].value,
    gradient: style.gradient,
    foregroundColor: style.foregroundColor,
    contentColor: style.contentColor,
  );
}

GtLessonSlideData _headerSlide(int index, _SlideStyle style) {
  return GtLessonSlideData.withHeader(
    title: 'LESSON ${index + 1}',
    data: _header(index),
    color: style.color ?? _backgrounds[index % _backgrounds.length].value,
    gradient: style.gradient,
    foregroundColor: style.foregroundColor,
    contentColor: style.contentColor,
  );
}

GtLessonSlideData _overflowSlide(int index, _SlideStyle style) {
  final (title, subTitle) = _longLesson;
  return GtLessonSlideData.withText(
    title: 'A LESSON TITLE LONG ENOUGH TO CROWD THE APP BAR ${index + 1}',
    data: subTitle,
    header: GtLessonSlideHeader(title: title, subTitle: subTitle),
    color: style.color ?? _backgrounds[index % _backgrounds.length].value,
    gradient: style.gradient,
    foregroundColor: style.foregroundColor,
    contentColor: style.contentColor,
  );
}

GtLessonSlideData _avSlide(int index, _LessonDeck deck, _SlideStyle style) {
  final (document, mediaType) = switch (deck) {
    _LessonDeck.youtube => (_youtubeUrl, AppMediaType.youtube),
    _LessonDeck.audio => (_audioUrl, AppMediaType.audio),
    _ => (_videoUrl, AppMediaType.video),
  };

  return GtLessonSlideData.withAV(
    title: 'LESSON ${index + 1}',
    data: AppAvData(document: document, mediaType: mediaType),
    header: _header(index),
    color: style.color ?? _backgrounds[index % _backgrounds.length].value,
    gradient: style.gradient,
    foregroundColor: style.foregroundColor,
    contentColor: style.contentColor,
  );
}

List<GtLessonSlideData> _buildDeck({
  required _LessonDeck deck,
  required int count,
  required _SlideStyle style,
}) {
  return List.generate(count, (index) {
    if (deck.isAudioVisual) return _avSlide(index, deck, style);

    return switch (deck) {
      _LessonDeck.images => _imageSlide(index, style),
      _LessonDeck.text => _textSlide(index, style),
      _LessonDeck.headerOnly => _headerSlide(index, style),
      _LessonDeck.overflow => _overflowSlide(index, style),
      // Cycles the three static slide shapes so one deck covers all of them.
      _LessonDeck.mixed => switch (index % 3) {
        0 => _imageSlide(index, style),
        1 => _textSlide(index, style),
        _ => _headerSlide(index, style),
      },
      _ => _imageSlide(index, style),
    };
  });
}

@widgetbook.UseCase(name: 'GtLessonSlides', type: GtLessonSlides)
Widget playgroundGtLessonSlidesDoc(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtLessonSlides',
    description:
        'An educational slides template supporting lessons, images, audio/video playback, and navigation controls.',
    code: '''
GtLessonSlides(
  controller: GtLessonslideController(
    slides: [
      GtLessonSlideData.withImage(
        title: "LESSON 1",
        data: AppImageData(GtVectorIllustrations.vault),
        alignment: Alignment.center,
        header: GtLessonSlideHeader(
          title: "WHAT IS SAVING",
          subTitle: "Saving means keeping some of your money to use later.",
        ),
        color: GtColors.pink100.value,
        // Pair a foreground with `color`: it tints the app bar title and
        // cancel button, which otherwise take their color from the palette
        // and cannot know about a caller-supplied background.
        foregroundColor: GtColors.neutral950.value,
        // Pair a content color with `gradient`: it tints the header and body
        // on the content card, a different surface to the slide background.
        contentColor: GtColors.neutral950.value,
      ),
    ],
  ),
  indicatorColor: GtColors.purple500.value,
  onCancel: () => handleCancel(),
  onCompleted: () => handleCompleted(),
)''',
    child: GtEmptyStateCard(
      description:
          'Select "GtLessonSlides Gallery" in the sidebar to exercise every '
          'deck shape, color and media type against the live template.',
      icon: GtIcons.alarmClock,
    ),
  );
}

@widgetbook.UseCase(name: 'GtLessonSlides Gallery', type: GtLessonSlides)
Widget playgroundGtLessonSlidesUseCase(BuildContext context) {
  final deck = context.knobs.object.dropdown(
    label: 'Deck',
    options: _LessonDeck.values,
    initialOption: _LessonDeck.mixed,
    labelBuilder: (value) => value.label,
  );

  final count = context.knobs.int.slider(
    label: 'Slide count',
    initialValue: 3,
    min: 1,
    max: 8,
  );

  final color = context.knobs.colorOrNull(
    label: 'Slide background (overrides the per-slide default)',
  );

  final foregroundColor = context.knobs.colorOrNull(
    label: 'Foreground color (app bar title + cancel button)',
  );

  final contentColor = context.knobs.colorOrNull(
    label: 'Content color (slide header + body)',
  );

  final gradient = context.knobs.objectOrNull.dropdown<Gradient>(
    label: 'Slide gradient',
    options: [
      context.gradients.slideGradient(),
      context.gradients.ghostGradient,
      context.gradients.duoToneGradient(
        GtColors.purple700.value,
        GtColors.pink100.value,
      ),
    ],
    labelBuilder: (value) => switch (value) {
      _ when value == context.gradients.ghostGradient => 'Ghost',
      LinearGradient(begin: Alignment.bottomLeft) => 'Slide',
      _ => 'Duo-tone',
    },
  );

  final imageAlignment = context.knobs.object.dropdown<Alignment>(
    label: 'Image alignment',
    initialOption: Alignment.center,
    options: const [
      Alignment.topCenter,
      Alignment.center,
      Alignment.bottomCenter,
      Alignment.centerLeft,
      Alignment.centerRight,
    ],
    labelBuilder: (value) => switch (value) {
      Alignment.topCenter => 'Top',
      Alignment.bottomCenter => 'Bottom',
      Alignment.centerLeft => 'Left',
      Alignment.centerRight => 'Right',
      _ => 'Center',
    },
  );

  final imageSize = context.knobs.double.slider(
    label: 'Image size',
    initialValue: 240,
    min: 80,
    max: 360,
  );

  final indicatorColor = context.knobs.colorOrNull(label: 'Indicator color');

  final style = _SlideStyle(
    color: color,
    gradient: gradient,
    foregroundColor: foregroundColor,
    contentColor: contentColor,
    imageAlignment: imageAlignment,
    imageSize: imageSize,
  );

  return _LessonSlidesHost(
    // Rebuilding the host on any knob change gives each configuration a fresh
    // controller and disposes the previous one. That also makes this page a
    // live check of the teardown path: flipping a knob mid-animation is the
    // same unmount that used to throw an active-ticker assertion.
    key: ValueKey(
      Object.hashAll([
        deck,
        count,
        color,
        foregroundColor,
        contentColor,
        gradient,
        imageAlignment,
        imageSize,
      ]),
    ),
    slides: _buildDeck(deck: deck, count: count, style: style),
    indicatorColor: indicatorColor,
  );
}

/// Owns the controller for the gallery page.
///
/// [GtLessonslideController] holds an animation, a media player and a stream,
/// so it needs an owner with a lifecycle. A top-level `final` controller — the
/// shape this use case used to have — never disposes and leaks its player
/// across every hot reload.
class _LessonSlidesHost extends StatefulWidget {
  final List<GtLessonSlideData> slides;
  final Color? indicatorColor;

  const _LessonSlidesHost({
    super.key,
    required this.slides,
    this.indicatorColor,
  });

  @override
  State<_LessonSlidesHost> createState() => _LessonSlidesHostState();
}

class _LessonSlidesHostState extends State<_LessonSlidesHost> {
  late final GtLessonslideController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GtLessonslideController(slides: widget.slides);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Rewinds the deck so the page stays usable after it ends, and surfaces
  /// which callback fired — otherwise both look like "nothing happened".
  void _restart(String event) {
    _controller.reset();

    ScaffoldMessenger.maybeOf(context)
      ?..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('$event fired — deck restarted'),
          duration: 2.seconds,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return GtLessonSlides(
      controller: _controller,
      indicatorColor: widget.indicatorColor,
      onCancel: () => _restart('onCancel'),
      onCompleted: () => _restart('onCompleted'),
    );
  }
}
