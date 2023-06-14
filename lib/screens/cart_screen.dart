import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/screens/search_screen.dart';
import 'package:flutter_amazon_clone/widgets/address_bar.dart';
import 'package:flutter_amazon_clone/widgets/cart_product.dart';
import 'package:flutter_amazon_clone/widgets/custom_button.dart';
import 'package:provider/provider.dart';

import '../constants/global_variables.dart';
import '../providers/user_provider.dart';
import '../widgets/cart_sub_total.dart';
import 'address_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  navigateToSearchScreen(String searchQuery) {
    Navigator.pushNamed(context, SearchScreen.routeName,
        arguments: searchQuery);
  }

  navigateToAddressScreen(int sum) {
    Navigator.pushNamed(context, AddressScreen.routeName, arguments: sum.toString());
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    int sum = 0;
    for (var e in user.cart) {
      final quantity = e['quantity'] as int?;
      final product = e['product'] as Map<String, dynamic>?;
      if (quantity != null && product != null && product['price'] != null) {
        sum += quantity * (product['price'] as int);
      }
    }
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  margin: const EdgeInsets.only(left: 15),
                  child: Material(
                    borderRadius: BorderRadius.circular(7),
                    elevation: 1,
                    child: TextFormField(
                      onFieldSubmitted: navigateToSearchScreen,
                      decoration: InputDecoration(
                          prefixIcon: InkWell(
                            onTap: () {},
                            child: const Padding(
                              padding: EdgeInsets.only(
                                left: 6,
                              ),
                              child: Icon(
                                Icons.search,
                                color: Colors.black,
                                size: 23,
                              ),
                            ),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: const EdgeInsets.only(top: 10),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            borderSide:
                                BorderSide(color: Colors.black38, width: 1),
                          ),
                          hintText: 'Search Amazon.in',
                          hintStyle: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                          )),
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.transparent,
                height: 42,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: const Icon(
                  Icons.mic,
                  color: Colors.black,
                  size: 25,
                ),
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AddressBar(),
            const SizedBox(
              height: 10,
            ),
            const CartSubTotal(),
            CustomButton(
              text: 'Proceed to Buy  ${user.cart.length} items',
              onTap:()=> navigateToAddressScreen(sum),
              color: Colors.yellow[600],
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              color: Colors.black12.withOpacity(0.08),
              height: 1,
            ),
            const SizedBox(
              height: 5,
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: user.cart.length,
                itemBuilder: (context, index) {
                  return CartProduct(index: index);
                })
          ],
        ),
      ),
    );
  }
}
