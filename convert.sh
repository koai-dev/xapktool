#!/bin/bash

# XAPK to APK Converter (Open Source Version)
# Usage: ./convert.sh input.xapk output.apk

INPUT_XAPK=$1
OUTPUT_APK=$2

# Check arguments
if [ -z "$INPUT_XAPK" ] || [ -z "$OUTPUT_APK" ]; then
    echo "Usage: $0 <input.xapk> <output.apk>"
    exit 1
fi

# Check for required tools
if ! command -v java &> /dev/null; then
    echo "Error: Java is not installed."
    exit 1
fi

if ! command -v zipalign &> /dev/null; then
    echo "Error: zipalign is not installed (Android SDK Build-Tools)."
    exit 1
fi

if ! command -v apksigner &> /dev/null; then
    echo "Error: apksigner is not installed (Android SDK Build-Tools)."
    exit 1
fi

# Configuration (Adjust paths as needed)
APKEDITOR_PATH="./bin/APKEditor.jar"
DEBUG_KEYSTORE="./debug.keystore"
KEY_ALIAS="androiddebugkey"
KEY_PASS="android"
STORE_PASS="android"

if [ ! -f "$APKEDITOR_PATH" ]; then
    echo "Error: APKEditor.jar not found at $APKEDITOR_PATH"
    echo "Please download it and place it in the bin/ directory."
    exit 1
fi

# Create temp directory
TEMP_DIR=$(mktemp -d)
echo "Working in $TEMP_DIR..."

# 1. Merge XAPK (Extract & Merge Split APKs)
echo ">> Merging XAPK..."
java -jar "$APKEDITOR_PATH" m -i "$INPUT_XAPK" -o "$TEMP_DIR/merged.apk" -f -extractNativeLibs false

if [ ! -f "$TEMP_DIR/merged.apk" ]; then
    echo "Error: Merge failed."
    rm -rf "$TEMP_DIR"
    exit 1
fi

# 2. Zipalign
echo ">> Zipaligning..."
zipalign -p -f 4 "$TEMP_DIR/merged.apk" "$TEMP_DIR/aligned.apk"

# 3. Sign
echo ">> Signing..."
# Create a debug keystore if not exists
if [ ! -f "$DEBUG_KEYSTORE" ]; then
    echo "Creating debug keystore..."
    keytool -genkey -v -keystore "$DEBUG_KEYSTORE" -storepass "$STORE_PASS" -alias "$KEY_ALIAS" -keypass "$KEY_PASS" -keyalg RSA -keysize 2048 -validity 10000 -dname "CN=Android Debug,O=Android,C=US"
fi

apksigner sign --ks "$DEBUG_KEYSTORE" --ks-pass "pass:$STORE_PASS" --ks-key-alias "$KEY_ALIAS" --key-pass "pass:$KEY_PASS" --out "$OUTPUT_APK" "$TEMP_DIR/aligned.apk"

# Cleanup
rm -rf "$TEMP_DIR"

echo ">> Success! Output: $OUTPUT_APK"
