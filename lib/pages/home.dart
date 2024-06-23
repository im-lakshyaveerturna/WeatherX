import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:finalweather/services/API.dart';
import 'package:finalweather/services/location.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _controller = TextEditingController();
  final WeatherData weatherData = WeatherData();
  final Location location = Location();
  Map<String, dynamic> currentData = {};
  bool isLoading = true;
  String emoji = '';
  int day = 0;
  int indexx = 0;


  @override
  void initState() {
    super.initState();
    _initialFetchWeatherData();
  }

  Future<void> _initialFetchWeatherData() async {
    await location.fetchData();
    try {
      print(location.currentLocation);
      await weatherData.getValue(location.currentLocation);
      setState(() {
        currentData = weatherData.weatherInfo;
        isLoading = false;
      });
    } catch (e) {
      // Handle error
      print('Error fetching weather data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  if (isLoading || currentData['days'] == null)...[
                    Center(
                      child: Column(
                        children: [
                          SizedBox(height: 380),
                          Container(
                            child: SpinKitPulsingGrid(
                              color: Colors.white,
                              size: 50.0,
                            ),
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
                        _fetchWeatherData(value);
                      },
                    ),
                  ),
                  if (currentData.isNotEmpty)
                    SizedBox(height: 40),

                  if (currentData['days'] != null)
                    Column(
                      children: [

                        Text(
                          '${((currentData['days'][day]['temp'] - 32) * 5 / 9).round()} °C',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 80,
                            fontFamily: 'Monts',
                          ),
                        ),
                        Text(
                          '${currentData['resolvedAddress']}',
                          style: TextStyle(color: Colors.white, fontFamily: 'Sedan'),
                        ),
                        SizedBox(height: 5,),

                        Text(
                          '${currentData['days'][indexx]['datetime']}',
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
                                            '${((currentData['days'][day]['tempmin'] - 32) * 5 / 9).round()}°',
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
                                            '${((currentData['days'][day]['tempmax'] - 32) * 5 / 9).round()}°',
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
                                            '${((currentData['days'][day]['feelslike'] - 32) * 5 / 9).round()}°',
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
                                                '${currentData['days'][day]['windspeed']}',
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
                                              percent: (currentData['days'][day]['precipprob']/ 100) ,
                                              center: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Text(
                                                    "${(currentData['days'][day]['precipprob'])}%",
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
                                              percent: (currentData['days'][day]['humidity']/100),
                                              center: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Text(
                                                    "${(currentData['days'][day]['humidity'])}%",
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
                                            '${currentData['days'][day]['sunrise']}',
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
                                            '${currentData['days'][day]['sunset']}',
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

                  if (currentData['days'] != null)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(currentData['days'].length, (index) {
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
                                day += 1;
                                indexx = index;

                              });
                            },

                            child: ListTile(
                              title: Text('${currentData['days'][index]['datetime']}', style: TextStyle(color: Colors.white)),
                              subtitle: Text('${((currentData['days'][index]['temp'] - 32) * 5 / 9).round()} °C', style: TextStyle(color: Colors.white)),
                              leading: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (currentData['days'][index]['cloudcover'] > 50 && weatherData.weatherInfo['days'][index]['precipprob'] < 40)

                                      FaIcon(Icons.cloud, color: Colors.white60),

                                    if (currentData['days'][index]['cloudcover'] < 50 && weatherData.weatherInfo['days'][index]['precipprob'] < 40)
                                      Icon(Icons.wb_sunny, color: Colors.amber),

                                    if (currentData['days'][index]['precipprob'] >= 40)
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

  Future<void> _fetchWeatherData(String value) async {
    setState(() {
      isLoading = true;
    });

    try {
      await weatherData.getValue(value);
    } catch (e) {
      // Handle error
      print('Error fetching weather data: $e');
    }

      if (!weatherData.error) {
        Navigator.pushNamed(context, '/weather_data', arguments: value);
      } else {
        Navigator.pushNamed(context, '/errorpage', arguments: {'isLoading': isLoading});
      }
    }
  }

