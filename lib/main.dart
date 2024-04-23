import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/helper_classes/notifications_helper.dart';
import 'screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotifications.init();

  var themeProvider = ThemeProvider();
  themeProvider.updateThemeBasedOnTime();

  runApp(
    ChangeNotifierProvider<ThemeProvider>(
      create: (_) => themeProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeProvider>(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: themeProvider.themeData,
            home: const HomePage(),
          );
        },
      ),
    );
  }
}

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = ThemeData.light(); // Default to light theme
  bool _isDarkModeEnabled = false;

  ThemeData get themeData => _themeData;
  bool get isDarkModeEnabled => _isDarkModeEnabled;

  void setThemeMode(ThemeMode mode) {
    _themeData = mode == ThemeMode.dark ? ThemeData.dark() : ThemeData.light();
    notifyListeners();
  }

  void toggleTheme() {
    _themeData = _isDarkModeEnabled ? ThemeData.dark() : ThemeData.light();
    notifyListeners();
  }

  void setDarkMode(bool isEnabled) {
    _isDarkModeEnabled = isEnabled;
    toggleTheme(); // Update theme immediately
  }

  void updateThemeBasedOnTime() {
    DateTime now = DateTime.now();
    int nightModeStartHour = 20;
    int nightModeEndHour = 6;

    // Check if the current time is between the start and end time for night mode
    bool isNightTime = now.hour >= nightModeStartHour || now.hour < nightModeEndHour;

    // If dark mode is enabled, set the theme to dark regardless of time
    if (_isDarkModeEnabled) {
      _themeData = ThemeData.dark();
    } else {
      // Set the theme mode based on the time of day
      _themeData = isNightTime ? ThemeData.dark() : ThemeData.light();
    }

    notifyListeners();
  }

// Other methods...
}

