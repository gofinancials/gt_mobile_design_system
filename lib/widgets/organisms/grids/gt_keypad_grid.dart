import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A grid-based virtual keypad widget for numeric input.
///
/// This widget displays a standard numeric keypad (0-9) along with a backspace
/// button and an optional biometric authentication button. It is commonly used
/// for PIN entry, passcodes, or entering monetary amounts.
class GtKeyPadGrid extends GtStatefulWidget {
  /// Controls the text being edited by the keypad.
  final TextEditingController controller;

  /// Optional callback triggered when the biometric authentication button is pressed.
  ///
  /// If this is null, the biometric button in the grid will be hidden.
  final OnPressed? onBioAuth;

  /// The maximum number of characters allowed in the input.
  final int limit;

  /// The alignment of the grid within its parent. Defaults to [Alignment.center].
  final AlignmentGeometry alignment;

  /// Callback invoked whenever the input text changes.
  final OnChanged<String>? onChanged;

  /// Callback invoked when the input length reaches the specified [limit].
  final OnChanged<String>? onCompleted;

  /// Creates a [GtKeyPadGrid].
  const GtKeyPadGrid({
    required this.controller,
    required this.limit,
    this.onBioAuth,
    this.alignment = Alignment.center,
    super.key,
    this.onChanged,
    this.onCompleted,
  });

  @override
  State<StatefulWidget> createState() => _GtKeyPadGridState();
}

class _GtKeyPadGridState extends State<GtKeyPadGrid> {
  TextEditingController get controller => widget.controller;
  OnPressed? get onBioAuth => widget.onBioAuth;
  int get limit => widget.limit;
  AlignmentGeometry get alignment => widget.alignment;
  OnChanged<String>? get onChanged => widget.onChanged;
  OnChanged<String>? get onCompleted => widget.onCompleted;

  @override
  void initState() {
    super.initState();
    controller.addListener(_listener);
  }

  void _updateValue(String char) {
    AppHelpers.updateValue(char, controller, limit: limit);
  }

  void _listener() {
    onChanged?.call(controller.text);
    if (controller.text.length < limit) return;
    onCompleted?.call(controller.text);
  }

  @override
  void dispose() {
    controller.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        key: const PageStorageKey("app-key-pad"),
        alignment: alignment,
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            for (final (index, keyRow) in GtKeyCellData.values.indexed) ...[
              TableRow(
                children: List.generate(
                  keyRow.length,
                  (index) => GtKeyCell(
                    data: keyRow[index],
                    onSelected: _updateValue,
                    onBioAuth: onBioAuth,
                  ),
                ),
              ),
              if (index < GtKeyCellData.values.length - 1)
                TableRow(children: GtGap.yLg() * 3),
            ],
          ],
        ),
      ),
    );
  }
}

/// A single key cell within the [GtKeyPadGrid].
///
/// Displays either a text value (e.g., numbers) or an icon (e.g., backspace, biometrics).
class GtKeyCell extends GtStatelessWidget {
  /// The data representing this key's value and optional icon.
  final GtKeyCellData data;

  /// Callback invoked with the key's string value when it is tapped.
  final OnChanged<String> onSelected;

  /// Callback invoked when a biometric key is tapped.
  final OnPressed? onBioAuth;

  /// Creates a [GtKeyCell].
  const GtKeyCell({
    required this.data,
    required this.onSelected,
    this.onBioAuth,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (data.value == "bio" && onBioAuth == null) {
      return const Offstage();
    }

    final padding = context.insets.symmetricDp(
      vertical: 12.px,
      horizontal: 14.px,
    );

    Widget child = GtText(
      data.value,
      style: context.textStyles.h4(),
      textAlign: TextAlign.center,
    );

    if (data.value == "bio" && onBioAuth != null) {
      child = GtIcon(data.icon ?? GtIcons.faceId, size: 32, variant: .soft);
    }

    if (data.value == 'x') {
      child = GtIcon(data.icon ?? GtIcons.delete, size: 32, variant: .soft);
    }

    return TableRowInkWell(
      overlayColor: WidgetStatePropertyAll(context.palette.primary.alpha10),
      onTap: () {
        HapticFeedback.heavyImpact();
        if (data.value == "bio") return onBioAuth?.call();

        onSelected(data.value);
      },
      child: Padding(padding: padding, child: child),
    );
  }
}
