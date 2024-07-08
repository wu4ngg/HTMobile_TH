import 'package:app/app/page/purchase_history.dart';

class PurchaseHistoryModel {
  String? id;
  String fullName;
  String dateCreated;
  int total;
  PurchaseHistoryModel(
      {this.id,
      required this.fullName,
      required this.dateCreated,
      required this.total});
  factory PurchaseHistoryModel.fromJson(Map<String, dynamic> json) {
    return PurchaseHistoryModel(
        id: json["id"] ?? "",
        fullName: json["fullName"] ?? "",
        dateCreated: json["dateCreated"] ?? "",
        total: json["total"] ?? 0);
  }
}
