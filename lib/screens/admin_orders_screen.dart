import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/screens/order_details_screen.dart';
import 'package:flutter_amazon_clone/services/admin_service.dart';
import 'package:flutter_amazon_clone/widgets/loader.dart';
import 'package:flutter_amazon_clone/widgets/product_widget.dart';

import '../model/order_model.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({Key? key}) : super(key: key);

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  List<Order>? orders;
  final AdminService adminService = AdminService();

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  fetchOrders() async {
    orders = await adminService.fetchAllOrders(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return orders == null
        ? const Loader()
        : GridView.builder(
            itemCount: orders!.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemBuilder: (context, index) {
              final orderData = orders![index];
              return GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, OrderDetailsScreen.routeName,arguments: orderData);
                },
                child: SizedBox(
                  height: 140,
                  child: ProductWidget(image: orderData.products[0].images[0]),
                ),
              );
            });
  }
}
