import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/cart_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/products_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/viewed_recently_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/inner_screens/product_details.dart';
import 'package:hadi_ecommerce_firebase_admin/services/myapp_functions.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/products/heart_btn.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/subtitle_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/title_text.dart';
import 'package:provider/provider.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({
    super.key,
    required this.productId,
  });
  final String productId;
  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final viewedProdProvider = Provider.of<ViewedProdProvider>(context);

    final getCurrentProduct = productsProvider.findByProdId(widget.productId);

    Size size = MediaQuery.of(context).size;
    return getCurrentProduct == null
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.all(6.0),
            child: GestureDetector(
              onTap: () async {
                viewedProdProvider.addViewedProd(
                    productId: getCurrentProduct.productId);
                await Navigator.pushNamed(
                  context,
                  ProductDetails.routeName,
                  arguments: getCurrentProduct.productId,
                );
                // Navigator.of(context).push(
                //   PageRouteBuilder(
                //     pageBuilder: (BuildContext context,
                //         Animation<double> animation,
                //         Animation<double> secondaryAnimation) {
                //       return ProductDetails(
                //         productId: getCurrentProduct.productId,
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
                // Navigator.of(context).pushNamed(
                //   ProductDetails.routeName,
                //   arguments: getCurrentProduct.productId,
                // );
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => ProductDetails(
                //             name: ProductDetails.routeName,
                //             productId: getCurrentProduct.productId,
                //           )),
                // );
              },
              child: Column(
                children: [
                  //check if the product has imageFileList in the firebase to show swiper widget

                  Hero(
                    tag:
                        // "click",
                        getCurrentProduct.productImage,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: FancyShimmerImage(
                        imageUrl: getCurrentProduct.productImage,
                        height: size.height * 0.22,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 5,
                        child: TitleTextWidget(
                          label: getCurrentProduct.productTitle,
                          maxLines: 2,
                          fontSize: 18,
                        ),
                      ),
                      Flexible(
                        child: HeartButtonWidget(
                          productId: getCurrentProduct.productId,
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 4,
                        child: SubtitleTextWidget(
                          label: "${getCurrentProduct.productPrice} جنيه",
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                          // maxLines: 2,
                        ),
                      ),
                      Flexible(
                        child: Material(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.lightBlue,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            splashColor: Colors.red,
                            onTap: () async {
                              //check if already in cart
                              if (cartProvider.isProductInCart(
                                  productId: getCurrentProduct.productId)) {
                                return;
                              }
                              try {
                                await cartProvider.addToCartFirebase(
                                    productId: getCurrentProduct.productId,
                                    quantity: 1,
                                    context: context);
                              } catch (error) {
                                MyAppFunctions.showErrorOrWarningDialog(
                                    context: context,
                                    fct: () {},
                                    subTitle: error.toString());
                              }

                              // await productsProvider.addImageFileListToProduct(
                              //     productId: getCurrentProduct.productId);
                              // if (cartProvider.isProductInCart(
                              //     productId: getCurrentProduct.productId)) {
                              //   return;
                              // }
                              // cartProvider.addToCart(
                              //     productId: getCurrentProduct.productId);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Icon(
                                cartProvider.isProductInCart(
                                        productId: getCurrentProduct.productId)
                                    ? Icons.check
                                    : Icons.add_shopping_cart_outlined,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
