
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:http/io_client.dart';

class ClassifyService {
  late String url;

  ClassifyService({required this.url});

  Future<dynamic> classify({required String path}) async {
    try{
      HttpClient client = HttpClient()..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
      var ioClient = IOClient(client);
      var request = MultipartRequest("POST", Uri.parse("$url/classify"));
      request.files.add(await MultipartFile.fromPath(
        'pic',
        path,
      ));
    var response=await ioClient.send(request);
    String body=await response.stream.bytesToString();
    if(body == "No Leaf"){
      return "No Leaf";
    }
    else if(body!="Error"){
      return jsonDecode(body);
    }
    else{
      return "error";
    }

    }
    on Exception catch (_, e){
      print(e);
      return "netError";
    }
  }
}