import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Login extends StatefulWidget {
  final Map arguments;
  const Login({Key? key, required this.arguments}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {


  TextEditingController phone=TextEditingController();
  TextEditingController password=TextEditingController();

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
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          iconTheme: const IconThemeData(
              color: Colors.green
          ),
          elevation: 0,
          actions: [
            IconButton(onPressed: (){
              Navigator.pushNamed(context, "/setURLPage");
            }, icon: const Icon(Icons.list_alt))
          ],
          systemOverlayStyle: const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
          backgroundColor: Colors.transparent,
        ),
        body: Form(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 30),
            children: [
              const SizedBox(height: 70,),
              const Align(alignment: Alignment.centerLeft,child: Text("Login",style: TextStyle(color: Colors.green,fontSize: 30,fontWeight: FontWeight.bold),),),
              const SizedBox(height: 40,),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200]
                ),
                child: TextField(
                  controller: phone,
                  focusNode: null,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Phone No.'
                  ),
                ),
              ),
              const SizedBox(height: 15,),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200]
                ),
                child: TextField(
                  obscureText: true,
                  controller: password,
                  focusNode: null,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Password'
                  ),
                ),
              ),
              const SizedBox(height: 15,),
              TextButton(onPressed: ()async{

              },style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),backgroundColor: Colors.green,foregroundColor: Colors.white,padding: const EdgeInsets.all(18)), child: const Text("Login",style: TextStyle(fontSize: 17),),),
              const SizedBox(height: 20,),
              Align(
                child: GestureDetector(
                  child: const Text("Signup",style: TextStyle(fontSize: 16,color: Colors.green,decoration: TextDecoration.underline),),
                  onTap: (){
                    Navigator.pushReplacementNamed(context, "/signup");
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
