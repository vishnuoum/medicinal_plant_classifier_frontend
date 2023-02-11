import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medicinal_plant_classifier/pages/home.dart';
import 'package:medicinal_plant_classifier/pages/initPage.dart';
import 'package:medicinal_plant_classifier/pages/login.dart';
import 'package:medicinal_plant_classifier/pages/setURLPage.dart';
import 'package:medicinal_plant_classifier/pages/signup.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      routes: {
        "/home" : (context) => Home(arguments: ModalRoute.of(context)!.settings.arguments as Map),
        "/login" : (context) => Login(arguments: ModalRoute.of(context)!.settings.arguments as Map),
        "/signup" : (context) => Signup(arguments: ModalRoute.of(context)!.settings.arguments as Map),
        "/setURLPage" : (context) => SetURLPage(arguments: ModalRoute.of(context)!.settings.arguments as Map),
        "/" : (context) => const InitPage()
      },
      initialRoute: "/",
    );
  }
}
