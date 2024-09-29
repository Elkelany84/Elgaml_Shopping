import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:hadi_ecommerce_firebase_admin/constants/app_constants.dart';
import 'package:hadi_ecommerce_firebase_admin/localization/locales.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/categories_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/products_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/theme_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/categories_screen.dart';
import 'package:hadi_ecommerce_firebase_admin/services/assets_manager.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/app_name_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/products/category_runded_widget.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/products/latest_arrival.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/subtitle_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/title_text.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final categoriesProvider = Provider.of<CategoriesProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    // UserModel? userModel;
    // User? user = FirebaseAuth.instance.currentUser;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.shoppingCart),
        ),
        title: const AppNameTextWidget(
          label: "Elgaml Stores",
          fontSize: 24,
        ),
      ),
      body: Directionality(
        textDirection: themeProvider.currentLocaleProvider == "ar"
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 12,
                ),
                // Visibility(
                //   visible: user == null ? false : true,
                //   child: SubtitleTextWidget(
                //     label: "Delivery to :${userModel!.userName}",
                //   ),
                // ),
                SizedBox(
                  height: size.height * 0.22,
                  child: ClipRRect(
                    // borderRadius: BorderRadius.circular(20),
                    child: Swiper(
                      autoplay: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Image.asset(
                          AppConstants.bannerImages[index],
                          fit: BoxFit.fill,
                        );
                      },
                      itemCount: AppConstants.bannerImages.length,
                      pagination: const SwiperPagination(
                        builder: DotSwiperPaginationBuilder(
                            activeColor: Colors.red, color: Colors.white),
                      ),
                      // control: SwiperControl(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: productsProvider.getProducts.isNotEmpty,
                  child: TitleTextWidget(
                    label: LocaleData.latestArrivals.getString(context),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: productsProvider.getProducts.isNotEmpty,
                  child: SizedBox(
                    height: size.height * 0.2,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: productsProvider.getProducts.length < 10
                            ? productsProvider.getProducts.length
                            : 7,
                        itemBuilder: (context, index) {
                          return ChangeNotifierProvider.value(
                              value: productsProvider.getProducts[index],
                              child: const LatestArrivalProductWidgets());
                        }),
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TitleTextWidget(
                        label: LocaleData.categories.getString(context)),
                    const SizedBox(
                      width: 2,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, CategoriesScreen.routeName);
                      },
                      child: SubtitleTextWidget(
                        label: LocaleData.showAll.getString(context),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  children: List.generate(categoriesProvider.categories.length,
                      (index) {
                    return CategoryRoundedWidget(
                      name: categoriesProvider.categories[index].name,
                      image: categoriesProvider.categories[index].image,
                      // name: AppConstants.categoriesList[index].name,
                      // image: AppConstants.categoriesList[index].image,
                    );
                  }),
                )
              ],
            ),
          ),
        ),
      ),
      // backgroundColor: AppColors.lightScaffoldColor,
    );
  }
}
