import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medicinal_plant_classifier/services/listService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Search extends StatefulWidget {
  final Map arguments;
  const Search({Key? key, required this.arguments}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {

  bool isSearch=true;
  TextEditingController searchController=TextEditingController();
  late ListService listService;
  bool loading=true;
  dynamic result=[];
  String txt="Loading";
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    listService = widget.arguments["listService"];
    sharedPreferences = widget.arguments["sharedPreferences"];
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void init({String query=""})async{
    result=await listService.fetchAllPlants(q: query);
    print(result);
    if(result!="error"){
      setState(() {
        loading=false;
        txt="Loading";
      });
    }
    else{
      setState(() {
        txt="Loading...";
      });
      Future.delayed(const Duration(seconds: 5),(){init(query: query);});
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        if(isSearch) {
          searchController.clear();
          setState(() {
            isSearch = false;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          automaticallyImplyLeading: !isSearch,
          title: isSearch?Container(
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            width: MediaQuery.of(context).size.width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.text,
                    autofocus: true,
                    style: const TextStyle(color: Colors.black),
                    controller: searchController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(border: InputBorder.none,hintText: "Search"),
                    onChanged: (text){
                      setState(() {});
                    },
                    onSubmitted: (text){
                      setState(() {
                        loading=true;
                        isSearch=false;
                        result=[];
                      });
                      init(query: text);
                    },
                  ),
                ),
                searchController.text.isNotEmpty?IconButton(onPressed: (){searchController.clear();setState(() {});}, icon: const Icon(Icons.clear)):Container()
              ],
            ),
          ):const Text("Search Result",style: TextStyle(color: Colors.black),),
          actions: isSearch?[]:[IconButton(onPressed: (){
            setState(() {
              isSearch=true;
            });
            print("Search");
          }, icon: const Icon(Icons.search))],
        ),
        body: isSearch?Container():loading?Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50,width: 50,child: CircularProgressIndicator(strokeWidth: 5,valueColor: AlwaysStoppedAnimation(Colors.green),),),
              const SizedBox(height: 10,),
              Text(txt)
            ],
          ),
        ):result.length==0?const Center(
          child: Text("No results to display",style: TextStyle(color: Colors.grey, fontSize: 20),),
        ):GridView.builder(
          padding: const EdgeInsets.only(top: 10),
          itemCount: result.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 8.0 / 12.0,
            crossAxisCount: 2,
          ),
          itemBuilder: (BuildContext context, int index) {
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
        ),
      ),
    );
  }
}
