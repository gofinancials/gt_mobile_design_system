import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtKeyPadGrid extends GtStatefulWidget {
  final TextEditingController controller;
  final OnPressed? onBioAuth;
  final int limit;
  final AlignmentGeometry alignment;
  final OnChanged<String>? onChanged;
  final OnChanged<String>? onCompleted;

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

class GtKeyCell extends GtStatelessWidget {
  final GtKeyCellData data;
  final OnChanged<String> onSelected;
  final OnPressed? onBioAuth;

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
