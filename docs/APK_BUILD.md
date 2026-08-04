# Сборка тестового APK Ugur

## Через GitHub Actions

1. Загрузите содержимое архива Stage 18A в корень ветки `main`.
2. Откройте вкладку **Actions**.
3. Выберите **Build Ugur Android APK**.
4. Нажмите **Run workflow**.
5. После успешного завершения откройте запуск.
6. Скачайте artifact `ugur-v1.6.1-build20-debug-apk`.
7. Внутри находится файл `ugur-v1.6.1-build20-debug.apk`.

Workflow также автоматически запускается после каждого изменения ветки `main`.

## Сборка на компьютере

Нужны Flutter stable и Android SDK.

```bash
./tool/build_debug_apk.sh
```

Локальный результат:

```text
build/app/outputs/flutter-apk/app-debug.apk
```

Debug APK предназначен для тестирования. Для публикации позднее потребуется подписанный release AAB/APK.
