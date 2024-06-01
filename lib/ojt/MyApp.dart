import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:vhgp_deli/provider/appProvider.dart';
import './apis/apiServices.dart'; // Assuming this is where your sendLocation function is defined
import 'package:background_location/background_location.dart';
import './globals.dart' as globals;
import './utils/reuseFunc.dart';

class MyApp extends StatefulWidget {
  @override
  final Widget child;
  const MyApp({super.key, required this.child});
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late Timer _timer;
  AppLifecycleState? _notification;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      print(
          'Is active: ${Provider.of<AppProvider>(context, listen: false).isSwitched}');
      if (_notification == AppLifecycleState.inactive ||
          _notification == AppLifecycleState.paused) {
        print('notification: $_notification');
        sendRedisLocationApi();
      } else {
        sendRedisLocationApi();
      }
    });
  }

  // void sendRedisLocationApi() {
  //   if (Provider.of<AppProvider>(context, listen: false).isSwitched) {
  //     print("uk thi anh chiu thua em rau");
  //     Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high) // Geolocator.getCurrentPosition function may not work when the app is in the background
  //         .then((Position position) {
  //       ApiServices2.sendLocation(position.latitude, position.longitude)
  //           .catchError((e) {
  //         print('Error sending location: $e');
  //       });
  //     }).catchError((e) {
  //       print('Error getting location: $e');
  //     });
  //   } else {
  //     ApiServices2.removeLocation().catchError((e) {
  //       print('Error removing location: $e');
  //     });
  //   }
  // }

  Timer? locationTimer;
  void sendRedisLocationApi() {
    print('Number of orders that are shipping: ${globals.shippingOrderCounter.toString()}');
    if (Provider.of<AppProvider>(context, listen: false).isSwitched) {
      ApiServices2.updateStatusShipper(0).catchError((e) {
          print('Error update status shipper: $e');
        });
      print("Applifecyclestate: $_notification");
      BackgroundLocation.startLocationService().then((value) {
        globals.isActive = true;
        locationTimer = Timer.periodic(Duration(seconds: 3), (timer) async {
          var location = await BackgroundLocation().getCurrentLocation();
          ApiServices2.sendLocation(location.latitude!, location.longitude!);
          ApiServices2.trackingDistance(
              getUserId(), location.latitude!, location.longitude!);
        });
      });
    } else {
      locationTimer?.cancel();
      BackgroundLocation.stopLocationService();

      if (globals.isActive == true) {
        ApiServices2.updateStatusShipper(3).catchError((e) {
          print('Error update status shipper: $e');
        });
        ApiServices2.removeLocation().catchError((e) {
          print('Error removing location: $e');
        });
        ApiServices2.stopTrackingDistance(getUserId());
        globals.isActive = false;
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Return your app's widget here
    return widget.child;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('AppLifecycleState: $state');

    // inactive: không dùng app nhưng chưa chuyển sang app khác
    // paused: đang ở app khác
    // hidden khá giống paused
    // resumed: quay lại app
    // detached: app bị kill

    _notification = state; // Update the state
    if (state == AppLifecycleState.detached) {
      print('Remove redis location');
      try {
        ApiServices2.removeLocation();
      } catch (e) {
        print('Error removing location: $e');
      }
    }
    // super.didChangeAppLifecycleState(state);

    // switch (state) {
    //   case AppLifecycleState.detached:
    //     print('Remove redis location');
    //     try {
    //       ApiServices2.removeLocation();
    //     } catch (e) {
    //       print('Error removing location: $e');
    //     }
    //     break;
    //   case AppLifecycleState.inactive:
    //   case AppLifecycleState.paused:
    //   case AppLifecycleState.hidden:
    //   case AppLifecycleState.resumed:
    // }
  }
}
