import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

@widgetbook.UseCase(name: 'Images', type: GtImage, path: "[Atoms]/[Images]")
Widget playgroundImageUseCase(BuildContext context) {
  String imageUrl = context.knobs.object.dropdown(
    label: "Test Image Urls",
    options: [
      'https://res.cloudinary.com/jesse-dirisu/image/upload/v1589648790/bookme_mail/payment.png',
      'https://storage.googleapis.com/dump-storage-jesse/Security.png',
    ],
    initialOption:
        "https://res.cloudinary.com/jesse-dirisu/image/upload/v1589648790/bookme_mail/payment.png",
  );
  String lottierl = context.knobs.object.dropdown(
    label: "Test Lottie Urls",
    options: [
      'https://storage.googleapis.com/dump-storage-jesse/Saving%20the%20Money.json',
      'https://storage.googleapis.com/dump-storage-jesse/Money.json',
    ],
    initialOption:
        "https://storage.googleapis.com/dump-storage-jesse/Saving%20the%20Money.json",
  );
  double height = context.knobs.object.dropdown<double>(
    label: "Image Height",
    initialOption: 100,
    options: [20, 40, 60, 80, 100, 120, 140, 160, 180, 200, 220],
  );
  double width = context.knobs.object.dropdown<double>(
    label: "Image Width",
    initialOption: 100,
    options: [20, 40, 60, 80, 100, 120, 140, 160, 180, 200, 220],
  );
  final alignment = context.knobs.object.dropdown<(String, Alignment)>(
    label: "Image Alignment",
    initialOption: ("Center", Alignment.center),
    options: [
      ("Center", Alignment.center),
      ("Center Left", Alignment.centerLeft),
      ("Center Right", Alignment.centerRight),
    ],
    labelBuilder: (value) => value.$1,
  );
  final fit = context.knobs.object.dropdown<(String, BoxFit)>(
    label: "Image Fit",
    initialOption: ("Contain", BoxFit.contain),
    options: [
      ("Contain", BoxFit.contain),
      ("Cover", BoxFit.cover),
      ("Fill", BoxFit.fill),
      ("Fit Height", BoxFit.fitHeight),
      ("Fit Width", BoxFit.fitWidth),
      ("None", BoxFit.none),
      ("Scale Down", BoxFit.scaleDown),
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
              title: "images",
              rider: "Images Playground",
              sectionHeader: "Network Image [GtNetworkImage]",
            ),
          ),
          SliverToBoxAdapter(
            child: GtNetworkImage(
              imageUrl,
              height: height,
              width: width,
              alignment: alignment.$2,
              fit: fit.$2,
            ),
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "Lottie Images [GTLOTTIE]"),
          ),
          SliverToBoxAdapter(
            child: GtLottie(
              lottierl,
              height: height,
              width: width,
              alignment: alignment.$2,
              fit: fit.$2,
            ),
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "Catalogue of Image Type"),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: WidgetStateProperty.resolveWith(
                    (states) => context.palette.bg.sub,
                  ),
                  columns: const [
                    DataColumn(
                      label: GtText(
                        'Class Name',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: GtText(
                        'Purpose',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  rows: const [
                    DataRow(
                      cells: [
                        DataCell(GtText('GtImage')),
                        DataCell(
                          GtText(
                            'Conditionally Renders all Raster image types (i.e Network, File, Asset and Memory images)',
                          ),
                        ),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(GtText('GtSvg')),
                        DataCell(
                          GtText(
                            'Renders Network and Asset SVGs, has an asIcon constructor for rendering SVGs like icons',
                          ),
                        ),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(GtText('GtNetworkImage')),
                        DataCell(
                          GtText(
                            'Renders Network Images from URLs; internally parses data URLs into bytes to be rendered as memory images',
                          ),
                        ),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(GtText('GtFileImage')),
                        DataCell(GtText('Renders Images from Files')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(GtText('GtMemoryImage')),
                        DataCell(GtText('Renders images from raw bytes')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(GtText('GtIcon')),
                        DataCell(
                          GtText(
                            'Renders IconData following our Icon color pallete by default, has a withColor constructor for passing custom colou rs',
                          ),
                        ),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(GtText('GtLottie')),
                        DataCell(
                          GtText(
                            'Conditionally renders Nestwork or Asset Lottie files',
                          ),
                        ),
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
