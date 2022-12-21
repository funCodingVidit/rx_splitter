import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rx_splitter/constants/app_colors.dart';
import 'package:rx_splitter/controllers/authentication/login_controller.dart';
import 'package:rx_splitter/ui/screens/forgotPassword/forgot_password_screen.dart';
import 'package:rx_splitter/ui/screens/groups/display_groups.dart';
import 'package:rx_splitter/ui/screens/registration/registration_screen.dart';
import 'package:rx_splitter/utils/preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginController loginController = Get.put(LoginController());
  bool isLoading = false;

  void changeIsLoadingValue() {
    setState(() {
      isLoading = !isLoading;
    });
  }


  void loginUser() async {
    try {
      changeIsLoadingValue();
      final userData = await loginController.loginUserApi(loginController.email.text, loginController.password.text);
      if (kDebugMode) {
        print(userData);
      }
      final Map<String, dynamic> responseData = json.decode(userData.body);
      if (userData.statusCode == 200) {
        changeIsLoadingValue();
        PreferencesUtils().setToken(responseData['token']);
        //final decodedToken = TokenDecoder().decoder(responseData['token']);
        PreferencesUtils().setIsLogged(true);
        Get.offAll(()=> const DisplayGroupsScreen());
      } else {
        changeIsLoadingValue();
        Get.snackbar("Error", "${responseData['error']}", colorText: AppColors.white, backgroundColor: AppColors.red);
      }
    } catch(e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 125, top: 130),
            child: const Text(
              'Login',
              style: TextStyle(color: AppColors.black, fontSize: 33),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 35, right: 35),
                    child: Column(
                      children: [
                        TextField(
                          controller: loginController.email,
                          decoration: const InputDecoration(
                            labelText: "Email",
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextField(
                          controller: loginController.password,
                          decoration: const InputDecoration(
                            labelText: "Password",
                          ),
                          obscureText: true,
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            onPressed: () {
                              Get.to(() => const ForgotPasswordScreen());
                            },
                            child: const Text("Forgot password?", style: TextStyle(color: AppColors.kSecondary, decoration: TextDecoration.underline),),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: ElevatedButton(
                              onPressed: () {
                                loginUser();
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
                                  'Login',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                                text: "Don't have an account ",
                              ),
                              TextSpan(
                                style: const TextStyle(
                                  color: AppColors.kSecondary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                                text: "Sign Up",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    Get.to(const RegistrationScreen());
                                    //Navigator.pushNamed(context, 'registration');
                                  },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
