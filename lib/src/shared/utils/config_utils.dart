import 'dart:convert';

import 'package:bmg/src/models/admin_model.dart';
import 'package:flutter/services.dart';

class ConfigUtils {
  static Map<String, dynamic>? _config;

  /// Load the configuration file once and store it in memory.
  static Future<void> preloadConfig() async {
    final String jsonString = await rootBundle.loadString('config.json');
    _config = jsonDecode(jsonString);
  }

  /// Get the app name synchronously after preloading.
  static String get appName {
    if (_config == null) {
      throw Exception("Configuration not loaded. Call preloadConfig first.");
    }
    return _config!['appName'];
  }

  /// Get the list of admins synchronously after preloading.
  static List<AdminModel> get admins {
    if (_config == null) {
      throw Exception("Configuration not loaded. Call preloadConfig first.");
    }
    final List<dynamic> adminsJson = _config!['admins'];
    return adminsJson
        .map((admin) => AdminModel(admin['name'], admin['role']))
        .toList();
  }
}
