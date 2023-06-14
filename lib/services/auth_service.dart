// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/constants/error_handling.dart';
import 'package:flutter_amazon_clone/constants/global_variables.dart';
import 'package:flutter_amazon_clone/constants/utils.dart';
import 'package:flutter_amazon_clone/model/user_model.dart';
import 'package:flutter_amazon_clone/providers/user_provider.dart';
import 'package:flutter_amazon_clone/screens/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  void signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      User user = User(
        id: "",
        name: name,
        email: email,
        password: password,
        address: "",
        type: "",
        token: "",
        cart: [],
      );
      http.Response response = await http.post(
        Uri.parse('$uri/api/signup'),
        body: user.toJson(),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      httpErrorHandling(response: response, context: context, onSuccess: () {
        showSnackBar(context, "Account Created Login with the same credentials");
      });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //SignIn
  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse('$uri/api/signin'),
        body: json.encode({
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      debugPrint(response.body);


      httpErrorHandling(response: response, context: context, onSuccess: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        Provider.of<UserProvider>(context, listen: false).setUser(response.body);
        await prefs.setString('x-auth-token', jsonDecode(response.body)['token']);
        Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
        // showSnackBar(context, "Login Successful");
      });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //SignIn
  void getUserData(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');
      debugPrint("Token $token");

      if(token == null){
        prefs.setString('x-auth-token', '');
      }

      var tokenResponse = await http.post(Uri.parse('$uri/tokenIsValid'),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": token!,
        }
      );

      var response = jsonDecode(tokenResponse.body);
      debugPrint("Response $response");
      if(response == true){
        http.Response userResponse = await http.get(Uri.parse('$uri/'),
            headers: <String, String>{
              "Content-Type": "application/json; charset=UTF-8",
              "x-auth-token": token,
            }
        );

        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userResponse.body);
        debugPrint("User Details after Signing in ${userProvider.user}");
      }
    } catch (e) {
      debugPrint("Error message ${e.toString()}");
      showSnackBar(context, e.toString());
    }
  }
}
