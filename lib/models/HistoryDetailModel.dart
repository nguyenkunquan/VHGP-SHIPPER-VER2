import 'package:flutter/cupertino.dart';

class HistoryDetailModel {
  String? orderId;
  String? start;
  String? startBuilding;
  String? end;
  String? endBuilding;
  String? phone;
  String? customerNote;
  String? orderNote;
  String? serviceName;
  num? total;
  num? shipCost;
  num? paymentType;
  List? orderDetails;

  HistoryDetailModel({
    this.orderId,
    this.start,
    this.startBuilding,
    this.end,
    this.endBuilding,
    this.serviceName,
    this.total,
    this.shipCost,
    this.phone,
    this.customerNote,
    this.orderNote,
    this.paymentType,
    this.orderDetails,
  });

  factory HistoryDetailModel.fromJson(Map<String, dynamic> json) {
    return HistoryDetailModel(
      orderId: json['orderId'],
      serviceName: json['serviceName'],
      shipCost: json['shippingCost'] ?? 0,
      start: json['start'],
      startBuilding: json['startBuilding'],
      end: json['end'],
      endBuilding: json['endBuilding'],
      phone: json['phone'],
      customerNote: json['customerNote'],
      orderNote: json['orderNote'],
      paymentType: json['paymentType'],
      orderDetails: json['orderDetails'],
      total: json['total'] != null ? json['total'] : 0,
    );
  }
}
