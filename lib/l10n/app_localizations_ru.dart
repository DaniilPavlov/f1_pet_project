// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get navHome => 'Главная';

  @override
  String get navResults => 'Результаты';

  @override
  String get navCalendar => 'Календарь';

  @override
  String get navNews => 'Новости';

  @override
  String get navCircuits => 'Трассы';

  @override
  String get newsTitle => 'Новости';

  @override
  String get newsEmpty => 'Новостей пока нет';

  @override
  String get homeStandingsTitle => 'Турнирная таблица текущего сезона';

  @override
  String get circuitStatLength => 'Длина';

  @override
  String get circuitStatLaps => 'Круги';

  @override
  String get circuitStatTurns => 'Повороты';

  @override
  String get circuitStatTopSpeed => 'Скорость';

  @override
  String get circuitStatElevation => 'Перепад';

  @override
  String get homeWeekendTitle => 'Уикенд';

  @override
  String get homeWeekendLive => 'Live';

  @override
  String homeWeekendLeader(String name) {
    return 'Лидер: $name';
  }

  @override
  String homeWeekendWinner(String name) {
    return 'Победитель: $name';
  }

  @override
  String weekendSessionResultsTitle(String session) {
    return 'Результаты: $session';
  }

  @override
  String get weekendSessionResultsEmpty => 'Результатов пока нет';

  @override
  String get driverNotFound => 'Пилот не найден';

  @override
  String seasonLabel(String season) {
    return 'Сезон: $season';
  }

  @override
  String roundLabel(String round) {
    return 'Раунд: $round';
  }

  @override
  String get drivers => 'Пилоты';

  @override
  String get constructors => 'Конструкторы';

  @override
  String get driver => 'Пилот';

  @override
  String get constructor => 'Конструктор';

  @override
  String get nationality => 'Национальность';

  @override
  String get points => 'Очки';

  @override
  String get wins => 'Победы';

  @override
  String get winsShort => 'W';

  @override
  String get country => 'Страна';

  @override
  String get time => 'Время';

  @override
  String get timeStatus => 'Время /\nстатус';

  @override
  String get bestLap => 'Лучший\nкруг';

  @override
  String get none => 'нет';

  @override
  String fastestLapLabel(String time) {
    return '$time\nсамый\nбыстрый';
  }

  @override
  String get detailedInfo => 'Подробная информация';

  @override
  String get race => 'Гонка';

  @override
  String get sprint => 'Спринт';

  @override
  String get qualifying => 'Квалификация';

  @override
  String get pitStops => 'Пит-стопы';

  @override
  String get lap => 'Круг';

  @override
  String get stopNumber => 'Номер\nостановки';

  @override
  String get stopTime => 'Время\nстопа';

  @override
  String get raceTime => 'Время\nгонки';

  @override
  String get chooseSpecificRace => 'Выбрать конкретную гонку';

  @override
  String get raceSearchTitle => 'Поиск гонки';

  @override
  String get season => 'Сезон';

  @override
  String get yearHint => 'Год';

  @override
  String get selectSeason => 'Выберите сезон';

  @override
  String get selectRace => 'Выберите гонку';

  @override
  String get selectSeasonFirst => 'Сначала выберите сезон';

  @override
  String get seasonsLoadError => 'Не удалось загрузить сезоны';

  @override
  String get racesLoadError => 'Не удалось загрузить гонки';

  @override
  String get round => 'Раунд';

  @override
  String get numberHint => 'Номер';

  @override
  String get search => 'Поиск';

  @override
  String get raceSearchInfo => 'Выберите сезон, затем гонку из списка.';

  @override
  String get raceNotFound =>
      'По вашему запросу гонок не найдено. Проверьте введенные данные и попробуйте еще раз.';

  @override
  String get hallOfFameTitle => 'Зал славы';

  @override
  String get h2hTitle => 'H2H · Пилоты';

  @override
  String get h2hSubtitle =>
      'Сравните двух пилотов с фильтрами периода и списка';

  @override
  String get h2hDriverA => 'Пилот 1';

  @override
  String get h2hDriverB => 'Пилот 2';

  @override
  String get h2hCompare => 'Сравнить';

  @override
  String get h2hFiltersTitle => 'Фильтры';

  @override
  String get h2hPeriodFilter => 'Период';

  @override
  String get h2hSeasonFilter => 'Сезон';

  @override
  String get h2hCurrentSeason => 'Текущий';

  @override
  String get h2hPickYear => 'Выбор года';

  @override
  String get h2hDriversFilter => 'Пилоты';

  @override
  String get h2hCurrentDrivers => 'Текущие';

  @override
  String get h2hAllDrivers => 'Все';

  @override
  String get h2hSearchDriver => 'Имя или код';

  @override
  String get h2hDriversEmpty => 'Пилоты не найдены';

  @override
  String get h2hConstructorsTitle => 'H2H · Конструкторы';

  @override
  String get h2hConstructorsSubtitle =>
      'Сравните двух конструкторов с фильтрами периода и списка';

  @override
  String get h2hConstructorA => 'Конструктор 1';

  @override
  String get h2hConstructorB => 'Конструктор 2';

  @override
  String get h2hConstructorsFilter => 'Конструкторы';

  @override
  String get h2hCurrentConstructors => 'Текущие';

  @override
  String get h2hAllConstructors => 'Все';

  @override
  String get h2hSearchConstructor => 'Название';

  @override
  String get h2hConstructorsEmpty => 'Конструкторы не найдены';

  @override
  String get selectConstructor => 'Выберите конструктора';

  @override
  String get constructorsLoadError => 'Не удалось загрузить конструкторов';

  @override
  String get finishStatusTitle => 'Статусы финиша';

  @override
  String get finishStatusSubtitle =>
      'Как пилоты завершали гонки в сезоне — Finished, Retired, DSQ, +круги и другие.';

  @override
  String get finishStatusEmpty => 'Нет статусов финиша за этот сезон';

  @override
  String get shareNoResults => 'Результатов гонки пока нет';

  @override
  String shareAndMore(int count) {
    return '…и ещё $count';
  }

  @override
  String get selectDriver => 'Выберите пилота';

  @override
  String get driversLoadError => 'Не удалось загрузить пилотов';

  @override
  String get onMap => 'На карте';

  @override
  String get asList => 'Списком';

  @override
  String get circuitDetails => 'Подробнее о трассе';

  @override
  String get circuitInfoTitle => 'Информация о трассе';

  @override
  String get circuitWinnersTitle => 'Победители';

  @override
  String get circuitWinnersEmpty => 'Побед на этой трассе пока нет';

  @override
  String get readOnWikipedia => 'Прочитать информацию в википедии';

  @override
  String countryLabel(String country) {
    return 'Страна: $country';
  }

  @override
  String cityLabel(String city) {
    return 'Город: $city';
  }

  @override
  String get firstPractice => 'Первая практика';

  @override
  String get secondPractice => 'Вторая практика';

  @override
  String get thirdPractice => 'Третья практика';

  @override
  String get sprintQualifying => 'Спринт-квалификация';

  @override
  String get driverCode => 'Код';

  @override
  String get driverNumber => 'Номер';

  @override
  String get dateOfBirth => 'Дата рождения';

  @override
  String get openInWikipedia => 'Открыть в Wikipedia';

  @override
  String get unknown => 'Неизвестно';

  @override
  String get currentTeam => 'Текущая команда';

  @override
  String get currentDrivers => 'Текущие пилоты';

  @override
  String get careerTitle => 'Карьера';

  @override
  String get driverNewsTitle => 'Последние новости';

  @override
  String get careerStatRaces => 'Гонки';

  @override
  String get careerStatPodiums => 'Подиумы';

  @override
  String get careerStatPoles => 'Поулы';

  @override
  String get careerRaceListEmpty => 'В этом списке пока нет гонок';

  @override
  String get driverTeamsTitle => 'Команды';

  @override
  String get constructorDriversTitle => 'Пилоты';

  @override
  String get noConnection => 'Соединение отсутствует';

  @override
  String get noConnectionSubtitle =>
      'Как только соединение восстановится, вы снова сможете пользоваться приложением';

  @override
  String get refresh => 'Обновить';

  @override
  String get notNow => 'не сейчас';

  @override
  String get settings => 'Настройки';

  @override
  String get locationPermissionNeeded =>
      'Приложению требуется доступ к геопозиции.';

  @override
  String get tooManyRequests => 'Слишком много запросов';

  @override
  String get requestError => 'Ошибка при отправке запроса';

  @override
  String get responseParseError => 'Ошибка при обработке ответа от сервера';

  @override
  String get unexpectedError => 'Непредвиденная ошибка';

  @override
  String openUrlFailed(String url) {
    return 'Не удалось перейти по ссылке $url';
  }

  @override
  String get localeCodeRu => 'RU';

  @override
  String get localeCodeEn => 'EN';
}
