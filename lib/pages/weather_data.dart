import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:finalweather/services/API.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WeatherD extends StatefulWidget {
  const WeatherD({Key? key, required this.location}) : super(key: key);

  final String location;

  @override
  _WeatherDState createState() => _WeatherDState();
}

class _WeatherDState extends State<WeatherD> {
  final TextEditingController _controller = TextEditingController();
  final WeatherData weatherData = WeatherData();
  late Future<void> _weatherFuture;
  int day = 0;
  int indexx = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _weatherFuture = _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    try {

      await weatherData.getValue(widget.location);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching weather data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _weatherFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error fetching weather data'),
            ),
          );
        } else {
          return _buildWeatherUI();
        }
      },
    );
  }

  Widget _buildWeatherUI() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/${isLoading ? 'loading.jpeg' : 'skyblue.png'}'),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (isLoading || weatherData.weatherInfo['days'] == null)...[
                    Center(
                      child: Column(
                        children: [
                          SizedBox(height: 380),
                          SpinKitRotatingCircle(
                            color: Colors.white,
                            size: 50.0,
                          ),
                          SizedBox(height: 500)
                        ],
                      ),
                    ),],
                  Card(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Enter a location',
                        icon: Padding(
                          padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                          child: Icon(Icons.search),
                        ),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (value) {
                        _fetchWeatherData1(value);
                      },
                    ),
                  ),
                  if (weatherData.weatherInfo.isNotEmpty)
                    SizedBox(height: 40),

                  if (weatherData.weatherInfo['days'] != null)
                    Column(
                      children: [
                        Text(
                          '${((weatherData.weatherInfo['days'][day]['temp'] - 32) * 5 / 9).round()} °C',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 80,
                            fontFamily: 'Monts',
                          ),
                        ),
                        Text(
                          '${weatherData.weatherInfo['resolvedAddress']}',
                          style: TextStyle(color: Colors.white, fontFamily: 'Sedan'),
                        ),
                        SizedBox(height: 5,),

                        Text(
                          '${weatherData.weatherInfo['days'][indexx]['datetime']}',
                          style: TextStyle(color: Colors.white, fontFamily: 'Sedan'),
                        ),
                        SizedBox(height: 40),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                            gradient: LinearGradient(
                              colors: [Colors.blue, Colors.white],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Card(
                            color: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            '${((weatherData.weatherInfo['days'][day]['tempmin'] - 32) * 5 / 9).round()}°',
                                            style: TextStyle(color: Colors.white, fontSize: 32),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Lowest Today',
                                            style: TextStyle(color: Colors.white, fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            '${((weatherData.weatherInfo['days'][day]['tempmax'] - 32) * 5 / 9).round()}°',
                                            style: TextStyle(color: Colors.white, fontSize: 32),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Highest Today',
                                            style: TextStyle(color: Colors.white, fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 40),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            '${((weatherData.weatherInfo['days'][day]['feelslike'] - 32) * 5 / 9).round()}°',
                                            style: TextStyle(color: Colors.white, fontSize: 32),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Feels like',
                                            style: TextStyle(color: Colors.white, fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                '${weatherData.weatherInfo['days'][day]['windspeed']}',
                                                style: TextStyle(color: Colors.white, fontSize: 32),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(2,10,0,0),
                                                child: Text('km/Hr', style: TextStyle(color: Colors.white)),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Wind Speed',
                                            style: TextStyle(color: Colors.white, fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                            gradient: LinearGradient(
                              colors: [Colors.blue, Colors.white],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Card(
                            color: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top: 10),
                                            child: CircularPercentIndicator(
                                              radius: 70,
                                              lineWidth: 13.0,
                                              animation: true,
                                              percent: (weatherData.weatherInfo['days'][day]['precipprob']/ 100),
                                              center: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Text(
                                                    "${(weatherData.weatherInfo['days'][day]['precipprob'])}%",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 20.0,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              footer: Text(
                                                "Precipitation",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17.0,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              circularStrokeCap: CircularStrokeCap.round,
                                              progressColor: Colors.cyan,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top: 10),
                                            child: CircularPercentIndicator(
                                              radius: 70,
                                              lineWidth: 13.0,
                                              animation: true,
                                              percent: (weatherData.weatherInfo['days'][day]['humidity']/ 100),
                                              center: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Text(
                                                    "${(weatherData.weatherInfo['days'][day]['humidity'])}%",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 20.0,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              footer: Text(
                                                "Humidity",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17.0,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              circularStrokeCap: CircularStrokeCap.round,
                                              progressColor: Colors.amber[800],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 40),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons.cloudSun,
                                            size: 45,
                                            color: Colors.amber,
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            '${weatherData.weatherInfo['days'][day]['sunrise']}',
                                            style: TextStyle(color: Colors.white, fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons.solidMoon,
                                            size: 45,
                                            color: Colors.white60,
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            '${weatherData.weatherInfo['days'][day]['sunset']}',
                                            style: TextStyle(color: Colors.white, fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Text('Days to Come', style: TextStyle(color: Colors.white, fontSize: 25),)
                      ],
                    ),

                  if (weatherData.weatherInfo['days'] != null)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(weatherData.weatherInfo['days'].length, (index) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                            gradient: LinearGradient(
                              colors: [Colors.blue, Colors.white],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: Card(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  day = index;

                                });
                              },

                              child: ListTile(
                                title: Text('${weatherData.weatherInfo['days'][index]['datetime']}', style: TextStyle(color: Colors.white)),
                                subtitle: Text('${((weatherData.weatherInfo['days'][index]['temp'] - 32) * 5 / 9).round()} °C', style: TextStyle(color: Colors.white)),
                                leading: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (weatherData.weatherInfo['days'][index]['cloudcover'] > 50 && weatherData.weatherInfo['days'][index]['precipprob'] < 40)

                                      FaIcon(Icons.cloud, color: Colors.white60),

                                    if (weatherData.weatherInfo['days'][index]['cloudcover'] < 50 && weatherData.weatherInfo['days'][index]['precipprob'] < 40)
                                      Icon(Icons.wb_sunny, color: Colors.amber),

                                    if (weatherData.weatherInfo['days'][index]['precipprob'] >= 40)
                                      FaIcon(FontAwesomeIcons.cloudRain, color: Colors.white60),
                                  ],
                                ),

                              ),
                            ),
                          ),
                        );
                      }
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

  }
  Future<void> _fetchWeatherData1(String value) async {
    setState(() {
      isLoading = true;
    });

    try {
      await weatherData.getValue(value);
    } catch (e) {

      print('Error fetching weather data: $e');
    }


    if (!weatherData.error) {

      Navigator.pushNamed(context, '/weather_data', arguments: value);
    } else {

      Navigator.pushNamed(context, '/errorpage', arguments: {'isLoading': isLoading});
    }
  }
}



