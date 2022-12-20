import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rx_splitter/constants/api_constant.dart';

class ForgotPasswordController extends GetxController {
  TextEditingController email = TextEditingController();

  Future<http.Response> forgotPasswordApi() async {
    var response = await http.get(
      Uri.parse("${ApiConstant.forgotPasswordApi}?EmailId=${email.text}"),
      headers: {'Content-type': "application/json"},
    );
    return response;
  }
}
