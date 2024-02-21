// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'package:vhgp_deli/local_notifications.dart';

import 'Colors/color.dart';
import 'Json/constrain.dart';
import 'apis/apiServices.dart';
import 'firebase_options.dart';
import 'models/DriverModel.dart';
import 'pages/app.dart';
import 'pages/login_screen.dart';
import 'provider/appProvider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotifications.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await FirebaseMessaging.instance.setAutoInitEnabled(true);
  // await FirebaseMessaging.instance.requestPermission(
  //   alert: true,
  //   announcement: false,
  //   badge: true,
  //   carPlay: false,
  //   criticalAlert: false,
  //   provisional: false,
  //   sound: true,
  // );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AppProvider()),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      //theme: kDarkTheme,
      theme: kLightTheme,

      home: LandingScreen(),
      //home: OrderPage(),
    ),
  ));
}

class LandingScreen extends StatelessWidget {
  FirebaseAuth auth = FirebaseAuth.instance;
  checkUserAuth() async {
    try {
      User user = auth.currentUser!;
      return user;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    checkUserAuth().then((success) {
      if (success != null) {
        context.read<AppProvider>().setUserLogin(success.email);
        context.read<AppProvider>().setUid(success.uid);
        DriverModel driverModel = DriverModel();
        print("ok");
        ApiServices.getDriver(success.email)
            .then((value) => {
                  driverModel = value,
                  context.read<AppProvider>().setName(driverModel.fullName),
                  context.read<AppProvider>().setAvatar(driverModel.image),
                  context.read<AppProvider>().setDriverModel(driverModel),
                  context.read<AppProvider>().setStatus(driverModel.status!),

                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RootApp()))
                  // context.read<AppProvider>().setName(store.name)
                })
            .catchError((onError) => {print(onError)});
      } else {
        print("login");
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    });

    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(color: MaterialColors.primary),
      ),
    );
  }
}
