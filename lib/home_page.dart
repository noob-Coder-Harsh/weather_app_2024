import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather_app/weather_item.dart';
import 'package:weather_app/constants.dart';
import 'package:weather_app/details_page.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> cities = ['New Delhi','Mumbai','Gurgaon','Aligarh','Panipat','Palwal','Bangalore','Kolkata','Chennai','Hyderabad', 'Pune','Ahmedabad','Jaipur',];

  final Constants _constants = Constants();

  static String apiKey = '4efce536c5864e80a2a145802241404'; //Paste Your API Here

  String location = 'New Delhi'; //Default location
  String weatherIcon = 'heavycloud.png';
  int temperature = 0;
  int windSpeed = 0;
  int humidity = 0;
  int cloud = 0;
  String currentDate = '';

  List hourlyWeatherForecast = [];
  List dailyWeatherForecast = [];

  String currentWeatherStatus = '';

  //API Call
  String searchWeatherAPI = "https://api.weatherapi.com/v1/forecast.json?key=$apiKey&days=7&q=";

  void fetchWeatherData(String searchText) async {
    try {
      var searchResult =
      await http.get(Uri.parse(searchWeatherAPI + searchText));

      final weatherData = Map<String, dynamic>.from(
          json.decode(searchResult.body) ?? 'No data');

      var locationData = weatherData["location"];

      // Check if the country is India before updating the data
      if (locationData["country"] == "India") {
        var currentWeather = weatherData["current"];

        setState(() {
          location = getShortLocationName(locationData["name"]);

          var parsedDate =
          DateTime.parse(locationData["localtime"].substring(0, 10));
          var newDate = DateFormat('MMMMEEEEd').format(parsedDate);
          currentDate = newDate;

          //updateWeather
          currentWeatherStatus = currentWeather["condition"]["text"];
          weatherIcon =
          "${currentWeatherStatus.replaceAll(' ', '').toLowerCase()}.png";
          temperature = currentWeather["temp_c"].toInt();
          windSpeed = currentWeather["wind_kph"].toInt();
          humidity = currentWeather["humidity"].toInt();
          cloud = currentWeather["cloud"].toInt();

          //Forecast data
          dailyWeatherForecast = weatherData["forecast"]["forecastday"];
          hourlyWeatherForecast = dailyWeatherForecast[0]["hour"];
          print(dailyWeatherForecast);
        });
      } else {
        // Handle the case when the location is not in India
        print("Location is not in India");
      }
    } catch (e) {
      //debugPrint(e);
    }
  }


  //function to return the first two names of the string location
  static String getShortLocationName(String s) {
    List<String> wordList = s.split(" ");

    if (wordList.isNotEmpty) {
      if (wordList.length > 1) {
        return "${wordList[0]} ${wordList[1]}";
      } else {
        return wordList[0];
      }
    } else {
      return " ";
    }
  }

  @override
  void initState() {
    fetchWeatherData(location);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.only(top: 50, left: 10, right: 10),
        color: _constants.primaryColor.withOpacity(.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             Text('Current Weather Status',
              style: TextStyle(fontSize: 24,color: Color(0xff205cf1).withOpacity(0.75),fontWeight: FontWeight.bold),),
            SizedBox(height: 35,),
            //main Blue container
            buildCityWeather(location),
            buildHourlyWeatherForecast(),
          ],
        ),
      ),
    );
  }

  Widget buildCityWeather(String city) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      height: size.height * .65,
      decoration: BoxDecoration(
        gradient: _constants.linearGradientBlue,
        boxShadow: [
          BoxShadow(
            color: _constants.primaryColor.withOpacity(.5),
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
          //Search Widget
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/pin.png',color: Colors.white70,
                width: 20,
              ),
              const SizedBox(
                width: 4,
              ),
              DropdownButtonHideUnderline(
                child: DropdownButton(
                  dropdownColor: Colors.blue,
                  value: location,
                  icon: const Icon(Icons.keyboard_arrow_down,color: Colors.white70,),
                  items: cities.map((String location) {
                    return DropdownMenuItem(
                      value: location,
                      child: Text(location,style:  const TextStyle(color: Colors.white70),),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      location = newValue!;
                      fetchWeatherData(location);
                    });
                  },
                ),
              )

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
                    foreground: Paint()..shader = _constants.shader,
                  ),
                ),
              ),
              Text(
                'o',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()..shader = _constants.shader,
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
                onTap: () =>
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_)=> DetailPage(dailyForecastWeather: dailyWeatherForecast,))), //this will open forecast screen
                child: Text(
                  'More',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: _constants.primaryColor,
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
                String forecastTime = hourlyWeatherForecast[index]["time"].substring(11, 16);
                String forecastWeatherName = hourlyWeatherForecast[index]["condition"]["text"];
                String forecastWeatherIcon = "${forecastWeatherName.replaceAll(' ', '').toLowerCase()}.png";
                String forecastTemperature = hourlyWeatherForecast[index]["temp_c"].round().toString();
                String currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
                String currentHour = currentTime.substring(0, 2);
                String forecastHour = hourlyWeatherForecast[index]["time"].substring(11, 13);
                return Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Card(
                    color: currentHour == forecastHour ? _constants.primaryColor.withOpacity(0.25) : _constants.primaryColor,
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            forecastTime,
                            style: TextStyle(fontSize: 17, color: _constants.greyColor, fontWeight: FontWeight.w500),
                          ),
                          Image.asset('assets/$forecastWeatherIcon', width: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                forecastTemperature,
                                style: TextStyle(color: _constants.greyColor, fontSize: 17, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                '°',
                                style: TextStyle(color: _constants.greyColor, fontWeight: FontWeight.bold, fontSize: 18),
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