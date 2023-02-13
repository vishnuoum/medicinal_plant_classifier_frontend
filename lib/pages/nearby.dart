import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:medicinal_plant_classifier/services/nearbyService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class NearBy extends StatefulWidget {
  final Map arguments;
  const NearBy({Key? key, required this.arguments}) : super(key: key);

  @override
  State<NearBy> createState() => _NearByState();
}

class _NearByState extends State<NearBy> {

  bool loading = false;
  late NearbyService nearbyService;
  late SharedPreferences sharedPreferences;
  dynamic results = [];

  @override
  initState() {
    sharedPreferences = widget.arguments["sharedPreferences"];
    nearbyService = NearbyService(url: sharedPreferences.getString("url").toString());
    super.initState();
  }

  Future<dynamic> _determinePosition() async {
    showLoading(context);
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {

      if(context.mounted){
        Navigator.pop(context);
      }

      alertDialog('Location services are disabled.');
      return "error";
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {

        if(context.mounted){
          Navigator.pop(context);
        }

        alertDialog('Location permissions are denied');
        return "error";
      }
    }

    if (permission == LocationPermission.deniedForever) {

      if(context.mounted){
        Navigator.pop(context);
      }

      alertDeniedDialog('Location permissions are permanently denied. Please go to app settings to provide permission');
      return "error";
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    if(context.mounted){
      Navigator.pop(context);
    }
    return await Geolocator.getCurrentPosition();
  }

  showLoading(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: SizedBox(
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(
                strokeWidth: 5,
                valueColor: AlwaysStoppedAnimation(Colors.green),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text("Loading")
          ],
        ),
      ),
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(onWillPop: () async => false, child: alert);
        });
  }

  Future<void> alertDialog(var text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(text),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> alertDeniedDialog(var text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(text),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Go to settings'),
              onPressed: () async {
                await Geolocator.openAppSettings();
                if(context.mounted){
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void getHospitals(Position position) async {
    setState(() {
      loading = true;
    });
    var res = await nearbyService.getNearbyHospitals(lat: position.latitude.toString(), long: position.longitude.toString());
    setState(() {
      loading = false;
    });
    if(res=="error") {
      alertDialog("Something went wrong. Try again later.");
    }
    else if(res=="netError") {
      alertDialog("Something went wrong. Please check your network connection and try again later.");
    }
    else{
      setState(() {
        results = res;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: const Text("NearBy Hospitals",style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark
        ),
        iconTheme: const IconThemeData(
          color: Colors.black
        ),
      ),
      body: loading?Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(height: 50,width: 50,child: CircularProgressIndicator(strokeWidth: 5,valueColor: AlwaysStoppedAnimation(Colors.green),),),
            SizedBox(height: 10,),
            Text("Loading")
          ],
        ),
      ):results.length==0?const Center(
        child: Text("No results to show",style: TextStyle(color: Colors.grey,fontSize: 20),),
      ):ListView.builder(
        padding: EdgeInsets.only(top: 15),
        itemCount: results.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: ()async {
              if (!await launchUrl(Uri.parse(results[index]["url"]),
              mode: LaunchMode.externalApplication,
              )) {
              throw Exception('Could not launch ${results[index]["hospital"]}');
              }
            },
            isThreeLine: true,
            leading: const Icon(Icons.local_hospital),
            title: Text(results[index]["hospital"]),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5,),
                Text(results[index]["location"].replaceAll(results[index]["rating"][0], "").replaceAll(results[index]["rating"][1], "").trim()),
                const SizedBox(height: 5,),
                Text("⭐ ${results[index]["rating"][0]} ${results[index]["rating"][1]}")
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          dynamic position = await _determinePosition();
          print(position);
          if(position !="error"){
            print("go");
            getHospitals(position);
          }
        },
        child: Icon(Icons.location_on_sharp),
        tooltip: "Get Location",
      ),
    );
  }
}
