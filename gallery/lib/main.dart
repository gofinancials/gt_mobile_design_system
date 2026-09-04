import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'main.directories.g.dart';
import 'addons/addons.dart';

class GalleryConfig extends AppConfig {
  @override
  String get appName => "GT Mobile Gallery";

  @override
  String get baseUrl => "";

  @override
  String get aboutUsUrl => "";

  @override
  String get appId => "com.gotech.gallery";

  @override
  String get cipherIV => "";

  @override
  String get cipherKey => "";

  @override
  String get countryCode => "+234";

  @override
  String get dbName => "gallery_db";

  @override
  String get defaultLanguageCode => "en";

  @override
  Locale get defaultLocale => const Locale('en', 'US');

  @override
  bool get isMock => true;

  @override
  String get privacyUrl => "";

  @override
  String? get rsaPublicKeyPath => null;

  @override
  String get scheme => "gallery";

  @override
  AppConfigStrings get strings {
    return const AppConfigStrings(
      seconds: "seconds",
      minutes: "minutes",
      requestFailedUnexpectedly: "Request failed unexpectedly",
      checkNetwork: "Please check your network connection",
      noInternet: "No internet connection",
      momentsAgo: "Moments ago",
      minutesAgo: "Minutes ago",
      anHourAgo: "An hour ago",
      hoursAgo: "Hours ago",
      daysAgo: "Days ago",
      daysOld: "Days old",
      weeksOld: "Weeks old",
      monthsOld: "Months old",
      yearsOld: "Years old",
      yesterday: "Yesterday",
      fieldRequired: "This field is required",
      passwordRequired: "Password is required",
      passwordMustHaveNChars: "Password must have at least %s characters",
      invalidEmail: "Invalid email address",
      provideValidEmail: "Please provide a valid email address",
      invalidPhone: "Invalid phone number",
      invalidDate: "Invalid date",
      mustBeNYears: "Must be at least %s years old",
      invalidUrl: "Invalid URL",
      invalidAmount: "Invalid amount",
      amountMinimum: "Amount is below minimum",
      amountMaximum: "Amount exceeds maximum",
      fieldsDontMatch: "Fields do not match",
      invalidNumber: "Invalid number",
      minLength: "Minimum length not reached",
      maxLength: "Maximum length exceeded",
      insufficentFunds: "Insuffcient funds",
      copiedToClipboard: "Copied to clipboard",
      copiedFromClipboard: "Copied from clipboard",
      requestTimedOut: "Request timed out",
      secureConnectionFailed: "Secure connection failed",
      requestCancelled: "Request cancelled",
    );
  }

  @override
  String get supportUrl => "";

  @override
  List<Locale> get supportedLocales => const [Locale('en', 'US')];

  @override
  String get termsOfUseUrl => "";

  @override
  List<String> get webAppHosts => const [];
}

void main() {
  locator.registerLazySingleton<AppConfig>(() {
    return GalleryConfig();
  });
  locator.registerLazySingleton<GtThemeState>(() {
    return GtThemeState(AppMockStorageService(), kPersonalTheme);
  });

  runApp(const WidgetbookApp());
}

final ValueNotifier<GtThemeSetting> themeNotifier = ValueNotifier(
  GtThemeSetting(theme: kPersonalTheme, mode: ThemeMode.light),
);

@widgetbook.App()
class WidgetbookApp extends GtStatefulWidget {
  const WidgetbookApp({super.key});

  @override
  State<WidgetbookApp> createState() => _WidgetbookAppState();
}

class _WidgetbookAppState extends State<WidgetbookApp> {
  @override
  void initState() {
    super.initState();
    themeNotifier.addListener(_syncTheme);
  }

  @override
  void dispose() {
    themeNotifier.removeListener(_syncTheme);
    super.dispose();
  }

  void _syncTheme() {
    locator<GtThemeState>().switchTheme(themeNotifier.value.theme);
  }

  @override
  Widget build(BuildContext context) {
    final state = GtThemeSetting(theme: kPersonalTheme, mode: .system);
    final activeTheme = state.theme;
    final activeMode = state.mode;

    return GtStateWrapper(
      providers: [
        ChangeNotifierProvider<GtThemeState>(
          create: (_) => locator(),
          lazy: true,
        ),
      ],
      child: GtThemeProvider(
        theme: activeTheme,
        child: Widgetbook.material(
          initialRoute: "?path=designsystemcover/cover",
          directories: directories,
          darkTheme: activeTheme.materialDark,
          lightTheme: activeTheme.materialLight,
          themeMode: activeMode,
          addons: [
            ViewportAddon(Viewports.all),
            GtThemeAddon(themes: kAllThemes, themeNotifier: themeNotifier),
            // Nested in list order, so anything after the theme addon sits
            // closer to the use case and its MediaQuery wins. The theme addon
            // pins textScaler to 1, which is what TextScaleAddon overrides.
            GtAccessibilityAddon(),
            InspectorAddon(),
            // Renders the semantics tree over the use case, which is the only
            // practical way to see what a component announces without running
            // a screen reader. Marked experimental upstream; the worst case is
            // that a future widgetbook drops it and this line comes out.
            // ignore: experimental_member_use
            SemanticsAddon(),
            TextScaleAddon(max: 2),
            ZoomAddon(),
          ],
        ),
      ),
    );
  }
}
