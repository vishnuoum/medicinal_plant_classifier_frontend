
import 'dart:convert';

import 'package:http/http.dart';

class NearbyService {

  String url;

  NearbyService({required this.url});

  Future<dynamic> getNearbyHospitals({required String lat, required String long}) async {
    try{
      Response response = await get(Uri.parse("$url/nearby?location=lat $lat long $long"));
      if(response.body =="error"){
        return "error";
      }
      else{
        return jsonDecode(response.body);
      }
    }
    on Exception catch (_, e) {
      print(e);
      return "netError";
    }
  }

}