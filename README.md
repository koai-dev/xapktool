# XAPK to APK Converter (Script)

A simple bash script to convert `.xapk` (and `.apkm`, `.apks`) files into a standard, single `.apk` file that can be installed on any Android device.

## Why use this?
-   **No Root Required**: Converts files without needing root access on your phone.
-   **Fix "App not installed"**: Solves issues with Split APKs installation.
-   **Offline**: Runs entirely on your local machine.

## Prerequisites
1.  **Java (JRE/JDK 8+)**: Required to run APKEditor.
2.  **Android SDK Build-Tools**: Requires `zipalign` and `apksigner` in your PATH.
    -   macOS (via Brew): `brew install android-sdk`
    -   Ubuntu: `sudo apt install google-android-platform-tools-installer`
3.  **APKEditor.jar**: Download the latest `APKEditor.jar` and place it in a `bin/` folder.

## Usage

```bash
chmod +x convert.sh
./convert.sh game.xapk game-signed.apk
```

## Online Version
Don't want to install tools? Use our free online converter:
[**XAPK to APK Converter Online**](https://xapktool.com)

## License
MIT License.
