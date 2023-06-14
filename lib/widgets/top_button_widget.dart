import 'package:flutter/cupertino.dart';
import 'package:flutter_amazon_clone/services/account_service.dart';

import 'account_button.dart';

class TopButtons extends StatelessWidget {
  const TopButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            AccountButton(text: "Your Orders", onTap: (){}),
            AccountButton(text: "Turn Seller", onTap: (){}),
          ],
        ),
        const SizedBox(height: 10,),
        Row(
          children: [
            AccountButton(text: "Log Out", onTap: ()=> AccountService().logOut(context)),
            AccountButton(text: "Your Wish List", onTap: (){}),
          ],
        ),
      ],
    );
  }
}
