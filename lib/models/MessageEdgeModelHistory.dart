import 'package:flutter/cupertino.dart';

class MessageEdgeModelHistory {
  String? statusCode;
  dynamic data;

  MessageEdgeModelHistory({this.statusCode, this.data});

  factory MessageEdgeModelHistory.fromJson(Map<String, dynamic> json) {
    return MessageEdgeModelHistory(
      statusCode: json['statusCode'],
      data: json['data'],
    );
  }
}
