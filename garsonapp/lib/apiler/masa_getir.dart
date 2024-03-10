import 'package:garsonapp/sabitler/api_url.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class TableData {
  final int id;
  final int tableNumber;
  final bool status;
  final dynamic order;

  TableData({
    required this.id,
    required this.tableNumber,
    required this.status,
    required this.order,
  });

  factory TableData.fromJson(Map<String, dynamic> json) {
    return TableData(
      id: json['id'],
      tableNumber: json['tableNumber'],
      status: json['status'],
      order: json['order'],
    );
  }
}
