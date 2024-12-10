import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';
import '../../services/myapp_functions.dart';
import '../subtitle_text.dart';
import 'heart_btn.dart';

class DiscountProducts extends StatelessWidget {
  const DiscountProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    // final productsProvider = Provider.of<ProductsProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: size.width * 0.45,
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('products')
                .where('productBeforeDiscount', isNotEqualTo: '')
                .snapshots(),
            builder: (context, snapshot) {
              final products = snapshot.data!.docs;
              return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return SizedBox(
                      width: size.width * 0.45,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Hero(
                                  tag: product['productImage'],
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: FancyShimmerImage(
                                      imageUrl: product['productImage'],
                                      height: size.height * 0.11,
                                      width: size.width * 0.25,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              // if (getCurrentProduct!.productBeforeDiscount! > 0)
                              SubtitleTextWidget(
                                label:
                                    "${product['productBeforeDiscount']} جنيه",
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
                                  product['productTitle'],
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
                                        productId: product['productId'],
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          //check if already in cart
                                          if (cartProvider.isProductInCart(
                                              productId:
                                                  product['productId'])) {
                                            return;
                                          }
                                          try {
                                            await cartProvider
                                                .addToCartFirebase(
                                                    productId:
                                                        product['productId'],
                                                    quantity: 1,
                                                    color: 'normal',
                                                    context: context);
                                            // print("hhhhhh");
                                          } catch (error) {
                                            MyAppFunctions
                                                .showErrorOrWarningDialog(
                                              context: context,
                                              fct: () {
                                                // Navigator.pushReplacementNamed(
                                                //     context, LoginScreen.routeName);
                                              },
                                              subTitle: "Error adding to cart",
                                            );
                                            print("hhhhhh");
                                          }
                                        },
                                        icon: Icon(
                                          cartProvider.isProductInCart(
                                                  productId:
                                                      product['productId'])
                                              ? Icons.check
                                              : Icons
                                                  .add_shopping_cart_outlined,
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // if (getCurrentProduct!.productBeforeDiscount! > 0)
                                    //   SubtitleTextWidget(
                                    //     label:
                                    //         "${getCurrentProduct!.productBeforeDiscount} جنيه",
                                    //     color: Colors.grey,
                                    //     textDecoration: TextDecoration.lineThrough,
                                    //     fontWeight: FontWeight.normal, fontSize: 16,
                                    //     // maxLines: 2,
                                    //   ),
                                    FittedBox(
                                      child: SubtitleTextWidget(
                                        label:
                                            "${product['productPrice']} جنيه ",
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w600,
                                        // maxLines: 2,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  });
            }),
      ),
    );
  }
}
