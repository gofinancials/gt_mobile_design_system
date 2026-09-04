import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';

/// A minimal [AppConfig] for widget tests.
///
/// Widgets such as `GtBaseWidget` resolve [AppConfig] from the service locator
/// during `build`, so any test that mounts them must register an implementation
/// first. Call [registerTestAppConfig] from `setUpAll`.
class TestAppConfig extends AppConfig {
  @override
  String get appName => "GT Mobile UI Tests";

  @override
  String get appId => "com.gotech.gt_mobile_ui.tests";

  @override
  String get baseUrl => "";

  @override
  String get aboutUsUrl => "";

  @override
  String get privacyUrl => "";

  @override
  String get supportUrl => "";

  @override
  String get termsOfUseUrl => "";

  @override
  String get cipherIV => "";

  @override
  String get cipherKey => "";

  @override
  String get countryCode => "+234";

  @override
  String get dbName => "test_db";

  @override
  String get defaultLanguageCode => "en";

  @override
  Locale get defaultLocale => const Locale('en', 'US');

  @override
  List<Locale> get supportedLocales => const [Locale('en', 'US')];

  @override
  bool get isMock => true;

  @override
  String? get rsaPublicKeyPath => null;

  @override
  String get scheme => "gttest";

  @override
  List<String> get webAppHosts => const [];

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
}

/// Registers a [TestAppConfig] with the service locator if one is not already
/// registered. Safe to call from every `setUpAll`.
void registerTestAppConfig() {
  if (locator.isRegistered<AppConfig>()) return;
  locator.registerLazySingleton<AppConfig>(TestAppConfig.new);
}
