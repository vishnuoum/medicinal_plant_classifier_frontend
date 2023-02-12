
import 'dart:convert';

import 'package:http/http.dart';

class ListService {
  String url;
  ListService(this.url);

  Future<dynamic> getUsername({required String id}) async {
    try {
      Response response = await post(Uri.parse("$url/getUsername"), body: {"id":id});
      print(response.body);
      if (response.body != "Error") {
        return jsonDecode(response.body);
      }
      else {
        return "error";
      }
    }
    on Exception catch (_, e) {
      print(e);
      return "error";
    }
  }
  
  Future<dynamic> fetchAllPlants({String q=""}) async {
    try {
      Response response = await get(Uri.parse("$url/getPlants?q=$q"));
      print(response.body);
      if (response.body != "Error") {
        return jsonDecode(response.body);
      }
      else {
        return "error";
      }
    }
    on Exception catch (_, e) {
      print(e);
      return "error";
    }
  }

  Future<dynamic> getPurpose({required int id}) async {
    try {
      Response response = await get(Uri.parse("$url/getPurpose?id=$id"),);
      print(response.body);
      if (response.body != "Error") {
        return jsonDecode(response.body);
      }
      else {
        return "error";
      }
    }
    on Exception catch (_, e) {
      print(e);
      return "error";
    }
  }
}