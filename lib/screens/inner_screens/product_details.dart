import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hadi_ecommerce_firebase_admin/localization/locales.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/cart_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/products_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/theme_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/viewed_recently_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/search_screen.dart';
import 'package:hadi_ecommerce_firebase_admin/services/myapp_functions.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/products/heart_btn.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/products/latest_arrival_inside_details.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/subtitle_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/title_text.dart';
import 'package:provider/provider.dart';

import '../auth/login_screen.dart';

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
    print(widget.productId);
    // final productsProvider =
    //     Provider.of<ProductsProvider>(context, listen: false);
    // final productId = ModalRoute.of(context)?.settings.arguments as String;
    // final getCurrentProduct = productsProvider.findByProdId(productId);
    // fetchImageUrls(productId: widget.productId.toString());
    // screens = [
    //   const HomeScreen(),
    //   const SearchScreen(),
    //   const CartScreen(),
    //   const ProfileScreen()
    // ];
    // controller = PageController(initialPage: currentScreen);
    // _checkDeltaColor();
    super.initState();
  }

  int currentColor = 0;
  List colorSelected = [];
  // late List<Widget> screens;
  // late PageController controller;
  // int currentScreen = 0;

  // Color hexToColor(String hexString) {
  //   hexString = hexString.replaceFirst('#', '');
  //   if (hexString.length == 6) {
  //     hexString = 'FF' + hexString; // Add opacity if not provided
  //   }
  //   print(Color(int.parse(hexString, radix: 16)));
  //   return Color(int.parse(hexString, radix: 16));
  // }

  bool showPallette = false;
  String colorChosen = '';
  bool isBlue = false; //4279437290
  bool isBlueSelected = false;
  bool isRed = false; // #EA1C07>> 0xFFEA1C07
  bool isRedSelected = false;
  bool isGold = false; // >> #AD9C00 >> 0xffad9c00
  bool isGoldSelected = false;
  bool isYellow = false; //#C3EA07FF >> 0xFFC3EA07
  bool isYellowSelected = false;
  bool isBlack = false;
  bool isBlackSelected = false; //#0A0707FF >> 0xFF0A0707
  @override
  Widget build(BuildContext context) {
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final viewedProdProvider = Provider.of<ViewedProdProvider>(context);
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    // final productId = widget.productId;

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

//check if the colorsMap has any true value to show the colors palette
//     bool checkIfAnyColorTrue(Map<String, dynamic> colorsMap) {
//       return colorsMap.values.contains(true);
//     }

    // anyColorTrue(String docId) async {
    //   FirebaseFirestore firestore = FirebaseFirestore.instance;
    //   DocumentSnapshot documentSnapshot =
    //       await firestore.collection('products').doc(docId).get();
    //   Map<String, dynamic> colorsMap = documentSnapshot['colorsMap'];
    //   showPallette = true;
    //   setState(() {});
    //   print(' show palette $showPallette');
    //   return colorsMap.values.contains(true);
    //   return false;
    // }

    //check every key in the colorsMap to show available colors
    void _checkDeltaColor() async {
      DocumentSnapshot productDoc = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .get();

      Map<String, bool> colors =
          Map<String, bool>.from(productDoc['colorsMap']);

      setState(() {
        isBlue = colors['4279437290'] ?? false;
        isBlack = colors['0xFF0A0707'] ?? false;
        isGold = colors['0xffad9c00'] ?? false;
        isRed = colors['0xFFEA1C07'] ?? false;
        isYellow = colors['0xFFC3EA07'] ?? false;
      });
    }

    // anyColorTrue(productId);
    _checkDeltaColor();
    String productQuant = getCurrentProduct!.productQuantity;
    bool productAvailable = productQuant == '0' ? true : false;
    // print(productQuant);

    return Directionality(
      textDirection: TextDirection.rtl,
      // themeProvider.currentLocaleProvider == "ar"
      //     ? TextDirection.rtl
      //     : TextDirection.ltr,
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
        // bottomNavigationBar: NavigationBar(
        //   // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        //   elevation: 5,
        //   height: kBottomNavigationBarHeight,
        //   selectedIndex: currentScreen,
        //   onDestinationSelected: (index) {
        //     setState(() {
        //       currentScreen = index;
        //     });
        //     controller.jumpToPage(currentScreen);
        //   },
        //   destinations: [
        //     NavigationDestination(
        //       selectedIcon: const Icon(IconlyBold.home),
        //       icon: const Icon(IconlyLight.home),
        //       label: LocaleData.home.getString(context),
        //     ),
        //     NavigationDestination(
        //       selectedIcon: const Icon(IconlyBold.search),
        //       icon: const Icon(IconlyLight.search),
        //       label: LocaleData.search.getString(context),
        //     ),
        //     NavigationDestination(
        //       selectedIcon: const Icon(IconlyBold.bag2),
        //       icon: Badge(
        //           backgroundColor: Colors.blue,
        //           textColor: Colors.white,
        //           label: Text("${cartProvider.cartItems.length}"),
        //           child: const Icon(IconlyLight.bag2)),
        //       label: LocaleData.cart.getString(context),
        //     ),
        //     NavigationDestination(
        //       selectedIcon: const Icon(IconlyBold.profile),
        //       icon: const Icon(IconlyLight.profile),
        //       label: LocaleData.profile.getString(context),
        //     ),
        //   ],
        // ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: getCurrentProduct == null
              ? const SizedBox.shrink()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      imageList.length > 1
                          ? SizedBox(
                              height: showPallette
                                  ? size.height * 0.25
                                  : size.height * 0.35,
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
                                tag:
                                    // "click",
                                    getCurrentProduct.productImage,
                                child: FancyShimmerImage(
                                  imageUrl: getCurrentProduct.productImage,
                                  height: showPallette
                                      ? size.height * 0.25
                                      : size.height * 0.35,
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
                      Visibility(
                        visible:
                            isBlue || isBlack || isGold || isRed || isYellow,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SubtitleTextWidget(
                              textDirection: TextDirection.rtl,
                              label: "الألوان المتاحة: ",
                              color: Colors.black, fontSize: 20,
                              fontWeight: FontWeight.w700,
                              // maxLines: 2,
                            ),
                            FittedBox(
                              child: Container(
                                height: 50,
                                // width: 220,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.blue[100],
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    //Black Color
                                    GestureDetector(
                                      onTap: () async {
                                        print(isBlackSelected);
                                        isGoldSelected = false;
                                        isBlackSelected = true;
                                        isRedSelected = false;
                                        isBlueSelected = false;
                                        isYellowSelected = false;
                                        colorChosen = "Black";
                                        await Fluttertoast.showToast(
                                            msg: "تم اختيار اللون الأسود");

                                        setState(() {});
                                      },
                                      child: Visibility(
                                        visible: isBlack,
                                        child: Container(
                                          padding: EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: isBlackSelected
                                                      ? Colors.white
                                                      : Colors.blue
                                                          .withOpacity(0.1),
                                                  width: 2)),
                                          child: Container(
                                            padding: EdgeInsets.all(15),
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    //Blue Color
                                    GestureDetector(
                                      onTap: () async {
                                        isGoldSelected = false;
                                        isBlackSelected = false;
                                        isRedSelected = false;
                                        isBlueSelected = true;
                                        isYellowSelected = false;
                                        colorChosen = "Blue";
                                        print(isBlueSelected);
                                        await Fluttertoast.showToast(
                                            msg: "تم اختيار اللون الأزرق");

                                        setState(() {});
                                      },
                                      child: Visibility(
                                        visible: isBlue,
                                        child: Container(
                                          padding: EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: isBlueSelected
                                                      ? Colors.white
                                                      : Colors.blue
                                                          .withOpacity(0.1),
                                                  width: 2)),
                                          child: Container(
                                            padding: EdgeInsets.all(15),
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    //Golden Color
                                    GestureDetector(
                                      onTap: () async {
                                        isGoldSelected = true;
                                        isBlackSelected = false;
                                        isRedSelected = false;
                                        isBlueSelected = false;
                                        isYellowSelected = false;
                                        colorChosen = "Gold";
                                        await Fluttertoast.showToast(
                                            msg: "تم اختيار اللون الذهبى");

                                        setState(() {
                                          // isBlueSelected != isBlueSelected;
                                          print(isGoldSelected);
                                        });
                                      },
                                      child: Visibility(
                                        visible: isGold,
                                        child: Container(
                                          padding: EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: isGoldSelected
                                                      ? Colors.white
                                                      : Colors.blue
                                                          .withOpacity(0.1),
                                                  width: 2)),
                                          child: Container(
                                            padding: EdgeInsets.all(15),
                                            decoration: BoxDecoration(
                                              color: Color(0xffad9c00),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    //Red Color
                                    GestureDetector(
                                      onTap: () async {
                                        isGoldSelected = false;
                                        isBlackSelected = false;
                                        isRedSelected = true;
                                        isBlueSelected = false;
                                        isYellowSelected = false;
                                        colorChosen = "Red";
                                        await Fluttertoast.showToast(
                                            msg: "تم اختيار اللون الأحمر");

                                        setState(() {
                                          // isBlueSelected != isBlueSelected;
                                        });
                                      },
                                      child: Visibility(
                                        visible: isRed,
                                        child: Container(
                                          padding: EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: isRedSelected
                                                      ? Colors.white
                                                      : Colors.blue
                                                          .withOpacity(0.1),
                                                  width: 2)),
                                          child: Container(
                                            padding: EdgeInsets.all(15),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    //Yellow Color
                                    GestureDetector(
                                      onTap: () async {
                                        isGoldSelected = false;
                                        isBlackSelected = false;
                                        isRedSelected = false;
                                        isBlueSelected = false;
                                        isYellowSelected = true;
                                        colorChosen = "Yellow";
                                        await Fluttertoast.showToast(
                                            msg: "تم اختيار اللون الأصفر");

                                        setState(() {
                                          // isBlueSelected != isBlueSelected;
                                        });
                                      },
                                      child: Visibility(
                                        visible: isYellow,
                                        child: Container(
                                          padding: EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: isYellowSelected
                                                      ? Colors.white
                                                      : Colors.blue
                                                          .withOpacity(0.1),
                                                  width: 2)),
                                          child: Container(
                                            padding: EdgeInsets.all(15),
                                            decoration: BoxDecoration(
                                              color: Colors.yellow,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // ColorPicker(outerBorder: false, color: Colors.green)
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // Center(
                      //   child: SizedBox(
                      //     height: 100,
                      //     width: 400,
                      //     child: FutureBuilder<List<MapEntry<String, dynamic>>>(
                      //       future:
                      //           productsProvider.getColorsMapAsList(productId),
                      //       builder: (context, snapshot) {
                      //         if (snapshot.connectionState ==
                      //             ConnectionState.waiting) {
                      //           return Center(
                      //               child: CircularProgressIndicator());
                      //         } else if (snapshot.hasError) {
                      //           return Center(
                      //               child: Text('Error: ${snapshot.error}'));
                      //         } else {
                      //           List<MapEntry<String, dynamic>> colorsList =
                      //               snapshot.data ?? [];
                      //           hexToColor('#ff8800');
                      //           return Center(
                      //             child: ListView.builder(
                      //                 // scrollDirection: Axis.horizontal,
                      //                 itemCount: colorsList.length,
                      //                 itemBuilder: (context, index) {
                      //                   return
                      //                       //   Center(
                      //                       //   child: GestureDetector(
                      //                       //     onTap: () {
                      //                       //       setState(() {
                      //                       //         currentColor = index;
                      //                       //         print(currentColor);
                      //                       //       });
                      //                       //     },
                      //                       //     child: ColorPicker(
                      //                       //         outerBorder:
                      //                       //             colorsList[index].value,
                      //                       //         color: Colors.red),
                      //                       //   ),
                      //                       // );
                      //                       ListTile(
                      //                     title: Text(
                      //                         'Color: ${colorsList[index].key}'),
                      //                     subtitle: Row(
                      //                       children: [
                      //                         Text(
                      //                             'Value: ${colorsList[index].value}'),
                      //                         Container(
                      //                           child: Text(
                      //                             'hhhh',
                      //                             style:
                      //                                 TextStyle(fontSize: 20),
                      //                           ),
                      //                           decoration: BoxDecoration(
                      //                               color: Colors.green),
                      //                         )
                      //                       ],
                      //                     ),
                      //                   );
                      //                 }),
                      //           );
                      //         }
                      //       },
                      //       // child: Container(
                      //       //   height: 50,
                      //       //   width: 200,
                      //       //   padding: EdgeInsets.all(8),
                      //       //   decoration: BoxDecoration(
                      //       //       color: Colors.black.withOpacity(0.3),
                      //       //       borderRadius: BorderRadius.circular(30)),
                      //       //   child: ListView.separated(
                      //       //       scrollDirection: Axis.horizontal,
                      //       //       itemBuilder: (context, index) {
                      //       //         return GestureDetector(
                      //       //           onTap: () {
                      //       //             setState(() {
                      //       //               currentColor = index;
                      //       //               print(currentColor);
                      //       //             });
                      //       //           },
                      //       //           child: ColorPicker(
                      //       //               outerBorder: currentColor == index,
                      //       //               color: colorSelected[index]),
                      //       //         );
                      //       //       },
                      //       //       separatorBuilder: (context, index) {
                      //       //         return SizedBox(
                      //       //           height: 3,
                      //       //         );
                      //       //       },
                      //       //       itemCount: colorSelected.length),
                      //       // ),
                      //     ),
                      //   ),
                      // ),
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
                                        productId:
                                            getCurrentProduct.productId) ||
                                    productAvailable == true) {
                                  return;
                                }
                                try {
                                  await cartProvider.addToCartFirebase(
                                      productId: getCurrentProduct.productId,
                                      quantity: 1,
                                      context: context,
                                      color: colorChosen);
                                } catch (error) {
                                  MyAppFunctions.showErrorOrWarningDialog(
                                      context: context,
                                      fct: () {
                                        Navigator.pushReplacementNamed(
                                            context, LoginScreen.routeName);
                                        print("hhhhhh");
                                        // Navigator.pushReplacementNamed(
                                        //     context, LoginScreen.routeName);
                                      },
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
                                productAvailable
                                    ? 'المنتج غير متوفر حاليا'
                                    : cartProvider.isProductInCart(
                                            productId:
                                                getCurrentProduct.productId)
                                        ? LocaleData.productDetailsAddedAlready
                                            .getString(context)
                                        : LocaleData.productDetailsAddedToCart
                                            .getString(context),
                                style: const TextStyle(fontSize: 18),
                              ),
                              icon: Icon(cartProvider.isProductInCart(
                                          productId:
                                              getCurrentProduct.productId) &&
                                      productAvailable != true
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
                      const SizedBox(
                        height: 15,
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: TitleTextWidget(
                            textDirection: TextDirection.rtl,
                            label: "أحدث المنتجات :"),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Visibility(
                        visible: viewedProdProvider.viewedProdsItems.isNotEmpty,
                        child: SizedBox(
                          height: size.height * 0.2,
                          width: size.width,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: productsProvider.getProducts.length,
                              itemBuilder: (context, index) {
                                return ChangeNotifierProvider.value(
                                    value: productsProvider.getProducts[index],
                                    child: LatestArrivalProductDetails());
                              }),
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
