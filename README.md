# F1 Pet Project

Flutter-приложение со статистикой Formula 1  
(турнирные таблицы, результаты, календарь, зал славы, трассы).

Данные — [Jolpica F1 API](https://github.com/jolpica/jolpica-f1) (совместим с Ergast).

## Стек

| Слой | Технологии |
|------|------------|
| UI | Flutter, Material |
| State | MobX + Provider |
| Навигация | Auto Route |
| Сеть | Dio |
| Codegen | json_serializable, mobx_codegen, auto_route_generator |
| Карта | Yandex MapKit |

## Структура

```
f1_pet_project/
├── lib/
│   ├── common/      # виджеты, тема, helpers, map package
│   ├── core/        # фичи: home, results, schedule, hall_of_fame, circuits, map
│   ├── data/        # модели ответа, exceptions
│   ├── services/    # Dio, executor, cache
│   └── router/      # Auto Route
├── test/
├── android/
├── ios/
└── .github/workflows/
```

## Требования

- Flutter **3.35.3+**
- Dart **3.8+**
- Java **21** (Android / Yandex MapKit)
- Yandex MapKit API key (см. ниже)

## Yandex MapKit

Ключ **не хранится в git**.

**Android** — в `android/local.properties`:

```properties
yandex.mapkit.apiKey=YOUR_KEY
```

**iOS** — скопируй example и подставь ключ:

```bash
cp ios/Flutter/Secrets.xcconfig.example ios/Flutter/Secrets.xcconfig
```

## Запуск

```bash
flutter pub get
dart run build_runner build
flutter run
```

## Тесты и анализ

```bash
flutter analyze
flutter test
```

## CI / CD

[![CI](https://github.com/DaniilPavlov/f1_pet_project/actions/workflows/ci.yml/badge.svg)](https://github.com/DaniilPavlov/f1_pet_project/actions/workflows/ci.yml)

| Workflow | Когда | Что делает |
|----------|-------|------------|
| `ci.yml` | push / PR в `master` | codegen check, analyze, test |
| `release.yml` | тег `v*` или вручную | Android APK (+ GitHub Release) |

Релиз:

```bash
# версия в pubspec.yaml должна совпадать с тегом
git tag v1.0.2
git push origin v1.0.2
```

Для release-подписи APK (опционально) — secrets `ANDROID_KEYSTORE_*` в GitHub Actions.

## Возможности

- **Главная** — турнирные таблицы пилотов и конструкторов текущего сезона  
- **Результаты** — последняя гонка, поиск гонки по году и раунду, детальная карточка (гонка, спринт, квалификация, пит-стопы)  
- **Календарь** — расписание сезона с сессиями уик-энда (практики, квалификация, спринт, спринт-квалификация, гонка)  
- **Зал славы** — итоговые таблицы пилотов и конструкторов за выбранный год  
- **Трассы** — список и карта Yandex MapKit с пинами/кластерами, карточка трассы и ссылка на Wikipedia  
- **Карточка пилота** — по нажатию на строку в таблицах (код, номер, национальность, дата рождения, Wikipedia)  
- **Локализация** — русский и английский, переключатель в верхней панели без перезапуска приложения  
- **Напоминания** — локальные уведомления за 30 минут до сессии (в ОС держим до 10 ближайших, окно обновляется при открытии приложения)
- **Кэш расписания** — общий дневной кэш для календаря и напоминаний
