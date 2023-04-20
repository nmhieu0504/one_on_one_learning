// ignore_for_file: constant_identifier_names, camel_case_types

class API_URL {
  static const String BASE_URL = "https://sandbox.api.lettutor.com";

  static const String LOGIN = "$BASE_URL/auth/login";
  static const String REGISTER = "$BASE_URL/auth/register";
  static const String FORGET_PASSWORD = "$BASE_URL/user/forgotPassword";
  static const String REFRESH_TOKEN = "$BASE_URL/auth/refresh-token";

  static const String GET_TUTOR_LIST = "$BASE_URL/tutor/more?perPage=10&page=";
  static const String GET_TUTOR_DETAIL = "$BASE_URL/tutor/";
  static const String SEARCH_TUTOR = "$BASE_URL/tutor/search";
}
