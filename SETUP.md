# Flutter App Setup Instructions

## Fix MissingPluginException Error

If you see `MissingPluginException` for `shared_preferences`, follow these steps:

### 1. Clean and Rebuild
```bash
cd application
flutter clean
flutter pub get
flutter pub upgrade
```

### 2. For Android
```bash
cd android
./gradlew clean
cd ..
flutter build apk --debug
# OR for running on device/emulator:
flutter run
```

### 3. Important Notes
- **DO NOT** use hot restart (R) after adding new plugins
- **DO** use full rebuild (stop app, then `flutter run`)
- If using an emulator, restart it after `flutter clean`

## API Configuration

Update the base URL in `lib/core/constants/api_endpoints.dart`:
- For emulator: `http://10.0.2.2:8000` (Android) or `http://localhost:8000` (iOS)
- For physical device: `http://YOUR_COMPUTER_IP:8000`

## Running the App

1. Make sure backend is running on port 8000
2. Run migrations: `cd backend && php artisan migrate`
3. Start Flutter app: `cd application && flutter run`

## Troubleshooting

### Plugin Not Found
- Run `flutter clean`
- Delete `build/` and `.dart_tool/` folders
- Run `flutter pub get`
- Rebuild completely

### API Connection Issues
- Check backend is running
- Verify base URL matches your setup
- Check firewall/network settings
- For Android emulator, use `10.0.2.2` instead of `localhost`
