import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rx_splitter/constants/app_colors.dart';
import 'package:rx_splitter/controllers/authentication/registration_controller.dart';
import 'package:rx_splitter/utils/extensions/validation.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  RegistrationController registrationController =
      Get.put(RegistrationController());

  bool agree = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    listenToChanges();
    registrationController.name.clear();
    registrationController.email.clear();
    registrationController.password.clear();

  }

  void listenToChanges() {
    registrationController.name.addListener(() {
      registrationController.name.text;
    });
    registrationController.email.addListener(() {
      registrationController.email.text;
    });
    registrationController.password.addListener(() {
      registrationController.password.text;
    });
  }

  Future<void> registerUser() async {
    try {
      //_formKey.currentState?.reset();
      final nameText = registrationController.name.text;
      final email = registrationController.email.text;
      final password = registrationController.password.text;
      String responseString = await RegistrationController().registerUserApi(nameText, email, password);
      final splitted = responseString.split("-");
      Get.snackbar(splitted[0], splitted[1],
          snackPosition: SnackPosition.TOP,
          colorText: AppColors.white,
          backgroundColor: Colors.green);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 35, right: 35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'Sign up',
                          style:
                              TextStyle(color: AppColors.black, fontSize: 33),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: registrationController.name,
                              decoration: const InputDecoration(
                                labelText: "Full name",
                              ),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Name is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            TextFormField(
                              controller: registrationController.email,
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
                            const SizedBox(
                              height: 24,
                            ),
                            TextFormField(
                              controller: registrationController.password,
                              decoration: const InputDecoration(
                                labelText: "Password",
                              ),
                              obscureText: true,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Password cannot be empty';
                                } else if (!val.isValidPassword) {
                                  return 'Password should be of minimum six characters, at least one uppercase letter, one lowercase letter, one number and one special character';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                  visualDensity:
                                      const VisualDensity(horizontal: -4),
                                  //materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  value: agree,
                                  onChanged: (value) {
                                    setState(() {
                                      agree = value ?? false;
                                    });
                                  },
                                ),
                                const Expanded(
                                  child: Text(
                                    'I agree to Terms and Conditions',
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 8),
                            Center(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (agree) {
                                      if (_formKey.currentState!.validate()) {
                                        registerUser();
                                      }
                                    } else {
                                      return;
                                    }
                                    //agree ? form registerUser: null;
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: agree ? AppColors.kPrimary : Colors.grey,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 15.0,
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text(
                                      'Sign up',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
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
      ),
    );
  }
}
