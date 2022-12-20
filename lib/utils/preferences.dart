import 'package:get_storage/get_storage.dart';

class Keys {
  static const String authToken = "authToken";
  static const String isLoggedIn = "isLoggedIn";
}

class PreferencesUtils {
  final storage = GetStorage();

  void setToken(String token) {
    storage.write(Keys.authToken, token);
  }

  String getToken() {
    final jwtToken = storage.read(Keys.authToken);
    return jwtToken;
  }

  void setIsLogged(bool value) {
    storage.write(Keys.isLoggedIn, value);
  }

  bool? getIsLogged() {
    final isLoggedIn = storage.read(Keys.isLoggedIn);
    return isLoggedIn;
  }
}
