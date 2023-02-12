import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medicinal_plant_classifier/services/classifyService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Selection extends StatefulWidget {

  final Map arguments;
  const Selection({Key? key, required this.arguments}) : super(key: key);

  @override
  State<Selection> createState() => _SelectionState();
}

class _SelectionState extends State<Selection> {


  final ImagePicker _picker = ImagePicker();
  late ClassifyService classifyService;
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    sharedPreferences = widget.arguments["sharedPreferences"];
    classifyService = ClassifyService(url: sharedPreferences.getString("url").toString());
    super.initState();
  }

  showLoading(BuildContext context){
    AlertDialog alert =AlertDialog(
      content: SizedBox(
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(height: 50,width: 50,child: CircularProgressIndicator(strokeWidth: 5,valueColor: AlwaysStoppedAnimation(Colors.green),),),
            SizedBox(height: 10,),
            Text("Loading")
          ],
        ),
      ),
    );

    showDialog(context: context,builder:(BuildContext context){
      return WillPopScope(onWillPop: ()async => false,child: alert);
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


  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: (){
        Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const SizedBox(),
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
          iconTheme: const IconThemeData(
            color: Colors.black
          ),
        ),
        backgroundColor: Colors.transparent,
        body: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async{
                          final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
                          if(photo?.path == null) {
                            return;
                          }
                          print(photo!.path);
                          if(context.mounted) {
                            showLoading(context);
                          }
                          var result = await classifyService.classify(path: photo.path);
                          print(result);
                          if(context.mounted) {
                            Navigator.pop(context);
                          }
                          if(result=="error") {
                            alertDialog("Something went wrong. Try again later");
                          }
                          else if(result == "No Leaf") {
                            alertDialog("Could not find any leaf in the image");
                          }
                          else{
                            if(context.mounted) {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, "/results",arguments: {"sharedPreferences":sharedPreferences, "result":result});
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)
                            ),
                            padding: const EdgeInsets.all(20)
                        ),
                        child: const Icon(Icons.camera,size: 30),
                      ),
                      const SizedBox(height: 10,),
                      const Text("Open Camera", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 17),)
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
                          if(photo?.path == null) {
                            return;
                          }
                          print(photo!.path);
                          if(context.mounted) {
                            showLoading(context);
                          }
                          var result = await classifyService.classify(path: photo.path);
                          print(result);
                          if(context.mounted) {
                            Navigator.pop(context);
                          }
                          if(result=="error") {
                            alertDialog("Something went wrong. Try again later");
                          }
                          else if(result == "No Leaf") {
                            alertDialog("Could not find any leaf in the image");
                          }
                          else{
                            if(context.mounted) {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, "/results",arguments: {"sharedPreferences":sharedPreferences, "result":result});
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)
                            ),
                            padding: const EdgeInsets.all(20)
                        ),
                        child: const Icon(Icons.upload_file,size: 30),
                      ),
                      const SizedBox(height: 10,),
                      const Text("Open Files", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 17),)
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
