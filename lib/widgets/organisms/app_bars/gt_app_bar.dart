import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:gt_mobile_ui/widgets/molecules/media/gt_avatar.dart';

class GtHomeAppBar extends GtStatelessWidget implements PreferredSizeWidget {
  final AppImageData? avatar;
  final OnPressed onClickSearch;
  final OnPressed onClickHide;
  final OnPressed onClickNotification;

  const GtHomeAppBar({
    this.avatar,
    required this.onClickSearch,
    required this.onClickHide,
    required this.onClickNotification,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final toolbarHeight = MediaQuery.paddingOf(context).top;
    final btnColor = Colors.transparent;

    return Material(
      type: .transparency,
      child: Container(
        padding: (context.insets.defaultHorizontalInsets).add(
          EdgeInsets.only(top: toolbarHeight),
        ),
        color: Colors.transparent,
        child: Row(
          spacing: context.spacingBase,
          children: [
            GtAvatar(avatar: avatar, alignment: .centerLeft, initials: "JB"),
            const Spacer(),
            GtIconButton(
              icon: GtIcons.magnifier,
              onPressed: onClickSearch,
              shape: .square,
              color: btnColor,
              variant: .neutral,
              size: .medium,
              gradient: context.gradients.ghostGradient,
            ),
            GtIconButton(
              icon: GtIcons.hide,
              onPressed: onClickHide,
              shape: .square,
              color: btnColor,
              variant: .neutral,
              gradient: context.gradients.ghostGradient,
              size: .medium,
            ),
            GtIconButton(
              icon: GtIcons.bell,
              onPressed: onClickNotification,
              shape: .square,
              color: btnColor,
              variant: .neutral,
              gradient: context.gradients.ghostGradient,
              size: .medium,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize {
    return Size.fromHeight(kToolbarHeight);
  }
}

// class GtAppBar extends GtStatelessWidget implements PreferredSizeWidget {
//   final bool showLogo;
//   final bool implyLeading;
//   final Widget? leading;
//   final String? title;
//   final double? toolbarHeight;
//   final Color? color;
//   final Widget? trailing;
//   final EdgeInsetsGeometry? padding;

//   const GtAppBar({
//     this.implyLeading = true,
//     this.leading,
//     this.trailing,
//     this.title,
//     this.color,
//     this.toolbarHeight,
//     this.padding,
//     this.showLogo = true,
//     super.key,
//   });
//   bool get _shouldImplyLeading {
//     return leading == null && (implyLeading && AppRouter.canPop());
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bgColor = color ?? AppColors.transparent;
//     final toolbarHeight = MediaQuery.paddingOf(context).top;

//     Widget? center;

//     if (showLogo) {
//       center = const AppLogo(height: AppPxMap.px20);
//     }

//     if (title != null) {
//       center = AppText(
//         title,
//         style: context.textStyle.t3(),
//         textAlign: TextAlign.center,
//         maxLines: 2,
//       );
//     }

//     return Material(
//       color: bgColor,
//       child: Container(
//         padding: (padding ?? context.insets.defaultHorizontalInsets).add(
//           EdgeInsets.only(top: toolbarHeight),
//         ),
//         decoration: BoxDecoration(color: bgColor),
//         child: Table(
//           defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//           columnWidths: const {
//             0: FlexColumnWidth(5),
//             1: FlexColumnWidth(10),
//             2: FlexColumnWidth(5),
//           },
//           children: [
//             TableRow(
//               children: [
//                 if (_shouldImplyLeading)
//                   const AppBackButton()
//                 else
//                   leading ?? const Offstage(),
//                 center ?? const Offstage(),
//                 if (trailing != null)
//                   Align(alignment: Alignment.centerRight, child: trailing)
//                 else
//                   const Offstage(),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Size get preferredSize {
//     return Size.fromHeight(toolbarHeight ?? kToolbarHeight);
//   }
// }

// class GtActionAppBar extends GtStatelessWidget implements PreferredSizeWidget {
//   final Widget? leading;
//   final double? toolbarHeight;
//   final Color? color;
//   final Widget? trailing;
//   final EdgeInsetsGeometry? padding;

//   const GtActionAppBar({
//     this.leading,
//     this.trailing,
//     this.color,
//     this.toolbarHeight,
//     this.padding,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final bgColor = color ?? AppColors.transparent;
//     final toolbarHeight = MediaQuery.paddingOf(context).top;

//     return Material(
//       color: bgColor,
//       child: Container(
//         padding: (padding ?? context.insets.defaultHorizontalInsets).add(
//           EdgeInsets.only(top: toolbarHeight),
//         ),
//         decoration: BoxDecoration(color: bgColor),
//         child: Row(
//           children: [
//             Flexible(
//               flex: 4,
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: leading ?? const Offstage(),
//               ),
//             ),
//             const Spacer(flex: 1),
//             Flexible(
//               flex: 4,
//               child: Align(
//                 alignment: Alignment.centerRight,
//                 child: trailing ?? const Offstage(),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Size get preferredSize {
//     return Size.fromHeight(toolbarHeight ?? kToolbarHeight);
//   }
// }

// class TrSearchableAppBar extends GtStatelessWidget
//     implements PreferredSizeWidget {
//   final OnPressed onClickSearch;
//   final Widget? trailing;

//   const TrSearchableAppBar({
//     required this.onClickSearch,
//     this.trailing,
//     super.key,
//   });

//   @override
//   Size get preferredSize {
//     return const Size.fromHeight(kToolbarHeight * 1.5);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final color = AppColors.purple;
//     final toolbarHeight =
//         MediaQuery.paddingOf(context).top + context.sp(AppPxMap.px10);
//     final iconColor = context.theme.whiteTextColor;

//     return Material(
//       color: color,
//       child: Container(
//         padding: context.insets.defaultHorizontalInsets.add(
//           EdgeInsets.only(
//             top: toolbarHeight,
//             bottom: context.sp(AppPxMap.px12),
//           ),
//         ),
//         decoration: BoxDecoration(color: color),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             AppLogo(
//               height: AppPxMap.px20,
//               color: iconColor,
//               trailing: trailing,
//             ),
//             AppIconButton(
//               icon: GtSvg(
//                 AppVectors.search,
//                 color: iconColor,
//                 height: context.sp(AppPxMap.px16),
//               ),
//               size: ButtonSize.medium,
//               onPressed: onClickSearch,
//               variant: IconBtnVariant.normal,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class TrSearchAppBar extends GtStatefulWidget implements PreferredSizeWidget {
//   final OnChanged<TranscriptSearchParam?> onChanged;
//   final Duration debounceTime;
//   final FocusNode? focusNode;
//   final ValueNotifier<TranscriptSearchParam> param;
//   final String? hintText;
//   final bool enabled;

//   const TrSearchAppBar({
//     required this.onChanged,
//     required this.debounceTime,
//     required this.param,
//     this.focusNode,
//     this.hintText,
//     this.enabled = true,
//     super.key,
//   });

//   @override
//   Size get preferredSize {
//     return const Size.fromHeight(kToolbarHeight * 3);
//   }

//   @override
//   State<StatefulWidget> createState() => _TrSearchAppBarState();
// }

// class _TrSearchAppBarState extends State<TrSearchAppBar> {
//   late final Debouncer _debouncer;
//   late final TextEditingController _controller;
//   late final ValueNotifier<TranscriptSearchParam> _param;

//   @override
//   void initState() {
//     super.initState();
//     _param = widget.param;
//     _controller = TextEditingController();
//     _debouncer = Debouncer(widget.debounceTime);
//     _param.addListener(_paramListener);
//   }

//   @override
//   void dispose() {
//     _param.removeListener(_paramListener);
//     _controller.dispose();
//     super.dispose();
//   }

//   _paramListener() {
//     _debouncer.run(() {
//       if (!_param.hasValue) return;
//       if (_param.value.hasQuery && _param.value.query != _controller.text) {
//         _controller.text = _param.value.query;
//       }
//       widget.onChanged(_param.value);
//     });
//   }

//   _clearRange() => _param.value = _param.value.clearRange();
//   _clearStatus() => _param.value = _param.value.clearStatus();
//   _clearType() => _param.value = _param.value.clearType();

//   _updateParam({
//     String? query,
//     TranscriptType? type,
//     SearchDateRange? range,
//     TranscriptStatus? status,
//   }) {
//     _param.value = _param.value.copyWith(
//       query: query,
//       type: type,
//       range: range,
//       status: status,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final color = context.theme.raisedBtnBgColor;
//     final hint = LocaleKeys.searchTranscriptsTitle.tr();

//     return Material(
//       color: color,
//       child: SafeArea(
//         bottom: false,
//         child: Padding(
//           padding: context.insets.onlySp(bottom: AppPxMap.px16),
//           child: Column(
//             spacing: context.sp(AppPxMap.px16),
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Padding(
//                 padding: context.insets.defaultHorizontalInsets,
//                 child: Row(
//                   spacing: context.sp(AppPxMap.px12),
//                   children: [
//                     Expanded(
//                       child: GtSearchField(
//                         type: SearchType.light,
//                         controller: _controller,
//                         focusNode: widget.focusNode,
//                         onClear: () {
//                           _param.value = TranscriptSearchParam(query: "");
//                         },
//                         onChanged: (text) => _updateParam(query: text),
//                         onFieldSubmitted: (text) => _updateParam(query: text),
//                         hintText: widget.hintText ?? hint,
//                         isEnabled: widget.enabled,
//                         textInputAction: TextInputAction.search,
//                       ),
//                     ),
//                     AppTextButton(
//                       onPressed: AppRouter.popView,
//                       text: LocaleKeys.cancel.tr(),
//                       color: context.theme.whiteTextColor,
//                     ),
//                   ],
//                 ),
//               ),
//               GenericListener(
//                 valueListenable: _param,
//                 builder: (param) {
//                   return SingleChildScrollView(
//                     padding: context.insets.defaultHorizontalInsets,
//                     scrollDirection: Axis.horizontal,
//                     child: Row(
//                       spacing: context.sp(AppPxMap.px12),
//                       children: [
//                         TranscriptSearchPill(
//                           value: param.range,
//                           options: SearchDateRange.options,
//                           icon: AppVectors.date,
//                           onSelect: (range) => _updateParam(range: range),
//                           label: param.range?.label,
//                           onClear: _clearRange,
//                           placeholder: LocaleKeys.filterDateRangeButton.tr(),
//                         ),
//                         TranscriptSearchPill(
//                           value: param.type,
//                           options: TranscriptType.options,
//                           icon: param.type?.icon ?? AppVectors.transcribe,
//                           onSelect: (type) => _updateParam(type: type),
//                           label: param.type?.title.ctr(),
//                           onClear: _clearType,
//                           placeholder: LocaleKeys.transcriptTypeTitle.tr(),
//                         ),
//                         TranscriptSearchPill(
//                           value: param.status,
//                           options: TranscriptStatus.options,
//                           icon: param.status?.icon ?? AppVectors.retry,
//                           onSelect: (status) => _updateParam(status: status),
//                           label: param.status?.title.tr(),
//                           onClear: _clearStatus,
//                           placeholder: LocaleKeys.transcriptionStatusTitle.tr(),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class TranscriptSearchPill<T> extends GtStatelessWidget with AppModalMixin {
//   final T? value;
//   final List<SelectionData<T>> options;
//   final String? label;
//   final String? icon;
//   final String placeholder;
//   final OnChanged<T?> onSelect;
//   final OnPressed? onClear;

//   const TranscriptSearchPill({
//     required this.value,
//     required this.onSelect,
//     required this.options,
//     required this.placeholder,
//     this.onClear,
//     this.label,
//     this.icon,
//     super.key,
//   });

//   SelectionData<T>? get selection {
//     if (value == null) return null;
//     return SelectionData(selection: value as T, label: label ?? placeholder);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final color = value != null
//         ? context.theme.raisedBtnBgColor
//         : context.theme.whiteTextColor;
//     final status = value != null ? PillStatus.info : PillStatus.search;
//     Widget? trailing;
//     if (value != null && onClear != null) {
//       trailing = SizedBox.square(
//         dimension: context.sp(AppPxMap.px14),
//         child: FittedBox(
//           fit: BoxFit.scaleDown,
//           child: AppIconButton(
//             icon: GtSvg(
//               AppVectors.close,
//               height: context.sp(AppPxMap.px16),
//               color: context.theme.whiteTextColor,
//             ),
//             size: ButtonSize.small,
//             onPressed: onClear!,
//             variant: IconBtnVariant.primary,
//           ),
//         ),
//       );
//     }

//     return GtStatusPill(
//       onTap: () {
//         showSelectionSheet<T>(
//           context,
//           options: options,
//           title: placeholder,
//           selection: selection,
//           initialChildSize: options.length <= 3 ? 0.3 : 0.4,
//           maxChildSize: options.length <= 3 ? 0.35 : 0.5,
//           minChildSize: options.length <= 3 ? 0.15 : 0.2,
//           onSelect: (data) => onSelect(data.selection),
//           allowSearch: false,
//         );
//       },
//       label ?? placeholder,
//       spacing: context.sp(AppPxMap.px8),
//       iconColor: color,
//       icon: icon,
//       status: status,
//       trailing: trailing,
//     );
//   }
// }
