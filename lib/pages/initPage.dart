import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitPage extends StatefulWidget {
  const InitPage({Key? key}) : super(key: key);

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {

  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    loadSP();
    super.initState();
  }

  void loadSP() async{
    sharedPreferences = await SharedPreferences.getInstance();
    if(!sharedPreferences.containsKey("url")) {
      sharedPreferences.setString("url", "http://10.0.2.2:3000");
    }

    if(context.mounted) {
      if(!sharedPreferences.containsKey("id")) {
        Navigator.pushReplacementNamed(
            context, "/login", arguments: {"sharedPreferences": sharedPreferences});
      }
      else {
        Navigator.pushReplacementNamed(
            context, "/home",
            arguments: {"sharedPreferences": sharedPreferences});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator(color: Colors.green,)),
    );
  }
}
