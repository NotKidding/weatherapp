//import 'dart:html';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:google_fonts/google_fonts.dart';


class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  // api key
  final _WeatherService = WeatherService('06d1a126a3c0cd9eec0fb7c05889fbc7');
  Weather? _weather;

  //fetch weather
  _fetchWeather() async{

    //get current city
    String cityName = await _WeatherService.getCurrentCity();

    //get weather for city
    try {
      final weather = await _WeatherService.getWeather(cityName);
      setState((){
        _weather = weather;
      });
    }

    //any errors
    catch (e){
      print(e);
    }

  }

  //weather animation
  String getWeatherAnimation(String? mainCondition ) {
    if (mainCondition == null) return 'assets/sunny.json'; //default to sunny

    switch (mainCondition.toLowerCase()){
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rainy.json';
      case 'thunderstorm':
        return 'assets/storm.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';




    }
  }

  



  //init state
  @override
  void initState(){
    super.initState();
  

  //fetch weather on startup
  _fetchWeather();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.fmd_good_rounded, size: 50.0,),
            //city name
            Text(_weather?.cityName ?? "Loading city...", textScaler: const TextScaler.linear(3), style: GoogleFonts.alata() ,),



            //animation
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),


            //temperature
            Text('${_weather?.temperature.round()}°C', textScaler: const TextScaler.linear(2.5), style: GoogleFonts.alata(),),


            //weather condition
            Text(_weather?.mainCondition ?? "", textScaler: TextScaler.linear(1.5), style: GoogleFonts.alata(),)


          ],
        ),
      ),
    );
  }
}