import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/data/constants/constants.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtDashboardScaffold', type: GtDashboardScaffold)
Widget playgroundGtDashboardScaffoldUseCase(BuildContext context) {
  final style = context.knobs.object.dropdown<GtBottomNavigationStyle>(
    label: 'Navigation Style',
    options: GtBottomNavigationStyle.values,
    initialOption: GtBottomNavigationStyle.ios,
    labelBuilder: (v) => v.name,
  );
  final isLoading = context.knobs.boolean(
    label: 'Loading',
    initialValue: false,
  );

  return GtWidgetDocPage(
    title: 'GtDashboardScaffold',
    description:
        'A complete dashboard scaffold that coordinates pages, app bars, and bottom navigation states.',
    code:
        '''
GtDashboardScaffold(
  pageController: pageController,
  bottomNavigationStyle: GtBottomNavigationStyle.${style.name},
  data: [
    GtDashboardPageData(
      page: HomePage(),
      ${isLoading ? "isLoading: true,\n      loadingSemanticsLabel: 'Loading your accounts',\n      appBar: GtHomeAppBar(isLoading: true)," : 'appBar: GtHomeAppBar(),'}
      navItem: GtBottomNavigationItem(
        selectedIcon: GtIcons.homeFilled,
        unselectedIcon: GtIcons.home,
        label: 'Home',
      ),
    ),
  ],
)''',
    child: GtEmptyStateCard(
      variant: GtCardVariant.normal,
      icon: GtIcons.alarmClock,
      description:
          'Please refer to the "GtDashboardScaffold Gallery" page in Widgetbook to preview the active dashboard scaffold layout in its full-screen interactive context.',
    ),
  );
}

@widgetbook.UseCase(
  name: 'GtDashboardScaffold Gallery',
  type: GtDashboardScaffold,
)
Widget buildGtDashboardScaffoldGallery(BuildContext context) {
  return const _DashboardScaffoldPreview();
}

class _DashboardScaffoldPreview extends GtStatefulWidget {
  const _DashboardScaffoldPreview();

  @override
  State<_DashboardScaffoldPreview> createState() =>
      _DashboardScaffoldPreviewState();
}

typedef _Account = ({
  String id,
  String type,
  String number,
  num balance,
  String currency,
});

const _accounts = <_Account>[
  (
    id: 'sav-01',
    type: 'Savings',
    number: '0123456789',
    balance: 1284350.75,
    currency: AppStrings.naira,
  ),
  (
    id: 'cur-02',
    type: 'Current',
    number: '0987654321',
    balance: 96420.05,
    currency: AppStrings.dollar,
  ),
  (
    id: 'dom-03',
    type: 'Domiciliary',
    number: '0456123789',
    balance: 3120.4,
    currency: AppStrings.euro,
  ),
  (
    id: 'dom-04',
    type: 'Domiciliary',
    number: '0456123790',
    balance: 5000,
    currency: AppStrings.pound,
  ),
];

class _DashboardScaffoldPreviewState extends State<_DashboardScaffoldPreview> {
  final _pageController = ValueNotifier(0);

  late final GtAccountDataController<_Account> _accountController;

  final _loadingAccountController = GtAccountDataController<_Account>(
    accounts: const [],
  );

  bool _hidden = false;

  final List<GtBottomNavigationItem> _items = const [
    GtBottomNavigationItem(
      selectedIcon: GtIcons.homeFilled,
      unselectedIcon: GtIcons.home,
      label: 'Home',
    ),
    GtBottomNavigationItem(
      selectedIcon: GtIcons.walletAltFilled,
      unselectedIcon: GtIcons.walletAlt,
      label: 'Payments',
    ),
    GtBottomNavigationItem(
      selectedIcon: GtIcons.productFilled,
      unselectedIcon: GtIcons.product,
      label: 'Products',
    ),
    GtBottomNavigationItem(
      selectedIcon: GtIcons.cardFilled,
      unselectedIcon: GtIcons.card,
      label: 'Cards',
    ),
  ];

  void _toggleHidden() => setState(() => _hidden = !_hidden);

  Widget _getHomePage(GtAccountDataController<_Account> controller) {
    final raw = context.palette.raw;
    final white = context.palette.staticColors.white;

    return Padding(
      padding: context.insets.symmetricDp(vertical: 24.px),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: GtAccountDetailSlides<_Account>(
              controller: controller,
              hidden: _hidden,
              onToggleHide: _toggleHidden,
              actions: GtActionButtonBar(
                padding: context.insets.symmetricDp(horizontal: 26.5.px),
                buttons: [
                  GtActionButton(
                    icon: GtIcons.circleInfo,
                    label: 'Details',
                    backgroundColor: raw.green500,
                    iconColor: white,
                    onPressed: () => context.showToast('Send tapped'),
                  ),
                  GtActionButton(
                    icon: GtIcons.arrowNorthEastThin,
                    label: 'Send',
                    backgroundColor: raw.tealBlue600,
                    iconColor: white,
                    onPressed: () => context.showToast('Transfer tapped'),
                  ),
                  GtActionButton(
                    icon: GtIcons.exchange,
                    label: 'Move',
                    backgroundColor: raw.pink500,
                    iconColor: white,
                    onPressed: () => context.showToast('Airtime tapped'),
                  ),
                  GtActionButton(
                    icon: GtIcons.fileContent,
                    label: 'Recharge',
                    backgroundColor: raw.yellow500,
                    iconColor: white,
                    onPressed: () => context.showToast('More tapped'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<GtDashboardPageData> _getData({required bool isLoading}) => [
    GtDashboardPageData(
      page: _getHomePage(
        isLoading ? _loadingAccountController : _accountController,
      ),
      isLoading: isLoading,
      loadingSemanticsLabel: 'Loading your accounts',
      appBar: GtHomeAppBar(
        isLoading: isLoading,
        userFullName: "Alex Lobaloba",
        onClickHelp: () {},
        helpSemanticsLabel: "Help",
        onToggleAccounts: () {},
        toggleAccountText: "All Accounts",
        toggleAccountSemanticsLabel: "Switch account, All Accounts",
      ),
      navItem: _items[0],
      showGradient: true,
    ),
    GtDashboardPageData(
      appBar: GtTitleAppBar(title: "Cards"),
      page: Center(child: GtText('Cards Page', style: context.textStyles.h6())),
      navItem: _items[1],
    ),
    GtDashboardPageData(
      appBar: GtTitleAppBar(title: "Cards"),
      page: Center(child: GtText('Cards Page', style: context.textStyles.h6())),
      navItem: _items[2],
    ),
    GtDashboardPageData(
      appBar: GtTitleAppBar(title: "Cards"),
      page: Center(child: GtText('Cards Page', style: context.textStyles.h6())),
      navItem: _items[3],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _accountController = GtAccountDataController(
      accounts: [
        for (final account in _accounts)
          GtAccountData(
            id: account.id,
            type: account.type,
            accountNumber: account.number,
            balance: account.balance,
            data: account,
            currency: account.currency,
          ),
      ],
    );
  }

  @override
  void dispose() {
    _accountController.dispose();
    _loadingAccountController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.knobs.boolean(
      label: 'Loading',
      initialValue: false,
    );

    return GtDashboardScaffold(
      onClickHelp: () {},
      data: _getData(isLoading: isLoading),
      pageController: _pageController,
      bottomNavigationStyle: context.knobs.object
          .dropdown<GtBottomNavigationStyle>(
            label: "Bottom Navigation Style",
            options: GtBottomNavigationStyle.values,
            initialOption: GtBottomNavigationStyle.ios,
            labelBuilder: (value) => value.name,
          ),
    );
  }
}
