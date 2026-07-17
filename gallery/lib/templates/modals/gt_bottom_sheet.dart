import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtBottomSheet', type: GtBottomSheet)
Widget playgroundGtBottomSheetUseCase(BuildContext context) {
  return const _BottomSheetPreview();
}

class _BottomSheetPreview extends StatefulWidget {
  const _BottomSheetPreview();

  @override
  State<_BottomSheetPreview> createState() => _BottomSheetPreviewState();
}

const List<(IconData, String)> _items = [
  (GtIcons.editDoc, "Edit"),
  (GtIcons.calendarEmpty, "Schedule"),
  (GtIcons.copy, "Duplicate"),
  (GtIcons.shareIos, "Export"),
  (GtIcons.trash, "Delete"),
  (GtIcons.message, "Retry SMS and email"),
  (GtIcons.whatsapp, "Verify with a Selfie"),
];

class _BottomSheetPreviewState extends State<_BottomSheetPreview> with GtBottomSheetMixin {
  @override
  Widget build(BuildContext context) {
    final title = context.knobs.string(label: 'Sheet Title', initialValue: 'Manage payroll');
    final floating = context.knobs.boolean(label: 'Floating Style', initialValue: false);

    return GtWidgetDocPage(
      title: 'GtBottomSheet',
      description: 'Modal and draggable bottom sheets supporting custom height, scrollability, and floating cards. Access these helper methods by mixing GtBottomSheetMixin into your State class.',
      code: '''
// 1. Add GtBottomSheetMixin to your State class
class MyState extends State<MyWidget> with GtBottomSheetMixin {

  // A. Present a Simple Bottom Sheet
  void openSimpleSheet() {
    showSheet(
      context,
      maxHeightFraction: 0.5,
      child: GtStatusState.success(
        title: "Success!",
        subtitle: "Operation completed successfully.",
        actionLabel: "OK",
        onActionPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  // B. Present a Floating Bottom Sheet (Card Details)
  void openFloatingSheet() {
    showSheet(
      context,
      maxHeightFraction: 0.5,
      floating: true,
      isScrollable: true,
      child: MyCardDetailsWidget(),
    );
  }

  // C. Present a Draggable Bottom Sheet (Manage Payroll)
  void openDraggableSheet() {
    showDraggableSheet(
      context,
      minChildSize: 0.2,
      initialChildSize: 0.3,
      maxHeightFraction: 0.7,
      builder: (scrollController) {
        return MyScrollableContent(controller: scrollController);
      },
    );
  }

  // D. Present a Floating Draggable Bottom Sheet
  void openFloatingDraggableSheet() {
    showDraggableSheet(
      context,
      initialChildSize: 0.4,
      maxChildSize: 0.5,
      minChildSize: 0.2,
      floating: true,
      builder: (scrollController) {
        return MyScrollableContent(controller: scrollController);
      },
    );
  }
}
''',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: context.spacingLg,
        children: [
          GtRaisedButton(
            text: 'Show Simple Bottom Sheet',
            onPressed: () {
              showSheet(
                context,
                maxHeightFraction: .5,
                floating: floating,
                child: GtStatusState.success(
                  title: "successful !",
                  subtitle: "Your BVN was added successfully. You can now initiate transactions.",
                  actionLabel: "SUCCESS",
                  onActionPressed: () => Navigator.of(context).pop(),
                ),
              );
            },
          ),
          GtRaisedButton(
            text: 'Show Floating Bottom Sheet',
            variant: GtButtonVariant.secondary,
            onPressed: () {
              showSheet(
                context,
                maxHeightFraction: .5,
                floating: true,
                isScrollable: true,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const GtGap.yLg(),
                    GtTitleAppBar(title: "CARD DETAILS"),
                    Padding(
                      padding: context.insets.symmetricDp(
                        horizontal: 16.px,
                        vertical: 24.px,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          GtInfoListTile(
                            "Cardholder name",
                            text: "ALEX LOBALOBA",
                            trailing: GtCopyPill("Alex Lobaloba"),
                          ),
                          const GtGap.yBase(),
                          GtInfoListTile(
                            "Card number",
                            text: "1234 5678 9012 3456",
                            trailing: GtCopyPill("1234 5678 9012 3456"),
                          ),
                          const GtGap.yBase(),
                          GtInfoListTile("Expiry date", text: "11/25"),
                          const GtGap.yBase(),
                          GtInfoListTile("Security code", text: "123"),
                          const GtGap.yBase(),
                          GtInfoListTile(
                            "Billing address",
                            text: "20 Marina Boulevard, Ipaja, Lagos, 1274, Nigeria",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          GtRaisedButton(
            text: 'Show Draggable Bottom Sheet',
            variant: GtButtonVariant.info,
            onPressed: () {
              showDraggableSheet(
                context,
                minChildSize: .2,
                initialChildSize: .3,
                maxHeightFraction: .7,
                floating: floating,
                builder: (value) {
                  return SingleChildScrollView(
                    controller: value,
                    padding: context.insets.defaultAllInsets,
                    child: SafeArea(
                      top: false,
                      child: Column(
                        spacing: context.spacingSm,
                        children: [
                          GtModalAppBar(title: title),
                          for (final item in _items)
                            GtIconListTile.alt(item.$2, icon: item.$1),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          GtRaisedButton(
            text: 'Show Floating Draggable Bottom Sheet',
            variant: GtButtonVariant.destructive,
            onPressed: () {
              showDraggableSheet(
                context,
                initialChildSize: .4,
                maxChildSize: .5,
                minChildSize: .2,
                floating: true,
                builder: (value) {
                  return ListView(
                    controller: value,
                    children: [
                      const GtGap.yLg(),
                      GtTitleAppBar(title: "CARD DETAILS"),
                      Padding(
                        padding: context.insets.symmetricDp(
                          horizontal: 16.px,
                          vertical: 24.px,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            GtInfoListTile(
                              "Cardholder name",
                              text: "ALEX LOBALOBA",
                              trailing: GtCopyPill("Alex Lobaloba"),
                            ),
                            const GtGap.yBase(),
                            GtInfoListTile(
                              "Card number",
                              text: "1234 5678 9012 3456",
                              trailing: GtCopyPill("1234 5678 9012 3456"),
                            ),
                            const GtGap.yBase(),
                            GtInfoListTile("Expiry date", text: "11/25"),
                            const GtGap.yBase(),
                            GtInfoListTile("Security code", text: "123"),
                            const GtGap.yBase(),
                            GtInfoListTile(
                              "Billing address",
                              text: "20 Marina Boulevard, Ipaja, Lagos, 1274, Nigeria",
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
