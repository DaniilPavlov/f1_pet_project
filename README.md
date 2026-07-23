# F1 App

Flutter app with Formula 1 stats  
(standings, results, calendar, hall of fame, circuits).

Data:
- [Jolpica F1 API](https://github.com/jolpica/jolpica-f1) (Ergast-compatible) — schedule, results, standings
- [ESPN](https://site.api.espn.com/) — news, weekend scoreboard, driver photos

Same idea, other stacks:

- [f1_kotlin](https://github.com/DaniilPavlov/f1_kotlin) — Kotlin + Jetpack Compose (Android)
- [f1_kmp](https://github.com/DaniilPavlov/f1_kmp) — Kotlin Multiplatform (Android / iOS)

## Stack

| Layer | Tech |
|------|------------|
| UI | Flutter, Material |
| State | MobX + Provider |
| Navigation | Auto Route |
| Network | Dio (`AppDio`, Jolpica `RequestHandler`) |
| Data | Feature repositories + `AppDataRefresh` (pull-to-refresh) |
| Codegen | json_serializable, mobx_codegen, auto_route_generator |
| Map | Yandex MapKit |
| Backend | Firebase (Core, Analytics, Crashlytics, Remote Config), AppMetrica |

## Architecture

- **DI** — root `MultiProvider` in `lib/main.dart` (repos, `AppDataRefresh`, reminders). ESPN `Dio` is created in `main` and passed into repos.
- **Jolpica** — one `RequestHandler` wired via `ApiLoader.configure` (static access from repos); screens do not call Dio.
- **Repositories** — Jolpica/ESPN/Wikipedia live in `*/repositories/`.
- **`AppDataRefresh.clearAll()`** — soft-invalidate on pull-to-refresh; cached data kept for offline.
- **Cache** — Jolpica: `CacheInterceptor` (memory + prefs). ESPN/schedule/seasons: `PrefsJsonStore` / `DayPrefsJsonStore`.
- **Firebase** — `bootstrapFirebase()` in `main`. Client configs **gitignored**; CI uses `tool/ci` stubs.
- **AppMetrica** — `bootstrapAppMetrica()` from `.env` (envied).
- **Logging** — package `logger` + Dio `LogInterceptor` in debug.
- **Controller `*ForTest` params** — optional fetch hooks for unit tests (`@visibleForTesting`).

## Structure

```
f1_pet_project/
├── lib/
│   ├── common/
│   ├── core/        # home, results, schedule, news, circuits
│   ├── data/
│   ├── services/
│   ├── app_config.dart
│   └── router/
├── tool/ci/
├── assets/
├── test/
├── android/ / ios/
└── .github/workflows/
```

## Requirements

- Flutter **3.35.3+**, Dart **3.8+**, Java **21**
- Yandex MapKit API key, Firebase project

## Secrets

Not in git. Local `.env`:

```bash
APPMETRICA_API_KEY=...
YANDEX_MAPKIT_API_KEY=...
```

```bash
dart run build_runner build
flutter run
```

iOS MapKit: `ios/Flutter/Secrets.xcconfig` with `YANDEX_MAPKIT_API_KEY=...` (gitignored).  
Firebase files from FlutterFire are gitignored; CI uses stubs.

## Firebase

```bash
firebase login
flutterfire configure --yes --project=<PROJECT_ID> --platforms=android,ios,web
# ios: cd ios && pod install
```

Remote Config: `local_notifications_enabled` (bool), `min_app_version` (string).

## CI / CD

[![CI](https://github.com/DaniilPavlov/f1_pet_project/actions/workflows/ci.yml/badge.svg)](https://github.com/DaniilPavlov/f1_pet_project/actions/workflows/ci.yml)

| Workflow | When | What |
|----------|------|------|
| `ci.yml` | push / PR → `master` | analyze, test |
| `release.yml` | tag `v*` | APK + GitHub Release |

```bash
# bump pubspec `version: name+code` (code must increase), then:
git tag v1.6.3 && git push origin v1.6.3
```

Release secrets: `YANDEX_MAPKIT_API_KEY`, `ANDROID_KEYSTORE_*` (required); `APPMETRICA_API_KEY`, `FIREBASE_OPTIONS_DART`, `GOOGLE_SERVICES_JSON` (optional).

```bash
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
base64 -i upload-keystore.jks | pbcopy   # → ANDROID_KEYSTORE_BASE64
```

## Web / tests

```bash
flutter build web --release
flutter analyze && flutter test
```

## Features

- **Home** — current season driver and constructor standings
- **Results** — weekend scoreboard, latest race, race search, hall of fame, H2H (drivers / constructors), finish statuses
- **Calendar** — monthly calendar with session times; on empty days shows next GP card (layout + countdown); local reminders 30 min before
- **News** — F1 headlines from ESPN
- **Circuits** — list and map with pins/clusters, track layouts, length/laps/turns/speed/elevation, Wikipedia, winners history
- **Driver / Constructor cards** — ESPN photos, career stats with tappable wins / podiums / poles lists, share as image
- **Localization** — Russian and English
