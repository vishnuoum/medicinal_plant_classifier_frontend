import 'package:floating_action_bubble_custom/floating_action_bubble_custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medicinal_plant_classifier/pages/selection.dart';
import 'package:medicinal_plant_classifier/services/listService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  final Map arguments;
  const Home({Key? key, required this.arguments}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {

  late SharedPreferences sharedPreferences;
  late Animation<double> _animation;
  late AnimationController _animationController;
  bool loading = true;
  String txt = "Loading";
  String username = "";
  late ListService listService;

  dynamic result = [
    {
      "id": 1,
      "plant": "Tulsi",
      "scientific": "ABCD",
      "pic": "http://cdn.shopify.com/s/files/1/0047/9730/0847/products/nurserylive-seeds-krishna-tulsi-tulsi-black-0-5-kg-seeds.png?v=1634226026"
    }
  ];

  @override
  void initState() {
    sharedPreferences = widget.arguments["sharedPreferences"];
    listService = ListService(sharedPreferences.getString("url").toString());
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 260), vsync: this,
    );

    final curvedAnimation = CurvedAnimation(
        curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    loadData();

    super.initState();
  }

  void loadData() async {

    var res = await listService.getUsername(id: sharedPreferences.getString("id").toString());
    setState(() {
      username = res == "error" ? "User" : res["name"];
    });

    res = await listService.fetchAllPlants();
    if(res == "error") {
      setState(() {
        txt = "Something went wrong";
      });
      Future.delayed(const Duration(seconds: 5) , (){
        loadData();
      });
    }
    else{
      setState(() {
        loading = false;
        result = res;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_animationController.isCompleted) {
          _animationController.reverse();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        body: loading?Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50,width: 50,child: CircularProgressIndicator(strokeWidth: 5,valueColor: AlwaysStoppedAnimation(Colors.green),),),
              const SizedBox(height: 10,),
              Text(txt)
            ],
          ),
        ):NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (BuildContext context,
                bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  toolbarHeight: 80,
                  floating: true,
                  title: Text("Hello $username", style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 27,
                    color: Colors.black),),
                  systemOverlayStyle: const SystemUiOverlayStyle(
                    statusBarIconBrightness: Brightness.dark,
                    statusBarColor: Colors.white
                  ),
                  elevation: 0,
                  backgroundColor: Colors.white,
                  actions: [
                    IconButton(onPressed: () {
                      Navigator.pushNamed(context, "/search", arguments: {"listService":listService,"sharedPreferences":sharedPreferences});
                    },
                      icon: const Icon(Icons.search),
                      color: Colors.black,),
                    PopupMenuButton<String>(
                      icon: const Icon(
                          Icons.more_vert_rounded, color: Colors.black,
                          size: 25),
                      onSelected: (String value) {
                        if(value=="Logout") {
                          sharedPreferences.remove("id");
                          Navigator.pushReplacementNamed(context, "/",arguments: widget.arguments);
                        }
                        print(value);
                      },
                      itemBuilder: (BuildContext context) {
                        return {'Logout'}.map((String choice) {
                          return PopupMenuItem<String>(
                            value: choice,
                            child: Text(choice),
                          );
                        }).toList();
                      },
                    ),
                    const SizedBox(width: 10,)
                  ],
                )
              ];
            },
            body: ListView(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 10, bottom: 60),
              children: [
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text("All Plants    ", style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),),
                ),
                GridView.builder(
                  padding: const EdgeInsets.only(top: 10),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 10,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 8.0 / 12.0,
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    index = 0;
                    return Padding(
                        padding: const EdgeInsets.all(5),
                        child: Card(
                            elevation: 10,
                            semanticContainer: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(context, "/plant", arguments: {"data":result[index],"sharedPreferences":sharedPreferences});
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        margin: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              10),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  result[index]["pic"]),
                                              fit: BoxFit.cover),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.only(
                                              bottom: 8.0),
                                        ),
                                      ),
                                    )),
                                Padding(padding: const EdgeInsets.only(
                                    left: 10, top: 3, bottom: 10, right: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(result[index]["name"],
                                        style: const TextStyle(fontSize: 20,
                                            fontWeight: FontWeight.bold),),
                                      const SizedBox(height: 5,),
                                      Text(
                                        "${result[index]["scientific"]}",
                                        style: const TextStyle(
                                          color: Colors.grey,
                                            fontSize: 15),),
                                      // Text(result[index]['username'],style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                      // Text(result[index]['place'],style: TextStyle(fontSize: 15),),
                                      // Text(result[index]["district"],style: TextStyle(fontSize: 15),)
                                    ],
                                  ),)
                              ],
                            )));
                  },
                )
              ],
            ),
        ),
        floatingActionButton: loading?const SizedBox():FloatingActionBubble(
          animation: _animation,
          onPressed: () =>
          _animationController.isCompleted
              ? _animationController.reverse()
              : _animationController.forward(),
          iconColor: Colors.white,
          iconData: CupertinoIcons.square_grid_2x2,
          tooltip: "More",
          backgroundColor: Colors.green,
          // Menu items
          items: <Widget>[
            // Floating action menu item
            BubbleMenu(
              title: 'Classify',
              iconColor: Colors.green,
              bubbleColor: Colors.white,
              icon: CupertinoIcons.leaf_arrow_circlepath,
              onPressed: () {
                _animationController.reverse();
                if(context.mounted){
                  // Navigator.pushNamed(context, "/selection", arguments: widget.arguments);
                  showCupertinoModalPopup(context: context, builder:
                      (context) => Selection(arguments: widget.arguments)
                  );
                }
              },
              style: const TextStyle(fontSize: 16, color: Colors.green),
            ),
            BubbleMenu(
              title: 'Near By',
              iconColor: Colors.green,
              bubbleColor: Colors.white,
              icon: Icons.local_hospital_outlined,
              onPressed: () {
                _animationController.reverse();
                Navigator.pushNamed(context, "/nearby", arguments: widget.arguments);
              },
              style: const TextStyle(fontSize: 16, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}

// body: SafeArea(
// child: ListView(
// padding: const EdgeInsets.only(left: 15,right: 15, top: 10, bottom: 60),
// children: [
// const Align(
// alignment: Alignment.centerRight,
// child: Text("All Plants    ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
// ),
// const SizedBox(height: 15,),
// GridView.builder(
// shrinkWrap: true,
// physics: const NeverScrollableScrollPhysics(),
// itemCount: 10,
// gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// childAspectRatio: 8.0 / 12.0,
// crossAxisCount: 2,
// ),
// itemBuilder: (BuildContext context, int index) {
// index=0;
// return Padding(
// padding: const EdgeInsets.all(5),
// child: Card(
// elevation: 10,
// semanticContainer: true,
// shape: RoundedRectangleBorder(
// borderRadius: BorderRadius.circular(10.0),
// ),
// clipBehavior: Clip.antiAlias,
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: <Widget>[
// Expanded(
// child: GestureDetector(
// onTap: (){
// // showPic(context, result[index]["pic"].replaceAll("http://10.0.2.2:3000",url));
// },
// child: Container(
// width: double.infinity,
// margin: const EdgeInsets.all(10),
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(10),
// image: DecorationImage(
// image: NetworkImage(result[index]["pic"]),
// fit: BoxFit.cover),
// ),
// child: const Padding(
// padding: EdgeInsets.only(bottom: 8.0),
// ),
// ),
// )),
// Padding(padding: const EdgeInsets.only(left: 10,top: 3,bottom: 10,right: 10),
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Text(result[index]["plant"],style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
// const SizedBox(height: 5,),
// Text("${result[index]["scientific"]}/Kg",style: const TextStyle(fontSize: 17),),
// // Text(result[index]['username'],style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
// // Text(result[index]['place'],style: TextStyle(fontSize: 15),),
// // Text(result[index]["district"],style: TextStyle(fontSize: 15),)
// ],
// ),)
// ],
// )));
// },
// )
// ],
// ),
// ),
