import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_admin/models/product_model.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/cart_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/products_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/viewed_recently_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/inner_screens/product_details.dart';
import 'package:hadi_ecommerce_firebase_admin/services/myapp_functions.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/products/heart_btn.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/subtitle_text.dart';
import 'package:provider/provider.dart';

class LatestArrivalProductDetails extends StatelessWidget {
  // final String productId;
  const LatestArrivalProductDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final productsProvider = Provider.of<ProductsProvider>(context);
    final productModel = Provider.of<ProductModel>(context);
    final viewedProdProvider = Provider.of<ViewedProdProvider>(context);
    // final getCurrentProduct = productsProvider.findByProdId(productId);
    Size size = MediaQuery.of(context).size;
    final getCurrentProduct =
        productsProvider.findByProdId(productModel.productId);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () async {
          viewedProdProvider.addViewedProd(productId: productModel.productId);
          await Navigator.pushReplacementNamed(
              context, ProductDetails.routeName,
              arguments: productModel.productId);
          // Navigator.of(context).push(
          //   PageRouteBuilder(
          //     pageBuilder: (BuildContext context, Animation<double> animation,
          //         Animation<double> secondaryAnimation) {
          //       return ProductDetails(
          //         productId: getCurrentProduct!.productId,
          //       );
          //     },
          //     transitionsBuilder: (BuildContext context,
          //         Animation<double> animation,
          //         Animation<double> secondaryAnimation,
          //         Widget child) {
          //       return Align(
          //         child: SizeTransition(
          //           sizeFactor: animation,
          //           child: child,
          //         ),
          //       );
          //     },
          //     transitionDuration: Duration(milliseconds: 500),
          //   ),
          // );
        },
        child: SizedBox(
          width: size.width * 0.45,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: FancyShimmerImage(
                        imageUrl: productModel.productImage,
                        height: size.height * 0.12,
                        width: size.width * 0.25,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  if (getCurrentProduct!.productBeforeDiscount! > 0)
                    SubtitleTextWidget(
                      label: "${getCurrentProduct!.productBeforeDiscount} جنيه",
                      color: Colors.grey,
                      textDecoration: TextDecoration.lineThrough,
                      fontWeight: FontWeight.normal, fontSize: 16,
                      // maxLines: 2,
                    ),
                ],
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
                                    color: 'normal',
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
