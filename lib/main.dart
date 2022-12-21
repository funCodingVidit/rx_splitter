import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rx_splitter/ui/screens/groups/display_groups.dart';
import 'package:rx_splitter/ui/screens/login/login_screen.dart';
import 'package:rx_splitter/utils/preferences.dart';

void main() {
  runApp(const RxSplitterApp());
}

class RxSplitterApp extends StatelessWidget {
  const RxSplitterApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    bool? isLoggedIn;
    isLoggedIn = PreferencesUtils().getIsLogged() ?? false;
    return GetMaterialApp(
      title: 'RxSplitter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isLoggedIn ? const DisplayGroupsScreen() : const LoginScreen(),
    );
  }
}
