import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

List<String> supportedAppLanguages = [
  "en", // English
  "ko", // Korean
  "ja", // Japanese
  "es", // Spanish
  "fr", // French
  "de", // German
  "it", // Italian
  "pt", // Portuguese
  "ru", // Russian
  "zh", // Chinese (Simplified)
  // "zh-TW", // Chinese (Traditional)
  "ar", // Arabic
  "hi", // Hindi
  "bn", // Bengali
  "pa", // Punjabi
  "ur", // Urdu
  "vi", // Vietnamese
  "th", // Thai
  "ms", // Malay
  "id", // Indonesian
  "tr", // Turkish
  "nl", // Dutch
  "sv", // Swedish
  "da", // Danish
  "fi", // Finnish
  "no", // Norwegian
  "pl", // Polish
  "uk", // Ukrainian
  "cs", // Czech
  "hu", // Hungarian
  "ro", // Romanian
  "el", // Greek
  "he", // Hebrew
];

List<Locale> supportedAppLocales = [
  const Locale("en"), // English
  const Locale("ko"), // Korean
  const Locale("ja"), // Japanese
  const Locale("es"), // Spanish
  const Locale("fr"), // French
  const Locale("de"), // German
  const Locale("it"), // Italian
  const Locale("pt"), // Portuguese
  const Locale("ru"), // Russian
  const Locale("zh"), // Chinese (Simplified)
  // Locale("zh", "TW"), // Chinese (Traditional)
  const Locale("ar"), // Arabic
  const Locale("hi"), // Hindi
  const Locale("bn"), // Bengali
  const Locale("pa"), // Punjabi
  const Locale("ur"), // Urdu
  const Locale("vi"), // Vietnamese
  const Locale("th"), // Thai
  const Locale("ms"), // Malay
  const Locale("id"), // Indonesian
  const Locale("tr"), // Turkish
  const Locale("nl"), // Dutch
  const Locale("sv"), // Swedish
  const Locale("da"), // Danish
  const Locale("fi"), // Finnish
  const Locale("no"), // Norwegian
  const Locale("pl"), // Polish
  const Locale("uk"), // Ukrainian
  const Locale("cs"), // Czech
  const Locale("hu"), // Hungarian
  const Locale("ro"), // Romanian
  const Locale("el"), // Greek
  const Locale("he"), // Hebrew
];

class AppLocalizations {
  AppLocalizations._internal(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    AppLocalizations? appLocalizations = Localizations.of<AppLocalizations>(context, AppLocalizations);
if(appLocalizations == null) {
   return AppLocalizations._internal(Localizations.localeOf(context));
}
else {
  return appLocalizations;
}
  }

  static List<Locale> supportedLocales = supportedAppLocales;

  Map<String, dynamic> data = {};

  late Map<String, dynamic> fallbackData;

  Future<void> load() async {
    fallbackData = json.decode(
      await rootBundle.loadString('assets/strings/en.json'),
    );

    if (locale.languageCode == 'en') {
      data = fallbackData;
      return;
    }

    try {
      final raw = await rootBundle.loadString(
        'assets/strings/${locale.languageCode}.json',
      );
      data = json.decode(raw);
    } catch (_) {
      data = {};
    }
  }


  String get(String key) {
    return data[key] ?? fallbackData[key] ?? key;
  }
}

class LocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {
  const LocalizationDelegate();

  @override
  bool isSupported(Locale locale) {
    return supportedAppLanguages.contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations._internal(locale);
    await localizations.load();

    return localizations;
  }

  @override
  bool shouldReload(LocalizationDelegate old) => false;
}