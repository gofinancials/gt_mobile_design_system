import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final countries = AppCountryUtility.searchCountries("23");

@widgetbook.UseCase(name: 'GtListTiles', type: GtListTile)
Widget gtListTileAllUseCase(BuildContext context) {
  // -----------------------------------------------------------------------
  // KNOBS FOR DYNAMIC RENDERING
  // -----------------------------------------------------------------------

  // Indicator Knobs
  String radioValue = context.knobs.object.dropdown(
    label: "Radio Options",
    initialOption: "Simple",
    options: ["Simple", "Double", "Triple"],
  );
  final switchVal1 = context.knobs.boolean(
    label: "Switch 1 Active",
    initialValue: false,
  );
  final switchVal2 = context.knobs.boolean(
    label: "Switch Icon Active",
    initialValue: true,
  );
  final switchVal3 = context.knobs.boolean(
    label: "Switch Full Active",
    initialValue: true,
  );
  final checkVal1 = context.knobs.boolean(
    label: "Checkbox 1 Active",
    initialValue: true,
  );
  final checkVal2 = context.knobs.boolean(
    label: "Checkbox 2 Active",
    initialValue: true,
  );
  final checkVal3 = context.knobs.boolean(
    label: "Checkbox 3 Active",
    initialValue: false,
  );

  // Transaction & Limit Knobs
  final txnName = context.knobs.string(
    label: 'Txn Name',
    initialValue: 'Netflix Subscription',
  );
  final txnSubtitle = context.knobs.string(
    label: 'Txn Subtitle',
    initialValue: '6 OCT, 2025 10:00AM',
  );
  final txnAmount = context.knobs.double.input(
    label: 'Txn Amount',
    initialValue: 4500.0,
  );
  final txnIsDebit = context.knobs.boolean(
    label: 'Txn Is Debit',
    initialValue: true,
  );
  final limitInfoLabel = context.knobs.string(
    label: 'Limit Info Label',
    initialValue: 'Current single airtime limit',
  );
  final limitInfoText = context.knobs.string(
    label: 'Limit Info Text',
    initialValue: 'N5,000,000.00',
  );
  final limitAirtime = context.knobs.double.slider(
    label: "Airtime Limit",
    min: 0,
    max: 80000,
    initialValue: 10000,
  );
  final limitBills = context.knobs.double.slider(
    label: "Bills Limit",
    min: 0,
    max: 80000,
    initialValue: 10000,
  );

  // Account & User Knobs
  final accountTitle = context.knobs.string(
    label: 'Account Title',
    initialValue: 'Savings Account',
  );
  final accountSubtitle = context.knobs.string(
    label: 'Account Subtitle',
    initialValue: 'USD',
  );
  final boldAccountSub = context.knobs.boolean(
    label: 'Bold Account Subtitle',
    initialValue: true,
  );

  // Status Knobs
  final stepIllusPath = context.knobs.string(
    label: 'Step Illus Path',
    initialValue: GtVectorIllustrations.identification,
  );
  final stepTitle = context.knobs.string(
    label: 'Step Title',
    initialValue: 'Step 1: Verification',
  );
  final stepSubtitle = context.knobs.string(
    label: 'Step Subtitle',
    initialValue:
        'Ask your parent to open your profile from their ‘Accounts’ in their onebank app',
  );

  // Info & Action Knobs
  final inputLabel = context.knobs.string(
    label: 'Input Label',
    initialValue: 'Account Number',
  );
  final inputText = context.knobs.string(
    label: 'Input Text',
    initialValue: '1234567890',
  );
  final cardInputLabel = context.knobs.string(
    label: 'Card Input Label',
    initialValue: 'Bank Info',
  );
  final cardInputText = context.knobs.string(
    label: 'Card Input Text',
    initialValue: '0987654321',
  );
  final copyLabel = context.knobs.string(
    label: 'Copy Label',
    initialValue: 'Account Name',
  );
  final copyValue = context.knobs.string(
    label: 'Copy Value',
    initialValue: '0123456789',
  );
  final deviceTitle = context.knobs.string(
    label: 'Device Title',
    initialValue: 'iPhone 13 Pro',
  );
  final deviceSubtitle = context.knobs.string(
    label: 'Device Subtitle',
    initialValue: 'Active now',
  );
  final removableTitle = context.knobs.string(
    label: 'Removable Title',
    initialValue: 'Surface Pro 9',
  );
  final removableSub = context.knobs.string(
    label: 'Removable Sub',
    initialValue: 'Accra, Ghana',
  );
  final deviceBtnText = context.knobs.string(
    label: 'Device Button Text',
    initialValue: 'Remove',
  );
  final instructionText = context.knobs.string(
    label: 'Instruction Text',
    initialValue:
        'Follow the on-screen prompts exactly as shown here and there.',
  );

  // Foundational Knobs
  final basicText = context.knobs.string(
    label: 'Basic Text',
    initialValue: 'Reminders',
  );
  final iconTileTitle = context.knobs.string(
    label: 'Icon Tile Title',
    initialValue: 'Notifications',
  );
  final iconTileSub = context.knobs.string(
    label: 'Icon Tile Sub',
    initialValue: 'Manage your alerts',
  );

  // -----------------------------------------------------------------------
  // LAYOUT
  // -----------------------------------------------------------------------
  final children = [
    GalleryPageHeader(
      title: "List Tiles",
      rider: "GtListTiles",
      sectionHeader:
          "Interactive Indicators [GtSwitchTile/GtRadioTile/GtCheckBoxTile]",
    ),

    GtCard(
      padding: context.insets.symmetricDp(vertical: 24.px, horizontal: 16.px),
      child: Column(
        spacing: context.spacingXl,
        children: [
          GtSwitchTile(
            "Allow email notifications",
            value: switchVal1,
            onChanged: (_) {},
          ),
          GtSwitchTile(
            "Allow email notifications",
            value: switchVal2,
            leading: GtIcon(GtIcons.bell),
            onChanged: (_) {},
          ),
          GtSwitchTile(
            "Allow email notifications",
            value: switchVal3,
            leading: GtIcon(GtIcons.bell),
            onChanged: (_) {},
            subtitle: "Receive notifications in a timely manner",
            footer: GtButtonPill(
              text: "FAIRLY SECURE",
              variant: .featured,
              alignment: .centerLeft,
            ),
          ),
          const GtDivider.base(),
          GtRadioTile(
            "Select an option",
            value: "Simple",
            groupValue: radioValue,
            radioStyle: .donut,
            onChanged: (_) {},
          ),
          GtRadioTile(
            "Select an option",
            value: "Double",
            groupValue: radioValue,
            leading: GtIcon(GtIcons.alert),
            onChanged: (_) {},
          ),
          GtRadioTile(
            "Select an option",
            value: "Triple",
            groupValue: radioValue,
            leading: GtIcon(GtIcons.vault),
            subtitle: "Please select me",
            onChanged: (_) {},
          ),
          GtRadioTile(
            "Select an option",
            value: "Triple",
            groupValue: radioValue,
            leading: GtIcon(GtIcons.calendar),
            subtitle: "Please select me",
            onChanged: (_) {},
            footer: GtButtonPill(
              text: "FAIRLY SECURE",
              variant: .away,
              alignment: .centerLeft,
            ),
          ),
          const GtDivider.base(),
          GtCheckBoxTile(
            "Select an option",
            value: "Simple",
            isActive: checkVal1,
            onChanged: (_) {},
          ),
          GtCheckBoxTile(
            "Select an option",
            value: "Double",
            isActive: checkVal2,
            leading: GtIcon(GtIcons.fileContent),
            onChanged: (_) {},
          ),
          GtCheckBoxTile(
            "Select an option",
            value: "Triple",
            isActive: checkVal3,
            leading: GtIcon(GtIcons.gear),
            subtitle: "Please select me",
            onChanged: (_) {},
          ),
          GtCheckBoxTile(
            "Select an option",
            value: "Triple",
            isActive: checkVal3,
            leading: GtIcon(GtIcons.umbrella),
            subtitle: "Please select me",
            onChanged: (_) {},
            footer: GtButtonPill(
              text: "FAIRLY SECURE",
              variant: .error,
              alignment: .centerLeft,
            ),
          ),
        ],
      ),
    ),

    // --- 2. TRANSACTIONS & FINANCIALS ---
    const GalleryPageSectionHeader(
      title:
          "Transactions & Financials [GtTransactionListTile/GtLimitInfoListTile/GtLimitEditListTile/GtDoubleColumnListTile/GtLimitInfoListTile/GtGoalProgressListTile]",
    ),

    GtCard(
      child: GtTransactionListTile(
        txnName,
        subtitle: txnSubtitle,
        amount: txnAmount,
        isDebit: txnIsDebit,
        leading: DecoratedBox(
          decoration: BoxDecoration(
            color: context.palette.error.base,
            shape: BoxShape.circle,
          ),
        ),
        onTap: () {},
      ),
    ),
    const GtGap.yXl(),
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
    const GtGap.yXl(),
    GtCard(
      padding: context.insets.allDp(12.px),
      borderRadius: 12.circularBorderRadius,
      child: Column(
        children: [
          GtDoubleColumnListTile(
            "Service",
            value: "IKEDC - Prepaid",
            valuePrefix: GtNetworkImage(GtNetworkImages.emergency, height: 16),
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
          GtDoubleColumnListTile("Fee", value: "N25", highlightValue: false),
        ],
      ),
    ),
    const GtGap.yBase(),
    GtCard(child: GtLimitInfoListTile(limitInfoLabel, value: limitInfoText)),
    const GtGap.yBase(),
    GtCard(
      padding: context.insets.allDp(16.px),
      child: Column(
        children: [
          GtLimitEditListTile(
            "Airtime",
            value: limitAirtime,
            max: 80000,
            onEdit: () {},
          ),
          const GtGap.yLg(),
          GtLimitEditListTile(
            "Bill Payments",
            value: limitBills,
            max: 80000,
            onEdit: () {},
          ),
        ],
      ),
    ),
    const GtGap.yBase(),
    GtGoalProgressListTile(
      currentAmount: context.knobs.double.slider(
        label: "Goal Progress",
        initialValue: 500,
        min: 0,
        max: 1000000,
      ),
      goalAmount: 1000000,
      onEdit: () {},
    ),

    // --- 3. USER & ACCOUNT PROFILES ---
    const GalleryPageSectionHeader(
      title:
          "User & Account Profiles [GtAccountListTile/GtContactListTile/GtStakeHolderListTile/GtStakeHolderStatusListTile]",
    ),
    GtCard(
      child: Column(
        children: [
          GtAccountListTile(
            accountTitle,
            subtitle: accountSubtitle,
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
            hasBoldSubtitle: boldAccountSub,
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
    const GtGap.yXl(),
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
    const GtGap.yXl(),
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
    const GtGap.yXl(),
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

    // --- 4. SELECTION & MENUS ---
    const GalleryPageSectionHeader(
      title:
          "Selection & Menus [GtSelectionListTile/GtMenuListTile/GtCountrySelectionListTile/GtStatusListTile]",
    ),

    GtCard(
      padding: context.insets.allDp(16.px),
      child: Column(
        children: [
          GtSelectionListTile(
            "FIRS",
            isSelected: true,
            value: "firs",
            onSelect: (value) {},
          ),
          const GtGap.yBase(),
          GtSelectionListTile(
            "IKEDC",
            isSelected: false,
            value: "ikedc",
            onSelect: (value) {},
          ),
          const GtGap.yBase(),
          GtSelectionListTile(
            "IBEDC",
            isSelected: false,
            value: "ikedc",
            leading: GtNetworkImage(GtNetworkImages.gym),
            onSelect: (value) {},
          ),
        ],
      ),
    ),
    const GtGap.yXl(),
    GtCard(
      padding: context.insets.allDp(16.px),
      child: Column(
        children: [
          GtSelectionListTile.withDescription(
            "Owner",
            description:
                "Full account control with ability to initiate and authorize all transactions",
            isSelected: true,
            value: "firs",
            onSelect: (value) {},
          ),
          const GtGap.yLg(),
          GtSelectionListTile.withDescription(
            "Co-Owner",
            description:
                "Shared ownership with full access; can initiate or authorize, but not both on same transaction",
            isSelected: false,
            value: "firs",
            onSelect: (value) {},
          ),
          const GtGap.yLg(),
          GtSelectionListTile.withDescription(
            "Processor",
            description:
                "Can initiate transactions and invoices; but requires Owner/Co-Owner approval",
            isSelected: false,
            value: "firs",
            onSelect: (value) {},
          ),
          const GtGap.yLg(),
          GtSelectionListTile.withDescription(
            "Accountant",
            description:
                "CView-only access to balances, transactions, and statements for reporting",
            isSelected: false,
            value: "firs",
            onSelect: (value) {},
          ),
          const GtGap.yLg(),
          GtSelectionListTile.withDescription(
            "View-Only",
            description:
                "Read-only access to account balances and transaction history",
            isSelected: false,
            value: "firs",
            onSelect: (value) {},
          ),
        ],
      ),
    ),
    const GtGap.yXl(),
    GtSelectionListTile.forRole(
      "Director",
      description: "Chief executive officer, director or both",
      isSelected: true,
      value: "firs",
      asCard: true,
      onSelect: (value) {},
    ),
    const GtGap.yBase(),
    GtSelectionListTile.forRole(
      "Shareholder",
      description: "Company ownership is either 5% or more",
      isSelected: false,
      value: "firs",
      asCard: true,
      onSelect: (value) {},
      footer: GtCard(
        color: GtColors.transparent.value,
        border: BorderSide(color: context.palette.stroke.strong, width: 2),
        child: GtSizedBox(height: 38),
      ),
    ),
    const GtGap.yBase(),
    GtSelectionListTile.forRole(
      "Signatory",
      description: "This person also have a signatory role",
      isSelected: false,
      value: "firs",
      asCard: true,
      onSelect: (value) {},
      footer: GtCard(
        color: GtColors.transparent.value,
        border: BorderSide(color: context.palette.stroke.strong, width: 2),
        child: GtSizedBox(height: 38),
      ),
    ),
    const GtGap.yXl(),
    GtCard(
      padding: context.insets.allDp(16.px),
      child: FutureBuilder(
        future: countries,
        builder: (_, task) {
          if (task.isLoading) return GtSpinner();
          if (task.hasError || !task.hasData) {
            return GtText(task.error.toString());
          }
          return Column(
            children: [
              for (final country in task.data!)
                Padding(
                  padding: context.insets.onlyDp(bottom: 12.px),
                  child: GtCountrySelectionListTile(
                    country,
                    isSelected: country == task.data.tryFirst,
                    onSelect: (_) {},
                  ),
                ),
            ],
          );
        },
      ),
    ),
    const GtGap.yXl(),
    GtCard(
      color: context.palette.bg.weak,
      padding: context.insets.symmetricDp(vertical: 24.px, horizontal: 16.px),
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

    // --- 5. STATUS & PROGRESSION ---
    const GalleryPageSectionHeader(
      title: "Status & Progression [GtStatusListTile/GtIllustratedStepTile]",
    ),

    GtIllustratedStepTile.card(
      illustrationPath: stepIllusPath,
      title: stepTitle,
      subtitle: stepSubtitle,
    ),
    const GtGap.yXl(),
    GtStatusListTile.card(
      icon: GtIcons.file,
      title: "CAC DOCUMENTS",
      subtitle:
          "Your official registration certificate issued by the Corporate Affairs Commission",
      footer: GtStatusPill(
        text: "Pending",
        variant: .away,
        alignment: .centerLeft,
      ),
      onPressed: () {},
    ),
    const GtGap.yBase(),
    GtStatusListTile.card(
      icon: GtIcons.tasks,
      title: "Status Report",
      isDone: true,
      footer: GtStatusPill(
        text: "Uploaded",
        variant: .success,
        alignment: .centerLeft,
      ),
      subtitle:
          "Your official registration certificate issued by the Corporate Affairs Commission",
      onPressed: () {},
    ),

    // --- 6. INFORMATION & ACTIONS ---
    const GalleryPageSectionHeader(
      title:
          "Information & Actions [GtInputListTile/GtCopyTile/GtExportListTile/GtDeviceListTile/GtInstructionListTile]",
    ),

    GtCard(
      child: GtInputListTile(inputLabel, text: inputText, onTap: () {}),
    ),
    const GtGap.yBase(),
    GtInputListTile.asCard(
      cardInputLabel,
      text: cardInputText,
      leading: const GtIcon(GtIcons.house),
      onTap: () {},
    ),
    const GtGap.yXl(),
    GtCard(
      padding: context.insets.symmetricDp(vertical: 24.px, horizontal: 16.px),
      child: GtCopyTile(
        copyLabel,
        value: copyValue,
        leading: GtIcons.user,
        onCopied: (text) {
          context.showToast(
            "Copied $text to clipboard",
            icon: GtIcons.fileContent,
            type: .verified,
          );
        },
      ),
    ),
    const GtGap.yXl(),
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
    const GtGap.yXl(),
    GtCard(
      child: GtDeviceListTile(
        deviceTitle,
        subtitle: deviceSubtitle,
        icon: GtIcons.mobile,
      ),
    ),
    const GtGap.yBase(),
    GtCard(
      child: GtDeviceListTile.removable(
        removableTitle,
        subtitle: removableSub,
        icon: GtIcons.laptop,
        buttonText: deviceBtnText,
        onRemove: () {},
      ),
    ),
    const GtGap.yXl(),
    GtCard(
      padding: context.insets.symmetricDp(vertical: 24.px, horizontal: 16.px),
      child: Column(
        spacing: context.spacingXl,
        children: [
          GtInstructionListTile(instructionText, icon: GtIcons.userSearch),
          GtInstructionListTile(instructionText, icon: GtIcons.camera),
          GtInstructionListTile(
            instructionText,
            iconVariant: GtIconVariant.strong,
            textColor: context.palette.text.darkerSub,
            icon: GtIcons.user,
          ),
        ],
      ),
    ),

    // --- 7. FOUNDATIONAL TILES ---
    const GalleryPageSectionHeader(
      title: "Foundational Tiles [GtListTile/GtIconListTile]",
    ),

    GtCard(
      child: GtListTile(
        text: basicText,
        leading: GtIcon(GtIcons.bell, size: context.dp(24.px)),
        trailing: GtIcon(
          GtIcons.chevronRight,
          size: context.dp(16.px),
          variant: GtIconVariant.soft,
        ),
        onTap: () {},
      ),
    ),
    const GtGap.yBase(),
    GtCard(
      child: GtListTile(
        text: "Profile Settings",
        leading: GtIcon(GtIcons.bell, size: context.dp(24.px)),
        onTap: () {},
      ),
    ),
    const GtGap.yXl(),
    GtCard(
      child: GtIconListTile(
        iconTileTitle,
        subtitle: iconTileSub,
        icon: GtIcons.bell,
        onTap: () {},
      ),
    ),
    const GtGap.yBase(),
    GtCard(
      child: GtIconListTile(
        iconTileTitle,
        subtitle: iconTileSub,
        icon: GtIcons.bell,
        crossAxisAlignment: CrossAxisAlignment.center,
        onTap: () {},
      ),
    ),
    const GtGap.ySectionSm(),
  ];

  return Scaffold(
    key: PageStorageKey("List Tiles"),
    body: ListView.builder(
      key: PageStorageKey("List Tiles List"),
      padding: context.insets.defaultAllInsets,
      itemBuilder: (_, index) => children[index],
      itemCount: children.length,
    ),
  );
}
