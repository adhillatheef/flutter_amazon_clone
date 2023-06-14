// import 'package:flutter/cupertino.dart';
// import 'package:flutter_amazon_clone/providers/user_provider.dart';
// import 'package:provider/provider.dart';
//
// class CartSubTotal extends StatelessWidget {
//   const CartSubTotal({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final user = context.watch<UserProvider>().user;
//     int sum = 0;
//     user.cart
//         .map((e) => sum += e['quantity'] * e['product']['price'] as int)
//         .toList();
//     return Container(
//       margin: const EdgeInsets.all(10),
//       child: Row(
//         children: [
//           const Text(
//             'SubTotal',
//             style: TextStyle(
//               fontSize: 20,
//             ),
//           ),
//           Text(
//             '\$$sum',
//             style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           )
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter_amazon_clone/providers/user_provider.dart';
import 'package:provider/provider.dart';

class CartSubTotal extends StatelessWidget {
  const CartSubTotal({Key? key}) : super(key: key);

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

    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          const Text(
            'SubTotal',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          Text(
            '\$$sum',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
