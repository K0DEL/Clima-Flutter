import 'package:clima/services/weather.dart';
import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'dart:convert';
import 'package:clima/screens/city_screen.dart';

class LocationScreen extends StatefulWidget {

  LocationScreen({this.locationWeather});
  final locationWeather;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {

  String weatherIcon;
  int temperature;
  String cityName;
  String weatherMessage;

  WeatherModel weatherModel = WeatherModel();

  void updateUI(dynamic weatherData){
    if(weatherData == null) {

        temperature = 0;
        weatherIcon = 'ERROR';
        weatherMessage = 'No Location';
        cityName = 'your City';
      }
    else{

        try{
          setState(() {
            print(weatherData);

            //jsonDecode does not takes null and crashes the app.
            // still the crashing was there
            // so I fixed it by converting condition to var for now <(＿　＿)>

            var decodedData = jsonDecode(weatherData);
            var condition = decodedData['weather'][0]['id'];
            weatherIcon = weatherModel.getWeatherIcon(condition);
            double temp = decodedData['main']['temp'];
            temperature = temp.toInt();
            cityName = decodedData['name'];
            weatherMessage = weatherModel.getMessage(temperature);
          });
        }catch(e){
          print(e);
        }

    }

  }

  @override

  void initState(){
    super.initState();
    updateUI(widget.locationWeather);
  }



  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () async {
                      var weatherData = await weatherModel.getLocationWeather();
                      updateUI(weatherData);
                    },
                    child: Icon(
                      Icons.near_me,  
                      size: 50.0,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      var typedName = await Navigator.push(
                          context, MaterialPageRoute(
                          builder: (context){
                            return CityScreen();
                          }
                        ),
                      );
                      if (typedName != null)
                        {
                          var weatherData = await weatherModel.getCityWeather(typedName);
                          updateUI(weatherData);
                        }
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temperature°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      '$weatherIcon',
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  '$weatherMessage in $cityName',
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

