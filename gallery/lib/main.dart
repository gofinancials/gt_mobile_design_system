import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'main.directories.g.dart';
import 'addons/gt_theme_addon.dart';

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
  String get copyrightText => "© 2024 Go Tech";

  @override
  String get countryCode => "US";

  @override
  String get dbName => "gallery_db";

  @override
  String get defaultAvatar => "";

  @override
  String get defaultLanguageCode => "en";

  @override
  Locale get defaultLocale => const Locale('en', 'US');

  @override
  bool get isMock => true;

  @override
  String get logo => "";

  @override
  String get package => "com.gotech.gallery";

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
  runApp(const WidgetbookApp());
}

@widgetbook.App()
class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GtThemeProvider(
      theme: kPersonalTheme,
      child: Widgetbook.material(
        initialRoute: "?path=designsystemcover/cover",
        directories: directories,
        addons: [
          ViewportAddon(Viewports.all),
          GtThemeAddon(themes: kAllThemes),
          InspectorAddon(),
          TextScaleAddon(max: 1.5),
          ZoomAddon(),
        ],
      ),
    );
  }
}
