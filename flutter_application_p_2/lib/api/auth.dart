import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_application_p_2/api/response.dart';

class APIAuth {
  static Future<APIResponse> login (String email, String password) async {
    var headers = {'Content-Type': 'application/json'};
    var data = json.encode(
        {"email": email, "password": password});
    var dio = Dio();
    var response = await dio.request(
      'http://54.175.155.216/api/p-2/auth.php?method=login',
      options: Options(
        method: 'POST',
        headers: headers,
      ),
      data: data,
    );

    if (response.statusCode == 200) {
      return APIResponse.fromResponse(response.data);
    } else {
      return APIResponse(success: false, data: {'message': response.statusMessage});
    }
  }
}
