import 'package:bmg/src/shared/providers/transaction_provider.dart';
import 'package:bmg/src/shared/providers/transactions_provider.dart';
import 'package:bmg/src/shared/utils/config_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  WidgetsFlutterBinding.ensureInitialized();
  final settingsController = SettingsController(SettingsService());

  // Preload the configuration file before the app starts.
  await ConfigUtils.preloadConfig();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await SharedPreferences.getInstance();

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();
  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => TransactionsProvider()),
    ChangeNotifierProvider(create: (context) => TransactionProvider()),
  ], child: MyApp(settingsController: settingsController)));
}
