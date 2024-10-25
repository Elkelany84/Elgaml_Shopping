import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_admin/models/product_model.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/cart_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/viewed_recently_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/inner_screens/product_details.dart';
import 'package:hadi_ecommerce_firebase_admin/services/myapp_functions.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/products/heart_btn.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/subtitle_text.dart';
import 'package:provider/provider.dart';

class LatestArrivalProductWidgets extends StatelessWidget {
  const LatestArrivalProductWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    final productModel = Provider.of<ProductModel>(context);
    final viewedProdProvider = Provider.of<ViewedProdProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () async {
          viewedProdProvider.addViewedProd(productId: productModel.productId);
          await Navigator.pushNamed(context, ProductDetails.routeName,
              arguments: productModel.productId);
        },
        child: SizedBox(
          width: size.width * 0.45,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Hero(
                  tag: productModel.productImage,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: FancyShimmerImage(
                      imageUrl: productModel.productImage,
                      height: size.height * 0.12,
                      width: size.width * 0.25,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Flexible(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      productModel.productTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          HeartButtonWidget(
                            productId: productModel.productId,
                          ),
                          IconButton(
                            onPressed: () async {
                              //check if already in cart
                              if (cartProvider.isProductInCart(
                                  productId: productModel.productId)) {
                                return;
                              }
                              try {
                                await cartProvider.addToCartFirebase(
                                    productId: productModel.productId,
                                    quantity: 1,
                                    context: context);
                              } catch (error) {
                                // Navigator.pushReplacementNamed(
                                //     context, LoginScreen.routeName);
                                MyAppFunctions.showErrorOrWarningDialog(
                                    context: context,
                                    fct: () {},
                                    subTitle: error.toString());
                              }

                              // if (cartProvider.isProductInCart(
                              //     productId: productModel.productId)) {
                              //   return;
                              // }
                              // cartProvider.addToCart(
                              //     productId: productModel.productId);
                            },
                            icon: Icon(
                              cartProvider.isProductInCart(
                                      productId: productModel.productId)
                                  ? Icons.check
                                  : Icons.add_shopping_cart_outlined,
                              size: 20,
                              color: Colors.lightBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    FittedBox(
                      child: SubtitleTextWidget(
                        label: "${productModel.productPrice} جنيه ",
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                        // maxLines: 2,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
