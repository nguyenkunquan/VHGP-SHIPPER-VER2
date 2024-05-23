import 'package:flutter/cupertino.dart';

class OrderEdgeModel {
  String? orderId;
  num? actionId;
  String? name;
  String? customerNote;
  String? orderNote;
  String? phone;
  String? serviceName;
  num? paymentType;
  num? total;
  num? shipCost;
  num? actionType;
  num? actionStatus;
  List? orderDetailActions;

  OrderEdgeModel(
      {this.orderId,
      this.actionId,
      this.name,
      this.paymentType,
      this.customerNote,
      this.orderNote,
      this.phone,
      this.serviceName,
      this.total,
      this.shipCost,
      this.actionStatus,
      this.orderDetailActions,
      this.actionType});

  factory OrderEdgeModel.fromJson(Map<String, dynamic> json) {
    return OrderEdgeModel(
      orderId: json['orderId'],
      actionId: json['actionId'],
      name: json['name'],
      customerNote: json['customerNote'],
      orderNote: json['orderNote'],
      phone: json['phone'],
      serviceName: json['serviceName'],
      paymentType: json['paymentType'],
      total: json['total'] != null ? json['total'] : 0,
      shipCost: json['shipCost'] ?? 0,
      actionType: json['actionType'],
      actionStatus: json['actionStatus'],
      orderDetailActions: json['orderDetailActions'],
    );
  }
}
