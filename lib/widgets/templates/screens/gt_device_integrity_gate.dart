import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Checks the device once at launch and keeps the app off a device that fails.
///
/// Mount it at the app root, in `MaterialApp.builder`. While the check runs,
/// the app is built but offstage, so its navigator exists for a cold-start deep
/// link and keeps its state, and a spinner shows instead. If the verdict from
/// [service] blocks, the app is dropped for a full-screen
/// [GtStatusState.error] whose only action, [exitLabel], closes the app.
///
/// The check runs again only when [enforced] changes. When [enforced] is false
/// nothing is ever blocked, though the device is still read and logged.
class GtDeviceIntegrityGate extends GtStatefulWidget {
  /// The app.
  final Widget child;

  /// Whether this build blocks a failing device.
  final bool enforced;

  /// The blocked screen's headline, such as "Security check failed".
  final String blockedTitle;

  /// The blocked screen's explanation, such as "This device does not meet the
  /// app's security requirements".
  final String blockedSubtitle;

  /// The label of the button that closes the app.
  final String exitLabel;

  /// Reads and judges the device.
  final AppDeviceIntegrityService service;

  /// Closes the app; [SystemNavigator.pop] unless a test replaces it.
  final OnPressedAsync onExit;

  /// Creates a [GtDeviceIntegrityGate] around [child].
  const GtDeviceIntegrityGate({
    super.key,
    required this.child,
    required this.enforced,
    required this.blockedTitle,
    required this.blockedSubtitle,
    required this.exitLabel,
    this.service = const AppDeviceIntegrityServiceImpl(),
    this.onExit = SystemNavigator.pop,
  });

  @override
  State<GtDeviceIntegrityGate> createState() => _GtDeviceIntegrityGateState();
}

class _GtDeviceIntegrityGateState extends State<GtDeviceIntegrityGate> {
  AppDeviceIntegrityVerdict? _verdict;

  @override
  void initState() {
    super.initState();
    _check();
  }

  @override
  void didUpdateWidget(covariant GtDeviceIntegrityGate oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enforced != widget.enforced) _check();
  }

  Future<void> _check() async {
    final verdict = await widget.service.evaluate(enforced: widget.enforced);
    if (!mounted) return;
    setState(() => _verdict = verdict);
  }

  @override
  Widget build(BuildContext context) {
    final checked = _verdict != null;
    final blocked = _verdict?.isBlocked ?? false;

    return Stack(
      fit: .expand,
      children: [
        Offstage(
          offstage: !checked,
          child: blocked ? const SizedBox.shrink() : widget.child,
        ),
        if (!checked)
          const Scaffold(body: Center(child: GtSpinner()))
        else if (blocked)
          Scaffold(
            body: SafeArea(
              child: Padding(
                padding: context.insets.defaultHorizontalInsets,
                child: GtStatusState.error(
                  title: widget.blockedTitle,
                  subtitle: widget.blockedSubtitle,
                  actionLabel: widget.exitLabel,
                  onActionPressed: widget.onExit,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
