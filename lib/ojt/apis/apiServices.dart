import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ansicolor/ansicolor.dart';
import 'dart:convert';

import 'package:vhgp_deli/ojt/models/order_model.dart';

class ApiServices2{
  
  static Future<void> sendLocation(double latitude, double longitude) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    AnsiPen pen = AnsiPen()..green(bold: true);
    print(pen('User ID: ${user!.email}'));
    print(pen('sendLocation function called'));
    print(pen('Sending location: $latitude, $longitude'));
    var url = Uri.parse('http://vhgp-api.vhgp.net/api/Shipper/AddRedis');
    var response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      'id': user.email,
      'latitude': '$latitude',
      'longitude': '$longitude'
    }),
  );
    if (response.statusCode != 200) {
      throw Exception('Failed to update location ${response.statusCode} ${response.body}');
    }
  }
  
  static Future<void> removeLocation() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    var url = Uri.parse('http://vhgp-api.vhgp.net/api/Shipper/RemoveRedis/${user!.email}');
    var response = await http.delete(url);
    print(response);
    if (response.statusCode != 200) {
      throw Exception('Failed to remove location');
    }
  }

  static Future<List<OrderModel>> getOrders() async {
    final uri = Uri.parse('https://664ace75a300e8795d42fe60.mockapi.io/order');
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Failed to get orders');
    }
    List<OrderModel> orders = [];
    final bodyContent = utf8.decode(response.bodyBytes);
    var orderList = jsonDecode(bodyContent) as List;
    orders = orderList.map((order) => OrderModel.fromJson(order)).toList();
    return orders;
}

}