# f1_pet_project

Flutter-приложение про Formula 1.

- **State management:** MobX
- **Navigation:** Auto Route
- **API:** [jolpica-f1](http://api.jolpi.ca/ergast/f1/)

## Требования

- Flutter **3.35.3+**
- Dart **3.8+**
- Java **17** (для Android)

## Локальный запуск

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

Репозиторий: [DaniilPavlov/f1_pet_project](https://github.com/DaniilPavlov/f1_pet_project)

[![CI](https://github.com/DaniilPavlov/f1_pet_project/actions/workflows/ci.yml/badge.svg)](https://github.com/DaniilPavlov/f1_pet_project/actions/workflows/ci.yml)

### CI (`ci.yml`)

Запускается на push и pull request в `master`:

1. `flutter pub get`
2. проверка, что codegen актуален (`build_runner`)
3. `flutter analyze`
4. `flutter test`

### CD (`release.yml`)

Сборка артефактов:

- **Автоматически** — при push тега `v*` (например `v1.0.2`)
- **Вручную** — Actions → Release → Run workflow

Собирается:

- **Android APK** — автоматически по тегу `v*` или вручную
- **Web** — только вручную (Actions → Release), т.к. проект завязан на Yandex MapKit

Артефакты загружаются в GitHub Actions. При релизе по тегу создаётся GitHub Release с APK.

#### Подпись Android (опционально)

Без секретов APK собирается с debug-подписью (как в локальном `build.gradle` без `key.properties`).

Для release-подписи добавь secrets в GitHub → Settings → Secrets and variables → Actions:

| Secret | Описание |
|--------|----------|
| `ANDROID_KEYSTORE_BASE64` | Keystore в base64: `base64 -i upload-keystore.jks` |
| `ANDROID_KEYSTORE_PASSWORD` | Пароль keystore |
| `ANDROID_KEY_ALIAS` | Alias ключа |
| `ANDROID_KEY_PASSWORD` | Пароль ключа |

#### Создание релиза

```bash
git tag v1.0.2
git push origin v1.0.2
```
