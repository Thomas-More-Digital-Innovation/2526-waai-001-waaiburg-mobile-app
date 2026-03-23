# 2526-waai-001-waaiburg-mobile-app

Mobile app for the Waaiburg project in 2025-2026
for of the Waaiburg project in 2022-2023

## Install steps

1. Install Flutter SDK
2. Install flutter extension in VSCode
3. Run flutter doctor
4. Install Android Studio
5. Install Android SDK
6. Install Android emulator

*Fun fact: you can also use your mobile phone to run the app. Make sure to enable USB debugging on your phone and connect it to your computer. Then run `flutter run` in the terminal.*

## Possible problems

1. cmdline-tools component is missing -> install it in Android Studio
2. Some Android licenses not accepted. -> run flutter doctor --android-licenses in cmd and accept all licenses
3. 'flutter' is not recognized as an internal or external command, operable program or batch file. -> add flutter sdk bin path to environment variables and restart vscode

## Deployment

For instructions on how to build and upload the app to the Play Store and App Store, see [DEPLOYMENT.md](./documents/mobileapp/DEPLOYMENT.md).

## Notes from the previous developer

If you ever update Flutter, make sure the minSdk is updated in [android/app/build.gradle](./code/mobileapp/android/app/build.gradle) to the newest version. If you don't do this, the Google Play Console will complain about it and won't let you upload the new version.

---

<img src="documents/files/appicons/appstore.png" width="200" height="200">

> Stay cool, Stay open-source
