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
- **Firebase** — `bootstrapFirebase()` in `main` (Core, Analytics, Crashlytics, Remote Config). Client configs are **gitignored**; CI uses stubs under `tool/ci/`.
- **AppMetrica** — `bootstrapAppMetrica()`: local `.env` (envied) or `--dart-define` / GitHub secret for release.
- **Logging** — package `logger` + Dio `LogInterceptor` in debug.
- **Controller `*ForTest` params** — optional fetch hooks for unit tests (`@visibleForTesting`).

## Structure

```
f1_pet_project/
├── lib/
│   ├── common/      # layered shared: widgets, utils, models, repositories, packages, localization
│   ├── core/        # 5 tabs only — nested screens inside each:
│   │   ├── home/
│   │   ├── results/   # + race_info, race_search, hof, h2h, finish_status, driver, constructor
│   │   ├── schedule/
│   │   ├── news/
│   │   └── circuits/  # + map, circuit detail, stats
│   ├── data/        # shared Jolpica models (standings, …), exceptions
│   ├── services/    # AppDio, RequestHandler, ApiLoader, AppDataRefresh, firebase, appmetrica
│   ├── app_config.dart  # envied from .env
│   └── router/      # Auto Route
├── tool/ci/         # Firebase stubs for CI analyze
├── assets/
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
- Firebase project (see below)

## Firebase

Packages: `firebase_core`, `firebase_analytics`, `firebase_crashlytics`, `firebase_remote_config`.  
App IDs: Android `com.example.f1_pet_project`, iOS `com.example.f1PetProject`.

One-time setup (CLI already usable if installed globally):

```bash
firebase login
flutterfire configure --yes --project=<YOUR_FIREBASE_PROJECT_ID> --platforms=android,ios,web
```

This writes `lib/firebase_options.dart`, `android/app/google-services.json`, `ios/Runner/GoogleService-Info.plist`, and `firebase.json` (**gitignored** — do not commit, so clones cannot hit your project).  
CI copies stubs from `tool/ci/`. Release can inject real files via secrets `FIREBASE_OPTIONS_DART` and `GOOGLE_SERVICES_JSON`.  
In Firebase Console enable **Analytics**, **Crashlytics**, and **Remote Config**. After iOS configure: `cd ios && pod install && cd ..`.

Remote Config parameters (set in Firebase Console):

| Key | Type | Default | Meaning |
|-----|------|---------|---------|
| `local_notifications_enabled` | Boolean | `true` | Allow creating local race reminder notifications |
| `min_app_version` | String | `0.0.0` | Minimum supported app version; below → blocking update screen (GitHub Releases) |

## Secrets

Keys are **not in git**. Locally one file:

```bash
# .env (gitignored)
APPMETRICA_API_KEY=...
YANDEX_MAPKIT_API_KEY=...

dart run build_runner build   # once after changing AppMetrica key
flutter run
```

- **Android MapKit** — reads `YANDEX_MAPKIT_API_KEY` from `.env`
- **iOS MapKit** — `ios/Flutter/Secrets.xcconfig` with `YANDEX_MAPKIT_API_KEY=...` (gitignored)
- **AppMetrica** — from `.env` via envied
- **Firebase** — local `firebase_options.dart` / `google-services.json` / plist (gitignored); CI uses `tool/ci` stubs

**Release** still needs GitHub Secrets (`YANDEX_MAPKIT_API_KEY`, optional `APPMETRICA_API_KEY`, optional Firebase) — Actions cannot see your local `.env`.

## AppMetrica

`appmetrica_plugin`: sessions/installs after activate. Crashes → Crashlytics.

## Yandex MapKit

If the key is restricted by app fingerprint in [Yandex Developer Console](https://developer.tech.yandex.ru/services/), register **both** debug and release SHA-1:

```bash
# debug
keytool -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore -storepass android

# release (your upload keystore)
keytool -list -v -alias YOUR_ALIAS -keystore path/to/upload-keystore.jks
```

After installing a release APK, check logcat: `RootApp` must log `API key present`. If it says `EMPTY`, the key was not baked into the build.

## Android versioning / APK updates

Use `versionName+versionCode` in `pubspec.yaml`:

```yaml
version: 1.6.2+202607231
```

Android updates only if the new APK has a **higher `versionCode`** and the **same signing certificate**.  
Do **not** set `archivesBaseName` with parentheses (e.g. `1.6.1(202607230)`) — that pattern caused “App not installed” on devices; b2c CI strips it for the same reason. Release APK is the plain `app-release.apk`.

## Web

```bash
flutter build web --release
flutter run -d web-server --web-hostname=0.0.0.0 --web-port=8080
# open http://127.0.0.1:8080
```

Works for news (ESPN), circuit list/layouts, H2H UI, etc.  
**Yandex Map** and **local race reminders** are mobile-only.

Jolpica (`api.jolpi.ca`) may be blocked by some browsers (e.g. Yandex Protect) even for a direct URL open — then standings/calendar/results stay empty on web; Chrome/Safari usually work. Use `0.0.0.0` + `127.0.0.1` locally so IPv4 clients can connect.

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
# bump version in pubspec.yaml first (e.g. 1.5.0+202607230), then tag the same versionName
git tag v1.5.0
git push origin v1.5.0
```

Secrets (release only — local uses `.env` / Secrets.xcconfig):
- `YANDEX_MAPKIT_API_KEY` — required for the map
- `APPMETRICA_API_KEY` — optional
- `FIREBASE_OPTIONS_DART` / `GOOGLE_SERVICES_JSON` — optional (else CI stubs)
- `ANDROID_KEYSTORE_*` — optional

## Features

- **Home** — current season driver and constructor standings
- **Results** — weekend scoreboard, latest race, race search, hall of fame, H2H (drivers / constructors), finish statuses
- **Calendar** — monthly calendar with session times; on empty days shows next GP card (layout + countdown); local reminders 30 min before
- **News** — F1 headlines from ESPN
- **Circuits** — list and map with pins/clusters, track layouts, length/laps/turns/speed/elevation, Wikipedia, winners history
- **Driver / Constructor cards** — ESPN photos, career stats with tappable wins / podiums / poles lists, share as image
- **Localization** — Russian and English
