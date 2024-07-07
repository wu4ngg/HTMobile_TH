import 'dart:convert';
import 'dart:developer';

import 'package:app/app/model/product.dart';
import 'package:app/app/model/register.dart';
import 'package:app/app/model/user.dart';
import 'package:app/app/page/category/categorywidget.dart';
import 'package:dio/dio.dart';

class API {
  final Dio _dio = Dio();
  String baseUrl = "https://huflit.id.vn:4321";

  API() {
    _dio.options.baseUrl = "$baseUrl/api";
  }

  Dio get sendRequest => _dio;
}

class APIRepository {
  API api = API();

  Map<String, dynamic> header(String token) {
    return {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*',
      'Authorization': 'Bearer $token'
    };
  }

  Future<String> register(Signup user) async {
    try {
      final body = FormData.fromMap({
        "numberID": user.numberID,
        "accountID": user.accountID,
        "fullName": user.fullName,
        "phoneNumber": user.phoneNumber,
        "imageURL": user.imageUrl,
        "birthDay": user.birthDay,
        "gender": user.gender,
        "schoolYear": user.schoolYear,
        "schoolKey": user.schoolKey,
        "password": user.password,
        "confirmPassword": user.confirmPassword
      });
      Response res = await api.sendRequest.post('/Student/signUp',
          options: Options(headers: header('no token')), data: body);
      if (res.statusCode == 200) {
        print("ok");
        return "ok";
      } else {
        print("fail");
        return "signup fail";
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<List<ProductModel>> getProductsByCateid(
      String accountID, int id, String token) async {
    try {
      List<ProductModel> lst = [];
      Response res = await api.sendRequest.get('/Product/getListByCatId',
          options: Options(headers: header(token)),
          queryParameters: {"accountID": accountID, "categoryID": id});
      var data = res.data;
      for (var element in data) {
        lst.add(ProductModel.fromJson(element));
      }
      return lst;
    } catch (e) {
      return [];
    }
  }

  Future<List<CategoryModel>> getListCategory(
      String accountID, String token) async {
    try {
      List<CategoryModel> lst = [];
      Response res = await api.sendRequest.get('/Category/getList',
          options: Options(headers: header(token)),
          queryParameters: {"accountID": accountID});
      var data = res.data;
      for (var element in data) {
        lst.add(CategoryModel.fromJson(jsonEncode(element)));
      }
      return lst;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ProductModel>> getListProduct(
      String accountID, String token) async {
    try {
      List<ProductModel> tmp = [];
      Response res = await api.sendRequest.get('/Product/getList',
          options: Options(headers: header(token)),
          queryParameters: {"accountID": accountID});
      var data = res.data;
      for (var element in data) {
        tmp.add(ProductModel.fromJson(element));
      }
      return tmp;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> login(String accountID, String password) async {
    try {
      final body =
          FormData.fromMap({'AccountID': accountID, 'Password': password});
      Response res = await api.sendRequest.post('/Auth/login',
          options: Options(headers: header('no token')), data: body);
      if (res.statusCode == 200) {
        final tokenData = res.data['data']['token'];
        print("ok login");
        return tokenData;
      } else {
        return "login fail";
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<bool> forgetPassword(
      String accountID, String numberID, String newPass) async {
    try {
      final body = FormData.fromMap(
          {'accountID': accountID, 'numberID': numberID, 'newPass': newPass});
      Response res = await api.sendRequest.put('/Auth/forgetPass', data: body);
      return res.statusCode == 200;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<User> current(String token) async {
    try {
      Response res = await api.sendRequest
          .get('/Auth/current', options: Options(headers: header(token)));
      return User.fromJson(res.data);
    } catch (ex) {
      rethrow;
    }
  }

  Future<bool> uploadProduct(ProductModel prod, String token) async {
    try {
      final body = FormData.fromMap(prod.toMap());
      Response res = await api.sendRequest.post('/addProduct',
          data: body, options: Options(headers: header(token)));
      return res.statusCode == 200;
    } catch (ex) {
      log(ex.toString());
      rethrow;
    }
  }
}
