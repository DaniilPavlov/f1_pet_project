# F1 App Project

Flutter app with Formula 1 stats  
(standings, results, calendar, hall of fame, circuits).

Data — [Jolpica F1 API](https://github.com/jolpica/jolpica-f1) (Ergast-compatible).

Same idea, other stacks:

- [f1_kotlin](https://github.com/DaniilPavlov/f1_kotlin) — Kotlin + Jetpack Compose (Android)
- [f1_kmp](https://github.com/DaniilPavlov/f1_kmp) — Kotlin Multiplatform (Android / iOS)

## Stack

| Layer | Tech |
|------|------------|
| UI | Flutter, Material |
| State | MobX + Provider |
| Navigation | Auto Route |
| Network | Dio |
| Codegen | json_serializable, mobx_codegen, auto_route_generator |
| Map | Yandex MapKit |

## Structure

```
f1_pet_project/
├── lib/
│   ├── common/      # widgets, theme, helpers, map package
│   ├── core/        # features: home, results, schedule, news, circuits, h2h, …
│   ├── data/        # response models, exceptions
│   ├── services/    # Dio, executor, cache
│   └── router/      # Auto Route
├── test/
├── android/
├── ios/
└── .github/workflows/
```

## Requirements

- Flutter **3.35.3+**
- Dart **3.8+**
- Java **21** (Android / Yandex MapKit)
- Yandex MapKit API key (see below)

## Yandex MapKit

The key is **not stored in git**.

**Android** — in `android/local.properties`:

```properties
yandex.mapkit.apiKey=YOUR_KEY
```

**iOS** — copy the example and put your key in:

```bash
cp ios/Flutter/Secrets.xcconfig.example ios/Flutter/Secrets.xcconfig
```

## Run

```bash
flutter pub get
dart run build_runner build
flutter run
```

## Tests and analysis

```bash
flutter analyze
flutter test
```

## CI / CD

[![CI](https://github.com/DaniilPavlov/f1_pet_project/actions/workflows/ci.yml/badge.svg)](https://github.com/DaniilPavlov/f1_pet_project/actions/workflows/ci.yml)

| Workflow | When | What it does |
|----------|-------|------------|
| `ci.yml` | push / PR to `master` | codegen check, analyze, test |
| `release.yml` | tag `v*` or manual | Android APK (+ GitHub Release) |

Release:

```bash
# version in pubspec.yaml must match the tag
git tag v1.0.2
git push origin v1.0.2
```

For release APK signing (optional) — `ANDROID_KEYSTORE_*` secrets in GitHub Actions.

## Features

- **Home** — current season driver and constructor standings  
- **Results** — weekend scoreboard, latest race, race search, hall of fame, H2H (drivers / constructors), finish statuses  
- **Calendar** — season schedule with weekend sessions and reminders  
- **News** — F1 headlines from ESPN  
- **Circuits** — list and Yandex MapKit map with pins/clusters, circuit card, Wikipedia, winners history  
- **Driver / Constructor cards** — career stats with tappable wins / podiums / poles lists, share as image  
- **Localization** — Russian and English  
- **Reminders** — local notifications 30 minutes before a session  
- **Schedule cache** — shared daily cache for the calendar and reminders  
