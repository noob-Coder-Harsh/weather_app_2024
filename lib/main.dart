import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/local_notifications.dart';
import 'home_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotifications.init();
  runApp(const MyApp());
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

  ThemeData get themeData => _themeData;

  void setThemeMode(ThemeMode mode) {
    _themeData = mode == ThemeMode.dark ? ThemeData.dark() : ThemeData.light();
    notifyListeners();
  }

  void toggleTheme() {
    // Get the current time
    DateTime now = DateTime.now();
    // Define the start and end time for night mode (e.g., from 8 PM to 6 AM)
    int nightModeStartHour = 20;
    int nightModeEndHour = 6;

    // Check if the current time is between the start and end time for night mode
    bool isNightTime = now.hour >= nightModeStartHour || now.hour < nightModeEndHour;

    // Set the theme mode based on the time of day
    _themeData = isNightTime ? ThemeData.dark() : ThemeData.light();
    notifyListeners();
  }
}
