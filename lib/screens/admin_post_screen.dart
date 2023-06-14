import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/screens/admin_addProduct_screen.dart';
import 'package:flutter_amazon_clone/services/admin_service.dart';
import 'package:flutter_amazon_clone/widgets/loader.dart';
import 'package:flutter_amazon_clone/widgets/product_widget.dart';

import '../model/product_model.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({Key? key}) : super(key: key);

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  List<Product>? products;
  final AdminService adminService = AdminService();

  @override
  void initState() {
    super.initState();
    fetchAllProducts();
  }

  fetchAllProducts() async {
    products = await adminService.fetchAllProducts(context);
    setState(() {});
  }

  deleteProduct(Product product, int index) async {
    adminService.deleteProduct(context: context, product: product, onSuccess: (){
      products!.removeAt(index);
      setState(() {});
    });
  }

  navigateToAddProductScreen() {
    Navigator.pushNamed(context, AddProductScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        tooltip: "Add a Product",
        onPressed: navigateToAddProductScreen,
        child: const Icon(Icons.add),
      ),
      body: products == null
          ? const Loader()
          : GridView.builder(
              itemCount: products!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context, index) {
                final productData = products![index];
                return Column(
                  children: [
                    SizedBox(
                      height: 140,
                      child: ProductWidget(image: productData.images[0]),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          productData.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        )),
                        IconButton(
                            onPressed: () => deleteProduct(productData, index),
                            icon: const Icon(Icons.delete_outline))
                      ],
                    )
                  ],
                );
              }),
    );
  }
}
