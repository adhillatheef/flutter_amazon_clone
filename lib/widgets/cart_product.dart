// import 'package:flutter/material.dart';
// import 'package:flutter_amazon_clone/model/product_model.dart';
// import 'package:flutter_amazon_clone/services/product_details_service.dart';
// import 'package:provider/provider.dart';
//
// import '../providers/user_provider.dart';
//
// class CartProduct extends StatefulWidget {
//   final int index;
//
//   const CartProduct({Key? key, required this.index}) : super(key: key);
//
//   @override
//   State<CartProduct> createState() => _CartProductState();
// }
//
// class _CartProductState extends State<CartProduct> {
//   final ProductDetailsService productDetailsService = ProductDetailsService();
//
//   increaseQuantity(Product product){
//     productDetailsService.addToCart(context: context, product: product);
//   }
//   decreaseQuantity(Product product){
//     productDetailsService.addToCart(context: context, product: product);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     int quantity = 0;
//     final productCart = Provider.of<UserProvider>(context, listen: false).user.cart[widget.index];
//     // final productCart = context.watch<UserProvider>().user.cart[widget.index];
//     final product = Product.fromMap(productCart['product']);
//     if (productCart != null) {
//       quantity = productCart['quantity']; // or any other appropriate fallback widget
//     }
//
//
//     return Column(
//       children: [
//         Container(
//           margin: const EdgeInsets.symmetric(horizontal: 10),
//           child: Row(
//             children: [
//               Image.network(
//                 product.images[0],
//                 fit: BoxFit.contain,
//                 height: 135,
//                 width: 135,
//               ),
//               Column(
//                 children: [
//                   Container(
//                     width: 235,
//                     padding: const EdgeInsets.symmetric(horizontal: 10),
//                     child: Text(
//                       product.name,
//                       style: const TextStyle(fontSize: 16),
//                       maxLines: 2,
//                     ),
//                   ),
//                   Container(
//                     width: 235,
//                     padding: const EdgeInsets.only(left: 10, top: 5),
//                     child: Text(
//                       "\$ ${product.price}",
//                       style: const TextStyle(
//                           fontSize: 20, fontWeight: FontWeight.bold),
//                       maxLines: 2,
//                     ),
//                   ),
//                   Container(
//                     width: 235,
//                     padding: const EdgeInsets.only(
//                       left: 10,
//                     ),
//                     child: const Text(
//                       "Eligible for free shipping",
//                     ),
//                   ),
//                   Container(
//                     width: 235,
//                     padding: const EdgeInsets.only(
//                       left: 10,
//                     ),
//                     child: const Text(
//                       "In stock",
//                       style: TextStyle(color: Colors.teal),
//                       maxLines: 2,
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ),
//         Container(
//           margin: const EdgeInsets.all(10),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     color: Colors.black12,
//                     width: 1.5,
//                   ),
//                   borderRadius: BorderRadius.circular(5),
//                   color: Colors.black12,
//                 ),
//                 child: Row(
//                   children: [
//                     InkWell(
//                       onTap: () => decreaseQuantity(product),
//                       child: Container(
//                         width: 35,
//                         height: 32,
//                         alignment: Alignment.center,
//                         child: const Icon(
//                           Icons.remove,
//                           size: 18,
//                         ),
//                       ),
//                     ),
//                     DecoratedBox(
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.black12, width: 1.5),
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(0),
//                       ),
//                       child: Container(
//                         width: 35,
//                         height: 32,
//                         alignment: Alignment.center,
//                         child: Text(quantity.toString()),
//                       ),
//                     ),
//                     InkWell(
//                       onTap:()=> increaseQuantity(product),
//                       child: Container(
//                         width: 35,
//                         height: 32,
//                         alignment: Alignment.center,
//                         child: const Icon(
//                           Icons.add,
//                           size: 18,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         )
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/model/product_model.dart';
import 'package:flutter_amazon_clone/services/product_details_service.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class CartProduct extends StatefulWidget {
  final int index;

  const CartProduct({Key? key, required this.index}) : super(key: key);

  @override
  State<CartProduct> createState() => _CartProductState();
}

class _CartProductState extends State<CartProduct> {
  final ProductDetailsService productDetailsService = ProductDetailsService();

  void increaseQuantity(Product product) {
    productDetailsService.addToCart(context: context, product: product);
  }

  void decreaseQuantity(Product product) {
    productDetailsService.addToCart(context: context, product: product);
  }

  @override
  Widget build(BuildContext context) {
    int quantity = 0;
    final productCart =
    Provider.of<UserProvider>(context).user.cart[widget.index];
    final product = productCart != null
        ? Product.fromMap(productCart['product'])
        : null;
    if (productCart != null) {
      quantity = productCart['quantity'];
    }

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Image.network(
                product?.images[0] ?? '',
                fit: BoxFit.contain,
                height: 135,
                width: 135,
              ),
              Column(
                children: [
                  Container(
                    width: 235,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      product?.name ?? '',
                      style: const TextStyle(fontSize: 16),
                      maxLines: 2,
                    ),
                  ),
                  Container(
                    width: 235,
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    child: Text(
                      "\$ ${product?.price ?? ''}",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                      maxLines: 2,
                    ),
                  ),
                  Container(
                    width: 235,
                    padding: const EdgeInsets.only(
                      left: 10,
                    ),
                    child: const Text(
                      "Eligible for free shipping",
                    ),
                  ),
                  Container(
                    width: 235,
                    padding: const EdgeInsets.only(
                      left: 10,
                    ),
                    child: const Text(
                      "In stock",
                      style: TextStyle(color: Colors.teal),
                      maxLines: 2,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.black12,
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => decreaseQuantity(product!),
                      child: Container(
                        width: 35,
                        height: 32,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.remove,
                          size: 18,
                        ),
                      ),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12, width: 1.5),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: Container(
                        width: 35,
                        height: 32,
                        alignment: Alignment.center,
                        child: Text(quantity.toString()),
                      ),
                    ),
                    InkWell(
                      onTap: () => increaseQuantity(product!),
                      child: Container(
                        width: 35,
                        height: 32,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.add,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
