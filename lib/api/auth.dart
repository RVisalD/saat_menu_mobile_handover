import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:saatmenumobileapp/helper/preferences.dart';
import 'package:saatmenumobileapp/helper/utils/constants.dart';
import '../models/auth.dart';

class AuthService {
  static Future<Auth?> login(String contact, String password) async {
    Map<String, dynamic> data = {
      "contact": contact,
      "password": password,
    };

    try {
      final response = await http.post(
        Uri.parse('${apiLink}staff/login'),
        body: data,
      );

      var responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Auth authResponse = Auth.fromJson(responseBody);

          await AppPreferences.saveUserData(authResponse.staff);
          await AppPreferences.saveUserToken(authResponse.token ?? '');
        // }

        return authResponse;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<void> logout() async {
    String token = await AppPreferences.getUserToken() ?? '';
    try {
      final response = await http.post(
        Uri.parse('${apiLink}staff/logout'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        await AppPreferences.clearUserData();
        await AppPreferences.clearUserToken();
      }
    } catch (e) {
      await AppPreferences.clearUserData();
      await AppPreferences.clearUserToken();
    }
  }
}
