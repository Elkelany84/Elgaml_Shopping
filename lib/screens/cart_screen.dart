import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/title_text.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: TitleTextWidget(
          label: "Cart",
        ),
      ),
    );
  }
}
