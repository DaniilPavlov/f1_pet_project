import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @navHome.
  ///
  /// In ru, this message translates to:
  /// **'Главная'**
  String get navHome;

  /// No description provided for @navResults.
  ///
  /// In ru, this message translates to:
  /// **'Результаты'**
  String get navResults;

  /// No description provided for @navCalendar.
  ///
  /// In ru, this message translates to:
  /// **'Календарь'**
  String get navCalendar;

  /// No description provided for @navHallOfFame.
  ///
  /// In ru, this message translates to:
  /// **'Зал славы'**
  String get navHallOfFame;

  /// No description provided for @navCircuits.
  ///
  /// In ru, this message translates to:
  /// **'Трассы'**
  String get navCircuits;

  /// No description provided for @homeStandingsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Турнирная таблица текущего сезона'**
  String get homeStandingsTitle;

  /// No description provided for @seasonLabel.
  ///
  /// In ru, this message translates to:
  /// **'Сезон: {season}'**
  String seasonLabel(String season);

  /// No description provided for @roundLabel.
  ///
  /// In ru, this message translates to:
  /// **'Раунд: {round}'**
  String roundLabel(String round);

  /// No description provided for @drivers.
  ///
  /// In ru, this message translates to:
  /// **'Пилоты'**
  String get drivers;

  /// No description provided for @constructors.
  ///
  /// In ru, this message translates to:
  /// **'Конструкторы'**
  String get constructors;

  /// No description provided for @driver.
  ///
  /// In ru, this message translates to:
  /// **'Пилот'**
  String get driver;

  /// No description provided for @constructor.
  ///
  /// In ru, this message translates to:
  /// **'Конструктор'**
  String get constructor;

  /// No description provided for @nationality.
  ///
  /// In ru, this message translates to:
  /// **'Национальность'**
  String get nationality;

  /// No description provided for @points.
  ///
  /// In ru, this message translates to:
  /// **'Очки'**
  String get points;

  /// No description provided for @wins.
  ///
  /// In ru, this message translates to:
  /// **'Победы'**
  String get wins;

  /// No description provided for @winsShort.
  ///
  /// In ru, this message translates to:
  /// **'W'**
  String get winsShort;

  /// No description provided for @country.
  ///
  /// In ru, this message translates to:
  /// **'Страна'**
  String get country;

  /// No description provided for @time.
  ///
  /// In ru, this message translates to:
  /// **'Время'**
  String get time;

  /// No description provided for @bestLap.
  ///
  /// In ru, this message translates to:
  /// **'Лучший\nкруг'**
  String get bestLap;

  /// No description provided for @none.
  ///
  /// In ru, this message translates to:
  /// **'нет'**
  String get none;

  /// No description provided for @fastestLapLabel.
  ///
  /// In ru, this message translates to:
  /// **'{time}\nсамый\nбыстрый'**
  String fastestLapLabel(String time);

  /// No description provided for @detailedInfo.
  ///
  /// In ru, this message translates to:
  /// **'Подробная информация'**
  String get detailedInfo;

  /// No description provided for @race.
  ///
  /// In ru, this message translates to:
  /// **'Гонка'**
  String get race;

  /// No description provided for @sprint.
  ///
  /// In ru, this message translates to:
  /// **'Спринт'**
  String get sprint;

  /// No description provided for @qualifying.
  ///
  /// In ru, this message translates to:
  /// **'Квалификация'**
  String get qualifying;

  /// No description provided for @pitStops.
  ///
  /// In ru, this message translates to:
  /// **'Пит-стопы'**
  String get pitStops;

  /// No description provided for @lap.
  ///
  /// In ru, this message translates to:
  /// **'Круг'**
  String get lap;

  /// No description provided for @stopNumber.
  ///
  /// In ru, this message translates to:
  /// **'Номер\nостановки'**
  String get stopNumber;

  /// No description provided for @stopTime.
  ///
  /// In ru, this message translates to:
  /// **'Время\nстопа'**
  String get stopTime;

  /// No description provided for @raceTime.
  ///
  /// In ru, this message translates to:
  /// **'Время\nгонки'**
  String get raceTime;

  /// No description provided for @lastRace.
  ///
  /// In ru, this message translates to:
  /// **'Последняя гонка: '**
  String get lastRace;

  /// No description provided for @chooseSpecificRace.
  ///
  /// In ru, this message translates to:
  /// **'Выбрать конкретную гонку'**
  String get chooseSpecificRace;

  /// No description provided for @raceSearchTitle.
  ///
  /// In ru, this message translates to:
  /// **'Поиск гонки'**
  String get raceSearchTitle;

  /// No description provided for @season.
  ///
  /// In ru, this message translates to:
  /// **'Сезон'**
  String get season;

  /// No description provided for @yearHint.
  ///
  /// In ru, this message translates to:
  /// **'Год'**
  String get yearHint;

  /// No description provided for @round.
  ///
  /// In ru, this message translates to:
  /// **'Раунд'**
  String get round;

  /// No description provided for @numberHint.
  ///
  /// In ru, this message translates to:
  /// **'Номер'**
  String get numberHint;

  /// No description provided for @search.
  ///
  /// In ru, this message translates to:
  /// **'Поиск'**
  String get search;

  /// No description provided for @raceSearchInfo.
  ///
  /// In ru, this message translates to:
  /// **'Здесь вы можете найти результаты определенной гонки, начиная с 1950 года.\nМинимальное количество раундов в сезоне - 7, максимальное - 24.\n(данные на момент 2026 года)'**
  String get raceSearchInfo;

  /// No description provided for @raceNotFound.
  ///
  /// In ru, this message translates to:
  /// **'По вашему запросу гонок не найдено. Проверьте введенные данные и попробуйте еще раз.'**
  String get raceNotFound;

  /// No description provided for @hallOfFameTitle.
  ///
  /// In ru, this message translates to:
  /// **'Зал славы'**
  String get hallOfFameTitle;

  /// No description provided for @onMap.
  ///
  /// In ru, this message translates to:
  /// **'На карте'**
  String get onMap;

  /// No description provided for @asList.
  ///
  /// In ru, this message translates to:
  /// **'Списком'**
  String get asList;

  /// No description provided for @circuitDetails.
  ///
  /// In ru, this message translates to:
  /// **'Подробнее о трассе'**
  String get circuitDetails;

  /// No description provided for @circuitInfoTitle.
  ///
  /// In ru, this message translates to:
  /// **'Информация о трассе'**
  String get circuitInfoTitle;

  /// No description provided for @readOnWikipedia.
  ///
  /// In ru, this message translates to:
  /// **'Прочитать информацию в википедии'**
  String get readOnWikipedia;

  /// No description provided for @countryLabel.
  ///
  /// In ru, this message translates to:
  /// **'Страна: {country}'**
  String countryLabel(String country);

  /// No description provided for @cityLabel.
  ///
  /// In ru, this message translates to:
  /// **'Город: {city}'**
  String cityLabel(String city);

  /// No description provided for @firstPractice.
  ///
  /// In ru, this message translates to:
  /// **'Первая практика'**
  String get firstPractice;

  /// No description provided for @secondPractice.
  ///
  /// In ru, this message translates to:
  /// **'Вторая практика'**
  String get secondPractice;

  /// No description provided for @thirdPractice.
  ///
  /// In ru, this message translates to:
  /// **'Третья практика'**
  String get thirdPractice;

  /// No description provided for @sprintQualifying.
  ///
  /// In ru, this message translates to:
  /// **'Спринт-квалификация'**
  String get sprintQualifying;

  /// No description provided for @driverCode.
  ///
  /// In ru, this message translates to:
  /// **'Код'**
  String get driverCode;

  /// No description provided for @driverNumber.
  ///
  /// In ru, this message translates to:
  /// **'Номер'**
  String get driverNumber;

  /// No description provided for @dateOfBirth.
  ///
  /// In ru, this message translates to:
  /// **'Дата рождения'**
  String get dateOfBirth;

  /// No description provided for @openInWikipedia.
  ///
  /// In ru, this message translates to:
  /// **'Открыть в Wikipedia'**
  String get openInWikipedia;

  /// No description provided for @driverCareerTitle.
  ///
  /// In ru, this message translates to:
  /// **'Карьера'**
  String get driverCareerTitle;

  /// No description provided for @driverTeamsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Команды'**
  String get driverTeamsTitle;

  /// No description provided for @driverStatRaces.
  ///
  /// In ru, this message translates to:
  /// **'Гонки'**
  String get driverStatRaces;

  /// No description provided for @driverStatPodiums.
  ///
  /// In ru, this message translates to:
  /// **'Подиумы'**
  String get driverStatPodiums;

  /// No description provided for @driverStatPoles.
  ///
  /// In ru, this message translates to:
  /// **'Поулы'**
  String get driverStatPoles;

  /// No description provided for @noConnection.
  ///
  /// In ru, this message translates to:
  /// **'Соединение отсутствует'**
  String get noConnection;

  /// No description provided for @noConnectionSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Как только соединение восстановится, вы снова сможете пользоваться приложением'**
  String get noConnectionSubtitle;

  /// No description provided for @refresh.
  ///
  /// In ru, this message translates to:
  /// **'Обновить'**
  String get refresh;

  /// No description provided for @notNow.
  ///
  /// In ru, this message translates to:
  /// **'не сейчас'**
  String get notNow;

  /// No description provided for @settings.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get settings;

  /// No description provided for @locationPermissionNeeded.
  ///
  /// In ru, this message translates to:
  /// **'Приложению требуется доступ к геопозиции.'**
  String get locationPermissionNeeded;

  /// No description provided for @tooManyRequests.
  ///
  /// In ru, this message translates to:
  /// **'Слишком много запросов'**
  String get tooManyRequests;

  /// No description provided for @requestError.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка при отправке запроса'**
  String get requestError;

  /// No description provided for @responseParseError.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка при обработке ответа от сервера'**
  String get responseParseError;

  /// No description provided for @unexpectedError.
  ///
  /// In ru, this message translates to:
  /// **'Непредвиденная ошибка'**
  String get unexpectedError;

  /// No description provided for @openUrlFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось перейти по ссылке {url}'**
  String openUrlFailed(String url);

  /// No description provided for @localeCodeRu.
  ///
  /// In ru, this message translates to:
  /// **'RU'**
  String get localeCodeRu;

  /// No description provided for @localeCodeEn.
  ///
  /// In ru, this message translates to:
  /// **'EN'**
  String get localeCodeEn;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
