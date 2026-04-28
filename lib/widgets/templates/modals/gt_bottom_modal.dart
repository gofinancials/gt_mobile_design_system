import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Visual phase for [GtLoaderBottomModal].
enum GtBottomModalPhase {
  /// Initial/processing state that shows the animated loader.
  loading,

  /// Completed successfully.
  success,

  /// Completed with an error state.
  error,
}

/// Immutable snapshot consumed by [GtLoaderBottomModal].
class GtBottomModalState {
  final bool visible;
  final GtBottomModalPhase phase;
  final String title;
  final String? description;

  const GtBottomModalState({
    required this.visible,
    required this.phase,
    required this.title,
    this.description,
  });
}

/// Controller for driving [GtLoaderBottomModal] state transitions.
///
/// This keeps the bottom modal independent from overlay logic and can be
/// triggered from button presses in any screen/use case.
class GtBottomModalController extends ChangeNotifier {
  GtBottomModalState _state = const GtBottomModalState(
    visible: false,
    phase: GtBottomModalPhase.loading,
    title: '',
  );

  Timer? _autoCloseTimer;

  GtBottomModalState get state => _state;

  /// Shows the modal in loading mode by default.
  ///
  /// If [animate] is false, it opens directly in success/error mode.
  void showMessageOverlay(
    String title, {
    String? description,
    bool animate = true,
    bool showError = false,
  }) {
    _cancelAutoClose();
    _state = GtBottomModalState(
      visible: true,
      phase: animate
          ? GtBottomModalPhase.loading
          : (showError ? GtBottomModalPhase.error : GtBottomModalPhase.success),
      title: title,
      description: description,
    );
    notifyListeners();
  }

  /// Switches to success/error state and optionally auto-closes.
  void hideLoaderOverLay(
    String title, {
    String? description,
    OnPressed? onComplete,
    bool showError = false,
    int durationInSec = 2,
  }) {
    _cancelAutoClose();
    _state = GtBottomModalState(
      visible: true,
      phase: showError ? GtBottomModalPhase.error : GtBottomModalPhase.success,
      title: title,
      description: description,
    );
    notifyListeners();

    _autoCloseTimer = Timer(Duration(seconds: durationInSec), () {
      hideOverlay();
      onComplete?.call();
    });
  }

  /// Closes and resets the modal.
  void hideOverlay() {
    _cancelAutoClose();
    _state = const GtBottomModalState(
      visible: false,
      phase: GtBottomModalPhase.loading,
      title: '',
    );
    notifyListeners();
  }

  void _cancelAutoClose() {
    _autoCloseTimer?.cancel();
    _autoCloseTimer = null;
  }

  @override
  void dispose() {
    _cancelAutoClose();
    super.dispose();
  }
}

/// Animated loader/success/error bottom container.
///
/// Place inside a [Stack] as the last child so it appears floating at the
/// bottom of the screen. It intentionally does not use overlay/route APIs.
class GtLoaderBottomModal extends StatefulWidget {
  final GtBottomModalController controller;
  final EdgeInsetsGeometry? margin;

  const GtLoaderBottomModal({required this.controller, this.margin, super.key});

  @override
  State<GtLoaderBottomModal> createState() => _GtLoaderBottomModalState();
}

class _GtLoaderBottomModalState extends State<GtLoaderBottomModal>
    with TickerProviderStateMixin {
  final Duration _heightDuration = const Duration(milliseconds: 260);
  double _currentHeightPx = 0.0;

  late AnimationController _titleController;
  late AnimationController _successController;
  late Animation<Offset> _titleSlide;
  late Animation<double> _titleFade;
  late Animation<Offset> _successSlide;
  late Animation<double> _successFade;

  @override
  void initState() {
    super.initState();
    _initAnimation();
    widget.controller.addListener(_onControllerChanged);
    _onControllerChanged();
  }

  void _initAnimation() {
    _titleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _successController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _titleSlide =
        Tween<Offset>(begin: const Offset(0.0, 0.05), end: Offset.zero).animate(
          CurvedAnimation(parent: _titleController, curve: Curves.easeOutCubic),
        );
    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _titleController, curve: Curves.easeInOut),
    );

    _successSlide =
        Tween<Offset>(begin: const Offset(0.0, 0.45), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _successController,
            curve: Curves.easeOutCubic,
          ),
        );
    _successFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _successController, curve: Curves.easeInOut),
    );
  }

  void _onControllerChanged() {
    if (!mounted) return;
    final state = widget.controller.state;
    if (!state.visible) {
      setState(() => _currentHeightPx = 0.0);
      return;
    }

    final hasDescription = (state.description ?? '').trim().isNotEmpty;
    final targetHeightPx = hasDescription ? 164.0 : 145.0;

    setState(() => _currentHeightPx = targetHeightPx);
    _titleController
      ..reset()
      ..forward();

    if (state.phase != GtBottomModalPhase.loading) {
      _successController
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    _titleController.dispose();
    _successController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final state = widget.controller.state;
    final title = state.title;
    final description = state.description;
    final resolvedMargin =
        widget.margin ??
        context.insets.onlyDp(left: 16.px, right: 16.px, bottom: 24.px);
    final currentHeight = context.dp(_currentHeightPx.px);

    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedContainer(
        duration: _heightDuration,
        curve: Curves.easeInOut,
        height: currentHeight,
        width: double.infinity,
        margin: resolvedMargin,
        decoration: BoxDecoration(
          color: palette.bg.white,
          borderRadius: context.borderRadius4Xl,
          boxShadow: context.shadows.sm(),
        ),
        child: Builder(
          builder: (_) {
            if (currentHeight <= 0) return const SizedBox.shrink();
            return SlideTransition(
              position: _titleSlide,
              child: FadeTransition(
                opacity: _titleFade,
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: currentHeight,
                      maxHeight: currentHeight,
                    ),
                    child: Column(
                      mainAxisSize: .min,
                      crossAxisAlignment: .center,
                      children: [
                        // Top handle strip (sheet affordance).
                        Padding(
                          padding: EdgeInsets.only(
                            top: context.dp(8.px),
                            bottom: context.dp(20.px),
                          ),
                          child: Container(
                            width: context.dp(32.px),
                            height: context.dp(4.px),
                            decoration: BoxDecoration(
                              color: palette.stroke.sub,
                              borderRadius: context.borderRadiusXxs,
                            ),
                          ),
                        ),
                        _GtBottomModalStatusWidget(phase: state.phase),
                        const GtGap.yXl(),
                        Flexible(
                          child: state.phase == GtBottomModalPhase.loading
                              ? GtText(
                                  title.upper,
                                  style: context.textStyles.h6(),
                                  textAlign: TextAlign.center,
                                )
                              : SlideTransition(
                                  position: _successSlide,
                                  child: FadeTransition(
                                    opacity: _successFade,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        GtText(
                                          title.upper,
                                          style: context.textStyles.h6(),
                                          textAlign: TextAlign.center,
                                        ),
                                        if ((description ?? '')
                                            .trim()
                                            .isNotEmpty) ...[
                                          const GtGap.yXs(),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: context.dp(20.px),
                                            ),
                                            child: GtText(
                                              description!,
                                              style: context.textStyles.bodyS(
                                                color:
                                                    GtColors.neutral600.value,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Resolves leading icon/loader for the current phase.
class _GtBottomModalStatusWidget extends StatelessWidget {
  final GtBottomModalPhase phase;

  const _GtBottomModalStatusWidget({required this.phase});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return switch (phase) {
      GtBottomModalPhase.loading => GtSpinner(
        color: palette.bg.strong,
        size: context.dp(28.px),
      ),
      GtBottomModalPhase.success => GtSvg(
        GtVectorIllustrations.success,
        width: context.dp(30.px),
        height: context.dp(30.px),
      ),
      GtBottomModalPhase.error => GtSvg(
        GtVectorIllustrations.failed,
        width: context.dp(30.px),
        height: context.dp(30.px),
      ),
    };
  }
}
