import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// The foundational blueprint for an application's design system theme.
///
/// This abstract class aggregates all styling primitives (colors, typography,
/// spacing, shadows, etc.) and native Flutter theme data. Host applications
/// must implement this class to provide their specific brand identity and
/// token configurations.
class GtTheme {
  /// Creates a base instance of [GtTheme].
  ///
  /// Requires the foundational [lightPalette] and [darkPalette] that drive
  /// the semantic coloring engine for the host application.
  const GtTheme({
    required this.lightPalette,
    required this.darkPalette,
    required this.name,
  });

  /// The color palette used when the application is in light mode.
  final GtPalette lightPalette;

  /// The color palette used when the application is in dark mode.
  final GtPalette darkPalette;

  /// The display name of the theme.
  ///
  /// Useful for debugging, analytics, or displaying theme options in a UI.
  final String name;

  /// The compiled Material [ThemeData] for dark mode.
  ThemeData get materialDark {
    final base = ThemeData.dark();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarColor: darkPalette.primary.darker,
        systemNavigationBarColor: darkPalette.bg.white,
      ),
    );
    return base.copyWith(
      extensions: [darkPalette],
      splashColor: GtColors.transparent.value,
      pageTransitionsTheme: PageTransitionsTheme(builders: defaultTransitions),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      splashFactory: NoSplash.splashFactory,
      brightness: Brightness.dark,
      dividerColor: darkPalette.faded.light,
      dialogTheme: base.dialogTheme.copyWith(
        backgroundColor: darkPalette.staticColors.black.setOpacity(0.3),
      ),
      colorScheme: base.colorScheme.copyWith(
        surface: darkPalette.bg.white,
        error: darkPalette.error.dark,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: darkPalette.bg.white,
      primaryColor: darkPalette.primary.darker,
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(color: darkPalette.text.strong),
        backgroundColor: darkPalette.bg.white,
      ),
      iconTheme: base.iconTheme.copyWith(color: darkPalette.icon.strong),
      cardTheme: base.cardTheme.copyWith(
        color: darkPalette.bg.white,
        elevation: 0,
      ),
      bottomAppBarTheme: base.bottomAppBarTheme.copyWith(
        elevation: 0,
        color: darkPalette.bg.white,
      ),
      bottomNavigationBarTheme: base.bottomNavigationBarTheme.copyWith(
        backgroundColor: darkPalette.bg.white,
        elevation: 0,
      ),
      bottomSheetTheme: base.bottomSheetTheme.copyWith(
        backgroundColor: darkPalette.bg.white,
        elevation: 0,
      ),
      buttonTheme: base.buttonTheme.copyWith(
        buttonColor: darkPalette.primary.darker,
        disabledColor: darkPalette.faded.light,
        textTheme: ButtonTextTheme.normal,
      ),
      cardColor: darkPalette.bg.white,
      textTheme: base.textTheme.apply(
        displayColor: darkPalette.text.strong,
        bodyColor: darkPalette.text.strong,
        fontFamily: fonts.body,
      ),
      textSelectionTheme: base.textSelectionTheme.copyWith(
        selectionColor: darkPalette.primary.alpha10,
        selectionHandleColor: darkPalette.primary.darker,
        cursorColor: darkPalette.primary.darker,
      ),
      inputDecorationTheme: InputDecorationTheme(
        errorMaxLines: 1,
        helperMaxLines: 1,
        isDense: true,
        filled: true,
        suffixStyle: TextStyle(color: darkPalette.text.sub),
        prefixStyle: TextStyle(color: darkPalette.text.sub),
        labelStyle: TextStyle(color: darkPalette.text.sub),
        helperStyle: TextStyle(color: darkPalette.text.sub),
        hintStyle: TextStyle(color: darkPalette.text.sub),
      ),
    );
  }

  /// The compiled Material [ThemeData] for light mode.
  ThemeData get materialLight {
    final base = ThemeData.light();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: lightPalette.primary.darker,
        systemNavigationBarColor: lightPalette.bg.white,
      ),
    );
    return base.copyWith(
      extensions: [lightPalette],
      splashColor: GtColors.transparent.value,
      pageTransitionsTheme: PageTransitionsTheme(builders: defaultTransitions),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      splashFactory: NoSplash.splashFactory,
      brightness: Brightness.light,
      dividerColor: lightPalette.faded.light,
      dialogTheme: base.dialogTheme.copyWith(
        backgroundColor: lightPalette.staticColors.black.setOpacity(0.3),
      ),
      colorScheme: base.colorScheme.copyWith(
        surface: lightPalette.bg.white,
        error: lightPalette.error.dark,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: lightPalette.bg.white,
      primaryColor: lightPalette.primary.darker,
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(color: lightPalette.text.strong),
        backgroundColor: lightPalette.bg.white,
      ),
      iconTheme: base.iconTheme.copyWith(color: lightPalette.icon.strong),
      cardTheme: base.cardTheme.copyWith(
        color: lightPalette.bg.white,
        elevation: 0,
      ),
      bottomAppBarTheme: base.bottomAppBarTheme.copyWith(
        elevation: 0,
        color: lightPalette.bg.white,
      ),
      bottomNavigationBarTheme: base.bottomNavigationBarTheme.copyWith(
        backgroundColor: lightPalette.bg.white,
        elevation: 0,
      ),
      bottomSheetTheme: base.bottomSheetTheme.copyWith(
        backgroundColor: lightPalette.bg.white,
        elevation: 0,
      ),
      buttonTheme: base.buttonTheme.copyWith(
        buttonColor: lightPalette.primary.darker,
        disabledColor: lightPalette.faded.light,
        textTheme: ButtonTextTheme.normal,
      ),
      cardColor: lightPalette.bg.white,
      textTheme: base.textTheme.apply(
        displayColor: lightPalette.text.strong,
        bodyColor: lightPalette.text.strong,
        fontFamily: fonts.body,
      ),
      textSelectionTheme: base.textSelectionTheme.copyWith(
        selectionColor: lightPalette.primary.alpha10,
        selectionHandleColor: lightPalette.primary.darker,
        cursorColor: lightPalette.primary.darker,
      ),
      inputDecorationTheme: InputDecorationTheme(
        errorMaxLines: 1,
        helperMaxLines: 1,
        isDense: true,
        filled: true,
        suffixStyle: TextStyle(color: lightPalette.text.sub),
        prefixStyle: TextStyle(color: lightPalette.text.sub),
        labelStyle: TextStyle(color: lightPalette.text.sub),
        helperStyle: TextStyle(color: lightPalette.text.sub),
        hintStyle: TextStyle(color: lightPalette.text.sub),
      ),
    );
  }

  /// The compiled [CupertinoThemeData] for light mode, if applicable.
  CupertinoThemeData? get cupertinoLight {
    return CupertinoThemeData(
      brightness: Brightness.light,
      barBackgroundColor: lightPalette.primary.darker,
      primaryColor: lightPalette.primary.darker,
      primaryContrastingColor: lightPalette.primary.alpha10,
      scaffoldBackgroundColor: lightPalette.bg.white,
      applyThemeToAll: true,
    );
  }

  /// The compiled [CupertinoThemeData] for dark mode, if applicable.
  CupertinoThemeData? get cupertinoDark {
    return CupertinoThemeData(
      brightness: Brightness.dark,
      barBackgroundColor: lightPalette.primary.darker,
      primaryColor: lightPalette.primary.darker,
      primaryContrastingColor: lightPalette.primary.alpha10,
      scaffoldBackgroundColor: lightPalette.bg.white,
      applyThemeToAll: true,
    );
  }

  /// The grid layout configuration for the theme.
  GtGrid get grid => GtGrid();

  /// The typography font family definitions.
  GtFonts get fonts => GtFonts();

  /// Resolves the spacing and layout gap tokens for the given [context].
  GtSpacing get spacing => GtSpacing();

  /// Resolves the border radius tokens for the given [context].
  GtRadii get radii => GtRadii();

  /// Resolves the shadow and elevation tokens for the given [context].
  GtShadows shadows(BuildContext context) => GtShadows(context);

  /// Resolves the gradient styles for the given [context].
  GtGradients gradients(BuildContext context) => GtGradients(context);

  /// Resolves the typography and text styles for the given [context].
  GtTextStyles textStyles(BuildContext context) => GtTextStyles(context, fonts);

  /// Resolves the form input styles and decorations for the given [context].
  GtInputStyles inputStyles(BuildContext context) => GtInputStyles(context);

  /// The default page transition animations mapped by target platform.
  Map<TargetPlatform, PageTransitionsBuilder> get defaultTransitions {
    Map<TargetPlatform, PageTransitionsBuilder> transitionMap = {};
    for (final platform in TargetPlatform.values) {
      transitionMap[platform] = const CupertinoPageTransitionsBuilder();
    }
    return transitionMap;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! GtTheme) return false;
    return lightPalette == other.lightPalette &&
        darkPalette == other.darkPalette &&
        name == other.name;
  }

  @override
  int get hashCode => Object.hash(lightPalette, darkPalette, name);
}

/// The pre-configured theme specifically designed for the Kids application.
///
/// Uses `KidsLightPalette` and `KidsDarkPalette` for a playful and vibrant look.
final kKidsTheme = GtTheme(
  lightPalette: KidsLightPalette(),
  darkPalette: KidsDarkPalette(),
  name: "Kids",
);

/// The pre-configured default theme for the main Personal banking application.
///
/// Uses `PersonalLightPalette` and `PersonalDarkPalette` for a professional, corporate look.
final kPersonalTheme = GtTheme(
  lightPalette: PersonalLightPalette(),
  darkPalette: PersonalDarkPalette(),
  name: "Personal",
);

/// A comprehensive list of all available themes in the design system.
///
/// This list includes predefined themes such as [kPersonalTheme] and [kKidsTheme].
List<GtTheme> kAllThemes = [kPersonalTheme, kKidsTheme];

/// Retrieves the default theme, which is the first theme in the list of all themes.
/// This can be used as a fallback or default selection when no specific theme is chosen.
GtTheme get kDefaultTheme => kAllThemes.first;
