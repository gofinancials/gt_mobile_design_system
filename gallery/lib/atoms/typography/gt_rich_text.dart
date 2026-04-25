// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:gt_mobile_ui/gt_mobile_ui.dart';

@widgetbook.UseCase(name: 'GtRichText', type: GtRichText)
Widget playgroundGtRichTextUseCase(BuildContext context) {
  final String testString = """
<h1>GtRichText Engine Live! 🎉</h1>
<p>Welcome to the ultimate test of our custom styled text widget. This version fully supports our automated #HashtagParsing system! Let's see how it handles #FlutterDev and #DartLang mixed with our custom XML.</p>

<h2>Typography & Weights</h2>
<p>We can seamlessly transition from standard text to <m>medium weight</m>, <sb>semi-bold</sb>, and full <b>bold</b> or <strong>strong</strong> text. Need to lean into a point? Drop in some <em>italics</em> right next to a #DesignSystem hashtag.</p>

<h3>Underlines & Alerts</h3>
<p>Sometimes you just need a standard <u>underline</u>. Other times, a <mu>medium underline</mu> or a <bu>bold underline</bu> is necessary to grab attention. If something goes wrong, we drop in an <e>inline error state</e> to warn the user.</p>

<h4>Links & Interactivity</h4>
<p>Clickable elements are crucial. Here is a standard <a href="https://flutter.dev">hyperlink</a>, a <ma href="https://dart.dev">medium link</ma>, a <sba href="https://pub.dev">semi-bold link</sba>, and a high-priority <ba href="https://google.com">bold action link</ba>. Do these interfere with our #MobileRouting? Let's find out.</p>

<h5>Final Stress Test</h5>
<p>What happens when we stack #Multiple #Hashtags #InARow? Or put a #Hashtag at the very end of a sentence? The regex should isolate them perfectly without breaking the surrounding <sb>formatting</sb>.</p>
""";

  final maxLines = context.knobs.object.dropdown<(String, int)>(
    label: "Max Lines",
    initialOption: ("None", 0),
    options: [
      ("None", 0),
      ("1 Line", 1),
      ("5 Lines", 5),
      ("10 Lines", 10),
      ("15 Lines", 15),
    ],
    labelBuilder: (value) => value.$1,
  );
  final alignment = context.knobs.object.dropdown<(String, TextAlign)>(
    label: "Text Alignment",
    initialOption: ("Start", TextAlign.start),
    options: [
      ("Start", TextAlign.start),
      ("Center", TextAlign.center),
      ("End", TextAlign.end),
      ("Justify", TextAlign.justify),
    ],
    labelBuilder: (value) => value.$1,
  );
  final hashColor = context.knobs.object.dropdown<(String, Color)>(
    label: "Hashtag Color",
    initialOption: ("Default", context.palette.highlighted.base),
    options: [
      ("Default", context.palette.highlighted.base),
      ("Text", context.palette.text.strong),
      ("Red", context.palette.error.base),
      ("Green", context.palette.success.base),
      ("Blue", context.palette.information.base),
      ("Yellow", context.palette.warning.base),
    ],
    labelBuilder: (value) => value.$1,
  );

  return Scaffold(
    body: Padding(
      padding: context.insets.symmetricDp(
        horizontal: context.grid.singleColumn.margins.px,
      ),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: GalleryPageHeader(
              title: "Rich Text",
              rider: "Rich Text Playground",
              sectionHeader: "Rich Text Sample",
            ),
          ),
          SliverToBoxAdapter(
            child: GtRichText(
              testString,
              maxLines: maxLines.$2 <= 0 ? null : maxLines.$2,
              textAlign: alignment.$2,
              hashTagColor: hashColor.$2,
              key: ValueKey(Theme.of(context).brightness),
            ),
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "Default Tags"),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: MaterialStateProperty.resolveWith(
                    (states) => context.palette.bg.sub,
                  ),
                  columns: const [
                    DataColumn(
                      label: GtText(
                        'Tag',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: GtText(
                        'Purpose',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: GtText(
                        'Styling Behavior',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: GtText(
                        'Interactive',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  rows: const [
                    // Typography
                    DataRow(
                      cells: [
                        DataCell(GtText('<p>')),
                        DataCell(GtText('Paragraph')),
                        DataCell(GtText('Base textStyle or bodyM()')),
                        DataCell(GtText('Yes (Calls onTextTap)')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(GtText('<h1> - <h6>')),
                        DataCell(GtText('Headers 1-6')),
                        DataCell(GtText('context.textStyles.h1() - h6()')),
                        DataCell(GtText('Yes (Calls onTextTap)')),
                      ],
                    ),

                    // Weights
                    DataRow(
                      cells: [
                        DataCell(GtText('<b>, <strong>')),
                        DataCell(GtText('Bold Text')),
                        DataCell(GtText('FontWeight.bold')),
                        DataCell(GtText('Yes (Calls onTextTap)')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(GtText('<sb>')),
                        DataCell(GtText('Semi-bold Text')),
                        DataCell(GtText('FontWeight.w600')),
                        DataCell(GtText('Yes (Calls onTextTap)')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(GtText('<m>')),
                        DataCell(GtText('Medium Text')),
                        DataCell(GtText('FontWeight.w500')),
                        DataCell(GtText('Yes (Calls onTextTap)')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(GtText('<e>')),
                        DataCell(GtText('Error State')),
                        DataCell(GtText('palette.error.base')),
                        DataCell(GtText('Yes (Calls onTextTap)')),
                      ],
                    ),

                    // Underlines
                    DataRow(
                      cells: [
                        DataCell(GtText('<u>')),
                        DataCell(GtText('Standard Underline')),
                        DataCell(GtText('TextDecoration.underline')),
                        DataCell(GtText('Yes (Calls onTextTap)')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(GtText('<bu>')),
                        DataCell(GtText('Bold Underline')),
                        DataCell(GtText('FontWeight.bold + Underline')),
                        DataCell(GtText('Yes (Calls onTextTap)')),
                      ],
                    ),

                    // Links & Auto
                    DataRow(
                      cells: [
                        DataCell(GtText('<a>')),
                        DataCell(GtText('Standard Link')),
                        DataCell(GtText('Base Weight + Underline')),
                        DataCell(GtText('External URL / onTextTap')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(GtText('<ba>')),
                        DataCell(GtText('Bold Action Link')),
                        DataCell(GtText('FontWeight.bold + Underline')),
                        DataCell(GtText('External URL / onTextTap')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(GtText('<ht>')),
                        DataCell(GtText('Auto-Hashtag')),
                        DataCell(GtText('hashTagColor (Auto-generated)')),
                        DataCell(GtText('Yes (Calls onTextTap)')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: GtGap.ySectionLg()),
        ],
      ),
    ),
  );
}
