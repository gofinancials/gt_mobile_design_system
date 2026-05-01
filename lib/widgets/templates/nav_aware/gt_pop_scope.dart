import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

// class GtRootPopScope extends GtStatefulWidget {
//   final Widget child;

//   const GtRootPopScope({super.key, required this.child});

//   @override
//   State<GtRootPopScope> createState() => _GtRootPopScopeState();
// }

// class _GtRootPopScopeState extends State<GtRootPopScope> with GtModalMixin {
//   @override
//   Widget build(BuildContext context) {
//     if (!Navigator.of(context).canPop()) {
//       return PopScope(
//         canPop: false,
//         onPopInvokedWithResult: (_, __) {
//           confirmAction(
//             GtRouter.navigatorKey.currentContext ?? context,
//             onContinue: GtRouter.closeGt,
//             title: LocaleKeys.closeGt.tr(),
//             description: LocaleKeys.closeGtQuestion.tr(),
//           );
//         },
//         child: widget.child,
//       );
//     }
//     return widget.child;
//   }
// }

class GtPopScope extends GtStatefulWidget {
  final Widget child;
  final bool canPop;
  final OnChanged2<bool, Object?>? onPopRequest;

  const GtPopScope({
    super.key,
    required this.child,
    this.canPop = true,
    this.onPopRequest,
  });

  @override
  State<GtPopScope> createState() => _GtopScopeState();
}

class _GtopScopeState extends State<GtPopScope> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.canPop,
      onPopInvokedWithResult: widget.onPopRequest,
      child: widget.child,
    );
  }
}
