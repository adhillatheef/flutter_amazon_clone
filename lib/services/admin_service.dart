// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_amazon_clone/constants/error_handling.dart';
import 'package:flutter_amazon_clone/constants/global_variables.dart';
import 'package:flutter_amazon_clone/constants/utils.dart';
import 'package:flutter_amazon_clone/model/order_model.dart';
import 'package:flutter_amazon_clone/model/product_model.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../model/sales_model.dart';
import '../providers/user_provider.dart';

class AdminService {
  sellProducts({
    required BuildContext context,
    required String name,
    required String description,
    required double price,
    required double quantity,
    required String category,
    required List<File> images,
  }) async {
    try {
      var userProvider = Provider.of<UserProvider>(context, listen: false);

      final cloudinary = CloudinaryPublic('dij0utuar', 'q2vqbigy');
      List<String> imageUrls = [];
      for (int i = 0; i < images.length; i++) {
        CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(images[i].path, folder: name),
        );
        imageUrls.add(response.secureUrl);
      }

      Product product = Product(
          name: name,
          description: description,
          quantity: quantity,
          images: imageUrls,
          category: category,
          price: price);

      http.Response response = await http.post(
        Uri.parse('$uri/admin/add-product'),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": userProvider.user.token,
        },
        body: product.toJson(),
      );

      httpErrorHandling(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Product Added successfully');
            Navigator.pop(context);
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //get all products
  Future<List<Product>> fetchAllProducts(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    List<Product> productListFromJson(String jsonString) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => Product.fromMap(json)).toList();
    }
    try {
      http.Response response =
          await http.get(Uri.parse('$uri/admin/get-products'), headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "x-auth-token": userProvider.user.token,
      });

      debugPrint("Response ${response.body}");
      httpErrorHandling(
          response: response,
          context: context,
          onSuccess: () {
            debugPrint("Success");
            //TODO Mistake is here rectify it tomorrow...
            for (int i = 0; i < jsonDecode(response.body).length; i++) {
              // productList.add(Product.fromJson(jsonEncode(jsonDecode(response.body[i]))));
              // productList.add(Product.fromJson(response.body));
              productList = productListFromJson(response.body);
            }
            debugPrint("Product List $productList");
          });
    } catch (e) {
      debugPrint("Error ${e.toString()}");
      showSnackBar(context, e.toString());
    }
    return productList;
  }

  //Delete Product
  void deleteProduct({
    required BuildContext context,
    required Product product,
    required VoidCallback onSuccess,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('$uri/admin/delete-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': product.id,
        }),
      );

      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () {
          onSuccess();
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //get all orders
  Future<List<Order>> fetchAllOrders(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Order> orderList = [];
    List<Order> orderListFromJson(String jsonString) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => Order.fromMap(json)).toList();
    }
    try {
      http.Response response =
      await http.get(Uri.parse('$uri/admin/get-orders'), headers: {
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
              orderList = orderListFromJson(response.body);
            }
            debugPrint("Product List $orderList");
          });
    } catch (e) {
      debugPrint("Error ${e.toString()}");
      showSnackBar(context, e.toString());
    }
    return orderList;
  }

  //change order status
  void changeOrderStatus({
    required BuildContext context,
    required int status,
    required Order order,
    required VoidCallback onSuccess,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('$uri/admin/change-order-status'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': order.id,
          'status': status,
        }),
      );

      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () {
          onSuccess();
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }


  Future<Map<String, dynamic>> getEarnings(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Sales> sales = [];
    int totalEarning = 0;
    try {
      http.Response res =
      await http.get(Uri.parse('$uri/admin/analytics'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () {
          var response = jsonDecode(res.body);
          totalEarning = response['totalEarnings'];
          sales = [
            Sales('Mobiles', response['mobileEarnings']),
            Sales('Essentials', response['essentialEarnings']),
            Sales('Books', response['booksEarnings']),
            Sales('Appliances', response['applianceEarnings']),
            Sales('Fashion', response['fashionEarnings']),
          ];
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return {
      'sales': sales,
      'totalEarnings': totalEarning,
    };
  }

}
