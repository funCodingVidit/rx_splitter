import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rx_splitter/constants/api_constant.dart';

class AddGroupMemberController extends GetxController with StateMixin<List<dynamic>> {
  final name = TextEditingController();
  final email = TextEditingController();
  bool isLoading = false;

  /*@override
  void onInit() {
    fetchGroupMembersList();
    super.onInit();
  }*/

  @override
  void dispose() {
    super.dispose();
    name.dispose();
    email.dispose();
  }

  fetchGroupMembersList(int groupId) async {
    try {
      _updateIsLoading(true);
      await Future.delayed(3.seconds);
      change(null, status: RxStatus.loading());
      var response = await http.get(Uri.parse("${ApiConstant.getGroupMembersApi}/$groupId"),
          headers: ApiConstant.requestHeaders);
      _updateIsLoading(false);
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['status'] == "Success") {
          var data = List<dynamic>.from(responseData['response'].map((s) => s));
          if (data.isEmpty) {
            change(null, status: RxStatus.empty());
          } else {
            change(data, status: RxStatus.success());
          }
        } else {
          change(null, status: RxStatus.empty());
        }
      } else {
        change(null, status: RxStatus.error());
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load data ${e.toString()}');
      }
    }
  }

  Future<http.Response> createGroupMember(int groupId, String emailId) async {
    final response = await http.post(
        Uri.parse("${ApiConstant.createGroupMemberApi}/$groupId"),
        headers: ApiConstant.requestHeaders,
        body: json.encode([
          {
            'Email': emailId,
          }
        ]));
    return response;
  }

  void _updateIsLoading(bool currentStatus) {
    isLoading = currentStatus;
    update();
  }
}
