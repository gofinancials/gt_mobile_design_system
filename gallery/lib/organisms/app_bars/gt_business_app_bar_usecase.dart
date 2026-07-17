import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtProAppBar', type: GtProAppBar)
Widget playgroundGtProAppBarUseCase(BuildContext context) {
  final fullName = context.knobs.string(
    label: 'Full Name',
    initialValue: 'Alex Lobaloba',
  );
  final businessName = context.knobs.string(
    label: 'Business Name',
    initialValue: 'Sterling Tech Ltd',
  );
  final verified = context.knobs.boolean(
    label: 'Verified Business',
    initialValue: true,
  );

  return GtWidgetDocPage(
    title: 'GtProAppBar',
    description:
        'A specialized app bar for business/pro screens with status toggles, notifications, and profile triggers.',
    code:
        '''
GtProAppBar(
  fullName: "$fullName",
  businessName: "$businessName",
  verified: $verified,
  onClickStat: () {},
  onClickProfile: () {},
  onClickNotification: () {},
)''',
    child: GtProAppBar(
      fullName: fullName,
      businessName: businessName,
      verified: verified,
      onClickStat: () {},
      onClickProfile: () {},
      onClickNotification: () {},
    ),
  );
}
