import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_application_p_2/api/response.dart';

class APIForm {
  //ดึงข้อมูล Profile
  static Future<APIResponse> profile(userId) async {
    var data = '''''';
    var dio = Dio();
    var response = await dio.request(
      'http://54.175.155.216/api/p-2/form.php?method=profile&user_id=$userId',
      options: Options(
        method: 'GET',
      ),
      data: data,
    );

    if (response.statusCode == 200) {
      return APIResponse.fromResponse(response.data);
    } else {
      return APIResponse(
          success: false, data: {'message': response.statusMessage});
    }
  }

  //Edit Profile
  static Future<APIResponse> editProfile(dynamic profile) async {
    var headers = {'Content-Type': 'application/json'};
    var data = json.encode(profile);
    /*
{
      "user_id": "1",
      "display_name": "Tummanoon W",
      "prefix": "Mr.",
      "fname": "Tummanoon",
      "mname": "Thongthawee",
      "lname": "Wanchaem",
      "nationality": "Lao",
      "place_of_birth": "Vientiane",
      "marital_status": "single",
      "date_of_birth": "1997-09-27",
      "passport_no": "PA0480931",
      "place_of_issue": "Lao People Democratic Republic",
      "date_of_issue": "2016-05-05",
      "date_of_expiry": "2024-05-04",
      "occupation": "Software Developer",
      "addr_dom": null,
      "addr_dom_tel": null,
      "addr_perm": null,
      "addr_perm_tel": null,
      "addr_perm_email": null
    }
    */

    var dio = Dio();
    var response = await dio.request(
      'http://54.175.155.216/api/p-2/form.php?method=edit-profile',
      options: Options(
        method: 'PUT',
        headers: headers,
      ),
      data: data,
    );

    if (response.statusCode == 200) {
      return APIResponse.fromResponse(response.data);
    } else {
      return APIResponse(
          success: false, data: {'message': response.statusMessage});
    }
  }

  //ดึงข้อมูล History VISA
  static Future<APIResponse> myForms(userId) async {
    var data = '''''';
    var dio = Dio();
    var response = await dio.request(
      'http://54.175.155.216/api/p-2/form.php?method=my-forms&user_id=$userId',
      options: Options(
        method: 'GET',
      ),
      data: data,
    );

    if (response.statusCode == 200) {
      return APIResponse.fromResponse(response.data);
    } else {
      return APIResponse(
          success: false, data: {'message': response.statusMessage});
    }
  }

  //New VISA VISA
  static Future<APIResponse> createForm(authorId) async {
    var headers = {'Content-Type': 'application/json'};
    var data = json.encode({"author_id": authorId});
    var dio = Dio();
    var response = await dio.request(
      'http://54.175.155.216/api/p-2/form.php?method=create-form',
      options: Options(
        method: 'POST',
        headers: headers,
      ),
      data: data,
    );

    if (response.statusCode == 200) {
      return APIResponse.fromResponse(response.data);
    } else {
      return APIResponse(
          success: false, data: {'message': response.statusMessage});
    }
  }

  //Editคำขอ VISA
  static Future<APIResponse> editForm(dynamic form) async {
    var headers = {'Content-Type': 'application/json'};
    var data = json.encode(form);

    /*
{
      "id": "1",
      "title": "แบบคำขอ VISA พ.ค.",
      "prefix": "Mr.",
      "fname": "Tummanoon",
      "mname": "Thongthawee",
      "lname": "Wanchaem",
      "nationality": "Lao",
      "place_of_birth": null,
      "marital_status": null,
      "date_of_birth": null,
      "passport_no": null,
      "place_of_issue": null,
      "date_of_issue": null,
      "date_of_expiry": null,
      "occupation": null,
      "addr_dom": null,
      "addr_dom_tel": null,
      "addr_perm": null,
      "addr_perm_tel": null,
      "addr_perm_email": null,
      "addr_des": null,
      "date_of_arrival": null,
      "travel_by": null,
      "duration_of_stay": null,
      "guarantor_des_name": null,
      "guarantor_des_tel": null,
      "guarantor_dom_name": null,
      "guarantor_dom_tel": null
    }
    */

    var dio = Dio();
    var response = await dio.request(
      'http://54.175.155.216/api/p-2/form.php?method=edit-form',
      options: Options(
        method: 'PUT',
        headers: headers,
      ),
      data: data,
    );

    if (response.statusCode == 200) {
      return APIResponse.fromResponse(response.data);
    } else {
      return APIResponse(
          success: false, data: {'message': response.statusMessage});
    }
  }

  //Deleteคำขอ VISA
  static Future<APIResponse> deleteForm(formId) async {
    var headers = {'Content-Type': 'application/json'};
    var data = json.encode({"id": formId});
    var dio = Dio();
    var response = await dio.request(
      'http://54.175.155.216/api/p-2/form.php?method=delete-form',
      options: Options(
        method: 'DELETE',
        headers: headers,
      ),
      data: data,
    );

    if (response.statusCode == 200) {
      return APIResponse.fromResponse(response.data);
    } else {
      return APIResponse(
          success: false, data: {'message': response.statusMessage});
    }
  }

  //รายละเอียดคำขอ VISA
  static Future<APIResponse> formDetail(formId) async {
    var data = '''''';
    var dio = Dio();
    var response = await dio.request(
      'http://54.175.155.216/api/p-2/form.php?method=form-detail&form-id=$formId',
      options: Options(
        method: 'GET',
      ),
      data: data,
    );

    if (response.statusCode == 200) {
      return APIResponse.fromResponse(response.data);
    } else {
      return APIResponse(
          success: false, data: {'message': response.statusMessage});
    }
  }
}
