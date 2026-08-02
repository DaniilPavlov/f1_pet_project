# Firebase Console setup (Auth + Firestore + App Check)

Already used in the app: Core, Analytics, Crashlytics, Remote Config, Auth, Firestore, App Check.

## Enable for Profile / Predictor

1. **Authentication → Sign-in method → Email/Password**
   - Enable Email/Password (not passwordless).
   - Do not enable Google / Apple / Anonymous for v1.
   - Templates → Email address verification — keep default or customize.

2. **Cloud Firestore**
   - Create database (production mode).
   - Prefer a region close to users (e.g. `europe-west` / `eur3`).
   - Rules (profile doc without verified email; seasons only after verification):

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{uid} {
      allow read, write: if request.auth != null && request.auth.uid == uid;
    }
    match /users/{uid}/seasons/{document=**} {
      allow read, write: if request.auth != null
        && request.auth.uid == uid
        && request.auth.token.email_verified == true;
    }
  }
}
```

3. **App Check**
   - Console → App Check → register Android (Play Integrity) + iOS (App Attest / DeviceCheck).
   - For **debug** builds: use debug providers; register debug tokens from logcat / Xcode under App Check → Manage debug tokens.
   - Enforce App Check for **Firestore** (and optionally Auth) only after debug tokens work — otherwise local debug will get `permission-denied`.

## Data shape

```
users/{uid}
  email, emailVerified, createdAt

users/{uid}/seasons/{year}
  weekends: { "{round}": { raceName, qualifyingOrder, raceOrder, …, actualQualifyingOrder?, actualRaceOrder? } }
  updatedAt
```

## Abuse hardening (in app)

- Registration sends email verification.
- Predictor is gated until `emailVerified`.
- App Check activated at bootstrap (debug providers in debug, Play Integrity / App Attest in release).

## Not needed yet

Storage, Cloud Functions (blocking `beforeCreate`), Cloud Messaging, Anonymous Auth.
