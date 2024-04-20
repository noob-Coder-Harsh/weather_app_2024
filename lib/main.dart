import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import 'package:timezone/data/latest.dart' as tz;



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  tz.initializeTimeZones();
  runApp(ChangeNotifierProvider(
      create: (context) => NotificationSettingsProvider(),
      child: const MyApp()));
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

  void toggleTheme() {
    _themeData = _themeData == ThemeData.light()
        ? ThemeData.dark()
        : ThemeData.light(); // Toggle between light and dark themes
    notifyListeners();
  }
}

class NotificationSettingsProvider extends ChangeNotifier {
  bool _isHourlyNotificationsEnabled = false;
  bool _isDailyNotificationsEnabled = false;

  bool get isHourlyNotificationsEnabled => _isHourlyNotificationsEnabled;
  bool get isDailyNotificationsEnabled => _isDailyNotificationsEnabled;

  void toggleHourlyNotifications(bool value) {
    _isHourlyNotificationsEnabled = value;
    notifyListeners();
  }

  void toggleDailyNotifications(bool value) {
    _isDailyNotificationsEnabled = value;
    notifyListeners();
  }
}

