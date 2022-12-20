import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:http/http.dart' as http;
import 'package:rx_splitter/constants/api_constant.dart';

class LoginController extends GetxController {
  final email = TextEditingController();
  final password = TextEditingController();

  Future<http.Response> loginUserApi(String email, String password) async {
    final response = await http.post(Uri.parse(ApiConstant.loginApi),
        headers: {'Content-Type': "application/json"},
        body: json.encode({
          'userName': email,
          'password': password,
        }));
    return response;
  }
}
