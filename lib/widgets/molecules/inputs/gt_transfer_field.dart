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

  /// The name or identifier of the user sending the funds.
  final String sender;

  /// The name or identifier of the user receiving the funds.
  final String recipient;

  /// The hint text displayed inside the note input field.
  final String noteHint;

  /// The available balance of the sender, used for validation and display.
  final double balance;

  /// The avatar widget representing the recipient.
  final GtAvatar recipientAvatar;

  /// The image data representing the sender.
  final AppImageData senderImage;

  /// Callback invoked whenever either the amount or the note changes.
  final OnChanged<({String? amount, String? note})>? onChange;

  /// Whether the transfer field is interactive and can be modified. Defaults to true.
  final bool isEnabled;

  /// The minimum allowable amount for the transfer.
  final num? min;

  /// The maximum allowable amount for the transfer.
  final num? max;

  /// Creates a new [GtTransferField].
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
              decoration: context.inputStyles.plainDecoration,
              suffix: GtNetworkImage(GtNetworkImages.transfer),
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
