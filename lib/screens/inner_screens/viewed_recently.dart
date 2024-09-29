import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:hadi_ecommerce_firebase_admin/localization/locales.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/products_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/theme_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/viewed_recently_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/services/assets_manager.dart';
import 'package:hadi_ecommerce_firebase_admin/services/myapp_functions.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/app_name_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/empty_bag.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/products/product_widget.dart';
import 'package:provider/provider.dart';

class ViewedRecentlyScreen extends StatelessWidget {
  const ViewedRecentlyScreen({super.key});
  final bool isEmpty = false;
  static String routeName = "ViewedRecentlyScreen";

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductsProvider>(context);
    final viewedProdProvider = Provider.of<ViewedProdProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return viewedProdProvider.viewedProdsItems.isEmpty
        ? Scaffold(
            body: EmptyBag(
              imagePath: AssetsManager.orderBag,
              title: LocaleData.viewedRecentlyMessage.getString(context),
              titleFont: 18,
              // subtitle: "Looks Like Your Cart is Empty,Start Shopping!",
              // details: "Looks Like Your Cart is Empty,Start Shopping!",
              buttonText: LocaleData.shopNow.getString(context), buttonFont: 18,
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
                  child: Image.asset(AssetsManager.orderBag),
                ),
                title: AppNameTextWidget(
                  label:
                      "${LocaleData.viewedRecently.getString(context)} (${viewedProdProvider.viewedProdsItems.length})",
                  fontSize: 22,
                ),
                actions: [
                  IconButton(
                      onPressed: () {
                        MyAppFunctions.showErrorOrWarningDialog(
                            fontSize: 16,
                            isError: false,
                            context: context,
                            fct: () {
                              viewedProdProvider.clearViewedProds();
                            },
                            subTitle: LocaleData.clearViewedRecently
                                .getString(context));
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
                      productId: viewedProdProvider.viewedProdsItems.values
                          .toList()[index]
                          .productId,
                    ),
                  );
                },
                itemCount: viewedProdProvider.viewedProdsItems.length,
                crossAxisCount: 2,
              ),
            ),
          );
  }
}
