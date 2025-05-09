// lib/core/constants/app_constants.dart
class AppConstants {
  // App name
  static const String appName = "MetroLink";

  // Database
  static const String databaseName = "metro_link.db";
  static const int databaseVersion = 1;

  // Tables
  static const String cardsTable = "cards";
  static const String journeysTable = "journeys";
  static const String usersTable = "users";
  static const String stationsTable = "stations";

  // Shared Preferences Keys
  static const String userIdKey = "user_id";
  static const String isFirstTimeKey = "is_first_time";
  static const String themeKey = "theme_mode";

  // Assets
  static const String splashLogo = "assets/images/logo.png";

  // API Endpoints (when we add backend integration)
  static const String baseUrl = "https://api.metrolink.app/";

  // Error Messages
  static const String generalError = "Something went wrong. Please try again.";
  static const String networkError = "No internet connection.";
  static const String cardScanError = "Failed to scan card. Please try again.";

  // Success Messages
  static const String cardScanned = "Card scanned successfully!";

  // Animation Durations
  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration pageFadeDuration = Duration(milliseconds: 300);
}