import 'dart:convert';
import 'package:saatmenumobileapp/models/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static Future<void> init() async {
  }

  // Fixed saveUserData method
  static Future<bool> saveUserData(Staff? staffData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      if (staffData != null) {
        String jsonString = jsonEncode(staffData.toJson());
        bool result = await prefs.setString('userData', jsonString);
        return result;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // Fixed getUserData method
  static Future<Auth> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? jsonString = prefs.getString('userData');
      if (jsonString != null && jsonString.isNotEmpty) {
        Map<String, dynamic> staffJson = jsonDecode(jsonString);
        Staff staff = Staff.fromJson(staffJson);
        
        Auth auth = Auth(staff: staff, token: await getUserToken());
        return auth;
      }
    } catch (e) {
      return Auth(staff: null, token: null);
    }

    return Auth(staff: null, token: null);
  }

  static Future<bool> clearUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove('userData');
    } catch (e) {
      return false;
    }
  }

  static Future<bool> saveUserToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      bool result = await prefs.setString('userToken', token);
      return result;
    } catch (e) {
      return false;
    }
  }

  static Future<String?> getUserToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('userToken');
      return token;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> clearUserToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove('userToken');
    } catch (e) {
      return false;
    }
  }
}