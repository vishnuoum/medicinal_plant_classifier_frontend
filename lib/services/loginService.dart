import 'dart:convert';

import 'package:http/http.dart';

class LoginService {
  late String url;

  LoginService(this.url);

  Future<dynamic> validate(
      {required String phone, required String password}) async {

    print("$url/login");

    try {
      Response response = await post(Uri.parse("$url/login"),
          body: {"phone": phone, "password": password});

      if (response.body != "Error") {
        return jsonDecode(response.body);
      }
      else {
        return "error";
      }
    }
    on Exception catch (_, e) {
      print(e);
      return "netError";
    }
  }

  Future<dynamic> register(
      {required String username,required String phone, required String password}) async {

    print("$url/signup");

    try {
      Response response = await post(Uri.parse("$url/signup"),
          body: {"username" : username,"phone": phone, "password": password});
      if (response.body == "Exists") {
        return "exists";
      }
      else if (response.body != "Error") {
        return jsonDecode(response.body);
      }
      else {
        return "error";
      }
    }
    on Exception catch (_, e) {
      print(e);
      return "netError";
    }
  }
}
