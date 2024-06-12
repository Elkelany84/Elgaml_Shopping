import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:hadi_ecommerce_firebase_admin/localization/locales.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/cart_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/products_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/theme_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/search_screen.dart';
import 'package:hadi_ecommerce_firebase_admin/services/myapp_functions.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/products/heart_btn.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/subtitle_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/title_text.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  ProductDetails({
    super.key,
    this.name,
    this.productId,
  });
  static String routeName = "ProductDetails";
  final String? name;
  final String? productId;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  List imageList = [];
  Future<List<String>> fetchImageUrls({required String productId}) async {
    final productDoc = await FirebaseFirestore.instance
        .collection('products')
        .doc(productId) // Replace with your actual product ID
        .get();

    final imageUrls = List<String>.from(productDoc['imageFileList']);
    // print(imageUrls);
    imageList = imageUrls;
    return imageUrls;
  }

  @override
  void initState() {
    // final productsProvider =
    //     Provider.of<ProductsProvider>(context, listen: false);
    // final productId = ModalRoute.of(context)?.settings.arguments as String;
    // final getCurrentProduct = productsProvider.findByProdId(productId);
    // fetchImageUrls(productId: widget.productId.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    final getCurrentProduct = productsProvider.findByProdId(productId);
    Size size = MediaQuery.of(context).size;
    fetchImageUrls(productId: productId);

    // Future<List<String>> fetchImageUrls({required String productId}) async {
    //   final productDoc = await FirebaseFirestore.instance
    //       .collection('products')
    //       .doc(getCurrentProduct!.productId) // Replace with your actual product ID
    //       .get();
    //
    //   final imageUrls = List<String>.from(productDoc['imageFileList']);
    //   return imageUrls;
    // }
    return Directionality(
      textDirection: themeProvider.currentLocaleProvider == "ar"
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        // bottomSheet: const RootScreen(),
        appBar: AppBar(
          centerTitle: true,
          // automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
            ),
          ),
          // leading: Padding(
          //   padding: EdgeInsets.all(8.0),
          //   child: Image.asset(AssetsManager.shoppingCart),
          // ),
          // title: const AppNameTextWidget(
          //   label: "Elgaml Stores",
          //   fontSize: 26,
          // ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: getCurrentProduct == null
              ? const SizedBox.shrink()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      imageList.length > 1
                          ? SizedBox(
                              height: 300.0,
                              child: ClipRRect(
                                // borderRadius: BorderRadius.circular(20),
                                child: Swiper(
                                  autoplay: true,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return FancyShimmerImage(
                                      imageUrl: imageList[index],
                                      boxFit: BoxFit.fill,
                                    );
                                  },
                                  itemCount: imageList.length,
                                  pagination: const SwiperPagination(
                                    builder: DotSwiperPaginationBuilder(
                                        activeColor: Colors.red,
                                        color: Colors.white),
                                  ),
                                  // control: SwiperControl(),
                                ),
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Hero(
                                tag: getCurrentProduct.productImage,
                                child: FancyShimmerImage(
                                  imageUrl: getCurrentProduct.productImage,
                                  height: size.height * 0.38,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              getCurrentProduct.productTitle,
                              softWrap: true,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w700),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SubtitleTextWidget(
                            textDirection: TextDirection.rtl,
                            label: "${getCurrentProduct.productPrice} جنيه",
                            color: Colors.blue, fontSize: 20,
                            fontWeight: FontWeight.w700,
                            // maxLines: 2,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          HeartButtonWidget(
                            productId: getCurrentProduct.productId,
                            bgColor: Colors.blue.shade100,
                          ),
                          SizedBox(
                            height: kBottomNavigationBarHeight - 10,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () async {
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

                                // if (cartProvider.isProductInCart(
                                //     productId: getCurrentProduct.productId)) {
                                //   return;
                                // }
                                // cartProvider.addToCart(
                                //     productId: getCurrentProduct.productId);
                              },
                              label: Text(
                                cartProvider.isProductInCart(
                                        productId: getCurrentProduct.productId)
                                    ? LocaleData.productDetailsAddedAlready
                                        .getString(context)
                                    : LocaleData.productDetailsAddedToCart
                                        .getString(context),
                                style: const TextStyle(fontSize: 20),
                              ),
                              icon: Icon(cartProvider.isProductInCart(
                                      productId: getCurrentProduct.productId)
                                  ? Icons.check
                                  : Icons.add_shopping_cart),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TitleTextWidget(
                              textDirection: TextDirection.rtl,
                              label: LocaleData.productDetailsAboutItem
                                  .getString(context)),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, SearchScreen.routeName,
                                  arguments: getCurrentProduct.productCategory);
                            },
                            child: SubtitleTextWidget(
                              textDirection: TextDirection.rtl,
                              label:
                                  "${LocaleData.productDetailsIn.getString(context)} ${getCurrentProduct.productCategory}",
                              color: Colors.blue,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: SubtitleTextWidget(
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                          label: getCurrentProduct.productDescription,
                          textOverflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
