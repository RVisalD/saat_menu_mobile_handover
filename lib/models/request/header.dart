import 'package:saatmenumobileapp/helper/preferences.dart';

class Header {
  static Future<Map<String, String>> toQueryParams() async {
    String token = await AppPreferences.getUserToken() ?? '';
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
}