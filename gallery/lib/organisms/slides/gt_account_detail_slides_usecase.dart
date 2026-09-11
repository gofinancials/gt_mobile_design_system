import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

typedef _Account = ({
  String id,
  String type,
  String number,
  num balance,
  String? subTitle,
});

const _catalogue = <_Account>[
  (
    id: 'sav-01',
    type: 'Savings',
    number: '0123456789',
    balance: 1284350.75,
    subTitle: 'Interest earned: ₦12,480.50',
  ),
  (
    id: 'cur-02',
    type: 'Current',
    number: '0987654321',
    balance: 96420.05,
    subTitle: 'Overdraft balance: ₦250,000.00',
  ),
  (
    id: 'dom-03',
    type: 'Domiciliary',
    number: '0456123789',
    balance: 3120.4,
    subTitle: null,
  ),
  (
    id: 'fix-04',
    type: 'Fixed Deposit',
    number: '0741852963',
    balance: 500000,
    subTitle: 'Matures 14 Mar 2027',
  ),
];

/// The pill pass-throughs, bundled so the knobs can reach the preview without
/// ten separate constructor arguments.
typedef _PillKnobs = ({
  GtAccountCopyPillVariant variant,
  String Function(GtAccountData<_Account>)? labelBuilder,
  String labelMode,
  Color? textColor,
  Color? backgroundColor,
  Color? borderColor,
  TextStyle? style,
  FontWeight? weight,
  bool showIcon,
  bool showShadow,
  BorderStyle borderStyle,
  String? semanticHint,
});

/// How the caption under the balance is composed.
///
/// Every mode leaves the copied value alone — that is always the bare account
/// number — which is the point the caption knob is here to demonstrate.
const _labelModes = ['Default', 'Title case', 'Number only', 'Type only'];

String Function(GtAccountData<_Account>)? _labelBuilder(String mode) =>
    switch (mode) {
      'Title case' => (account) =>
        '${account.type}${AppStrings.dotSeparator}${account.accountNumber}',
      'Number only' => (account) => account.accountNumber,
      'Type only' => (account) => account.type,
      // Null falls through to the widget's own composite caption.
      _ => null,
    };

@widgetbook.UseCase(name: 'GtAccountDetailSlides', type: GtAccountDetailSlides)
Widget playgroundGtAccountDetailSlidesUseCase(BuildContext context) {
  final count = context.knobs.int.slider(
    label: 'Accounts',
    initialValue: 3,
    min: 1,
    max: _catalogue.length,
    divisions: _catalogue.length - 1,
  );
  final showActions = context.knobs.boolean(
    label: 'Show action bar',
    initialValue: true,
  );
  final showSubtitles = context.knobs.boolean(
    label: 'Show subtitles',
    initialValue: true,
  );

  final labelMode = context.knobs.object.dropdown<String>(
    label: 'Pill caption',
    options: _labelModes,
    initialOption: _labelModes.first,
  );
  final variant = context.knobs.object.dropdown<GtAccountCopyPillVariant>(
    label: 'Pill variant',
    options: GtAccountCopyPillVariant.values,
    initialOption: GtAccountCopyPillVariant.personal,
    labelBuilder: (value) => value.name,
  );
  final textColor = context.knobs.colorOrNull(
    label: 'Pill text colour',
    initialValue: null,
  );
  final backgroundColor = context.knobs.colorOrNull(
    label: 'Pill background colour',
    initialValue: null,
  );
  final borderColor = context.knobs.colorOrNull(
    label: 'Pill border colour',
    initialValue: null,
  );
  final borderStyle = context.knobs.object.dropdown<BorderStyle>(
    label: 'Pill border style',
    options: BorderStyle.values,
    initialOption: BorderStyle.none,
    labelBuilder: (value) => value.name,
  );
  final weight = context.knobs.objectOrNull.dropdown<FontWeight?>(
    label: 'Pill text weight',
    options: const [null, FontWeight.w400, FontWeight.w600, FontWeight.w700],
    initialOption: null,
    labelBuilder: (value) => value == null ? 'default style' : '${value.value}',
  );
  final showIcon = context.knobs.boolean(
    label: 'Show pill copy icon',
    initialValue: false,
  );
  final showShadow = context.knobs.boolean(
    label: 'Show pill shadow',
    initialValue: false,
  );
  final semanticHint = context.knobs.string(
    label: 'Pill semantic hint',
    initialValue: 'Copies the account number to the clipboard',
  );

  // The widget resolves this itself; the gallery mirrors it so the style knob
  // can carry the same colour, as GtAccountCopyPill.style replaces rather than
  // merges the default.
  final resolvedTextColor = textColor ?? context.palette.primary.darker;

  final pill = (
    variant: variant,
    labelBuilder: _labelBuilder(labelMode),
    labelMode: labelMode,
    textColor: textColor,
    backgroundColor: backgroundColor,
    borderColor: borderColor,
    style: weight == null
        ? null
        : context.textStyles.subHeadXs(
            color: resolvedTextColor,
            heightPx: 12,
            weight: weight,
          ),
    weight: weight,
    showIcon: showIcon,
    showShadow: showShadow,
    borderStyle: borderStyle,
    semanticHint: semanticHint.isEmpty ? null : semanticHint,
  );

  String colorArg(Color? value) =>
      value == null ? 'null' : 'Color(0x${value.toARGB32().toRadixString(16)})';

  final labelBuilderSource = switch (labelMode) {
    'Title case' => "'\${account.type} • \${account.accountNumber}'",
    'Number only' => 'account.accountNumber',
    'Type only' => 'account.type',
    _ => null,
  };
  final styleSource = weight == null
      ? 'null'
      : 'context.textStyles.subHeadXs(color: ${colorArg(resolvedTextColor)}, '
            'heightPx: 12, weight: FontWeight.w${weight.value})';

  return GtWidgetDocPage(
    title: 'GtAccountDetailSlides',
    description:
        'A swipeable balance carousel: one GtBalanceText per account, a page '
        'indicator above it, a subtitle and an account pill for the selected '
        'account beneath it, and an optional GtActionButtonBar below. It is '
        'stateless — a GtAccountDataController owns both the account list and '
        'the PageController, so a swipe and a programmatic selection move the '
        'same state. The dots appear only from two accounts up, and the '
        'subtitle only for accounts with a GtAccountData.subTitle — the '
        'Domiciliary account has none. Tap the balance to toggle masking, or '
        'the pill to copy the account number.',
    code: [
      'GtAccountDetailSlides<Account>(',
      '  controller: _controller,',
      '  hidden: _hidden,',
      '  onToggleHide: () => setState(() => _hidden = !_hidden),',
      "  onIndexUpdate: (index, account) => debugPrint('\$index \$account'),",
      if (showActions) '  actions: GtActionButtonBar(buttons: [...]),',
      '  // Every GtAccountCopyPill option the slides expose. The caption is',
      '  // all these change — a tap always copies the bare account number.',
      if (labelBuilderSource != null)
        '  accountPillLabelBuilder: (account) => $labelBuilderSource,',
      '  accountPillVariant: GtAccountCopyPillVariant.${variant.name},',
      '  accountPillTextColor: ${colorArg(textColor)},',
      '  accountPillBackgroundColor: ${colorArg(backgroundColor)},',
      '  accountPillBorderColor: ${colorArg(borderColor)},',
      '  accountPillStyle: $styleSource,',
      '  showAccountPillIcon: $showIcon,',
      '  showAccountPillShadow: $showShadow,',
      '  accountPillBorderStyle: BorderStyle.${borderStyle.name},',
      '  accountPillSemanticHint: '
          '${semanticHint.isEmpty ? 'null' : "'$semanticHint'"},',
      ')',
    ].join('\n'),
    accessibilityNotes: const [
      'GtBalanceText announces the amount while visible and "Balance is '
          'hidden" while masked, so the mask holds in the accessibility tree '
          'as well as on screen.',
      'Neither the PageView nor GtScaledDots announces "account N of M". Use '
          'onIndexUpdate to announce the account that came into view, '
          'otherwise a swipe is silent.',
      'The account pill falls back to its caption as an accessibility label, '
          'so a caption of "Number only" announces a bare digit run. Set '
          'accountPillSemanticHint to say that tapping copies it.',
      'The balance row is a fixed 76dp, so at large text scales GtBalanceText '
          'scales itself down inside its FittedBox rather than growing the '
          'row. The pill has no such fallback and overflows past ~1.5x with a '
          'long caption — check both with the Accessibility addon.',
      'The whole balance line is the mask toggle, not just the eye icon, so '
          'the gesture stays comfortable at any scale.',
    ],
    child: GtCard(
      padding: context.insets.allDp(16.px),
      variant: GtCardVariant.normal,
      // Keyed on the knobs that shape the account list, so changing either
      // rebuilds the controller instead of leaving the old list attached.
      child: _AccountSlidesPreview(
        key: ValueKey((count, showSubtitles)),
        count: count,
        showSubtitles: showSubtitles,
        showActions: showActions,
        pill: pill,
      ),
    ),
  );
}

class _AccountSlidesPreview extends GtStatefulWidget {
  final int count;
  final bool showSubtitles;
  final bool showActions;
  final _PillKnobs pill;

  const _AccountSlidesPreview({
    required this.count,
    required this.showSubtitles,
    required this.showActions,
    required this.pill,
    super.key,
  });

  @override
  State<_AccountSlidesPreview> createState() => _AccountSlidesPreviewState();
}

class _AccountSlidesPreviewState extends State<_AccountSlidesPreview> {
  late final GtAccountDataController<_Account> _controller;
  bool _hidden = false;

  @override
  void initState() {
    super.initState();
    _controller = GtAccountDataController(
      accounts: [
        for (final account in _catalogue.take(widget.count))
          GtAccountData(
            id: account.id,
            type: account.type,
            accountNumber: account.number,
            balance: account.balance,
            subTitle: widget.showSubtitles ? account.subTitle : null,
            data: account,
          ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final raw = context.palette.raw;
    final white = context.palette.staticColors.white;
    final pill = widget.pill;

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        // ListenableBuilder(
        //   listenable: _controller,
        //   builder: (context, _) {
        //     final account = _controller.selectedAccount;

        //     return GtText(
        //       account == null
        //           ? 'No account selected'
        //           : 'Tapping the pill copies "${account.accountNumber}"',
        //       textAlign: .center,
        //       style: context.textStyles.subHeadS(),
        //     );
        //   },
        // ),
        // const GtGap.ySm(),
        GtAccountDetailSlides<_Account>(
          controller: _controller,
          hidden: _hidden,
          onToggleHide: () => setState(() => _hidden = !_hidden),
          onIndexUpdate: (index, account) =>
              context.showToast('${account?.type ?? 'Account'} selected'),
          accountPillLabelBuilder: pill.labelBuilder,
          accountPillVariant: pill.variant,
          accountPillTextColor: pill.textColor,
          accountPillBackgroundColor: pill.backgroundColor,
          accountPillBorderColor: pill.borderColor,
          accountPillStyle: pill.style,
          showAccountPillIcon: pill.showIcon,
          showAccountPillShadow: pill.showShadow,
          accountPillBorderStyle: pill.borderStyle,
          accountPillSemanticHint: pill.semanticHint,
          actions: widget.showActions
              ? GtActionButtonBar(
                  buttons: [
                    GtActionButton(
                      icon: GtIcons.sendSolid,
                      label: 'Send',
                      backgroundColor: raw.blue500,
                      iconColor: white,
                      onPressed: () => context.showToast('Send tapped'),
                    ),
                    GtActionButton(
                      icon: GtIcons.transfer,
                      label: 'Transfer',
                      backgroundColor: raw.purple500,
                      iconColor: white,
                      onPressed: () => context.showToast('Transfer tapped'),
                    ),
                    GtActionButton(
                      icon: GtIcons.airtime,
                      label: 'Airtime',
                      backgroundColor: raw.orange500,
                      iconColor: white,
                      onPressed: () => context.showToast('Airtime tapped'),
                    ),
                    GtActionButton(
                      icon: GtIcons.plus,
                      label: 'More',
                      backgroundColor: raw.yellow500,
                      iconColor: white,
                      onPressed: () => context.showToast('More tapped'),
                    ),
                  ],
                )
              : null,
        ),
      ],
    );
  }
}
