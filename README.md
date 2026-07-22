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

## Architecture

- **DI** — root `MultiProvider` in `lib/main.dart` (repos, `AppDataRefresh`, reminders). ESPN `Dio` is created in `main` and passed into repos.
- **Jolpica** — one `RequestHandler` wired via `ApiLoader.configure` (static access from repos); screens do not call Dio.
- **Repositories** — Jolpica/ESPN/Wikipedia live in `*/repositories/`.
- **`AppDataRefresh.clearAll()`** — pull-to-refresh / ErrorBody retry: Jolpica Dio cache, ESPN TTL (news, scoreboard), ESPN media (session), catalogs, Wikipedia thumbs, prefs day-cache (schedule/seasons).
- **Logging** — package `logger` + Dio `LogInterceptor` in debug.
- **Controller `*ForTest` params** — optional fetch hooks for unit tests (`@visibleForTesting`).

## Structure

```
f1_pet_project/
├── lib/
│   ├── common/      # widgets, theme, helpers, map, wikipedia
│   ├── core/        # features: home, results, schedule, news, circuits, h2h, …
│   ├── data/        # shared models (standings, …), exceptions
│   ├── services/    # AppDio, RequestHandler, ApiLoader, AppDataRefresh, executor
│   └── router/      # Auto Route
├── assets/          # circuit layouts, circuit stats, icons
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

**Android** — Flutter overwrites `android/local.properties` on every build, so keep the key in a separate file:

```bash
cp android/mapkit.properties.example android/mapkit.properties
# edit android/mapkit.properties → yandex.mapkit.apiKey=YOUR_KEY
```

Or export `YANDEX_MAPKIT_API_KEY` in the environment.

**iOS** — copy the example and put your key in:

```bash
cp ios/Flutter/Secrets.xcconfig.example ios/Flutter/Secrets.xcconfig
```

**Release / CI:** GitHub secret `YANDEX_MAPKIT_API_KEY` is required (written to `android/mapkit.properties` in the workflow).

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
version: 1.4.2+202607220
```

Android updates only if the new APK has a **higher `versionCode`** and the **same signing certificate**.  
Bumping only `1.4.2` → `1.4.3` without raising the `+N` part keeps the same `versionCode`, so the device will not replace the installed app.  
Different signing (debug vs release / another keystore) also forces uninstall + reinstall.

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
# bump version in pubspec.yaml first (e.g. 1.4.2+202607220), then tag the same versionName
git tag v1.4.2
git push origin v1.4.2
```

Secrets:
- `YANDEX_MAPKIT_API_KEY` — required for the map in release APKs
- `ANDROID_KEYSTORE_*` — optional; without them the APK is debug-signed

## Features

- **Home** — current season driver and constructor standings
- **Results** — weekend scoreboard, latest race, race search, hall of fame, H2H (drivers / constructors), finish statuses
- **Calendar** — monthly calendar with session times; on empty days shows next GP card (layout + countdown); local reminders 30 min before
- **News** — F1 headlines from ESPN
- **Circuits** — list and map with pins/clusters, track layouts, length/laps/turns/speed/elevation, Wikipedia, winners history
- **Driver / Constructor cards** — ESPN photos, career stats with tappable wins / podiums / poles lists, share as image
- **Localization** — Russian and English
