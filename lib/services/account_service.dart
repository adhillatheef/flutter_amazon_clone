// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_amazon_clone/constants/error_handling.dart';
import 'package:flutter_amazon_clone/constants/global_variables.dart';
import 'package:flutter_amazon_clone/constants/utils.dart';
import 'package:flutter_amazon_clone/model/order_model.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/user_provider.dart';
import '../screens/auth_screen.dart';

class AccountService {
  Future<List<Order>> fetchOrderProducts(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Order> ordersList = [];
    List<Order> ordersListFromJson(String jsonString) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => Order.fromMap(json)).toList();
    }

    try {
      http.Response response =
          await http.get(Uri.parse('$uri/api/orders/me'), headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "x-auth-token": userProvider.user.token,
      });

      debugPrint("Response ${response.body}");
      httpErrorHandling(
          response: response,
          context: context,
          onSuccess: () {
            debugPrint("Success");
            for (int i = 0; i < jsonDecode(response.body).length; i++) {
              ordersList = ordersListFromJson(response.body);
            }
            debugPrint("Product List $ordersList");
          });
    } catch (e) {
      debugPrint("Error ${e.toString()}");
      showSnackBar(context, e.toString());
    }
    return ordersList;
  }

  void logOut(BuildContext context) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setString('x-auth-token', '');
      Navigator.pushNamedAndRemoveUntil(
          context, AuthScreen.routeName, (route) => false);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
