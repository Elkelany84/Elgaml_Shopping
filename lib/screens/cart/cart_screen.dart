import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/cart/bottom_checkout.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/cart/cart_widget.dart';
import 'package:hadi_ecommerce_firebase_admin/services/assets_manager.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/app_name_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/empty_bag.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  final bool isEmpty = false;

  @override
  Widget build(BuildContext context) {
    return isEmpty
        ? Scaffold(
            body: EmptyBag(
              imagePath: AssetsManager.shoppingBasket,
              title: "Whoops",
              subtile: "Your Cart Is Empty!",
              details: "Looks Like Your Cart is Empty,Start Shopping!",
              buttonText: "Shop now",
            ),
          )
        : Scaffold(
            bottomSheet: CartBottomSheetWidget(),
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(AssetsManager.shoppingCart),
              ),
              title: AppNameTextWidget(
                label: "Cart Screen",
                fontSize: 22,
              ),
              actions: [
                IconButton(
                    onPressed: () {}, icon: Icon(Icons.delete_forever_rounded))
              ],
            ),
            body: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return CartWidget();
                }),
          );
  }
}
