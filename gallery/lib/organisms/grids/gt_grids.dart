import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:gt_mobile_ui/widgets/organisms/cards/gt_selectable_card.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final controller = GtTransferCategoryController(null);
final controller2 = ValueNotifier<AppImageData?>(null);
final threeDAvatars = [
  for (final image in GtNetworkImages.threeDAvatars)
    AppImageData(imageData: image),
];

@widgetbook.UseCase(
  name: 'GtTransferCategoryGrid',
  type: GtTransferCategoryGrid,
)
Widget buildGtTransferCategoryGridUsecase(BuildContext context) {
  return Scaffold(
    appBar: GtModalAppBar(),
    body: CustomScrollView(
      slivers: [
        SliverPadding(
          padding: context.insets.defaultHorizontalInsets,
          sliver: SliverList.list(
            children: [
              GtPageHeader(
                title: "CATEGORIES",
                subtitle:
                    "Categorize this payment to keep your spending organized.",
                subTitleColor: context.palette.text.darkerSub,
              ),
              const GtGap.ySectionSm(),
              GtTransferCategoryGrid(
                controller: controller,
                onAdd: () {
                  context.showToast("Clicked Add", type: .error);
                },
              ),
              const GtGap.ySectionLg(),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: GenericListener(
            valueListenable: controller2,
            builder: (selectedImage) {
              return GtSectionSlide.builder(
                scrollHeight: 130,
                title: "3D Avatars",
                itemCount: threeDAvatars.length,
                builder: (context, index) {
                  final image = threeDAvatars[index];
                  return GtAvatarSelectionCard(
                    image,
                    selected: image == selectedImage,
                    onSelect: (image) => controller2.value = image,
                  );
                },
              );
            },
          ),
        ),
      ],
    ),
  );
}
