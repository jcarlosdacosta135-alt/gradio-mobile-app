#!/usr/bin/env bash
set -euo pipefail
project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$project_dir"
mode="${1:-teste}"
case "$mode" in
  teste|publicacao) ;;
  *) echo 'Uso: bash scripts/gerar-apk.sh [teste|publicacao]' >&2; exit 2 ;;
esac
if [[ "$mode" == publicacao && ! -f android/key.properties ]]; then
  echo 'Configure android/key.properties e a chave release antes de publicar.' >&2
  exit 1
fi
bash scripts/preparar-android.sh
flutter analyze --no-fatal-infos --no-fatal-warnings
flutter test
if [[ "$mode" == teste ]]; then
  build_args=() 
  if [[ -n "${APK_TARGET_PLATFORM:-}" ]]; then
    build_args+=(--target-platform "$APK_TARGET_PLATFORM")
  fi
  flutter build apk --debug "${build_args[@]}"
  echo 'APK de teste: build/app/outputs/flutter-apk/app-debug.apk'
else
  flutter build apk --release --split-per-abi
  echo 'APKs assinados: build/app/outputs/flutter-apk/'
fi
