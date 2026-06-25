import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:provider/provider.dart';

class GtStateWrapper extends GtStatelessWidget {
  final Widget child;
  final List<ChangeNotifierProvider> providers;
  final String? path;

  const GtStateWrapper({
    super.key,
    required this.providers,
    required this.child,
  }) : path = null;

  const GtStateWrapper.forPath({
    super.key,
    required this.providers,
    required String initialRoute,
    required this.child,
  }) : path = initialRoute;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: providers, child: child);
  }
}
