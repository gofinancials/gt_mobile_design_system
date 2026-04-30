import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:provider/provider.dart';

class GtStateWrapper extends GtStatelessWidget {
  final Widget child;
  final List<ChangeNotifierProvider> providers;
  final String? path;

  const GtStateWrapper({
    super.key,
    required this.child,
    required this.providers,
  }) : path = null;

  const GtStateWrapper.forPath({
    super.key,
    required this.child,
    required this.providers,
    required String initialRoute,
  }) : path = initialRoute;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: child,
    );
  }
}
