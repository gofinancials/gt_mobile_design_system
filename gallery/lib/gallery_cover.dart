import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

@widgetbook.UseCase(name: 'Cover', type: DesignSystemCover)
Widget buildCover(BuildContext context) {
  final state = context.watch<GtThemeState>();
  final theme = context.knobs.object.dropdown(
    label: "Switch Theme",
    initialOption: state.themeSetting.theme,
    options: kAllThemes,
    labelBuilder: (value) => value.name.capitalise(),
  );
  final mode = context.knobs.object.dropdown(
    label: "Switch Theme Mode",
    initialOption: state.themeSetting.mode,
    options: ThemeMode.values,
    labelBuilder: (value) => value.name.capitalise(),
  );

  state.switchTheme(theme);
  state.changeMode(mode);
  return const DesignSystemCover();
}

/// A centralized class to hold all colors used in the design

/// The main entry screen that delegates everything to CustomPaint
class DesignSystemCover extends StatelessWidget {
  const DesignSystemCover({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            margin: context.insets.symmetricDp(horizontal: 10.px),
            height: context.dp(600.px),
            width: double.infinity,
            padding: context.insets.allDp(25.px),
            color: context.palette.coverColors.dark,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'go',
                      style: context.textStyles.d1(
                        color: context.palette.coverColors.light,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '01',
                      style: context.textStyles.d1(
                        color: context.palette.coverColors.light,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  'DESIGN SYSTEM',
                  style: context.textStyles.h6(
                    color: context.palette.coverColors.light,
                  ),
                ),
                Divider(
                  height: context.dp(40.px),
                  thickness: context.dp(2.px),
                  color: context.palette.coverColors.light,
                ),
                SizedBox(height: context.dp(10.px)),
                Text(
                  'FOUNDATION',
                  style: context.textStyles.d2(
                    color: context.palette.coverColors.light,
                  ),
                ),
                SizedBox(height: context.dp(30.px)),
                Wrap(
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: context.dp(10.px),
                  children: [
                    Card(
                      elevation: 0,
                      color: context.palette.away.base,
                      shape: RoundedRectangleBorder(
                        borderRadius: 8.circularBorderRadius,
                      ),
                      child: Padding(
                        padding: context.insets.symmetricDp(
                          horizontal: 16.px,
                          vertical: 10.px,
                        ),
                        child: Text(
                          "In progress",
                          style: context.textStyles.h6().copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: 8.circularBorderRadius,
                      ),
                      child: Padding(
                        padding: context.insets.symmetricDp(
                          horizontal: 16.px,
                          vertical: 10.px,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          spacing: context.dp(6.px),
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: context.palette.success.base,
                              size: context.dp(20.px),
                            ),
                            Text(
                              "Brand Assets",
                              style: context.textStyles
                                  .h6(color: context.palette.success.dark)
                                  .copyWith(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: 8.circularBorderRadius,
                      ),
                      child: Padding(
                        padding: context.insets.symmetricDp(
                          horizontal: 16.px,
                          vertical: 10.px,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          spacing: context.dp(6.px),
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: context.palette.success.base,
                              size: context.dp(20.px),
                            ),
                            Text(
                              "Guides",
                              style: context.textStyles
                                  .h6(color: context.palette.success.dark)
                                  .copyWith(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
