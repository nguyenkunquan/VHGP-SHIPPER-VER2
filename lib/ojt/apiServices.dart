

import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ansicolor/ansicolor.dart';

class ApiServices {
  static Future<void> sendLocation(double latitude, double longitude) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    AnsiPen pen = AnsiPen()..green(bold: true);
    print(pen('User ID: ${user!.email}'));
    print(pen('sendLocation function called'));
    print(pen('Sending location: $latitude, $longitude'));
    var url = Uri.parse('https://6627df44b625bf088c0a1d2b.mockapi.io/location/${user.email ?? 'default'}');
    var response = await http.put(url, body: {
      'id': user.email,
      'coordinates': '$latitude,$longitude',
    });

    if (response.statusCode != 200) {
      throw Exception('Failed to update location');
    }
  }
}