import 'package:flutter/material.dart';
import 'package:weather_app/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/helper_classes/notifications_helper.dart';
import '../main.dart';

class SettingsPage extends StatefulWidget {
  final String location;
  final int temperature;
  final String currentWeatherStatus;

  const SettingsPage({
    Key? key,
    required this.location,
    required this.temperature,
    required this.currentWeatherStatus,
  }) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final Constants _constants = Constants();

  int _refreshTime = 1;
  bool _isDarkModeEnabled = false;
  bool _isNotificationEnabled = false;
  String _refreshInterval = 'Every Hour';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // Load saved settings from SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _refreshTime = prefs.getInt('refreshTime') ?? 1;
      _isDarkModeEnabled = prefs.getBool('isDarkModeEnabled') ?? false;
      _isNotificationEnabled = prefs.getBool('isNotificationEnabled') ?? false;
    });
  }

  // Save settings to SharedPreferences
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('refreshTime', _refreshTime);
    await prefs.setBool('isDarkModeEnabled', _isDarkModeEnabled);
    await prefs.setBool('isNotificationEnabled', _isNotificationEnabled);
  }

  @override
  Widget build(BuildContext context) {
    var currentLocation = widget.location.toString();
    var currentTemperature = widget.temperature.toInt();
    var currentWeather = widget.currentWeatherStatus.toString();
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.themeData == ThemeData.dark()
          ? _constants.primaryColorDark
          : _constants.primaryColor,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: themeProvider.themeData == ThemeData.dark()
            ? _constants.primaryColorDark
            : _constants.primaryColor,
      ),
      body: Stack(
        children: [
          Positioned(
            top: -25,
            left: 0,
            right: 0,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: themeProvider.themeData == ThemeData.dark()
                    ? _constants.primaryColorDark
                    : _constants.primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Image.asset('assets/cloud.png',),
            ),
          ),
          Positioned.fill(
            top: 150,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: themeProvider.themeData == ThemeData.dark()
                    ? _constants.greyColorDark
                    : _constants.greyColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  SwitchListTile(
                    title: Text('Dark Theme', style: TextStyle(fontWeight: FontWeight.bold,
                        color: themeProvider.themeData == ThemeData.dark() ? Colors.white : _constants.primaryColor)),
                    value: _isDarkModeEnabled,
                    onChanged: (value) {
                      setState(() {
                        _isDarkModeEnabled = value;
                        themeProvider.setDarkMode(value); // Toggle dark mode flag and update theme immediately
                      });
                      _saveSettings();
                    },
                  ),
                  SwitchListTile(
                    title: Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold,
                        color: themeProvider.themeData == ThemeData.dark() ? Colors.white : _constants.primaryColor)),
                    value: _isNotificationEnabled,
                    onChanged: (value) {
                      setState(() {
                        _isNotificationEnabled = value;
                      });
                      _saveSettings();
                    },
                  ),
                  ListTile(
                    title: Text('Refresh Interval', style: TextStyle(fontWeight: FontWeight.bold,
                        color: themeProvider.themeData == ThemeData.dark() ? Colors.white : _constants.primaryColor)),
                    trailing: DropdownButton<String>(
                      value: _refreshInterval,
                      onChanged: (newValue) {
                        setState(() {
                          _refreshInterval = newValue!;
                          if (_isNotificationEnabled) {
                            if (newValue == 'Every Hour') {
                              LocalNotifications.showHourlyNotifications(
                                title: '$currentLocation $currentTemperature °C',
                                body: "weather status - $currentWeather",
                              );
                            } else if (newValue == 'Every Day') {
                              LocalNotifications.showDailyNotifications(
                                title: '$currentLocation $currentTemperature °C',
                                body: "weather status - $currentWeather",
                              );
                            }
                          }
                        });
                      },
                      items: <String>['Every Hour', 'Every Day']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: TextStyle(color: themeProvider.themeData == ThemeData.dark() ? Colors.white : _constants.primaryColor)),
                        );
                      }).toList(),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _isNotificationEnabled
                        ? () {
                      LocalNotifications.showSimpleNotification(
                        title: '$currentLocation $currentTemperature °C',
                        body: "weather status - $currentWeather",
                        payload: 'payload',
                      );
                    }
                        : null,
                    child: const Text('notification'),
                  ),
                  ElevatedButton(
                    onPressed: _isNotificationEnabled
                        ? () {
                      LocalNotifications.showHourlyNotifications(
                        title: '$currentLocation $currentTemperature °C',
                        body: "weather status - $currentWeather",
                      );
                    }
                        : null,
                    child: const Text('Periodic notification'),
                  ),
                  ElevatedButton(
                    onPressed: _saveSettings,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeProvider.themeData == ThemeData.dark()
                          ? _constants.primaryColorDark
                          : _constants.primaryColor,
                    ),
                    child: const Text('Save Settings',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
