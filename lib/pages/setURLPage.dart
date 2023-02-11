import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetURLPage extends StatefulWidget {
  final Map arguments;
  const SetURLPage({Key? key, required this.arguments}) : super(key: key);

  @override
  State<SetURLPage> createState() => _SetURLPageState();
}

class _SetURLPageState extends State<SetURLPage> {

  TextEditingController url = TextEditingController(text: "");
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    sharedPreferences = widget.arguments["sharedPreferences"];
    url.text = sharedPreferences.getString("url")!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.green,
          statusBarIconBrightness: Brightness.light
        ),
        title: const Text("Set URL"),
      ),
      body: ListView(
        padding: const EdgeInsets.only(left: 25,right: 25,top: 60,bottom: 100),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
            color: Colors.grey[100],
            child: TextField(
              controller: url,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter URL"
              ),
            ),
          ),
          const SizedBox(height: 15,),
          TextButton(onPressed: (){
            if(url.text.isNotEmpty) {
              sharedPreferences.setString("url", url.text);
            }
          }, child: const Text("Set"))
        ],
      ),
    );
  }
}
