class RouteModel {
  String? orderId;
  String? routeId;
  String? firstEdge;
  String? lastEdge;
  num? edgeNum;
  num? orderNum;
  num? totalAdvance;
  num? totalCod;
  String? shipperId;
  num? status;
  // num? type;
  // int? orderActionStatus; // orderActionStatus of orderActionType 1 (shipper đang lấy hàng)

  RouteModel(
      {this.orderId,
      this.routeId,
      this.firstEdge,
      this.lastEdge,
      this.edgeNum,
      this.orderNum,
      this.totalAdvance,
      this.totalCod,
      this.shipperId,
      this.status,
      // this.type,
      // this.orderActionStatus
      });

  RouteModel.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    routeId = json['routeId'];
    firstEdge = json['firstEdge'];
    lastEdge = json['lastEdge'];
    edgeNum = json['edgeNum'];
    orderNum = json['orderNum'];
    totalAdvance = json['totalAdvance'];
    totalCod = json['totalCod'];
    shipperId = json['shipperId'];
    status = json['status'];
    // type = json['type'];
    // orderActionStatus = json['orderActionStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['orderId'] = orderId;
    data['routeId'] = routeId;
    data['firstEdge'] = firstEdge;
    data['lastEdge'] = lastEdge;
    data['edgeNum'] = edgeNum;
    data['orderNum'] = orderNum;
    data['totalAdvance'] = totalAdvance;
    data['totalCod'] = totalCod;
    data['shipperId'] = shipperId;
    data['status'] = status;
    // data['type'] = type;
    // data['orderActionStatus'] = orderActionStatus;
    return data;
  }

  static List<RouteModel> fromList(dynamic jsonList) {
    var list = jsonList as List;
    return list.map((map) => RouteModel.fromJson(map)).toList();
  }
}
