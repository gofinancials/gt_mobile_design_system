import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:provider/provider.dart';

class GtLocalStateWrapper<T extends ChangeNotifier> extends GtStatefulWidget {
  final ValueBuilder<T> builder;
  final T? notifier;

  const GtLocalStateWrapper({required this.builder, this.notifier, super.key});

  @override
  State<StatefulWidget> createState() => _GtLocalStateWrapperState<T>();
}

class _GtLocalStateWrapperState<T extends ChangeNotifier>
    extends State<GtLocalStateWrapper<T>> {
  late final T state;
  @override
  void initState() {
    super.initState();
    state = widget.notifier ?? locator<T>();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(
      value: state,
      child: Consumer<T>(
        builder: (context, value, child) {
          return widget.builder(value);
        },
      ),
    );
  }
}
