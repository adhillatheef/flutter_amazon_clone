import 'package:flutter/cupertino.dart';
import 'package:flutter_amazon_clone/constants/global_variables.dart';
import 'package:flutter_amazon_clone/screens/order_details_screen.dart';
import 'package:flutter_amazon_clone/services/account_service.dart';
import 'package:flutter_amazon_clone/widgets/product_widget.dart';

import '../model/order_model.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List<Order>? orders;
  final AccountService accountService = AccountService();

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  fetchProducts() async {
    orders = await accountService.fetchOrderProducts(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 15),
              child: const Text(
                'Your Orders',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 15),
              child: Text(
                'See All',
                style: TextStyle(
                  color: GlobalVariables.selectedNavBarColor,
                ),
              ),
            ),
          ],
        ),
        //Display the orders here
        Container(
          height: 170,
          padding: const EdgeInsets.only(left: 10, right: 0, top: 20),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: orders!.length,
              itemBuilder: ((context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, OrderDetailsScreen.routeName,
                        arguments: orders![index]);
                  },
                  child: ProductWidget(
                    image: orders![index].products[0].images[0],
                  ),
                );
              })),
        )
      ],
    );
  }
}
