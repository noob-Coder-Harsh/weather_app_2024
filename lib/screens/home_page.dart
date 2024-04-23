import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:weather_app/helper_classes/database_helper.dart';
import 'package:weather_app/widgets/search_widget.dart';

import 'package:weather_app/screens/settings_page.dart';
import 'package:weather_app/widgets/weather_animation.dart';
import 'package:weather_app/widgets/weather_item.dart';
import 'package:weather_app/constants.dart';
import 'package:weather_app/screens/details_page.dart';

import '../widgets/locations.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  final List<String> cities = CityData.cities;
  final Constants _constants = Constants();
  static String apiKey = '4efce536c5864e80a2a145802241404'; // Paste Your API Here
  String location = 'Mumbai'; // Default location
  String weatherIcon = 'heavycloud.png';
  int temperature = 0;
  int windSpeed = 0;
  int humidity = 0;
  int cloud = 0;
  String currentDate = '';
  bool isLoading = false;
  List hourlyWeatherForecast = [];
  List dailyWeatherForecast = [];
  String currentWeatherStatus = '';
  // API Call
  String searchWeatherAPI =
      "https://api.weatherapi.com/v1/forecast.json?key=$apiKey&days=7&q=";

  @override
  void initState() {
    super.initState();
    getUserLocation();
    isLoading = true;
  }

  Future<void> fetchWeatherData(String searchText) async {
    try {
      var searchResult =
      await http.get(Uri.parse(searchWeatherAPI + searchText));
      final weatherData = Map<String, dynamic>.from(
          json.decode(searchResult.body) ?? 'No data');
      var locationData = weatherData["location"];
      var currentWeather = weatherData["current"];
      setState(() {
        location = locationData["name"];
        var parsedDate =
        DateTime.parse(locationData["localtime"].substring(0, 10));
        var newDate = DateFormat('MMMMEEEEd').format(parsedDate);
        currentDate = newDate;
        // Update Weather
        currentWeatherStatus = currentWeather["condition"]["text"];
        weatherIcon =
        "${currentWeatherStatus.replaceAll(' ', '').toLowerCase()}.png";
        temperature = currentWeather["temp_c"].toInt();
        windSpeed = currentWeather["wind_kph"].toInt();
        humidity = currentWeather["humidity"].toInt();
        cloud = currentWeather["cloud"].toInt();

        // Forecast data
        dailyWeatherForecast = weatherData["forecast"]["forecastday"];
        hourlyWeatherForecast = dailyWeatherForecast[0]["hour"];
        print(dailyWeatherForecast);
      });

      await _databaseHelper.insertWeather({
        'location': location,
        'weatherIcon': weatherIcon,
        'temperature': temperature,
        'windSpeed': windSpeed,
        'humidity': humidity,
        'cloud': cloud,
        'currentDate': currentDate,
      });
      print('Data inserted');
    } catch (e) {
      print('Failed to fetch data: $e');
      // If fetching fails, load data from the database
      await _loadWeatherData();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadWeatherData() async {
    try {
      Map<String, dynamic> weatherData = await _databaseHelper.queryWeather();
      setState(() {
        location = weatherData['location'] ?? '';
        weatherIcon = weatherData['weatherIcon'] ?? '';
        temperature = weatherData['temperature'] ?? 0;
        windSpeed = weatherData['windSpeed'] ?? 0;
        humidity = weatherData['humidity'] ?? 0;
        cloud = weatherData['cloud'] ?? 0;
        currentDate = weatherData['currentDate'] ?? '';
      });
      print('Data loaded');
    } catch (e) {
      print('Error loading weather data: $e');
    }
  }

  Future<void> getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return;
    }
    Position position = await Geolocator.getCurrentPosition();
    List<Placemark> placeMarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    String currentLocationName = placeMarks.first.locality ?? 'Unknown';
    setState(() {
      if (cities.contains(currentLocationName)) {
        cities.remove(currentLocationName);
      }
      cities.insert(0, currentLocationName);
      location = currentLocationName;
    });
    await fetchWeatherData(currentLocationName);
  }

  void shareWeatherData() {
    // Compose the text to share
    String textToShare = 'Current weather in $location: $temperature°C';

    // Use the share package to share the text
    Share.share(textToShare);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);

    Size size = MediaQuery.of(context).size;
    Widget body;

    if (isLoading) {
      // Show a loading indicator while data is being fetched
      body = const WeatherLoadingAnimation();
    } else {
      // Show the actual weather data
      body = Container(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
        color: Theme.of(context).brightness == Brightness.dark
            ? _constants.primaryColorDark.withOpacity(0.5)
            : _constants.primaryColor.withOpacity(0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Main Blue container
            buildCityWeather(location),
            buildHourlyWeatherForecast(),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? _constants.primaryColorDark
            : _constants.primaryColor,
        title: const Text(
          'Current Weather Status',
          style: TextStyle(
              fontSize: 24,
              color: Colors.white54,
              fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              shareWeatherData(); // Call the share function when the button is pressed
            },
            icon: const Icon(Icons.share),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => SettingsPage(
                            location: location,
                            temperature: temperature,
                            currentWeatherStatus: currentWeatherStatus,
                          )));
                },
                icon: const Icon(Icons.settings)),
          )
        ],
      ),
      body: body,
    );
  }

  Widget buildCityWeather(String city) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      height: size.height * .65,
      decoration: BoxDecoration(
        gradient: Theme.of(context).brightness == Brightness.dark
            ? _constants.linearGradientBlueDark
            : _constants.linearGradientBlue,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? _constants.primaryColorDark.withOpacity(0.5)
                : _constants.primaryColor.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Search Widget
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/pin.png',
                color: Colors.white70,
                width: 20,
              ),
              const SizedBox(
                width: 4,
              ),
             Text(location,style: const TextStyle(color: Colors.white70,fontWeight: FontWeight.bold,fontSize: 18,letterSpacing: 1),),
              IconButton(
                icon: Icon(Icons.keyboard_arrow_down, color: Colors.white70,
                  size: 25,),
                onPressed: () async {
                  String? selectedCity = await showSearch<String>(
                    context: context,
                    delegate: CitySearchDelegate(cities),
                  );
                  if (selectedCity != null) {
                    setState(() {
                      location = selectedCity;
                    });
                    fetchWeatherData(selectedCity);
                  }
                },
              ),
            ],
          ),
          SizedBox(
            height: 125,
            child: Image.asset("assets/$weatherIcon"),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  temperature.toString(),
                  style: TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..shader = Theme.of(context).brightness == Brightness.dark
                          ? _constants.shaderDark
                          : _constants.shader,
                  ),
                ),
              ),
              Text(
                'o',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..shader = Theme.of(context).brightness == Brightness.dark
                        ? _constants.shaderDark
                        : _constants.shader,
                ),
              ),
            ],
          ),
          Text(
            currentWeatherStatus,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 20.0,
            ),
          ),
          Text(
            currentDate,
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Divider(
              color: Colors.white70,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                WeatherItem(
                  value: windSpeed.toInt(),
                  unit: 'km/h',
                  imageUrl: 'assets/windspeed.png',
                ),
                WeatherItem(
                  value: humidity.toInt(),
                  unit: '%',
                  imageUrl: 'assets/humidity.png',
                ),
                WeatherItem(
                  value: cloud.toInt(),
                  unit: '%',
                  imageUrl: 'assets/cloud.png',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHourlyWeatherForecast() {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.only(top: 10),
      height: size.height * .20,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Today',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => DetailPage(
                          dailyForecastWeather: dailyWeatherForecast,
                        ))), //this will open forecast screen
                child: Text(
                  'More',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? _constants.primaryColorDark
                        : _constants.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          SizedBox(
            height: 110,
            child: ListView.builder(
              itemCount: hourlyWeatherForecast.length,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                String forecastTime =
                hourlyWeatherForecast[index]["time"].substring(11, 16);
                String forecastWeatherName =
                hourlyWeatherForecast[index]["condition"]["text"];
                String forecastWeatherIcon =
                    "${forecastWeatherName.replaceAll(' ', '').toLowerCase()}.png";
                String forecastTemperature =
                hourlyWeatherForecast[index]["temp_c"].round().toString();
                String currentTime =
                DateFormat('HH:mm:ss').format(DateTime.now());
                String currentHour = currentTime.substring(0, 2);
                String forecastHour =
                hourlyWeatherForecast[index]["time"].substring(11, 13);
                return Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Card(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? currentHour == forecastHour
                        ? _constants.primaryColorDark.withOpacity(0.25)
                        : _constants.primaryColorDark
                        : currentHour == forecastHour
                        ? _constants.primaryColor.withOpacity(0.25)
                        : _constants.primaryColor,
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            forecastTime,
                            style: TextStyle(
                                fontSize: 17,
                                color: Theme.of(context).brightness ==
                                    Brightness.dark
                                    ? _constants.greyColorDark
                                    : _constants.greyColor,
                                fontWeight: FontWeight.w500),
                          ),
                          Image.asset('assets/$forecastWeatherIcon',
                              width: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                forecastTemperature,
                                style: TextStyle(
                                    color: Theme.of(context).brightness ==
                                        Brightness.dark
                                        ? _constants.greyColorDark
                                        : _constants.greyColor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                '°',
                                style: TextStyle(
                                    color: Theme.of(context).brightness ==
                                        Brightness.dark
                                        ? _constants.greyColorDark
                                        : _constants.greyColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}