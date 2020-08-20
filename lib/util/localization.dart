import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AppLocalizations {
  AppLocalizations(this.locale);
  final Locale locale;

  static AppLocalizations of(BuildContext context) =>
      Localizations.of(context, AppLocalizations);

  static const _localizedValues = {
    'en': {
      'app_title': 'Anzer Scheduling',
      
    },
    'my': {
      'app_title': 'ကြိုတင်ချိန်းဆို',
      
    }
  };

  String get apptitle => _localizedValues[locale.languageCode]['app_title'];
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'my'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) =>
      SynchronousFuture<AppLocalizations>(AppLocalizations(locale));

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}
