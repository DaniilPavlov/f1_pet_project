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
  String get navCircuits => 'Трассы';

  @override
  String get navPredictor => 'Предикт';

  @override
  String get navProfile => 'Профиль';

  @override
  String get homeHeadlinesTitle => 'Новости';

  @override
  String get homeScrollToNews => 'К новостям';

  @override
  String get profileTitle => 'Профиль';

  @override
  String get profileAccountSection => 'Аккаунт';

  @override
  String profileSignedInAs(String email) {
    return 'Вы вошли как $email';
  }

  @override
  String get profileNotSignedIn => 'Вы не авторизованы';

  @override
  String get profileSignIn => 'Войти';

  @override
  String get profileSignOut => 'Выйти';

  @override
  String get profileRegister => 'Зарегистрироваться';

  @override
  String get profilePredictorRequiresAuth =>
      'Войдите, чтобы пользоваться предиктором';

  @override
  String get profilePredictorRequiresVerification =>
      'Подтвердите email, чтобы пользоваться предиктором';

  @override
  String get profileEmailNotVerified =>
      'Мы отправили ссылку для подтверждения на вашу почту';

  @override
  String get profileResendVerification => 'Отправить ещё раз';

  @override
  String get profileRefreshVerification => 'Я подтвердил';

  @override
  String get profileVerificationSent => 'Письмо отправлено';

  @override
  String get profileStillNotVerified => 'Email ещё не подтверждён';

  @override
  String get profileEmailVerified => 'Email подтверждён';

  @override
  String get profileAppearanceSection => 'Внешний вид';

  @override
  String get profileTheme => 'Тема';

  @override
  String get profileLanguage => 'Язык';

  @override
  String get profileNotificationsSection => 'Уведомления';

  @override
  String get profileRaceReminders => 'Напоминания о сессиях';

  @override
  String get profileRaceRemindersSubtitle => 'За 30 минут до старта';

  @override
  String get profileRaceRemindersDisabledByRemote =>
      'Напоминания отключены удалённо';

  @override
  String get profilePracticeReminders => 'Напоминания о практиках';

  @override
  String get profilePracticeRemindersSubtitle => 'FP1, FP2, FP3';

  @override
  String get authSignInTitle => 'Вход';

  @override
  String get authRegisterTitle => 'Регистрация';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authPasswordLabel => 'Пароль';

  @override
  String get authNoAccount => 'Нет аккаунта? Зарегистрироваться';

  @override
  String get authHaveAccount => 'Уже есть аккаунт? Войти';

  @override
  String get authForgotPassword => 'Забыли пароль?';

  @override
  String get authPasswordResetSent => 'Письмо для сброса пароля отправлено';

  @override
  String get authErrorEmptyFields => 'Введите email и пароль';

  @override
  String get authErrorEmptyEmail => 'Введите email';

  @override
  String get authErrorInvalidEmail => 'Некорректный email';

  @override
  String get authErrorUserDisabled => 'Аккаунт отключён';

  @override
  String get authErrorUserNotFound => 'Аккаунт с таким email не найден';

  @override
  String get authErrorWrongPassword => 'Неверный пароль';

  @override
  String get authErrorInvalidCredential => 'Неверный email или пароль';

  @override
  String get authErrorEmailInUse => 'Email уже используется';

  @override
  String get authErrorWeakPassword =>
      'Пароль: минимум 8 символов, буква и цифра';

  @override
  String get authErrorDisposableEmail =>
      'Временные email-адреса не допускаются';

  @override
  String get authErrorTooManyRequests =>
      'Слишком много попыток. Попробуйте позже';

  @override
  String get authErrorNetwork => 'Ошибка сети. Проверьте соединение';

  @override
  String get authErrorGeneric => 'Что-то пошло не так. Попробуйте ещё раз';

  @override
  String get predictorTitle => 'Предиктор';

  @override
  String predictorSeasonPoints(String year, int points) {
    return '$year · $points очк.';
  }

  @override
  String get predictorLocked => 'Предикты заблокированы';

  @override
  String predictorLockIn(String countdown) {
    return 'Блок через $countdown';
  }

  @override
  String get predictorMissingQualiTime =>
      'Время квалификации пока неизвестно — правки ещё открыты';

  @override
  String get predictorWaitingResults => 'Ждём результаты';

  @override
  String get predictorNoUpcoming => 'Нет ближайшей гонки для предикта';

  @override
  String predictorMoveToTitle(String driver) {
    return 'Поставить $driver';
  }

  @override
  String get predictorMoveToHint =>
      'Обмен с этой позицией — остальные не сдвигаются';

  @override
  String get predictorCopyQualifyingToRace => 'Установить как в квалификации';

  @override
  String get predictorHistoryTitle => 'История сезона';

  @override
  String get predictorHistoryEmpty => 'Пока нет учтённых уикендов';

  @override
  String predictorWeekendPoints(String quali, String race, int total) {
    return 'Q $quali · R $race · $total очк.';
  }

  @override
  String get predictorPendingPoints => '—';

  @override
  String get predictorPredicted => 'Предикт';

  @override
  String get predictorActual => 'Факт';

  @override
  String predictorSessionPoints(int points) {
    return '$points очк.';
  }

  @override
  String get predictorCompareEmpty => 'Нет позиций для сравнения';

  @override
  String get predictorPastSeasonsTitle => 'Прошлые сезоны';

  @override
  String predictorSeasonButton(String year, int points, int races) {
    String _temp0 = intl.Intl.pluralLogic(
      points,
      locale: localeName,
      other: 'очков',
      many: 'очков',
      few: 'очка',
      one: 'очко',
    );
    String _temp1 = intl.Intl.pluralLogic(
      races,
      locale: localeName,
      other: 'гонок',
      many: 'гонок',
      few: 'гонки',
      one: 'гонка',
    );
    return '$year · $points $_temp0 · $races $_temp1';
  }

  @override
  String get predictorLeaderboardOpen => 'Лидерборд';

  @override
  String predictorLeaderboardTitle(String year) {
    return 'Лидерборд · $year';
  }

  @override
  String get predictorLeaderboardJoinHint =>
      'Придумай ник и согласись отображаться в публичном лидерборде сезона.';

  @override
  String get predictorNicknameLabel => 'Ник';

  @override
  String get predictorNicknameHint => '3–16 букв, цифр, _';

  @override
  String get predictorNicknameSave => 'Сохранить ник';

  @override
  String get predictorLeaderboardOptInLabel => 'Показывать меня в лидерборде';

  @override
  String get predictorLeaderboardOptInRequired =>
      'Нужно согласие на отображение в лидерборде';

  @override
  String get predictorLeaderboardJoin => 'Вступить в лидерборд';

  @override
  String get predictorLeaderboardLeave => 'Покинуть лидерборд';

  @override
  String get predictorLeaderboardListTitle => 'Таблица';

  @override
  String get predictorLeaderboardEmpty => 'Пока никого нет — будь первым';

  @override
  String predictorLeaderboardYourRank(int rank, int points) {
    return 'Ты · #$rank · $points очк.';
  }

  @override
  String get predictorNicknameErrorLength => 'Ник должен быть 3–16 символов';

  @override
  String get predictorNicknameErrorChars =>
      'Только буквы, цифры и подчёркивание';

  @override
  String get predictorNicknameErrorTaken => 'Этот ник уже занят';

  @override
  String get predictorLeaderboardErrorGeneric =>
      'Не удалось обновить лидерборд. Попробуй ещё раз';

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
  String get liveSessionBanner => 'Идёт сессия';

  @override
  String liveSessionBannerWithSession(String session) {
    return 'Идёт сессия · $session';
  }

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
  String get search => 'Поиск';

  @override
  String get raceSearchInfo => 'Выберите сезон, затем гонку из списка.';

  @override
  String get raceNotFound =>
      'По вашему запросу гонок не найдено. Проверьте введенные данные и попробуйте еще раз.';

  @override
  String get hallOfFameTitle => 'Зал славы';

  @override
  String get seasonRewindTitle => 'Перемотка сезона';

  @override
  String get seasonRewindSubtitle =>
      'Гонка таблиц: standings после каждого раунда';

  @override
  String get seasonRewindEmpty => 'В этом сезоне ещё нет завершённых этапов';

  @override
  String get seasonRewindPlay => 'Воспроизвести';

  @override
  String get seasonRewindPause => 'Пауза';

  @override
  String seasonRewindRaceOf(int index, int total) {
    return '$index / $total';
  }

  @override
  String get seasonRewindChartHint =>
      'Все участники по очкам — двигайте слайдер или нажмите Play';

  @override
  String get seasonRewindLoadError =>
      'Не удалось загрузить standings для этого раунда';

  @override
  String get h2hTitle => 'H2H';

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
  String get h2hPointsTimelineTitle => 'Очки по раундам';

  @override
  String get h2hPointsTimelineSubtitle =>
      'Накопленные очки чемпионата (гонка + спринт)';

  @override
  String get h2hPointsTimelineEmpty => 'Нет результатов гонок для сравнения';

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
  String get shareWeekendSummary => 'Поделиться сводкой уикенда';

  @override
  String get shareWeekendPodium => 'Подиум';

  @override
  String get selectDriver => 'Выберите пилота';

  @override
  String get driversLoadError => 'Не удалось загрузить пилотов';

  @override
  String get onMap => 'На карте';

  @override
  String get asList => 'Списком';

  @override
  String get circuitsMapWebUnavailable =>
      'Карта доступна в мобильном приложении. Ниже — список трасс.';

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
  String cityLabel(String city) {
    return 'Город: $city';
  }

  @override
  String scheduleRound(String round) {
    return 'Этап $round';
  }

  @override
  String get scheduleCountdownTitle => 'До FP1';

  @override
  String get scheduleDays => 'Дни';

  @override
  String get scheduleHours => 'Часы';

  @override
  String get scheduleMinutes => 'Минуты';

  @override
  String get scheduleViewSessions => 'Расписание сессий';

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
  String get careerRaceListLoading => 'Загружаем список гонок…';

  @override
  String newsArticleSemantics(String headline) {
    return 'Новость: $headline';
  }

  @override
  String navTabSemantics(String title, String selected) {
    return '$title, вкладка$selected';
  }

  @override
  String get navTabSelectedSuffix => ', выбрана';

  @override
  String predictorDriverSemantics(int position, String name, String locked) {
    return 'P$position $name$locked';
  }

  @override
  String get predictorLockedSuffix => ', заблокировано';

  @override
  String predictorHistorySemantics(
    String race,
    String quali,
    String racePts,
    int total,
  ) {
    return '$race, Q $quali, R $racePts, $total очков';
  }

  @override
  String get h2hModeDrivers => 'Пилоты';

  @override
  String get h2hModeConstructors => 'Конструкторы';

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
  String get showingCachedData => 'Показаны сохранённые данные';

  @override
  String get locationUnavailable => 'Невозможно определить местоположение';

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
  String get tooManyRequestsSubtitle =>
      'API временно ограничивает частоту. Подождите немного и попробуйте снова.';

  @override
  String get requestError => 'Ошибка при отправке запроса';

  @override
  String get responseParseError => 'Ошибка при обработке ответа от сервера';

  @override
  String get unexpectedError => 'Непредвиденная ошибка';

  @override
  String get errorRetrySubtitle => 'Попробуйте обновить экран.';

  @override
  String get forceUpdateTitle => 'Требуется обновление';

  @override
  String get forceUpdateSubtitle =>
      'Эта версия больше не поддерживается. Скачайте свежий релиз на GitHub.';

  @override
  String get forceUpdateButton => 'Обновить';
}
