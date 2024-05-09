import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:vhgp_deli/provider/appProvider.dart';
import './apiServices.dart'; // Assuming this is where your sendLocation function is defined

class MyApp extends StatefulWidget {
  @override
  final Widget child;
  const MyApp({super.key, required this.child});
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      if (Provider.of<AppProvider>(context, listen: false).isSwitched) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        await ApiServices.sendLocation(position.latitude, position.longitude);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Return your app's widget here
    return widget.child;
  }
}
