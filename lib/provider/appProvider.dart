import 'package:flutter/material.dart';

import '../models/DriverModel.dart';

class AppProvider with ChangeNotifier {
  String userId = "shipper1@gmail.com";
  String uid = "";
  String name = "";
  String avatar = "";
  late DriverModel driverModel = DriverModel();
  bool status = false;
  bool _isSwitched = false;

  void setStatus(String status) {
    status = status;
    notifyListeners();
  }

  void setDriverModel(DriverModel driver) {
    driverModel = driver;
    notifyListeners();
  }

  void setAvatar(img) {
    avatar = img;
    notifyListeners();
  }

  // void setIsLogout() {
  //   status = false;
  //   notifyListeners();
  // }

  void setUserLogin(id) {
    userId = id;
    notifyListeners();
  }

  void setUid(id) {
    uid = id;
    notifyListeners();
  }

  void setName(driverName) {
    name = driverName;
    notifyListeners();
  }

  void toogleSwitch(bool value) {
    _isSwitched = value;
    notifyListeners();
  }

  bool get getStatus => status;
  String get getUserId => userId;
  String get getAvatar => avatar;
  String get getUid => uid;
  String get getName => name;
  DriverModel get getDriverModel => driverModel;
  bool get isSwitched => _isSwitched;
}
