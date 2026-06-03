# Emulator Setup

Use this reference when a machine cannot run `adb devices`, has no Android emulator, or the user needs a closed-loop setup path.

## Recommended Windows Emulator

MuMu emulator download:

https://mumu.163.com/360mumu/

Why it is useful for this workflow:

- It is easy for non-Android developers to install on Windows.
- It exposes Android devices that can be controlled with `adb`.
- It is enough for smoke-testing APK install, launch, screenshots, UI hierarchy, and logcat.

## Required Tools

- Android emulator, such as MuMu.
- `adb`, usually from Android SDK Platform Tools.
- Optional: `aapt` or `apkanalyzer` for APK manifest metadata.
- Optional: GitHub CLI `gh` for private release artifact checks.

## Common ADB Locations On Windows

Check these locations before declaring `adb` missing:

- `adb` in PATH
- `%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe`
- `%ANDROID_HOME%\platform-tools\adb.exe`
- `%ANDROID_SDK_ROOT%\platform-tools\adb.exe`
- `C:\Program Files\Netease\MuMuPlayer-12.0\shell\adb.exe`
- `C:\Program Files\Netease\MuMu Player 12\shell\adb.exe`
- `C:\Program Files (x86)\Netease\MuMuPlayer-12.0\shell\adb.exe`

## Device Connection Notes

Start the emulator before running QA. Then run:

```powershell
adb devices -l
```

Some emulator setups expose a TCP endpoint. A common MuMu-style endpoint is:

```powershell
adb connect 127.0.0.1:7555
```

If that does not work, use the emulator UI/settings or vendor docs to find its adb port.

## Minimum Smoke Test

```powershell
adb devices -l
adb install -r -d app.apk
adb shell monkey -p com.example.app -c android.intent.category.LAUNCHER 1
adb exec-out screencap -p > screenshot.png
adb shell uiautomator dump /sdcard/window.xml
adb pull /sdcard/window.xml window.xml
adb logcat -d -t 400 > logcat.txt
```

If any step fails, report it as a setup or package blocker before judging UI quality.

