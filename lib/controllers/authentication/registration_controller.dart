import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:http/http.dart' as http;
import 'package:rx_splitter/constants/api_constant.dart';
import 'package:rx_splitter/ui/screens/login/login_screen.dart';

class RegistrationController extends GetxController {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  Future<String> registerUserApi(String name, String email, String password) async {
    String? resString;
    final response = await http.post(Uri.parse(ApiConstant.createUserApi),
        headers: {'Content-Type': "application/json"},
        body: json.encode({
          'name': name,
          'email': email,
          'password': password
        }));

    if (response.statusCode == 200) {
      resString = "SUCCESS-User registered successfully";
      Get.offAll(() => const LoginScreen());
    } else {
      print('Something went wrong');
      resString = "ERROR-Failed to create user";
    }
    return resString;
  }
}
