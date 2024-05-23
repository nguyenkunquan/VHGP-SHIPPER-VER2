import 'dart:ffi';

class OrderModel{
  String? id;
  String? storeId;
  int? buildingId;
  String? serviceId;
  String? phoneNumber;
  double? shipCost;
  int? status;

  OrderModel({
    this.id,
    this.storeId,
    this.buildingId,
    this.serviceId,
    this.phoneNumber,
    this.shipCost,
    this.status,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json){
    return OrderModel(
      id: json['id'],
      storeId: json['storeId'],
      buildingId: json['buildingId'],
      serviceId: json['serviceId'],
      phoneNumber: json['phoneNumber'],
      shipCost: (json['shipCost'] is int) ? (json['shipCost'] as int).toDouble() : json['shipCost'], // Ensure shipCost is a double
      status: json['status'],
    );
  }

  @override
  String toString() {
    return 'OrderModel{id: $id, storeId: $storeId, buildingId: $buildingId, serviceId: $serviceId, phoneNumber: $phoneNumber, shipCost: $shipCost, status: $status}';
  }

}