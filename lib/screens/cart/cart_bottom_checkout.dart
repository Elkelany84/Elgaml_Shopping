import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:hadi_ecommerce_firebase_admin/localization/locales.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/cart_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/products_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/subtitle_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/title_text.dart';
import 'package:provider/provider.dart';

class CartBottomSheetWidget extends StatelessWidget {
  const CartBottomSheetWidget({super.key, required this.function});

  final Function function;

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: const Border(
          top: BorderSide(width: 1, color: Colors.grey),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: kBottomNavigationBarHeight + 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleTextWidget(
                      label:
                          "${LocaleData.total.getString(context)} (${cartProvider.cartItems.length} ${LocaleData.products.getString(context)} / ${cartProvider.getQty()} ${LocaleData.items.getString(context)})",
                      fontSize: 17,
                    ),
                    SubtitleTextWidget(
                      label:
                          "\$ ${cartProvider.getTotal(productsProvider: productsProvider).toStringAsFixed(2)}",
                      color: Colors.blue,
                    )
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await function();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  LocaleData.checkout.getString(context),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
