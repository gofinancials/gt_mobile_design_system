import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtTransferField extends GtStatefulWidget {
  final GtInputController amountController;
  final GtInputController noteController;
  final String sender;
  final String recipient;
  final String noteHint;
  final double balance;
  final GtAvatar recipientAvatar;
  final AppImageData senderImage;
  final OnChanged<({String? amount, String? note})>? onChange;
  final bool isEnabled;
  final num? min;
  final num? max;

  const GtTransferField({
    super.key,
    required this.amountController,
    required this.noteController,
    required this.sender,
    required this.recipient,
    required this.senderImage,
    required this.recipientAvatar,
    required this.balance,
    required this.noteHint,
    this.onChange,
    this.isEnabled = true,
    this.max,
    this.min,
  });
  @override
  State<GtTransferField> createState() => _GtTransferFieldState();
}

class _GtTransferFieldState extends State<GtTransferField> {
  @override
  Widget build(BuildContext context) {
    return FormField<double>(
      initialValue: widget.balance,
      validator: (balance) => AppValidators.balanceValidator(
        widget.amountController.text,
        balance: balance ?? 0,
      ),
      builder: (field) {
        GtInputDecoration decoration = context.inputStyles.transferInputStyle;
        String balanceText = "balance".ctr();
        String formattedAmount = widget.balance.asCurrency(AppStrings.naira);
        String sendFooter = "$balanceText $formattedAmount";
        if (field.hasError) {
          sendFooter += " - ${field.errorText}";
        }

        if (field.hasError) {
          decoration = decoration.copyWith(
            textStyle: decoration.textStyle.copyWith(
              color: context.palette.error.base,
            ),
          );
        }

        final textField = GtTextField(
          key: PageStorageKey(
            "${widget.balance}-${widget.recipient}-${widget.sender}",
          ),
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
                  GtTransactionParticipantListTile(
                    widget.sender,
                    superscript: "from".utr(),
                    leading: GtImage(image: widget.senderImage),
                    subtitle: sendFooter,
                    crossAxisAlignment: .start,
                    subStyle: field.hasError ? decoration.errorStyle : null,
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
                              child: GtSvg(
                                GtVectors.trendDown,
                                width: context.dp(20.px),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(child: textField),
                    ],
                  ),
                  const GtGap.yMd(),
                  GtTransactionParticipantListTile(
                    widget.recipient.upper,
                    superscript: "to".utr(),
                    leading: widget.recipientAvatar,
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
