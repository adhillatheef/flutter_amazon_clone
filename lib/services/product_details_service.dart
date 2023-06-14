// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/constants/error_handling.dart';
import 'package:flutter_amazon_clone/constants/utils.dart';
import 'package:flutter_amazon_clone/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../constants/global_variables.dart';
import '../model/product_model.dart';
import 'package:http/http.dart' as http;

import '../model/user_model.dart';

class ProductDetailsService {
  // void rateProduct(
  //     {required BuildContext context,
  //     required Product product,
  //     required double rating}) async {
  //   final userProvider = Provider.of<UserProvider>(context, listen: false);
  //
  //   try {
  //     http.Response response =
  //         await http.post(Uri.parse('$uri/admin/rate'),
  //             headers: {
  //               "Content-Type": "application/json; charset=UTF-8",
  //               "x-auth-token": userProvider.user.token,
  //             },
  //             body: jsonEncode({
  //               'id': product.id,
  //               'rating': rating,
  //             }));
  //
  //     httpErrorHandling(response: response, context: context, onSuccess: () {});
  //   } catch (e) {
  //     showSnackBar(context, e.toString());
  //   }
  // }

  void rateProduct({
    required BuildContext context,
    required Product product,
    required double rating,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final response = await http.post(
        Uri.parse('$uri/api/products/rate/${product.id}'),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": userProvider.user.token,
        },
        body: jsonEncode({
          'userId': userProvider.user.id,
          'rating': rating,
        }),
      );

      if (response.statusCode == 200) {
        httpErrorHandling(
            response: response, context: context, onSuccess: () {});
      } else {
        // Rating failed
        // Handle the error by extracting the error message from the response
        final responseBody = jsonDecode(response.body);
        final errorMessage = responseBody['error'];
        showSnackBar(context, errorMessage);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //add to cart
  void addToCart({
    required BuildContext context,
    required Product product,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final response = await http.post(
        Uri.parse('$uri/api/add-to-cart'),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": userProvider.user.token,
        },
        body: jsonEncode({
          'userId': userProvider.user.id,
        }),
      );

      if (response.statusCode == 200) {
        httpErrorHandling(
            response: response,
            context: context,
            onSuccess: () {
              User user = userProvider.user
                  .copyWith(cart: jsonDecode(response.body)['cart']);
              userProvider.setUserFromModel(user);
            });
      } else {
        // Rating failed
        // Handle the error by extracting the error message from the response
        final responseBody = jsonDecode(response.body);
        final errorMessage = responseBody['error'];
        showSnackBar(context, errorMessage);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //remove from cart
  void removeFromCart({
    required BuildContext context,
    required Product product,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final response = await http.post(
        Uri.parse('$uri/api/remove-from-cart/${product.id}'),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": userProvider.user.token,
        },
        body: jsonEncode({
          'userId': userProvider.user.id,
        }),
      );

      if (response.statusCode == 200) {
        httpErrorHandling(
            response: response,
            context: context,
            onSuccess: () {
              User user = userProvider.user
                  .copyWith(cart: jsonDecode(response.body)['cart']);
              userProvider.setUserFromModel(user);
            });
      } else {
        // Rating failed
        // Handle the error by extracting the error message from the response
        final responseBody = jsonDecode(response.body);
        final errorMessage = responseBody['error'];
        showSnackBar(context, errorMessage);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
