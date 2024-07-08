import 'dart:developer';

import 'package:app/app/data/api.dart';
import 'package:app/app/model/purchase.dart';
import 'package:app/app/page/purchase/purchase_item.dart';
import 'package:app/app/provider/token_manager.dart';
import 'package:flutter/material.dart';

class PurchaseHistory extends StatefulWidget {
  const PurchaseHistory({super.key});

  @override
  State<PurchaseHistory> createState() => _PurchaseHistoryState();
}

class _PurchaseHistoryState extends State<PurchaseHistory> {
  List<PurchaseHistoryModel> lst = [];
  APIRepository repo = APIRepository();
  Future<void>? future;
  getData() async {
    lst = await repo.getPurchaseHistory(await TokenManager.getToken());
  }

  @override
  void initState() {
    future = getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: lst.length,
            itemBuilder: (context, index) => PurchaseItem(model: lst[index]),
          );
        });
  }
}
