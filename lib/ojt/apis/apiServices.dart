import 'dart:ffi';

import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ansicolor/ansicolor.dart';
import 'dart:convert';
import '../utils/reuseFunc.dart';

import 'package:vhgp_deli/ojt/models/order_model.dart';

class ApiServices2 {
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
      throw Exception(
          'Failed to update location ${response.statusCode} ${response.body}');
    }
  }

  static Future<void> removeLocation() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    var url = Uri.parse(
        'http://vhgp-api.vhgp.net/api/Shipper/RemoveRedis/${user!.email}');
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

  static Future<void> createOrderDistance(String orderId) async {
    var url =
        Uri.parse('http://vhgp-api.vhgp.net/api/order-distances?$orderId');
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode != 200) {
      throw Exception(
          'Failed to create order distance ${response.statusCode} ${response.body}');
    }
  }

  static Future<void> saveDistanceTracker(
      String orderId, double latitude, double longitude) async {
    var url = Uri.parse(
        'http://vhgp-api.vhgp.net/api/order-distances/distance-tracker/$orderId');
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'latitude': '$latitude', 'longitude': '$longitude'}),
    );
    if (response.statusCode != 200) {
      throw Exception(
          'Failed to save distance tracker ${response.statusCode} ${response.body}');
    }
  }

  static Future<void> terminateOrderDistances(String orderId) async {
    var url =
        Uri.parse('http://vhgp-api.vhgp.net/api/order-distances/$orderId');
    var response = await http.patch(
      url,
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode != 200) {
      throw Exception(
          'Failed to terminate order distance ${response.statusCode} ${response.body}');
    }
  }

  static Future<void> trackingDistance(
      String shipperId, double latitude, double longitude) async {
    shipperId = Uri.encodeComponent(
        shipperId); // should be URL encoded if it contains special characters like @
    // var url = Uri.parse('https://192.168.1.180:7253/api/shipper-distances/tracking/$shipperId');
    // var url = Uri.parse('https://localhost:7253/api/shipper-distances/tracking/$shipperId');
    var url = Uri.parse(
        'http://vhgp-api.vhgp.net/api/shipper-distances/tracking/$shipperId');
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'latitude': '$latitude', 'longitude': '$longitude'}),
    );
    if (response.statusCode != 200) {
      throw Exception(
          'Failed to tracking distance ${response.statusCode} ${response.body}');
    }
  }

  static Future<void> stopTrackingDistance(String shipperId) async {
    shipperId = Uri.encodeComponent(shipperId);
    // var url = Uri.parse('https://192.168.1.180:7253/api/shipper-distances/stopping/$shipperId');
    var url = Uri.parse(
        'http://vhgp-api.vhgp.net/api/shipper-distances/stopping/$shipperId');
    var response = await http.patch(
      url,
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode != 200) {
      throw Exception(
          'Failed to stop tracking distance ${response.statusCode} ${response.body}');
    }
  }

  static Future<double> getTotalDistanceByDate(
      String shipperId, DateTime request) async {
    shipperId = Uri.encodeComponent(shipperId);
    String requestString = Uri.encodeComponent(request.toString());
    var url = Uri.parse(
        'http://vhgp-api.vhgp.net/api/shipper-distances/$shipperId?request=$requestString');
    print(url);
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode != 200) {
      throw Exception(
          'Failed to get total distance ${response.statusCode} ${response.body}');
    }
    return double.parse(response.body);
  }
}
