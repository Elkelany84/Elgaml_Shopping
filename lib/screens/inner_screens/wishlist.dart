import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:hadi_ecommerce_firebase_admin/localization/locales.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/theme_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/wishlist_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/services/assets_manager.dart';
import 'package:hadi_ecommerce_firebase_admin/services/myapp_functions.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/app_name_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/empty_bag.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/products/product_widget.dart';
import 'package:provider/provider.dart';

class WishListScreen extends StatelessWidget {
  const WishListScreen({super.key});
  final bool isEmpty = true;
  static String routeName = "WishListScreen";

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return wishlistProvider.wishlistItems.isEmpty
        ? Scaffold(
            body: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                EmptyBag(
                  imagePath: AssetsManager.bagWish,
                  title: LocaleData.wishListMessage.getString(context),
                  // subtitle: "Looks Like Your Wishlist is Empty,Start Shopping!",
                  // details: "Looks Like Your Cart is Empty,Start Shopping!",
                  buttonText: LocaleData.shopNow.getString(context),
                  buttonFont: 18,
                ),
              ],
            ),
          )
        : Directionality(
            textDirection: themeProvider.currentLocaleProvider == "ar"
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: Scaffold(
              // bottomSheet: CartBottomSheetWidget(),
              appBar: AppBar(
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(AssetsManager.bagWish),
                ),
                title: AppNameTextWidget(
                  label:
                      "${LocaleData.wishList.getString(context)} (${wishlistProvider.wishlistItems.length})",
                  fontSize: 22,
                ),
                actions: [
                  IconButton(
                      onPressed: () {
                        MyAppFunctions.showErrorOrWarningDialog(
                            fontSize: 18,
                            isError: false,
                            context: context,
                            fct: () async {
                              wishlistProvider.wishlistItems.clear();
                              await wishlistProvider.clearCartFirebase();
                            },
                            subTitle:
                                LocaleData.clearWishList.getString(context));
                      },
                      icon: const Icon(
                        Icons.delete_forever_rounded,
                        color: Colors.red,
                      ))
                ],
              ),
              body: DynamicHeightGridView(
                // mainAxisSpacing: 12,
                // crossAxisSpacing: 12,
                builder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ProductWidget(
                      productId: wishlistProvider.wishlistItems.values
                          .toList()[index]
                          .productId,
                    ),
                  );
                },
                itemCount: wishlistProvider.wishlistItems.length,
                crossAxisCount: 2,
              ),
            ),
          );
  }
}
