import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rx_splitter/constants/api_constant.dart';

class AddGroupMemberController extends GetxController {
  final groupName = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    groupName.dispose();
  }

  Future<http.Response> createGroup(String groupName) async {
    final response = await http.post(Uri.parse(ApiConstant.createGroupApi),
        headers: ApiConstant.requestHeaders,
        body: json.encode({
          'groupName': groupName,
        }));
    return response;
  }
}
