import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:zodiac/providers/zodiac_provider.dart';
import 'package:zodiac/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent)
    );
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
    ]);
    return ChangeNotifierProvider(
      create:(context)=>ZodiacProvider(),
      child:MaterialApp(
          theme: ThemeData(
            primaryColor: Colors.black,
          ),
          darkTheme: ThemeData.dark().copyWith(
            primaryColor: Colors.white,
          ),
          themeMode: ThemeMode.system,
          debugShowCheckedModeBanner: false,
          title: 'Horoscope',
          home: const SplashScreen()
      )
    );
  }
}
