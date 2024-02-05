import 'package:flutter/cupertino.dart';

import 'TransactionModel.dart';

class TransactionListModel {
  String? date;
  String? fullDate;

  List<TransactionModel>? transactions;

  TransactionListModel({this.date, this.transactions, required this.fullDate});
}
