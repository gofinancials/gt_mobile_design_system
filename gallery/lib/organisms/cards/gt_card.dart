import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Cards Gallery', type: GtCard)
Widget buildGtCardUseCase(BuildContext context) {
  final productGridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: 140,
    crossAxisSpacing: 8,
    mainAxisSpacing: 8,
  );
  final billGridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: context.fractionalShortest(.5),
    mainAxisExtent: 92,
    childAspectRatio: 16 / 9,
    crossAxisSpacing: 12,
    mainAxisSpacing: 12,
  );
  final cardVariant = context.knobs.object.dropdown(
    label: 'Card Variant',
    options: GtCardVariant.values,
    initialOption: GtCardVariant.normal,
    labelBuilder: (value) => value.name.capitalise(),
  );

  final cornerStyle = context.knobs.object.dropdown(
    label: 'Corner Style',
    options: CornerStyle.values,
    initialOption: CornerStyle.rounded,
    labelBuilder: (value) => value.name.capitalise(),
  );

  final bannerTitle = context.knobs
      .string(
        label: 'Banner Title',
        initialValue:
            'Make it easy to get paid. Invite your friends to send you money.',
      )
      .upper;

  final bannerSubtitle = context.knobs.string(
    label: 'Banner Subtitle',
    initialValue: 'Request money either by a link or a QR Code',
  );

  bool bannerVisibility = context.knobs.boolean(
    label: 'Hide banner',
    initialValue: false,
  );

  final bannerVariant = context.knobs.object.dropdown(
    label: 'Banner Variant',
    options: GtCardVariant.values,
    initialOption: GtCardVariant.warning,
    labelBuilder: (value) => value.name.capitalise(),
  );

  final tipTitle = context.knobs.string(
    label: 'Tip Title',
    initialValue: 'Confirm Referee Details',
  );
  final tipSubtitle = context.knobs.string(
    label: 'Banner Title',
    initialValue:
        'Please ensure your referees’ details are accurate. They will be contacted to complete a form approving your account opening.',
  );
  final tipVariant = context.knobs.object.dropdown(
    label: 'Tip Variant',
    options: GtCardVariant.values,
    initialOption: GtCardVariant.away,
    labelBuilder: (value) => value.name.capitalise(),
  );
  final actionVariant = context.knobs.object.dropdown(
    label: 'Action Variant',
    options: GtCardVariant.values,
    initialOption: GtCardVariant.away,
    labelBuilder: (value) => value.name.capitalise(),
  );
  final alertVariant = context.knobs.object.dropdown(
    label: 'Alert Variant',
    options: GtCardVariant.values,
    initialOption: GtCardVariant.away,
    labelBuilder: (value) => value.name.capitalise(),
  );
  final notificationVariant = context.knobs.object.dropdown(
    label: 'Notification Variant',
    options: GtNotificationVariant.values,
    initialOption: GtNotificationVariant.error,
    labelBuilder: (value) => value.name.capitalise(),
  );

  return Scaffold(
    key: PageStorageKey("Cards Playground"),
    body: Padding(
      padding: context.insets.defaultHorizontalInsets,
      child: CustomScrollView(
        key: PageStorageKey("Cards Playground List"),
        slivers: [
          SliverList.list(
            children: [
              GalleryPageHeader(
                title: "Cards",
                rider: "Playground for cards",
                sectionHeader: "GtbannerCard",
              ),
              GtBannerCard(
                title: bannerTitle,
                subtitle: bannerSubtitle,
                variant: bannerVariant,
                hidden: bannerVisibility,
                onClose: () => bannerVisibility = true,
              ),
              const GalleryPageSectionHeader(title: "GtTipCard"),
              GtTipCard(
                title: tipTitle,
                subtitle: tipSubtitle,
                variant: tipVariant,
                hidden: bannerVisibility,
                onClose: () => bannerVisibility = true,
              ),
            ],
          ),
          SliverList.list(
            children: [
              const GalleryPageSectionHeader(
                title: "GtActionCard [.dismisible]",
              ),
              GtActionCard(
                title: "Refer a Friend, Earn ₦5,000 each",
                subtitle: "Love your Pro account? Share with your friends.",
                icon: GtIcons.gift,
                onActionTap: () {},
                actionText: "Share Invite",
                variant: actionVariant,
              ),
              const GtGap.yBase(),
              GtActionCard.dismissible(
                title: "Are you a freelancer?",
                subtitle: "We have something for you, have you tried flex?",
                icon: GtIcons.gemSparkle,
                onActionTap: () {},
                actionText: "ADD MONEY",
                variant: actionVariant,
                onDismiss: () {},
                dismissText: "DISMISS",
              ),
              const GtGap.yBase(),
              GtActionCard.dismissibleTrailing(
                title: "POS Dispute Update",
                subtitle: "We have an update on your disputed POS transaction.",
                trailing: GtSvg(
                  GtVectorIllustrations.serviceStatus,
                  width: 80,
                  height: 80,
                  alignment: .topRight,
                ),
                onActionTap: () {},
                actionText: "View",
                variant: actionVariant,
                onDismiss: () {},
                dismissText: "DISMISS",
              ),
            ],
          ),
          SliverList.list(
            children: [
              const GalleryPageSectionHeader(title: "GtAlertBanner"),
              GtAlertBanner(
                title: "Nearly there",
                subtitle:
                    "Your fixed savings plan matures in 7 days with ₦45,000 earned. Tap to renew now and keep the streak alive.",
                icon: GtSvg(GtVectorIllustrations.fuel),
                onClose: () {},
                variant: alertVariant,
              ),
            ],
          ),
          SliverList.list(
            children: [
              const GalleryPageSectionHeader(title: "GtReminderBanner"),
              GtReminderBanner(
                title: "UPGRADE FOLA'S ACCOUNT",
                subtitle:
                    "Fola is ready to move to a full OneBank account with full access to their money.",
                icon: GtSvg(GtVectorIllustrations.referral),
                onClose: () {},
                variant: alertVariant,
                actionText: "GET STARTED",
                onActionTap: () {},
              ),
            ],
          ),
          SliverList.list(
            children: [
              const GalleryPageSectionHeader(title: "GtAlertCard"),
              GtAlertCard(
                title: "Issue with address",
                subtitle: "Address not verified",
                variant: alertVariant,
                icon: GtIcons.houseAlt,
              ),
            ],
          ),
          SliverList.list(
            children: [
              const GalleryPageSectionHeader(title: "GtPaymentSourceCard"),
              GtPaymentSourceCard(
                title: "Pay from",
                accountDetail:
                    "savings ${AppStrings.dotSeparator} 1020293939".upper,
                balance: "Balance ₦200,015.00",
                variant: alertVariant,
                icon: GtNetworkImage(GtNetworkImages.savings),
              ),
            ],
          ),
          SliverList.list(
            children: [
              const GalleryPageSectionHeader(title: "GtNotificationCard"),
              GtNotificationCard(
                title: "Unauthorized access",
                subtitle: "You don't have the permission to do this",
                variant: notificationVariant,
                onClose: () {},
              ),
            ],
          ),
          SliverList.list(
            children: [
              const GalleryPageSectionHeader(title: "GtAdressCard"),
              GtAddressCard(
                line1: context.knobs.string(
                  label: "Address Line 1",
                  initialValue: "210 Sanusi Street",
                ),
                line2: context.knobs.string(
                  label: "Address Line 2",
                  initialValue: "Surulere, Lagos Nigeria 234768",
                ),
                variant: cardVariant,
              ),
              const GalleryPageSectionHeader(title: "GtHelpCard"),
              GtHelpCard(
                title: "Need more help?",
                subtitle: "Chat with us",
                variant: tipVariant,
              ),
              const GalleryPageSectionHeader(title: "GtProductCard"),
              const GtGap.yBase(),
              GtProductCard(
                name: "Premium",
                icon: GtIcons.gemSparkle,
                variant: .featured,
                description: "Try a premium account for more benefits",
              ),
              const GtGap.yBase(),
              GtProductCard(
                name: "Investments",
                icon: GtIcons.moneyBillCoin,
                variant: .success,
                description: "Start your investment journey with us",
              ),
              const GtGap.yBase(),
              GtProductCard(
                name: "Referrals",
                icon: GtIcons.gift,
                variant: .away,
                description: "Don’t be alone here. Invite your friends",
              ),
              const GtGap.yBase(),
            ],
          ),
          SliverGrid.list(
            gridDelegate: productGridDelegate,
            children: [
              GtProductCard(
                name: "Premium",
                icon: GtIcons.gemSparkle,
                variant: .featured,
                description: "Try a premium account for more benefits",
              ),
              GtProductCard(
                name: "Investments",
                icon: GtIcons.moneyBillCoin,
                variant: .success,
                description: "Start your investment journey with us",
              ),
              GtProductCard(
                name: "Referrals",
                icon: GtIcons.gift,
                variant: .away,
                description: "Don’t be alone here. Invite your friends",
              ),
              GtProductCard(
                name: "Premium",
                icon: GtIcons.gemSparkle,
                variant: .featured,
              ),
              GtProductCard(
                name: "Investments",
                icon: GtIcons.moneyBillCoin,
                variant: .success,
              ),
              GtProductCard(
                name: "Referrals",
                icon: GtIcons.gift,
                variant: .away,
              ),
            ],
          ),
          SliverList.list(
            children: [
              const GalleryPageSectionHeader(title: "GtEmptyStateCard"),
              GtEmptyStateCard(
                icon: context.knobs.objectOrNull.dropdown<IconData?>(
                  label: "State Icon",
                  options: [GtIcons.userSearch, null],
                  initialOption: GtIcons.userSearch,
                ),
                description: "You currently do not have any team member here",
                variant: context.knobs.object.dropdown<GtCardVariant>(
                  label: "State Variant",
                  options: GtCardVariant.values,
                  initialOption: .normal,
                  labelBuilder: (value) => value.name,
                ),
              ),
              const GtGap.yBase(),
              GtActionableEmptyStateCard(
                icon: GtIcons.fileContent,
                title: "No transfers yet",
                description:
                    "Your bulk transfers will appear after you create one",
                buttontext: "NEW bulk transfer",
                onPressed: () {},
                variant: context.knobs.object.dropdown<GtCardVariant>(
                  label: "State Variant",
                  options: GtCardVariant.values,
                  initialOption: .normal,
                  labelBuilder: (value) => value.name,
                ),
              ),
            ],
          ),
          SliverList.list(
            children: [
              const GalleryPageSectionHeader(title: "GtInStructionCard"),
              GtInstructionCard(
                icon: GtIcon(GtIcons.camera, variant: .soft, size: 24),
                description: "JPEG, JPG and PNG formats, up to 10 MB.",
                variant: context.knobs.object.dropdown<GtCardVariant>(
                  label: "Instruction Variant",
                  options: GtCardVariant.values,
                  initialOption: .normal,
                  labelBuilder: (value) => value.name,
                ),
                title: "Take picture of front of ID",
                onPressed: () {},
              ),
              const GtGap.yBase(),
              GtInstructionCard(
                icon: GtIcon(GtIcons.uploadFolder, size: 32),
                description: "Upload a scan or PDF of your CAC certificate",
                variant: context.knobs.object.dropdown<GtCardVariant>(
                  label: "Instruction Variant",
                  options: GtCardVariant.values,
                  initialOption: .normal,
                  labelBuilder: (value) => value.name,
                ),
                title: "Upload documents",
                onPressed: () {},
                isFilled: true,
              ),
            ],
          ),
          SliverList.list(
            children: [
              const GalleryPageSectionHeader(title: "GtBillCard [.tile]"),
              GtCard(
                child: Column(
                  children: [
                    GtBillCard.tile(
                      name: "Airtime",
                      icon: GtSvg(GtVectorIllustrations.building),
                    ),
                    GtBillCard.tile(
                      name: "Data & Internet",
                      icon: GtSvg(GtVectorIllustrations.house),
                    ),
                    GtBillCard.tile(
                      name: "Cable TV",
                      icon: GtSvg(GtVectorIllustrations.bin),
                    ),
                  ],
                ),
              ),
              const GtGap.yBase(),
            ],
          ),
          SliverGrid.list(
            gridDelegate: billGridDelegate,
            children: [
              GtBillCard(
                name: "Airtime",
                icon: GtSvg(GtVectorIllustrations.building),
              ),
              GtBillCard(
                name: "Data & Internet",
                icon: GtSvg(GtVectorIllustrations.house),
              ),
              GtBillCard(
                name: "Cable TV",
                icon: GtSvg(GtVectorIllustrations.bin),
              ),
              GtBillCard(
                name: "Electricity",
                icon: GtSvg(GtVectorIllustrations.authentication),
              ),
            ],
          ),
          SliverList.list(
            children: [
              const GalleryPageSectionHeader(title: "GtCard"),
              GtCard(
                variant: cardVariant,
                cornerStyle: cornerStyle,
                child: const GtText(
                  'This is a standard GtCard. Use the knobs to change my variant and corner style.',
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(child: const GtGap.ySectionXl()),
        ],
      ),
    ),
  );
}
