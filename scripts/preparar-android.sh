#!/usr/bin/env bash
set -euo pipefail
project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$project_dir"
if ! command -v flutter >/dev/null 2>&1; then
  echo 'Instale o Flutter (com Dart 3.9 ou superior) e adicione flutter ao PATH.' >&2
  exit 1
fi
# Restore only missing wrapper files from a disposable Flutter template.
# Never regenerate the Android project over the customized sources.
if [[ ! -f android/gradle/wrapper/gradle-wrapper.jar || ! -f android/gradlew || ! -f android/gradlew.bat ]]; then
  temp_dir="$(mktemp -d)"
  trap 'rm -rf -- "$temp_dir"' EXIT
  flutter create --platforms=android --project-name gradio_mobile_app --no-pub "$temp_dir/template"
  for wrapper_file in gradlew gradlew.bat gradle/wrapper/gradle-wrapper.jar; do
    if [[ ! -f "android/$wrapper_file" ]]; then
      cp "$temp_dir/template/android/$wrapper_file" "android/$wrapper_file"
    fi
  done
fi
chmod +x android/gradlew
flutter pub get
flutter doctor
echo 'Preparação concluída. Confira se o Android SDK e as licenças estão disponíveis.'
