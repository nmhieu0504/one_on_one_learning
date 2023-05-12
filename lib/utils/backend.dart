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

  static const String REPORT_TUTOR = "$BASE_URL/report";
  static const String ADD_TO_FAVOURITE = "$BASE_URL/user/manageFavoriteTutor";
  static const String GET_REVIEWS = "$BASE_URL/feedback/v2/";
  static const String GET_TUTOR_SCHEDULE = "$BASE_URL/schedule?";

  static const String GET_SCHEDULE_INFO = "$BASE_URL/booking/list/student?";
  static const String DELETE_SCHEDULE = "$BASE_URL/booking/schedule-detail";
  static const String GET_NEXT_SCHEDULE = "$BASE_URL/booking/next?dateTime=";
  static const String GET_TOTAL_TIME_LEARN = "$BASE_URL/call/total";
  static const String BOOK_A_CLASS = "$BASE_URL/booking";

  static const String GET_COURSES_LIST = "$BASE_URL/course?page=1&size=100";
  static const String GET_COURSE_DETAIL = "$BASE_URL/course";
  static const String GET_COURSE_CATEGORY = "$BASE_URL/content-category";

  static const String USER_DETAIL_INFO = "$BASE_URL/user/info";

  static const String GET_PRICE_OF_SESSION= "$BASE_URL/payment/price-of-session";

}
