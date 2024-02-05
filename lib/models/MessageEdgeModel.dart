import 'package:flutter/cupertino.dart';

class MessageEdgeModel {
  String? statusCode;
  List? data;

  MessageEdgeModel({this.statusCode, this.data});

  factory MessageEdgeModel.fromJson(Map<String, dynamic> json) {
    return MessageEdgeModel(
      statusCode: json['statusCode'],
      data: json['data'] ?? [],
    );
  }
}
