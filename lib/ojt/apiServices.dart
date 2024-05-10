import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ansicolor/ansicolor.dart';
import 'dart:convert';

class ApiServices {
  static Future<void> sendLocation(double latitude, double longitude) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    AnsiPen pen = AnsiPen()..green(bold: true);
    print(pen('User ID: ${user!.email}'));
    print(pen('sendLocation function called'));
    print(pen('Sending location: $latitude, $longitude'));
    var url = Uri.parse('http://vhgp-api.vhgp.net/api/locations');
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
      throw Exception('Failed to update location');
    }
  }
  
  static Future<void> removeLocation() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    var url = Uri.parse('http://vhgp-api.vhgp.net/api/locations/${user!.email}');
    var response = await http.delete(url);
    if (response.statusCode != 200) {
      throw Exception('Failed to remove location');
    }
  }
}