import 'package:amphi/models/app_localizations.dart';
import 'package:flutter/material.dart';

class Language extends StatelessWidget {

  final String label;
  final Locale? locale;
  const Language({super.key, required this.label, required this.locale});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      overflow: TextOverflow.ellipsis,
    );
  }

  static List<Language> items(BuildContext context) {

  return [
    Language(label: AppLocalizations.of(context).get("@locale_label_system"), locale: null),
    const Language(label: "العربية", locale: Locale("ar")),
    const Language(label: "বাংলা", locale: Locale("bn")),
    const Language(label: "Dansk", locale: Locale("da")),
    const Language(label: "Deutsch", locale: Locale("de")),
    const Language(label: "English", locale: Locale("en")),
    const Language(label: "Español", locale: Locale("es")),
    const Language(label: "Suomi", locale: Locale("fi")),
    const Language(label: "Français", locale: Locale("fr")),
    const Language(label: "Ελληνικά", locale: Locale("el")),
    const Language(label: "हिंदी", locale: Locale("hi")),
    const Language(label: "Bahasa Indonesia", locale: Locale("id")),
    const Language(label: "Italiano", locale: Locale("it")),
    const Language(label: "日本語", locale: Locale("ja")),
    const Language(label: "한국어", locale: Locale("ko")),
    const Language(label: "Nederlands", locale: Locale("nl")),
    const Language(label: "Norsk", locale: Locale("no")),
    const Language(label: "Português", locale: Locale("pt")),
    const Language(label: "Pусский", locale: Locale("ru")),
    const Language(label: "Svenska", locale: Locale("sv")),
    const Language(label: "ไทย", locale: Locale("th")),
    const Language(label: "Türkçe", locale: Locale("tr")),
    const Language(label: "Tiếng Việt", locale: Locale("vi")),
    const Language(label: "اردو", locale: Locale("ur")),
    const Language(label: "繁体中文", locale: Locale("zh", "Hant")),
    // Language(label: "简体中文", locale: Locale("zh", "Hans")),
  ];

}


  static List<DropdownMenuItem<Locale?>> dropdownItems(BuildContext context) {
    return items(context).map((language) {
      return DropdownMenuItem<Locale?>(
        value: language.locale,
        child: Text(
          language.label,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }).toList();
  }

}

class LanguageDropDownItem extends DropdownMenuItem {

    final Locale locale;
 const LanguageDropDownItem({super.key, required super.child, required this.locale});

}




