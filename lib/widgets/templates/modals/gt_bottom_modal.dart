import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// An animated bottom modal container for displaying static content or tracking asynchronous tasks.
///
/// This widget can be used standalone or presented via overlay APIs (like [showModalBottomSheet]).
/// When driven by a [GtBottomModalController], it animates seamlessly between loading, success,
/// and error states without needing to dismiss and rebuild the modal.
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

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  void _initAnimation() {
    _titleController = AnimationController(duration: 1.seconds, vsync: this)
      ..forward();
    _successController = AnimationController(duration: 1.seconds, vsync: this)
      ..forward();

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
      listenable: controller,
      builder: (context, child) {
        final isLoading = controller.isLoading;

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

        if (isLoading) {
          child = GtPopScope(child: IgnorePointer(child: child));
        }

        return child;
      },
    );
  }
}

/// Internal widget that renders the modal container, animations, and typography.
class _GtModalBody extends GtStatelessWidget {
  /// The animation driving the upward slide transition of the title.
  final Animation<Offset> titleSlide;

  /// The animation driving the fade-in transition of the title.
  final Animation<double> titleFade;

  /// The animation driving the upward slide transition of the success/error content.
  final Animation<Offset> successSlide;

  /// The animation driving the fade-in transition of the success/error content.
  final Animation<double> successFade;

  /// The main title text.
  final String title;

  /// An optional description text.
  final String? description;

  /// An optional progress text (e.g. "45%"). Overrides the description if provided.
  final String? progress;

  /// Margin applied around the modal container.
  final EdgeInsetsGeometry? margin;

  /// The icon widget to display above the title.
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
                                  GtRichText(
                                    resolvedDescription,
                                    textStyle: subStyle,
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
  /// The current phase of the modal (idle, loading, success, error).
  final GtBottomModalPhase phase;

  /// An optional custom icon to display when the phase is idle.
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
