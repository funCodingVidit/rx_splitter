import 'package:rx_splitter/utils/preferences.dart';

class ApiConstant {
  static Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Authorization': 'Bearer ${PreferencesUtils().getToken()}'
  };

  static const _baseUrl = "https://rxsplitterapis.azurewebsites.net/api"; //10.0.2.2 vidha.jangid.radixusers3.com
  static const _versionOneUrl = _baseUrl + VersionKeys.versionOne;
  static const createUserApi = "$_versionOneUrl/UserDetail/CreateUser";
  static const loginApi = "$_versionOneUrl/Authentication/login";
  static const forgotPasswordApi = "$_versionOneUrl/Authentication/ForgotPassword";
  static const createGroupApi = "$_versionOneUrl/Group/CreateGroup";
  static const getGroupsByIdApi = "$_versionOneUrl/Group/GetAllGroupsOfUser";
  //https://rxchatapis.azurewebsites.net/api/v1/Group/GetGroupById
  //https://https://rxsplitterapis.azurewebsites.net/api/v1/%22
}

class VersionKeys {
  static const String versionOne = "/v1";
}