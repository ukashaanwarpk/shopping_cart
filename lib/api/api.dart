import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../model/auth_model.dart';
import '../model/product_model.dart';

class ApiController extends ChangeNotifier {
  List<ProductModel> productList = [];
  Future<List<ProductModel>> getProduct() async {
    try {
      final response =
          await http.get(Uri.parse('https://fakestoreapi.com/products'));
      final jsonData = jsonDecode(response.body.toString());

      if (response.statusCode == 200) {
        productList.clear();
        for (Map i in jsonData) {
          productList.add(ProductModel.fromJson(i));
        }

        return productList;
      } else {
        if (kDebugMode) {
          print('Failed to load products: ${response.statusCode}');
        }
        return productList;
      }
    } catch (e) {
      if (kDebugMode) {
        print('The error in getProduct Api method $e');
      }
      rethrow;
    }
  }

  Future<dynamic> postApi(String username, String password) async {
    final response = await http.post(
      Uri.parse('https://dummyjson.com/auth/login'),
      body: {'username': username, 'password': password},
    );

    if (response.statusCode == 200) {
      return AuthModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

   List<ProductModel> filterItem = [];
  final searchController = TextEditingController();



  void onSearch() {

    List<ProductModel> newList = [];
    newList.addAll(productList);
    if (searchController.text.isNotEmpty) {
      newList.retainWhere((element) {
        String searchTerm = searchController.text.toLowerCase();
        String name = element.title.toString().toLowerCase();
          return name.contains(searchTerm);

      });
      filterItem = newList;
    } else {
      filterItem = productList;
    }

    notifyListeners();
  }





}
