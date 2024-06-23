import 'package:finalweather/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:finalweather/pages/home.dart';
import 'package:finalweather/errorpage.dart';
import 'package:provider/provider.dart';
import 'package:finalweather/pages/weather_data.dart';
import 'package:finalweather/theme/thememanager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => ThemeManager(),
        child: Consumer<ThemeManager>(
        builder: (context, themeManager, child) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      themeMode: themeManager.thememode,
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
        '/errorpage': (context) {

          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          final isLoading = args['isLoading'] as bool;
          return ErrorPage(isLoading: isLoading);
        },

        '/weather_data': (context) => WeatherD(location:ModalRoute.of(context)!.settings.arguments as String),
      },
    );
  }));
}}
