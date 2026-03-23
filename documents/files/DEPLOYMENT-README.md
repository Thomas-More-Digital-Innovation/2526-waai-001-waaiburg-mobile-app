# Deployment Guide - Play Store & App Store

This guide explains how to build and upload the "De Waaiburg" mobile app to Google Play Store and Apple App Store.

## Preparation

Ensure you have access to both the Google account of the Waaiburg app and the Apple account of the Waaiburg app.
Ask Ingrid for logins, she has them, if she says otherwise she's wrong.

1. Run `flutter clean` 
2. Update the version number in [pubspec.yaml](../../code/mobileapp/pubspec.yaml)

---

## Android (Google Play Store)

Android builds are signed using `android/key.properties` and the keystore file in `android/app/upload-keystore.jks`.
You can find them

### 0. Add files

Before you can create a release, you need 2 files that can be found in the Google Drive in the account from De Waaiburg App. Again ask Ingrid for the password.

You'll have 2 files: `key.properties` and `upload-keystore.jks`. 
Place the `key.properties` file in the `android/` folder and the `upload-keystore.jks` file in the `android/app/` folder.

### 1. Update Version

In `pubspec.yaml`, update the `version` field (e.g., `5.0.0+12`). The number after `+` must be incremented for every release.

### 2. Generate App Bundle (.aab)

Run the following command in the terminal:
```bash
flutter build appbundle --release --obfuscate --split-debug-info=build/debug-info
```
The output file will be at:
`build/app/outputs/bundle/release/app-release.aab`

### 3. Upload to Google Play Console

1. Make sure you are logged in into the Google account of the Waaiburg app.
2. Log in to [Google Play Console](https://play.google.com/console).
3. Select **De Waaiburg**.
4. Navigate to **Testing** -> **Internal testing** (for internal release) or **Production**.
5. Create a new release and upload the `.aab` file.
6. Review and rollout the release.

---

## 🟦 iOS (Apple App Store)

iOS deployment requires a macOS environment with **Xcode installed**.
Good luck finding one :)

### 1. Update Version

Update `pubspec.yaml` (same as Android if you haven't already done it). Xcode will automatically pick up these changes.

### 2. Configure Signing (First Time/New Mac)

1. Log into the developer account of De Waaiburg on the Mac
2. Open the project in Xcode: `open ios/Runner.xcworkspace`.
3. Select the **Runner** target.
4. Go to the **Signing & Capabilities** tab.
5. Ensure a Team is selected and the Bundle Identifier is `be.dewaaiburg`.

### 3. Generate Archive & Upload

You can use the command line or Xcode.

**Command Line (Recommended):**
```bash
flutter build ipa --export-method=app-store --obfuscate --split-debug-info=build/debug-info
```
*Note: This generates a `.ipa` file. If using Xcode, go to `Product -> Archive`, then use the Distribute App wizard.*

### 4. App Store Connect

1. Log in to [App Store Connect](https://appstoreconnect.apple.com/).
2. Select the **De Waaiburg** app.
3. Under **TestFlight**, monitor the upload status (it takes a few minutes for processing).
4. Once processed, you can distribute to testers or create a new Version in the **App Store** tab for review.

### Creating a new version on the App Store

This requires you to make a new version which Apple needs to review. This can take a few days.
Make sure you include a demo account for the private part of the app. Otherwise Apple will reject the app.

---

## Versioning Reference

The `version` in `pubspec.yaml` consists of two parts:
- **Build Name** (e.g., `4.0.2`): Shown to users in the store.
- **Build Number** (e.g., `12`): Internal ID used by stores to identify which build is "newer". **Must always increase.**

Usage:
```yaml
version: 4.0.2+12
```

---

## Quick Fixes / Errors

- **Keystore Not Found:** Ensure `android/app/upload-keystore.jks` exists.
- **CocoaPods Issues (iOS):** Run `cd ios && pod install && cd ..` if you changed native dependencies.
- **Xcode Search Path Errors:** Ensure you are opening the `.xcworkspace` file, not the `.xcodeproj`.
