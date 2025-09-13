import 'dart:convert';

import 'package:saatmenumobileapp/helper/utils/constants.dart';
import 'package:saatmenumobileapp/models/order_data.dart';
import 'package:http/http.dart' as http;
import 'package:saatmenumobileapp/models/request/header.dart';

class Ordering {
  static Future<OrderDataList> chefOrders(String endPoint) async {
    try {
      final response = await http.get(
        Uri.parse('${apiLink}chef/$endPoint'),
        headers: await Header.toQueryParams(),
      );
      if (response.statusCode == 200) {
        return OrderDataList.fromJson(jsonDecode(response.body));
      } else {
        return OrderDataList(orders: []);
      }
    } catch (e) {
      return OrderDataList(orders: []);
    }
  }
}