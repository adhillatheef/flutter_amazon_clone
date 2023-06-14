// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../constants/error_handling.dart';
import '../constants/global_variables.dart';
import '../constants/utils.dart';
import '../model/product_model.dart';
import '../providers/user_provider.dart';
import 'package:http/http.dart' as http;

class SearchService {
  Future<List<Product>> fetchSearchedProducts(
      {required BuildContext context, required String searchQuery}) async {
    final userProvider = Provider.of<UserProvider>(context,listen: false);
    List<Product> productList = [];
    List<Product> productListFromJson(String jsonString) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => Product.fromMap(json)).toList();
    }
    try {
      http.Response response = await http
          .get(Uri.parse('$uri/api/products/search/$searchQuery'), headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "x-auth-token": userProvider.user.token,
      });
      httpErrorHandling(
          response: response,
          context: context,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(response.body).length; i++) {
              // productList.add(Product.fromJson(jsonEncode(jsonDecode(response.body[i]))));
              productList = productListFromJson(response.body);
            }
          });
      debugPrint("Error search product: ${response.body}");
    } catch (e) {
      debugPrint("Error search product: ${e.toString()}");
      showSnackBar(context, e.toString());
    }
    return productList;
  }
}