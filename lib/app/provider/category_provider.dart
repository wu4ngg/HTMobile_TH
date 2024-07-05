import 'package:app/app/data/api.dart';
import 'package:app/app/page/category/categorywidget.dart';
import 'package:flutter/material.dart';

class CategoryProvider extends ChangeNotifier {
  int _currentIndex = -1;
  final APIRepository _repo = APIRepository();
  List<CategoryModel> _lst = [];
  List<CategoryModel> get lst => _lst;
  int get currentIndex => _currentIndex;
  set lst(List<CategoryModel> v){
    lst = v;
    notifyListeners();
  }
  set currentIndex(int v) {
    _currentIndex = v;
    notifyListeners();
  }
  updateCategories(String token, String accID) async {
    var lastList = _lst;
    _lst = await _repo.getListCategory(accID, token);
    if(lastList.length < _lst.length){
      notifyListeners();
    }
  }
}