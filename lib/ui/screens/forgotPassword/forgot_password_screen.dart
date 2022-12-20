import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rx_splitter/constants/app_colors.dart';
import 'package:rx_splitter/controllers/authentication/forgot_password_controller.dart';
import 'package:rx_splitter/ui/screens/login/login_screen.dart';
import 'package:rx_splitter/utils/extensions/validation.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  ForgotPasswordController forgotPasswordController = Get.put(ForgotPasswordController());
  bool isLoading = false;

  void changeIsLoadingValue() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  Future<void> sendResetPassword() async {
    try {
      changeIsLoadingValue();
      var response = await forgotPasswordController.forgotPasswordApi();
      if (response.statusCode == 200) {
        changeIsLoadingValue();
        Get.snackbar(
            "Success", "A link has been sent to the registered email address",
            snackPosition: SnackPosition.TOP, backgroundColor: Colors.green, colorText: AppColors.white);
        Get.offAll(() => const LoginScreen());
      } else {
        changeIsLoadingValue();
        final responseData = jsonDecode(response.body);
        Get.snackbar(
            "Failed", responseData['error']!, snackPosition: SnackPosition.TOP,
            backgroundColor: AppColors.red,
            colorText: AppColors.white);
      }
    } catch (e) {
      Get.snackbar("ERROR", "Something went wrong", snackPosition: SnackPosition.TOP, backgroundColor: AppColors.red, colorText: AppColors.white);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: AppColors.kSecondary, //change your color here
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("Reset your by password\nthrough Email", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
            const SizedBox(height: 40),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: forgotPasswordController.email,
                decoration: const InputDecoration(
                  labelText: "Email",
                ),
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Email is required';
                  } else if (!val.isValidEmail) {
                    return 'Enter a valid Email address';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: ElevatedButton(
                onPressed:() {
                  if (_formKey.currentState!.validate()) {
                    sendResetPassword();
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: AppColors.kPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 15.0,
                ),
                child: isLoading ?
                const SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(),
                ) : const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Send',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
