import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Results extends StatefulWidget {
  final Map arguments;
  const Results({Key? key, required this.arguments}) : super(key: key);

  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {

  bool loading = true;
  dynamic result;
  late SharedPreferences sharedPreferences;


  @override
  void initState() {
    result = widget.arguments["result"];
    sharedPreferences = widget.arguments["sharedPreferences"];
    print(result);
    loading = false;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Predictions", style: TextStyle(color: Colors.black),),
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark
        ),
      ),
      body: loading?const Center(
        child: CircularProgressIndicator(),
      ):
      GridView.builder(
        padding: const EdgeInsets.all(5),
        itemCount: result.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: (8 / 10),
          crossAxisCount: 2,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Stack(
            children: [
              SizedBox(
                height: 500,
                child: GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context, "/plant", arguments: {"data":result[index]["details"],"sharedPreferences":sharedPreferences});
                  },
                  child: Card(
                    elevation: 10,
                    clipBehavior: Clip.hardEdge,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Image.network(result[index]["details"]['pic'],fit: BoxFit.cover,),),
                ),
              ),
              Positioned(
                  bottom: 20,
                  right: 20,
                  child: CircleAvatar(
                      radius: 19,
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.green,
                      child: Text("${(result[index]["confidence"]*100).toStringAsFixed(0)}%",style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)))
            ],
          );
        },
      ),
    );
  }
}
