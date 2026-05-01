import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Animated loader/success/error bottom container.
///
/// Place inside a [Stack] as the last child so it appears floating at the
/// bottom of the screen. It intentionally does not use overlay/route APIs.
class GtBottomModal extends StatefulWidget {
  final GtBottomModalController? _controller;
  final GtBottomModalData? _data;

  /// Optional margin to apply around the modal container.
  ///
  /// If not provided, it defaults to a standard inset at the bottom of the screen.
  final EdgeInsetsGeometry? margin;

  /// The alignment of the modal within its parent.
  ///
  /// Defaults to [Alignment.bottomCenter].
  final AlignmentGeometry alignment;

  /// Creates a [GtBottomModal] that displays static [data].
  const GtBottomModal({
    required GtBottomModalData data,
    this.margin,
    super.key,
    this.alignment = .bottomCenter,
  }) : _data = data,
       _controller = null;

  /// Creates a [GtBottomModal] whose state is managed dynamically by a [controller].
  const GtBottomModal.controller({
    required GtBottomModalController controller,
    this.margin,
    super.key,
    this.alignment = .bottomCenter,
  }) : _controller = controller,
       _data = null;

  /// The controller managing this modal, if any.
  GtBottomModalController? get controller => _controller;

  /// The static data for this modal, if any.
  GtBottomModalData? get data => _data;

  /// Whether this modal is driven by a [GtBottomModalController].
  bool get hasController => _controller != null;

  /// The resolved title text.
  String get title {
    if (hasController) return controller!.title;
    return data!.title;
  }

  /// The resolved description text, or null if neither the controller nor the
  /// static data provides one.
  String? get description {
    return controller?.description ?? data?.description;
  }

  /// The resolved icon data, or null if neither the controller nor the static
  /// data provides one.
  AppImageData? get icon {
    return controller?.icon ?? data?.icon;
  }

  @override
  State<GtBottomModal> createState() => _GtBottomModalState();
}

class _GtBottomModalState extends State<GtBottomModal>
    with TickerProviderStateMixin {
  late AnimationController _titleController;
  late AnimationController _successController;
  late Animation<Offset> _titleSlide;
  late Animation<double> _titleFade;
  late Animation<Offset> _successSlide;
  late Animation<double> _successFade;

  late AppDebouncer _debouncer;

  @override
  void initState() {
    super.initState();
    _initAnimation();
    _debouncer = AppDebouncer(widget.controller?.completionDelay ?? 1.seconds);
    widget.controller?.taskNotifier?.addListener(_taskListener);
  }

  void _initAnimation() {
    _titleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward();
    _successController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward();

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

  @override
  void didUpdateWidget(covariant GtBottomModal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller?.taskNotifier != widget.controller?.taskNotifier) {
      oldWidget.controller?.taskNotifier?.removeListener(_taskListener);
      widget.controller?.taskNotifier?.addListener(_taskListener);
    }
  }

  void _taskListener() {
    _debouncer.abort();
    final callback = widget.controller?.onComplete;
    final task = widget.controller?.task;
    if (callback == null || task == null) return;
    if (task.isLoading) return;
    _debouncer.run(() => callback(task));
  }

  @override
  void dispose() {
    widget.controller?.taskNotifier?.removeListener(_taskListener);
    _debouncer.abort();
    _titleController.dispose();
    _successController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.hasController) {
      return Material(
        type: .transparency,
        child: GestureDetector(
          behavior: .opaque,
          onTap: context.pop,
          child: Align(
            alignment: widget.alignment,
            child: _GtModalBody(
              titleSlide: _titleSlide,
              titleFade: _titleFade,
              successSlide: _successSlide,
              successFade: _successFade,
              title: widget.title,
              icon: _GtBottomModalIconWidget(
                GtBottomModalPhase.idle,
                icon: widget.icon,
              ),
              description: widget.description,
              margin: widget.margin,
            ),
          ),
        ),
      );
    }

    final controller = widget.controller!;

    return ListenableBuilder(
      listenable: Listenable.merge([
        controller,
        if (controller.hasTask) controller.taskNotifier!,
      ]),
      builder: (context, child) {
        final task = controller.task;

        Widget child = Material(
          type: .transparency,
          child: Align(
            alignment: widget.alignment,
            child: _GtModalBody(
              titleSlide: _titleSlide,
              titleFade: _titleFade,
              successSlide: _successSlide,
              successFade: _successFade,
              title: controller.title,
              icon: _GtBottomModalIconWidget(
                controller.phase,
                icon: controller.icon,
              ),
              description: controller.description,
              margin: widget.margin,
              progress: controller.progress != null
                  ? "${controller.percentage}%"
                  : null,
            ),
          ),
        );

        if (task != null && task.isLoading) {
          child = GtPopScope(child: IgnorePointer(child: child));
        }

        return child;
      },
    );
  }
}

/// Internal widget that renders the modal container, animations, and typography.
class _GtModalBody extends GtStatelessWidget {
  final Animation<Offset> titleSlide;
  final Animation<double> titleFade;
  final Animation<Offset> successSlide;
  final Animation<double> successFade;
  final String title;
  final String? description;
  final String? progress;
  final EdgeInsetsGeometry? margin;
  final Widget? icon;

  const _GtModalBody({
    required this.titleSlide,
    required this.titleFade,
    required this.successSlide,
    required this.successFade,
    required this.title,
    this.progress,
    this.icon,
    this.description,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final resolvedMargin =
        margin ??
        context.insets.onlyDp(left: 16.px, right: 16.px, bottom: 34.px);
    final header = GtText(
      title.upper,
      style: context.textStyles.button(),
      textAlign: TextAlign.center,
    );
    TextStyle subStyle = context.textStyles.bodyXs(
      color: palette.text.darkerSub,
    );
    final resolvedDescription = progress ?? description;

    if (progress.hasValue) {
      subStyle = context.textStyles.subHeadXs(color: palette.text.sub);
    }

    return SafeArea(
      top: false,
      child: GestureDetector(
        onVerticalDragEnd: (details) {
          if (details.velocity.pixelsPerSecond.dy < 0.0) return;
          context.pop();
        },
        child: Container(
          constraints: BoxConstraints(maxWidth: 500),
          width: double.infinity,
          margin: resolvedMargin,
          padding: context.insets.symmetricDp(
            horizontal: 52.px,
            vertical: 8.px,
          ),
          decoration: BoxDecoration(
            color: palette.bg.white,
            borderRadius: context.borderRadius4Xl,
          ),
          child: SlideTransition(
            position: titleSlide,
            child: FadeTransition(
              opacity: titleFade,
              child: Column(
                mainAxisSize: .min,
                crossAxisAlignment: .center,
                children: [
                  Align(
                    alignment: .topCenter,
                    child: Container(
                      margin: context.insets.onlyDp(bottom: 16.px),
                      width: context.dp(32.px),
                      height: context.dp(4.px),
                      decoration: BoxDecoration(
                        color: palette.stroke.sub,
                        borderRadius: context.borderRadiusXxs,
                      ),
                    ),
                  ),
                  ?icon,
                  const GtGap.yBase(),
                  Flexible(
                    child: Builder(
                      builder: (_) {
                        return SlideTransition(
                          position: successSlide,
                          child: FadeTransition(
                            opacity: successFade,
                            child: Column(
                              mainAxisSize: .min,
                              crossAxisAlignment: .center,
                              children: [
                                header,
                                if (resolvedDescription.hasValue)
                                  GtText(
                                    resolvedDescription,
                                    style: subStyle,
                                    textAlign: TextAlign.center,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const GtGap.ySectionSm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Resolves leading icon/loader for the current phase.
class _GtBottomModalIconWidget extends StatelessWidget {
  final GtBottomModalPhase phase;
  final AppImageData? icon;

  const _GtBottomModalIconWidget(this.phase, {this.icon});

  @override
  Widget build(BuildContext context) {
    Widget child = const GtGap.ySectionSm();

    final size = context.dp(36.px);

    if (icon != null) {
      child = GtImage(image: icon, width: size, height: size);
    }

    return switch (phase) {
      .loading => GtSpinner(size: size),
      .success => GtSvg(
        GtVectorIllustrations.success,
        width: size,
        height: size,
      ),
      .error => GtSvg(GtVectorIllustrations.failed, width: size, height: size),
      _ => child,
    };
  }
}
