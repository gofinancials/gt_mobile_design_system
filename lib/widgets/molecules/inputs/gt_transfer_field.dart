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

  /// The hint text displayed inside the note input field.
  final String noteHint;

  /// Callback invoked whenever either the amount or the note changes.
  final OnChanged<({String? amount, String? note})>? onChange;

  /// Whether the transfer field is interactive and can be modified. Defaults to true.
  final bool isEnabled;

  /// The minimum allowable amount for the transfer.
  final num? min;

  /// The maximum allowable amount for the transfer.
  final num? max;

  final Widget? participantSeparator;

  final GtTransferParticipantData firstParticipant;
  final GtTransferParticipantData secondParticipant;

  /// Creates a new [GtTransferField].
  const GtTransferField({
    super.key,
    required this.amountController,
    required this.noteController,
    required this.firstParticipant,
    required this.secondParticipant,
    required this.noteHint,
    this.onChange,
    this.isEnabled = true,
    this.max,
    this.min,
    this.participantSeparator,
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
    final separator = GtSvg(GtVectors.trendDown, width: context.dp(20.px));

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
          onChanged: (value) {
            widget.onChange?.call((
              amount: value,
              note: widget.noteController.text,
            ));
          },
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
                              child: widget.participantSeparator ?? separator,
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
            GtTextField(
              controller: widget.noteController,
              hintText: widget.noteHint,
              isEnabled: widget.isEnabled,
              decoration: context.inputStyles.plainDecoration,
              suffix: GtNetworkImage(
                GtNetworkImages.transfer,
                height: context.dp(32.px),
                width: context.dp(32.px),
              ),
              onChanged: (value) {
                widget.onChange?.call((
                  amount: widget.amountController.text,
                  note: value,
                ));
              },
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

  const _GtTransferParticipantWidget({
    super.key,
    required this.data,
    required this.footerSuffix,
    this.crossAxisAlignment = .end,
    this.footerStyle,
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

    if (data.tag != null) tag = GtImage(image: data.tag!);

    return GtInkWell(
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
      ),
    );
  }
}
