import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A specialized compound input field designed for money transfer screens.
///
/// This widget creates a cohesive visual block containing the sender's details,
/// a stylized amount input field, the recipient's details, and an optional
/// note field. It handles basic balance validation and custom visual styling natively.
class GtTransferField extends GtStatefulWidget {
  /// The controller used to read and manipulate the transfer amount input.
  final GtInputController amountController;

  /// The controller used to read and manipulate the note or description input.
  final GtInputController noteController;

  /// The controller that manages the category of the transfer.
  final GtTransactionCategoryController? categoryController;

  /// The hint text displayed inside the note input field.
  final String noteHint;

  /// Callback invoked whenever the amount changes.
  final OnChanged<String?>? onAmountChanged;

  /// Callback invoked whenever the note changes.
  final OnChanged<String?>? onNoteChanged;

  /// Callback invoked whenever the category changes.
  final OnChanged<GtTransactionCategory?>? onCategoryChanged;

  /// Whether the transfer field is interactive and can be modified. Defaults to true.
  final bool isEnabled;

  /// The minimum allowable amount for the transfer.
  final num? min;

  /// The maximum allowable amount for the transfer.
  final num? max;

  /// The icon to display between the two participants.
  final Widget? middleIcon;

  /// The first participant in the transfer.
  final GtTransferParticipantData firstParticipant;

  /// The second participant in the transfer.
  final GtTransferParticipantData secondParticipant;

  /// Creates a new [GtTransferField].
  const GtTransferField({
    super.key,
    required this.amountController,
    required this.noteController,
    required this.firstParticipant,
    required this.secondParticipant,
    required this.noteHint,
    this.categoryController,
    this.onAmountChanged,
    this.onNoteChanged,
    this.onCategoryChanged,
    this.isEnabled = true,
    this.max,
    this.min,
    this.middleIcon,
  });

  @override
  State<GtTransferField> createState() => _GtTransferFieldState();
}

class _GtTransferFieldState extends State<GtTransferField> {
  double get balance {
    final first = widget.firstParticipant;
    final second = widget.secondParticipant;
    double? value;

    if (first.validate) value = first.balance;
    if (second.validate) value = second.balance;

    return value ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final first = widget.firstParticipant;
    final second = widget.secondParticipant;
    final separator = GtSvg(
      GtVectors.trendDown,
      width: context.dp(20.px),
      isDecorative: true,
    );

    return FormField(
      initialValue: widget.amountController.controller,
      validator: (text) {
        if (widget.min != null || widget.max != null) {
          return AppValidators.amountValidator(
            text?.text,
            minAmount: widget.min,
            maxAmount: min(balance, widget.max ?? 0),
          );
        }
        return AppValidators.balanceValidator(
          widget.amountController.text,
          balance: balance,
        );
      },
      builder: (field) {
        GtInputDecoration decoration = context.inputStyles.transferInputStyle;
        String? footer;
        TextStyle? subStyle;

        if (field.hasError) {
          footer = field.errorText;
          subStyle = decoration.errorStyle;
          decoration = decoration.copyWith(
            textStyle: decoration.textStyle.copyWith(
              color: context.palette.error.base,
            ),
          );
        }

        final textField = GtTextField(
          key: PageStorageKey("$balance-${first.label}-${second.label}"),
          decoration: decoration,
          isEnabled: widget.isEnabled,
          hintText: "0.00",
          inputFormatters: [AppAmountFormatter()],
          controller: widget.amountController,
          textAlign: .end,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: widget.onAmountChanged,
          autofillHints: const [AutofillHints.transactionAmount],
          autoCorrect: false,
        );

        return Column(
          crossAxisAlignment: .stretch,
          children: [
            GtCard(
              padding: context.insets.symmetricDp(
                vertical: 16.px,
                horizontal: 12.px,
              ),
              child: Column(
                mainAxisAlignment: .center,
                crossAxisAlignment: .stretch,
                children: [
                  _GtTransferParticipantWidget(
                    key: ValueKey(first.label),
                    data: first,
                    footerSuffix: first.validate ? footer : null,
                    footerStyle: first.validate ? subStyle : null,
                    crossAxisAlignment: .start,
                  ),
                  const GtGap.yBase(),
                  Row(
                    spacing: context.spacingSectionSm,
                    children: [
                      GtSizedBox(
                        height: 90,
                        width: 20,
                        child: FractionalTranslation(
                          translation: Offset(.5, 0),
                          child: CustomPaint(
                            painter: GtCenterLinePainter(
                              color: context.palette.stroke.soft,
                            ),
                            child: Center(
                              child: widget.middleIcon ?? separator,
                            ),
                          ),
                        ),
                      ),
                      Expanded(child: textField),
                    ],
                  ),
                  const GtGap.yMd(),
                  _GtTransferParticipantWidget(
                    key: ValueKey(second.label),
                    data: second,
                    footerSuffix: second.validate ? footer : null,
                    footerStyle: second.validate ? subStyle : null,
                  ),
                ],
              ),
            ),
            Align(
              alignment: .center,
              child: GtSizedBox(
                width: 20,
                height: context.spacingMd,
                child: RepaintBoundary(
                  child: ClipPath(
                    clipper: ConcaveRadiusClipper(),
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: context.palette.bg.weak),
                    ),
                  ),
                ),
              ),
            ),
            GtTransferCategoryField(
              controller: widget.categoryController,
              onChanged: widget.onCategoryChanged,
              leading: GtTextField(
                controller: widget.noteController,
                hintText: widget.noteHint,
                isEnabled: widget.isEnabled,
                decoration: context.inputStyles.plainDecoration,
                onChanged: widget.onNoteChanged,
              ),
            ),
          ],
        );
      },
    );
  }
}

/// A specialized compound input field designed for FX money transfer screens.
class GtFxTransferField extends GtStatefulWidget {
  /// The controller for the source amount input field.
  final GtInputController sourceAmountController;

  /// The controller for the target amount input field.
  final GtInputController targetAmountController;

  /// The controller for the note input field.
  final GtInputController noteController;

  /// The controller that manages the category of the transfer.
  final GtTransactionCategoryController? categoryController;

  /// The hint text displayed inside the note input field.
  final String noteHint;

  /// Callback invoked whenever the source amount changes.
  final OnChanged<String?>? onSourceAmountChanged;

  /// Callback invoked whenever the target amount changes.
  final OnChanged<String?>? onTargetAmountChanged;

  /// Callback invoked whenever the note changes.
  final OnChanged<String?>? onNoteChanged;

  /// Callback invoked whenever the category changes.
  final OnChanged<GtTransactionCategory?>? onCategoryChanged;

  /// Whether the transfer field is interactive and can be modified. Defaults to true.
  final bool isEnabled;

  /// The minimum allowable amount for the transfer.
  final num? min;

  /// The maximum allowable amount for the transfer.
  final num? max;

  /// The icon to display between the two participants.
  final Widget? middleIcon;

  /// The first participant in the transfer.
  final GtTransferParticipantData firstParticipant;

  /// The second participant in the transfer.
  final GtTransferParticipantData secondParticipant;

  /// The content to display between the two participants.
  final Widget? child;

  /// Creates a new [GtTransferField].
  const GtFxTransferField({
    super.key,
    required this.sourceAmountController,
    required this.targetAmountController,
    required this.noteController,
    required this.firstParticipant,
    required this.secondParticipant,
    required this.noteHint,
    this.categoryController,
    this.onCategoryChanged,
    this.onSourceAmountChanged,
    this.onTargetAmountChanged,
    this.onNoteChanged,
    this.isEnabled = true,
    this.max,
    this.min,
    this.middleIcon,
    this.child,
  });

  @override
  State<GtFxTransferField> createState() => _GtFxTransferFieldState();
}

class _GtFxTransferFieldState extends State<GtFxTransferField> {
  double get balance {
    final first = widget.firstParticipant;
    final second = widget.secondParticipant;
    double? value;

    if (first.validate) value = first.balance;
    if (second.validate) value = second.balance;

    return value ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final first = widget.firstParticipant;
    final second = widget.secondParticipant;
    final separator = GtSvg(
      GtVectors.trendDown,
      width: context.dp(20.px),
      isDecorative: true,
    );

    return FormField(
      initialValue: widget.sourceAmountController.controller,
      validator: (text) {
        if (widget.min != null || widget.max != null) {
          return AppValidators.amountValidator(
            text?.text,
            minAmount: widget.min,
            maxAmount: min(balance, widget.max ?? 0),
          );
        }
        return AppValidators.balanceValidator(
          widget.sourceAmountController.text,
          balance: balance,
        );
      },
      builder: (field) {
        GtInputDecoration decoration = context.inputStyles.fxTransferInputStyle;
        String? footer;
        TextStyle? subStyle;

        if (field.hasError) {
          footer = field.errorText;
          subStyle = decoration.errorStyle;
          decoration = decoration.copyWith(
            textStyle: decoration.textStyle.copyWith(
              color: context.palette.error.base,
            ),
          );
        }

        final sourceField = GtTextField(
          key: PageStorageKey("$balance-${first.label}-${second.label}"),
          decoration: decoration,
          isEnabled: widget.isEnabled,
          hintText: "0.00",
          inputFormatters: [AppAmountFormatter()],
          controller: widget.sourceAmountController,
          textAlign: .end,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: widget.onSourceAmountChanged,
          autofillHints: const [AutofillHints.transactionAmount],
          autoCorrect: false,
        );

        final targetField = GtTextField(
          key: PageStorageKey("$balance-${first.label}-${second.label}"),
          decoration: decoration,
          isEnabled: widget.isEnabled,
          hintText: "0.00",
          inputFormatters: [AppAmountFormatter()],
          controller: widget.targetAmountController,
          textAlign: .end,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: widget.onTargetAmountChanged,
          autofillHints: const [AutofillHints.transactionAmount],
          autoCorrect: false,
        );

        return Column(
          crossAxisAlignment: .stretch,
          children: [
            GtCard(
              padding: context.insets.symmetricDp(
                vertical: 16.px,
                horizontal: 12.px,
              ),
              child: Column(
                mainAxisAlignment: .center,
                crossAxisAlignment: .stretch,
                children: [
                  Row(
                    spacing: context.spacingSm,
                    children: [
                      Expanded(
                        flex: 6,
                        child: _GtTransferParticipantWidget(
                          key: ValueKey(first.label),
                          data: first,
                          footerSuffix: first.validate ? footer : null,
                          footerStyle: first.validate ? subStyle : null,
                          crossAxisAlignment: .start,
                          maxLines: 1,
                        ),
                      ),
                      Expanded(flex: 4, child: sourceField),
                    ],
                  ),
                  const GtGap.yBase(),
                  Row(
                    spacing: context.spacingSectionMd,
                    children: [
                      GtSizedBox(
                        height: 90,
                        width: 20,
                        child: FractionalTranslation(
                          translation: Offset(.5, 0),
                          child: CustomPaint(
                            painter: GtCenterLinePainter(
                              color: context.palette.stroke.soft,
                            ),
                            child: Center(
                              child: widget.middleIcon ?? separator,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: .horizontal,
                          physics: const GtMarqueeScrollPhysics(),
                          child: widget.child ?? const SizedBox.shrink(),
                        ),
                      ),
                    ],
                  ),
                  const GtGap.yMd(),
                  Row(
                    spacing: context.spacingSm,
                    children: [
                      Expanded(
                        flex: 6,
                        child: _GtTransferParticipantWidget(
                          key: ValueKey(second.label),
                          data: second,
                          footerSuffix: second.validate ? footer : null,
                          footerStyle: second.validate ? subStyle : null,
                          maxLines: 1,
                        ),
                      ),
                      Expanded(flex: 4, child: targetField),
                    ],
                  ),
                ],
              ),
            ),
            Align(
              alignment: .center,
              child: GtSizedBox(
                width: 20,
                height: context.spacingMd,
                child: RepaintBoundary(
                  child: ClipPath(
                    clipper: ConcaveRadiusClipper(),
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: context.palette.bg.weak),
                    ),
                  ),
                ),
              ),
            ),
            GtTransferCategoryField(
              controller: widget.categoryController,
              onChanged: widget.onCategoryChanged,
              leading: GtTextField(
                controller: widget.noteController,
                hintText: widget.noteHint,
                isEnabled: widget.isEnabled,
                decoration: context.inputStyles.plainDecoration,
                onChanged: widget.onNoteChanged,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _GtTransferParticipantWidget extends GtStatelessWidget {
  final GtTransferParticipantData data;
  final String? footerSuffix;
  final TextStyle? footerStyle;
  final CrossAxisAlignment crossAxisAlignment;
  final int? maxLines;

  const _GtTransferParticipantWidget({
    super.key,
    required this.data,
    required this.footerSuffix,
    this.crossAxisAlignment = .end,
    this.footerStyle,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final imageSize = context.dp(40.px);
    final balance = data.formattedBalance;
    final style = context.textStyles;
    final titleStyle = style.title2xs(color: palette.text.disabled);
    final hasFooter = footerSuffix.hasValue && balance.hasValue;
    Widget? tag;

    if (data.tag != null) tag = GtImage(image: data.tag!, isDecorative: true);

    return GtInkWell(
      role: .button,
      onTap: data.onTap,
      child: GtTransactionParticipantListTile(
        (data.name ?? data.label).upper,
        titleStyle: switch (data.name.hasValue) {
          false => titleStyle,
          _ => null,
        },
        superscript: switch (data.name.hasValue) {
          true => data.label,
          _ => null,
        },
        leading: switch (data.imageType) {
          .image => GtImage(
            image: data.image,
            width: imageSize,
            height: imageSize,
            isDecorative: true,
          ),
          _ => GtAvatar(
            avatar: data.image,
            size: imageSize,
            initials: data.name.initials,
            tag: tag,
          ),
        },
        subtitle: switch ((balance.hasValue, footerSuffix.hasValue)) {
          (true, true) => "${data.formattedBalance} - $footerSuffix",
          (true, _) => data.formattedBalance,
          (_, true) => footerSuffix,
          _ => null,
        },
        crossAxisAlignment: switch ((data.name.hasValue, hasFooter)) {
          (false, false) => .center,
          _ => crossAxisAlignment,
        },
        subStyle: footerStyle,
        maxLines: maxLines,
      ),
    );
  }
}

/// A dropdown widget for selecting a transaction category.
class GtTransferCategoryField extends GtStatefulWidget {
  /// The controller that manages the category of the transfer.
  final GtTransactionCategoryController? controller;

  /// Callback invoked whenever the category changes.
  final OnChanged<GtTransactionCategory?>? onChanged;

  /// The widget to display when there are no categories.
  final Widget? emptyWidget;

  /// The widget to display while loading categories.
  final Widget? loadingWidget;

  /// The leading widget.
  final Widget? leading;

  /// Indicates whether the category field is enabled.
  final bool isEnabled;

  /// Creates a new [GtTransferCategoryField].
  const GtTransferCategoryField({
    super.key,
    this.controller,
    this.onChanged,
    this.emptyWidget,
    this.loadingWidget,
    this.leading,
    this.isEnabled = true,
  });

  @override
  State<GtTransferCategoryField> createState() =>
      _GtTransferCategoryFieldState();
}

class _GtTransferCategoryFieldState extends State<GtTransferCategoryField>
    with GtBottomSheetMixin, GtTransactionCategoryMixin {
  late final GtTransactionCategoryController controller;

  @override
  void initState() {
    super.initState();
    final defaultCtrl = GtTransactionCategoryController(
      defaultInputCategories.first,
      categories: defaultInputCategories,
    );
    controller = widget.controller ?? defaultCtrl;

    if (!controller.categories.hasValue) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.categories = defaultInputCategories;
      });
    }
  }

  @override
  void dispose() {
    if (widget.controller != null) {
      controller.dispose();
    }
    super.dispose();
  }

  GtTransactionCategory get _fallbackCategory {
    return defaultInputCategories.first;
  }

  FutureOr<List<GtDropdownData<GtTransactionCategory>>>
  get _allCategories async {
    List<GtTransactionCategory> categories = controller.categories;

    if (!categories.hasValue) categories = defaultInputCategories;

    return categories.mapList((it) => it.dropdownData);
  }

  void _showSheet() {
    if (!widget.isEnabled) return;
    final dropdownController = GtDropdownInputController(
      selection: controller.value?.dropdownData,
    );
    showDraggableSheet(
      context,
      builder: (scrollController) => GtDropDownModal<GtTransactionCategory>(
        autoFocus: true,
        scrollController,
        controller: dropdownController,
        options: _allCategories,
        debounceTime: 500.milliseconds,
        emptyWidget: widget.emptyWidget,
        loadingWidget: widget.loadingWidget,
        builder: (value, value2) {
          return GtSelectionListTile(
            value.label.value,
            value: value,
            isSelected: value == value2.selection,
            leading: GtImage(
              image: value.value.image,
              width: context.dp(32.px),
              height: context.dp(32.px),
              isDecorative: true,
            ),
            onSelect: (val) {
              value2.selection = value;
              controller.select(value.value);
              context.maybePop();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                widget.onChanged?.call(value.value);
              });
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final decoration = context.inputStyles.plainDecoration;

    Widget child = GtDisabledOverlay(
      !widget.isEnabled,
      child: GtInkWell(
        role: .button,
        borderRadius: context.borderRadiusXl,
        hapticFeedbackType: .medium,
        onTap: _showSheet,
        child: Container(
          constraints: decoration.constraints,
          padding: decoration.padding,
          decoration: decoration.decoration,
          alignment: .center,
          child: ListenableBuilder(
            listenable: controller,
            builder: (context, child) {
              final category = controller.value ?? _fallbackCategory;
              final size = context.dp(32.px);

              return Row(
                crossAxisAlignment: .center,
                mainAxisAlignment: .center,
                spacing: context.spacingBase,
                mainAxisSize: .min,
                children: [
                  GtImage(
                    image: category.image,
                    width: size,
                    height: size,
                    isDecorative: true,
                  ),
                  GtIcon(GtIcons.chevronDown, size: context.dp(16.px)),
                ],
              );
            },
          ),
        ),
      ),
    );

    if (widget.leading != null) {
      child = Row(
        spacing: context.spacingBase,
        children: [
          Expanded(child: widget.leading!),
          child,
        ],
      );
    }

    return child;
  }
}
