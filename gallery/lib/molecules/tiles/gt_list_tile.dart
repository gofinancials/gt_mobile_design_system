import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/extensions/number_extensions.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'GtListTiles',
  type: GtListTile,
  path: "[Molecules]/GtListItems",
)
Widget gtListTileAllUseCase(BuildContext context) {
  String radioValue = context.knobs.object.dropdown(
    label: "Radio Options",
    initialOption: "Simple",
    options: ["Simple", "Double", "Triple"],
  );

  return Scaffold(
    key: PageStorageKey("List Tiles"),
    body: ListView(
      key: PageStorageKey("List Tiles List"),
      padding: const EdgeInsets.all(16.0),
      children: [
        GalleryPageHeader(
          title: "List Tiles",
          rider: "GtListTiles",
          sectionHeader: "GtListTile",
        ),
        const SizedBox(height: 8),
        GtCard(
          child: GtListTile(
            text: context.knobs.string(
              label: 'Basic Text',
              initialValue: 'Reminders',
            ),
            leading: GtIcon(GtIcons.bell, size: context.dp(24.px)),
            trailing: GtIcon(
              GtIcons.chevronRight,
              size: context.dp(18.px),
              variant: GtIconVariant.soft,
            ),
            onTap: () {},
          ),
        ),
        const SizedBox(height: 8),
        GtCard(
          child: GtListTile(
            text: "Profile Settings",
            leading: GtIcon(GtIcons.bell, size: context.dp(24.px)),
            onTap: () {},
          ),
        ),
        const SizedBox(height: 24),

        GtText('GtInputListTile', style: context.textStyles.h6()),
        const SizedBox(height: 8),
        GtCard(
          child: GtInputListTile(
            context.knobs.string(
              label: 'Input Label',
              initialValue: 'Account Number',
            ),
            text: context.knobs.string(
              label: 'Input Text',
              initialValue: '1234567890',
            ),
            onTap: () {},
          ),
        ),
        const SizedBox(height: 8),
        GtInputListTile.asCard(
          context.knobs.string(
            label: 'Card Input Label',
            initialValue: 'Bank Info',
          ),
          text: context.knobs.string(
            label: 'Card Input Text',
            initialValue: '0987654321',
          ),
          leading: const GtIcon(GtIcons.house),
          onTap: () {},
        ),
        const SizedBox(height: 24),
        GtText('GtLimitListTile', style: context.textStyles.h6()),
        const SizedBox(height: 8),
        GtCard(
          child: GtLimitInfoListTile(
            context.knobs.string(
              label: 'Card Input Label',
              initialValue: 'Current single airtime limit',
            ),
            value: context.knobs.string(
              label: 'Card Input Text',
              initialValue: 'N5,000,000.00',
            ),
          ),
        ),
        const SizedBox(height: 24),

        GtText('GtAccountListTile', style: context.textStyles.h6()),
        const SizedBox(height: 8),
        GtCard(
          child: Column(
            children: [
              GtAccountListTile(
                context.knobs.string(
                  label: 'Account Title',
                  initialValue: 'Savings Account',
                ),
                subtitle: context.knobs.string(
                  label: 'Account Subtitle',
                  initialValue: 'USD',
                ),
                leading: DecoratedBox(
                  decoration: BoxDecoration(
                    color: context.palette.primary.base,
                    shape: BoxShape.circle,
                  ),
                ),
                trailing: GtText(
                  "\$ 9,000.00",
                  style: context.textStyles.subHeadS(
                    color: context.palette.text.sub,
                  ),
                ),
                hasBoldSubtitle: context.knobs.boolean(
                  label: 'Bold Account Subtitle',
                  initialValue: true,
                ),
                onTap: () {},
              ),
              GtAccountListTile(
                "Alex Lobaloba",
                subtitle: "Kuda Bank",
                leading: DecoratedBox(
                  decoration: BoxDecoration(
                    color: context.palette.primary.base,
                    shape: BoxShape.circle,
                  ),
                ),
                trailing: GtSwitch(value: true, onChanged: (_) {}),
                hasBoldSubtitle: false,
                onTap: () {},
              ),
              GtAccountListTile(
                "Alex Lobaloba",
                subtitle: "Kuda Bank",
                leading: DecoratedBox(
                  decoration: BoxDecoration(
                    color: context.palette.primary.base,
                    shape: BoxShape.circle,
                  ),
                ),
                trailing: GtIcon(GtIcons.reorder),
                hasBoldSubtitle: false,
                onTap: () {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        GtText('GtContactListTile', style: context.textStyles.h6()),
        const SizedBox(height: 8),
        GtCard(
          child: Column(
            children: [
              GtContactListTile(
                "Kenneth Osmosis",
                subtitle: "@kennethosmosis",
                leading: DecoratedBox(
                  decoration: BoxDecoration(
                    color: context.palette.primary.base,
                    shape: BoxShape.circle,
                  ),
                ),
                onTap: () {},
              ),
              GtContactListTile(
                "Basit Samad",
                subtitle: "@bas.samad",
                leading: DecoratedBox(
                  decoration: BoxDecoration(
                    color: context.palette.feature.base,
                    shape: BoxShape.circle,
                  ),
                ),
                onTap: () {},
              ),
              GtContactListTile(
                "Mikhaeel Adesanya",
                subtitle: "@mikhaeel",
                leading: DecoratedBox(
                  decoration: BoxDecoration(
                    color: context.palette.away.base,
                    shape: BoxShape.circle,
                  ),
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        GtText('GtExportListTile', style: context.textStyles.h6()),
        const SizedBox(height: 8),
        GtCard(
          child: Column(
            children: [
              GtExportListTile(
                "Last 3 full months",
                subtitle: "1st Mar 2025 - 30th June 2025",
                onTap: () {},
              ),
              GtExportListTile(
                "Last 6 full months",
                subtitle: "1st Jan 2025 - 30th June 2025",
                onTap: () {},
              ),
              GtExportListTile("June", onTap: () {}),
            ],
          ),
        ),
        const SizedBox(height: 24),
        GtText('GtLimitEditListTile', style: context.textStyles.h6()),
        const SizedBox(height: 8),
        GtCard(
          padding: context.insets.allDp(16.px),
          child: Column(
            children: [
              GtLimitEditListTile(
                "Airtime",
                value: context.knobs.double.slider(
                  label: "Limit",
                  min: 0,
                  max: 80000,
                  initialValue: 10000,
                ),
                max: 80000,
                onEdit: () {},
              ),
              const GtGap.yLg(),
              GtLimitEditListTile(
                "Bill Payments",
                value: context.knobs.double.slider(
                  label: "Limit",
                  min: 0,
                  max: 80000,
                  initialValue: 10000,
                ),
                max: 80000,
                onEdit: () {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        GtText('GtIllustratedStepTile', style: context.textStyles.h6()),
        const SizedBox(height: 8),
        GtIllustratedStepTile.card(
          illustrationPath: context.knobs.string(
            label: 'Step Illus Path',
            initialValue: GtVectorIllustrations.identification,
          ),
          title: context.knobs.string(
            label: 'Step Title',
            initialValue: 'Step 1: Verification',
          ),
          subtitle: context.knobs.string(
            label: 'Step Subtitle',
            initialValue:
                'Ask your parent to open your profile from their ‘Accounts’ in their onebank app',
          ),
        ),
        const SizedBox(height: 24),

        GtText('GtStatusListTile', style: context.textStyles.h6()),
        const SizedBox(height: 8),
        GtStatusListTile.card(
          icon: GtIcons.file,
          title: "CAC DOCUMENTS",
          subtitle:
              "Your official registration certificate issued by the Corporate Affairs Commission",
          footer: GtStatusPill(text: "Pending", variant: .away),
          onPressed: () {},
        ),
        const SizedBox(height: 4),
        GtStatusListTile.card(
          icon: GtIcons.tasks,
          title: "Status Report",
          isDone: true,
          footer: GtStatusPill(text: "Uploaded", variant: .success),
          subtitle:
              "Your official registration certificate issued by the Corporate Affairs Commission",
          onPressed: () {},
        ),
        const SizedBox(height: 24),

        GtText('GtStakeholderListTile', style: context.textStyles.h6()),
        const SizedBox(height: 8),
        GtCard(
          child: Column(
            spacing: context.spacingXl,
            children: [
              GtStakeHolderListTile(
                "YAHYA BELLO",
                position: "Executive, shareholder and a signatory",
                footer: "39% shares ownership",
                onTap: () {},
              ),
              GtStakeHolderListTile(
                "LOLA ALAO",
                position: "Executive, shareholder",
                footer: "10% shares ownership",
                onTap: () {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        GtText('GtStakeholderStatusListTile', style: context.textStyles.h6()),
        const SizedBox(height: 8),
        GtCard(
          child: Column(
            spacing: context.spacingXl,
            children: [
              GtStakeHolderStatusListTile(
                "YAHYA BELLO",
                position: "Executive, shareholder",
                trailing: GtStatusPill(text: "Needs Action", variant: .error),
              ),
              GtStakeHolderStatusListTile(
                "LOLA ALAO",
                position: "Executive, shareholder",
                trailing: GtStatusPill(text: "Needs Action", variant: .error),
              ),
              GtStakeHolderStatusListTile(
                "Joseph Obinna",
                position: "Executive, shareholder",
                isVerified: true,
                trailing: GtStatusPill(text: "Verified", variant: .success),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        GtText('GtCopyTile', style: context.textStyles.h6()),
        const SizedBox(height: 8),
        GtCard(
          padding: context.insets.symmetricDp(
            vertical: 24.px,
            horizontal: 16.px,
          ),
          child: GtCopyTile(
            context.knobs.string(
              label: 'Copy Label',
              initialValue: 'Account Name',
            ),
            value: context.knobs.string(
              label: 'Copy Value',
              initialValue: '0123456789',
            ),
            leading: GtIcons.user,
            onCopied: () {},
          ),
        ),
        const SizedBox(height: 24),

        GtText('GtIconListTile', style: context.textStyles.h6()),
        const SizedBox(height: 8),
        GtCard(
          child: GtIconListTile(
            context.knobs.string(
              label: 'Icon Tile Title',
              initialValue: 'Notifications',
            ),
            subtitle: context.knobs.string(
              label: 'Icon Tile Sub',
              initialValue: 'Manage your alerts',
            ),
            icon: GtIcons.bell,
            onTap: () {},
          ),
        ),
        const SizedBox(height: 8),
        GtCard(
          child: GtIconListTile(
            context.knobs.string(
              label: 'Icon Tile Title',
              initialValue: 'Notifications',
            ),
            subtitle: context.knobs.string(
              label: 'Icon Tile Sub',
              initialValue: 'Manage your alerts',
            ),
            icon: GtIcons.bell,
            crossAxisAlignment: CrossAxisAlignment.center,
            onTap: () {},
          ),
        ),
        const SizedBox(height: 24),

        GtText('GtDeviceListTile', style: context.textStyles.h6()),
        const SizedBox(height: 8),
        GtCard(
          child: GtDeviceListTile(
            context.knobs.string(
              label: 'Device Title',
              initialValue: 'iPhone 13 Pro',
            ),
            subtitle: context.knobs.string(
              label: 'Device Subtitle',
              initialValue: 'Active now',
            ),
            icon: GtIcons.mobile,
          ),
        ),
        const SizedBox(height: 8),
        GtCard(
          child: GtDeviceListTile.removable(
            context.knobs.string(
              label: 'Removable Title',
              initialValue: 'Surface Pro 9',
            ),
            subtitle: context.knobs.string(
              label: 'Removable Sub',
              initialValue: 'Accra, Ghana',
            ),
            icon: GtIcons.laptop,
            buttonText: context.knobs.string(
              label: 'Device Button Text',
              initialValue: 'Remove',
            ),
            onRemove: () {},
          ),
        ),
        const SizedBox(height: 24),

        GtText('GtInstructionListTile', style: context.textStyles.h6()),
        const SizedBox(height: 8),
        GtCard(
          padding: context.insets.symmetricDp(
            vertical: 24.px,
            horizontal: 16.px,
          ),
          child: Column(
            spacing: context.spacingXl,
            children: [
              GtInstructionListTile(
                context.knobs.string(
                  label: 'Instruction Text',
                  initialValue:
                      'Follow the on-screen prompts exactly as shown as shown here and there.',
                ),
                icon: GtIcons.userSearch,
              ),
              GtInstructionListTile(
                context.knobs.string(
                  label: 'Instruction Text',
                  initialValue:
                      'Follow the on-screen prompts exactly as shown as shown here and there.',
                ),
                icon: GtIcons.camera,
              ),
              GtInstructionListTile(
                context.knobs.string(
                  label: 'Instruction Text',
                  initialValue:
                      'Follow the on-screen prompts exactly as shown here and there.',
                ),
                iconVariant: GtIconVariant.strong,
                textColor: context.palette.text.darkerSub,
                icon: GtIcons.user,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        GtText('GtIndicatorTiles', style: context.textStyles.h6()),
        const SizedBox(height: 8),
        GtCard(
          padding: context.insets.symmetricDp(
            vertical: 24.px,
            horizontal: 16.px,
          ),
          child: Column(
            spacing: context.spacingXl,
            children: [
              GtSwitchTile(
                "Allow email notifications",
                value: context.knobs.boolean(label: "Switch Value"),
                onChanged: (_) {},
              ),
              GtSwitchTile(
                "Allow email notifications",
                value: context.knobs.boolean(
                  label: "Switch Icon Value",
                  initialValue: true,
                ),
                leading: GtIcon(GtIcons.bell),
                onChanged: (_) {},
              ),
              GtSwitchTile(
                "Allow email notifications",
                value: context.knobs.boolean(
                  label: "Switch Full Value",
                  initialValue: true,
                ),
                leading: GtIcon(GtIcons.bell),
                onChanged: (_) {},
                subtitle: "Receive notifications in a timely manner",
              ),
              GtSwitchTile(
                "Allow email notifications",
                value: context.knobs.boolean(
                  label: "Switch Full Value",
                  initialValue: true,
                ),
                leading: GtIcon(GtIcons.bell),
                onChanged: (_) {},
                subtitle: "Receive notifications in a timely manner",
                footer: GtStatusPill(
                  text: "FAIRLY SECURE",
                  showBorder: false,
                  variant: .success,
                ),
              ),
              const GtDivider.base(),
              GtRadioTile(
                "Select an option",
                value: "Simple",
                groupValue: radioValue,
                onChanged: (update) {
                  radioValue = update;
                },
              ),
              GtRadioTile(
                "Select an option",
                value: "Double",
                groupValue: radioValue,
                leading: GtIcon(GtIcons.alert),
                onChanged: (update) {
                  radioValue = update;
                },
              ),
              GtRadioTile(
                "Select an option",
                value: "Triple",
                groupValue: radioValue,
                leading: GtIcon(GtIcons.vault),
                subtitle: "Please select me",
                onChanged: (update) {
                  radioValue = update;
                },
              ),
              GtRadioTile(
                "Select an option",
                value: "Triple",
                groupValue: radioValue,
                leading: GtIcon(GtIcons.calendar),
                subtitle: "Please select me",
                onChanged: (update) {
                  radioValue = update;
                },
                footer: GtStatusPill(
                  text: "FAIRLY SECURE",
                  showBorder: false,
                  variant: .away,
                ),
              ),
              const GtDivider.base(),
              GtCheckBoxTile(
                "Select an option",
                value: "Simple",
                isActive: context.knobs.boolean(
                  label: "Checkbox 1 Value",
                  initialValue: true,
                ),
                onChanged: (update) {
                  radioValue = update;
                },
              ),
              GtCheckBoxTile(
                "Select an option",
                value: "Double",
                isActive: context.knobs.boolean(
                  label: "Checkbox 2 Value",
                  initialValue: true,
                ),
                leading: GtIcon(GtIcons.fileContent),
                onChanged: (update) {
                  radioValue = update;
                },
              ),
              GtCheckBoxTile(
                "Select an option",
                value: "Triple",
                isActive: context.knobs.boolean(
                  label: "Checkbox 3 Value",
                  initialValue: false,
                ),
                leading: GtIcon(GtIcons.gear),
                subtitle: "Please select me",
                onChanged: (update) {
                  radioValue = update;
                },
              ),
              GtCheckBoxTile(
                "Select an option",
                value: "Triple",
                isActive: context.knobs.boolean(
                  label: "Checkbox 3 Value",
                  initialValue: false,
                ),
                leading: GtIcon(GtIcons.umbrella),
                subtitle: "Please select me",
                onChanged: (update) {
                  radioValue = update;
                },
                footer: GtStatusPill(
                  text: "FAIRLY SECURE",
                  showBorder: false,
                  variant: .error,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        GtText('GtMenuListTile', style: context.textStyles.h6()),
        const SizedBox(height: 8),
        GtCard(
          color: context.palette.bg.weak,
          padding: context.insets.symmetricDp(
            vertical: 24.px,
            horizontal: 16.px,
          ),
          child: Column(
            spacing: context.spacingXl,
            children: [
              GtMenuListTile<String>(
                "View Account",
                value: "account",
                icon: GtIcons.lock,
                onSelect: (value) {},
              ),
              GtMenuListTile<String>(
                "View Account",
                value: "account",
                icon: GtIcons.stopwatch,
                onSelect: (value) {},
              ),
              GtMenuListTile<String>(
                "View Account",
                value: "account",
                icon: GtIcons.shareIos,
                onSelect: (value) {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        GtText('GtTransactionListTile', style: context.textStyles.h6()),
        const SizedBox(height: 8),
        GtCard(
          child: GtTransactionListTile(
            context.knobs.string(
              label: 'Txn Name',
              initialValue: 'Netflix Subscription',
            ),
            subtitle: context.knobs.string(
              label: 'Txn Subtitle',
              initialValue: '6 OCT, 2025 10:00AM',
            ),
            amount: context.knobs.double.input(
              label: 'Txn Amount',
              initialValue: 4500.0,
            ),
            isDebit: context.knobs.boolean(
              label: 'Txn Is Debit',
              initialValue: true,
            ),
            leading: DecoratedBox(
              decoration: BoxDecoration(
                color: context.palette.error.base,
                shape: BoxShape.circle,
              ),
            ),
            onTap: () {},
          ),
        ),
        const SizedBox(height: 24),

        GtText(
          'GtTransactionParticipantListTile',
          style: context.textStyles.h6(),
        ),
        const SizedBox(height: 8),
        GtCard(
          child: Column(
            children: [
              GtTransactionParticipantListTile(
                "KENNETH OSMOSIS",
                superscript: "from",
                leading: GtNetworkImage(GtNetworkImages.shopping),
              ),
              const GtGap.yXl(),
              GtTransactionParticipantListTile(
                "SAVINGS",
                superscript: "to",
                leading: GtNetworkImage(GtNetworkImages.savings),
                subtitle: "Balance ${20400.asCurrency()}",
              ),
              const GtGap.yXl(),
              GtTransactionParticipantListTile(
                "SAM JONES",
                superscript: "to",
                crossAxisAlignment: CrossAxisAlignment.center,
                leading: DecoratedBox(
                  decoration: BoxDecoration(
                    color: context.palette.staticColors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                subtitle: "123455678890",
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        GtText('GtDualColumnListTile', style: context.textStyles.h6()),
        const SizedBox(height: 8),
        GtCard(
          padding: context.insets.allDp(12.px),
          borderRadius: 12.circularBorderRadius,
          child: Column(
            children: [
              GtDoubleColumnListTile(
                "Service",
                value: "IKEDC - Prepaid",
                valuePrefix: GtNetworkImage(
                  GtNetworkImages.emergency,
                  height: 16,
                ),
              ),
              const GtGap.yXl(),
              GtDoubleColumnListTile("Token number", value: "1234567890"),
            ],
          ),
        ),
        const GtGap.yBase(),
        GtCard(
          padding: context.insets.allDp(12.px),
          borderRadius: 12.circularBorderRadius,
          child: GtDoubleColumnListTile(
            "Category",
            value: "Bills",
            valueSuffix: GtNetworkImage(GtNetworkImages.bill),
          ),
        ),
        const GtGap.yBase(),
        GtCard(
          padding: context.insets.allDp(12.px),
          borderRadius: 12.circularBorderRadius,
          child: Column(
            children: [
              GtDoubleColumnListTile(
                "Status",
                value: "Completed",
                highlightValue: false,
              ),
              const GtGap.yXl(),
              GtDoubleColumnListTile(
                "Reference",
                value: "TRX24072983910527NGN",
                highlightValue: false,
              ),
              const GtGap.yXl(),
              GtDoubleColumnListTile(
                "Session ID",
                value: "TRX24072983910527NGN",
                highlightValue: false,
              ),
              const GtGap.yXl(),
              GtDoubleColumnListTile(
                "Fee",
                value: "N25",
                highlightValue: false,
              ),
            ],
          ),
        ),
        const SizedBox(height: 48),
      ],
    ),
  );
}
