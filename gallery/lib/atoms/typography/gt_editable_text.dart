// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:gt_mobile_ui/gt_mobile_ui.dart';

final focusNode = FocusNode();

@widgetbook.UseCase(name: 'GtEditableText', type: GtEditableText)
Widget playgroundGtEditableTextUseCase(BuildContext context) {
  final disabled = context.knobs.boolean(
    label: "Disable Edit",
    initialValue: false,
    description:
        "Toggle between editable and non editable states for Editable Text",
  );
  final direction = context.knobs.object.dropdown<TextDirection>(
    label: "Text Direction",
    initialOption: TextDirection.ltr,
    options: [TextDirection.ltr, TextDirection.rtl],
  );
  const text =
      "Sed ut perspiciatis, unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam eaque ipsa, quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt, explicabo. Nemo enim ipsam voluptatem, quia voluptas sit, aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos, qui ratione voluptatem sequi nesciunt, neque porro quisquam est, qui dolorem ipsum, quia dolor sit amet consectetur adipisci[ng] velit, sed quia non numquam [do] eius modi tempora inci[di]dunt, ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum[d] exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? [D]Quis autem vel eum i[r]ure reprehenderit, qui in ea voluptate velit esse, quam nihil molestiae consequatur, vel illum, qui dolorem eum fugiat, quo voluptas nulla pariatur?";
  final defaultController = TextEditingController(text: text);
  final maxLineController = TextEditingController(text: text);
  final directionController = TextEditingController(text: text);

  return Scaffold(
    body: Padding(
      padding: context.insets.symmetricDp(
        horizontal: context.grid.singleColumn.margins.px,
      ),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: GalleryPageHeader(
              title: "Editable Text",
              rider: "Editable Text Playground",
              sectionHeader: "Default Editable Text",
            ),
          ),
          SliverToBoxAdapter(
            child: GtEditableText(
              controller: defaultController,
              readonly: disabled,
              autofocus: true,
              focusNode: focusNode,
            ),
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(
              title: "Editable Text with Max Lines",
            ),
          ),
          SliverToBoxAdapter(
            child: GtEditableText(controller: maxLineController, maxLines: 4),
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(
              title: "Editable Text with directionality",
            ),
          ),
          SliverToBoxAdapter(
            child: GtEditableText(
              controller: directionController,
              textDirection: direction,
            ),
          ),
          SliverToBoxAdapter(child: GtGap.ySectionLg()),
        ],
      ),
    ),
  );
}
