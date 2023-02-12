import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medicinal_plant_classifier/services/listService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Plant extends StatefulWidget {
  final Map arguments;
  const Plant({Key? key, required this.arguments}) : super(key: key);

  @override
  State<Plant> createState() => _PlantState();
}

class _PlantState extends State<Plant> {

  dynamic data;
  late ListService listService;
  late SharedPreferences sharedPreferences;
  bool loading = true;
  dynamic purposes;
  String txt = "Loading";

  @override
  void initState() {
    data = widget.arguments["data"];
    sharedPreferences = widget.arguments["sharedPreferences"];
    listService = ListService(sharedPreferences.getString("url").toString());
    init();
    super.initState();
  }

  void init() async {
    var res = await listService.getPurpose(id: data["id"]);
    if(res == "error") {
      setState(() {
        txt = "Something went wrong";
      });
      Future.delayed(const Duration(seconds: 5),(){
        init();
      });
    }
    else{
      setState(() {
        loading = false;
        purposes = res;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading?Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50,width: 50,child: CircularProgressIndicator(strokeWidth: 5,valueColor: AlwaysStoppedAnimation(Colors.green),),),
            const SizedBox(height: 10,),
            Text(txt)
          ],
        ),
      ),
    ):Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(
            color: Colors.white,
        ),
        backgroundColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.green
        ),
      ),
      body:Stack(
        children: [
          Container(constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),),
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height*0.4,
            child: Image.network(data["pic"],fit: BoxFit.cover,),
          ),
          Positioned(
              left: 0,
              top: MediaQuery.of(context).size.height*0.36,
              child: Container(
                height: MediaQuery.of(context).size.height*0.64,
                // padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
                    boxShadow: [BoxShadow(
                      color: Colors.black,
                      blurRadius: 15.0,
                    )]
                ),
                constraints: BoxConstraints(
                  maxWidth:MediaQuery.of(context).size.width,
                ),
                child: ListView(
                  padding: const EdgeInsets.all(12),
                  children: [
                    const SizedBox(height: 20,),
                    Text(data["name"],style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                    const SizedBox(height: 3,),
                    Text(data["scientific"], style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic,fontWeight: FontWeight.bold,color: Colors.grey),),
                    const SizedBox(height: 25,),
                    SizedBox(width: MediaQuery.of(context).size.width,child: Text("${data["description"]}",textAlign:TextAlign.justify,style: const TextStyle(fontSize: 17),),),
                    const SizedBox(height: 30,),
                    const Center(child: Text("Benefits" , style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),)),
                    ListView.builder(
                      padding: EdgeInsets.only(top: 30),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: purposes.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(purposes[index]["part"],style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                            const SizedBox(height: 15,),
                            SizedBox(width: MediaQuery.of(context).size.width,child: Text("${purposes[index]["description"]}",textAlign:TextAlign.justify,style: const TextStyle(fontSize: 17),),),
                          ],
                        );
                      },
                    )
                  ],
                ),
              )
          ),
        ],
      ),
    );
  }
}
