import 'package:flutter/cupertino.dart';

class OrderCompleteModel {
  String? shipperId;
  num? actionType;
  String? image;

  OrderCompleteModel(
      {this.shipperId,
      this.actionType,
      this.image});

  factory OrderCompleteModel.fromJson(Map<String, dynamic> json) {
    return OrderCompleteModel(
      shipperId: json['shipperId'],
      actionType: json['actionType'],
      image: json['image'],
    );
  }
}