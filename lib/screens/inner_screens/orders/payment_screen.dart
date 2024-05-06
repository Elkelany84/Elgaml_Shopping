import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:hadi_ecommerce_firebase_admin/models/order_user_model.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/cart_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/order_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/products_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/user_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/inner_screens/orders/payment_bottom_checkout.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/inner_screens/orders/payment_success.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/inner_screens/personal_profile.dart';
import 'package:hadi_ecommerce_firebase_admin/services/myapp_functions.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/app_name_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/payment/payment_radio_option_widget.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/subtitle_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/title_text.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import 'package:uuid/uuid.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  static const routeName = "/payment-screen";

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  bool isLoading = false;
  String? _sessionId;
  User? user = FirebaseAuth.instance.currentUser;
  OrderUserModel? orderUserModel;
  bool _isLoading = true;
  int _categoryValue = 60;
  Future<void> fetchUserInfo() async {
    final userProvider = Provider.of<OrderProvider>(context, listen: false);
    final orderUserProvider =
        Provider.of<OrderProvider>(context, listen: false);

    try {
      setState(() {
        _isLoading = true;
      });
      orderUserModel = await orderUserProvider.fetchUserInfo();
    } catch (error) {
      await MyAppFunctions.showErrorOrWarningDialog(
        context: context,
        subTitle: error.toString(),
        fct: () {},
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> createSession() async {
    final auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;
    final String uid = user.uid;

    //Register user in FirebaseFirestore
    // await FirebaseFirestore.instance
    //     .collection("ordersAdvanced")
    //     .doc(_sessionId)
    //     .set({
    //   "userId": uid,
    //   "userName": user.displayName,
    //   "userEmail": user.email,
    //   "createdAt": Timestamp.now(),
    //   "userOrder": [],
    // });
  }

  @override
  void initState() {
    // _sessionId = const Uuid().v4();
    _sessionId = randomAlphaNumeric(6);
    print(_sessionId);
    fetchUserInfo();
    super.initState();
  }

  int hobby = 1;
  DateTime dateTime = DateTime.now(); // 获取当前时间
  String defaultTimeString = "Choose Delivery Time";

  @override
  Widget build(BuildContext context) {
    final productProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    // DateTime? maximumDate = dateTime;.add(const Duration(days: 7))
    return Scaffold(
      bottomSheet: PaymentBottomSheetWidget(
        function: () async {
          await placeOrderAdvanced(
            cartProvider: cartProvider,
            productProvider: productProvider,
            userProvider: userProvider,
            hobby: hobby,
          );
        },
        feesAmount: _categoryValue,
      ),
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
        title: const AppNameTextWidget(
          label: "CheckOut ",
          fontSize: 30,
        ),
      ),
      body: orderUserModel == null
          ? const SizedBox.shrink()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const TitleTextWidget(
                      label: "Shipping to : ",
                      fontSize: 24,
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    Container(
                      width: double.infinity,
                      height: 130,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey.shade100),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 8, right: 8, left: 8, bottom: 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SubtitleTextWidget(
                              label: orderUserModel!.userAddress,
                              fontSize: 20, color: Colors.black,
                              // textDecoration: TextDecoration.underline,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(PersonalProfile.routeName);
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SubtitleTextWidget(
                                      label: "Edit Address",
                                      fontStyle: FontStyle.italic,
                                      textDecoration: TextDecoration.underline,
                                    ),
                                    Icon(IconlyLight.location)
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // DeliveryContainerWidget(),
                    const SizedBox(
                      height: 10,
                    ),

                    const TitleTextWidget(
                      label: "Payment Method : ",
                      fontSize: 24,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    PaymentMethodWidget(
                      hobby,
                      (value) {
                        hobby = value;
                        setState(() {
                          hobby = value;
                        });
                        // print(hobby);
                      },
                    ),
                    // TitleTextWidget(
                    //   label: "Payment On Delivery",
                    //   fontSize: 24,
                    // ),
                    //Total Button
                    const SizedBox(
                      height: 20,
                    ),
                    // Center(
                    //   child: SizedBox(
                    //     height: 50,
                    //     width: 150,
                    //     child: ElevatedButton(
                    //       style: ElevatedButton.styleFrom(
                    //         elevation: 0,
                    //         backgroundColor: Colors.blue,
                    //         shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(10),
                    //         ),
                    //       ),
                    //       onPressed: () {},
                    //       child: Text(
                    //         "Buy Now",
                    //         style: TextStyle(
                    //             fontSize: 22,
                    //             // fontWeight: FontWeight.bold,
                    //             color: Colors.white),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // const TitleTextWidget(
                    //   label: "Delivery Date : ",
                    //   fontSize: 24,
                    // ),
                    // const SizedBox(
                    //   height: 5,
                    // ),
                    // SizedBox(
                    //   height: kBottomNavigationBarHeight,
                    //   width: double.infinity,
                    //   child: ElevatedButton(
                    //     style: ElevatedButton.styleFrom(
                    //       padding: const EdgeInsets.all(12),
                    //       backgroundColor: Colors.purpleAccent,
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(12),
                    //       ),
                    //     ),
                    //     onPressed: () {
                    //       showCupertinoModalPopup(
                    //           context: context,
                    //           builder: (context) {
                    //             return SizedBox(
                    //               height: 250, width: double.infinity,
                    //               // width: double.infinity,
                    //               child: DecoratedBox(
                    //                 decoration: BoxDecoration(
                    //                   color: Colors.white,
                    //                   borderRadius: BorderRadius.circular(10),
                    //                 ),
                    //                 child: CupertinoDatePicker(
                    //                   backgroundColor: Colors.white,
                    //                   onDateTimeChanged: (DateTime newTime) {
                    //                     setState(() {
                    //                       dateTime = newTime;
                    //                       // print(dateTime);
                    //                       defaultTimeString =
                    //                           "${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}";
                    //                     });
                    //                   },
                    //                   initialDateTime: dateTime,
                    //                   maximumDate: dateTime.add(
                    //                     const Duration(days: 20),
                    //                   ),
                    //                   use24hFormat: true,
                    //                 ),
                    //               ),
                    //             );
                    //           });
                    //     },
                    //     child: Text(
                    //       defaultTimeString,
                    //       style: const TextStyle(fontSize: 20),
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(
                      height: 2,
                    ),
                    const TitleTextWidget(
                      label: "Order Summary : ",
                      fontSize: 24,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TitleTextWidget(
                      label:
                          "Total Price: \$ ${cartProvider.getTotal(productsProvider: productProvider).toStringAsFixed(2)}",
                      fontSize: 18,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TitleTextWidget(
                      label: "Delivery Fees : \$ $_categoryValue ",
                      fontSize: 18,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 8, right: 12, left: 12),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('orderFees')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const CircularProgressIndicator();
                          } else {
                            List<DropdownMenuItem> categoryItems = [];
                            for (var doc in snapshot.data!.docs) {
                              categoryItems.add(
                                DropdownMenuItem(
                                  child: Text(doc['placeName']),
                                  value: doc['fees'],
                                ),
                              );
                            }

                            return DropdownButtonFormField(
                              hint: const Text('Select Place'),
                              value: _categoryValue,
                              items: categoryItems,
                              onChanged: (newValue) {
                                setState(() {
                                  _categoryValue = newValue;
                                  print(_categoryValue);
                                });
                              },
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    const SubtitleTextWidget(
                        label:
                            "- Fees may be vary Depends on Weight & Quantity (about 4 Pounds for Every KiloGram)."),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  //final professional one
  Future<void> placeOrderAdvanced({
    required UserProvider userProvider,
    required ProductsProvider productProvider,
    required CartProvider cartProvider,
    required int hobby,
    // required int categoryValue,
  }) async {
    final auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final ordersDb = FirebaseFirestore.instance.collection("ordersAdvanced");
    final usersDb = FirebaseFirestore.instance.collection("users");

    if (user == null) {
      return;
    }
    final uid = user.uid;
    try {
      setState(() {
        isLoading = true;
      });

      cartProvider.cartItems.forEach((key, value) async {
        final getCurrProd = productProvider.findByProdId(value.productId);
        final orderId = const Uuid().v4();
        // print(orderId);
        await createSession();
        await ordersDb.doc(_sessionId).set({
          // await ordersDb.doc(_sessionId).update({
          "userId": uid, //done
          "orderDate": Timestamp.now(), //done
          "totalProducts": cartProvider.getQty(), //done
          "sessionId": _sessionId, //done
          "totalPrice": cartProvider.getTotalForPayment(
              productsProvider: productProvider), //done
          "paymentMethod": hobby.toString() == "1" ? "Cash" : "Visa",
          "orderStatus": "Processing",
          "shippingDate": dateTime,
        });

        await ordersDb.doc(_sessionId).update({
          "userOrder": FieldValue.arrayUnion([
            {
              "orderId": orderId,
              "userId": uid,
              "sessionId": _sessionId,
              "userName": userProvider.getUserModel!.userName,
              "productId": value.productId,
              "productTitle": getCurrProd!.productTitle,
              "imageUrl": getCurrProd.productImage,
              "price": double.parse(getCurrProd.productPrice) * value.quantity,
              "totalPrice": cartProvider.getTotalForPayment(
                  productsProvider: productProvider),
              "quantity": value.quantity,
              "orderDate": Timestamp.now(),
              "shippingDate": dateTime,
            }
          ])
        });
      });
      // await ordersDb.doc(uid).update({
      //   "orderSummary": FieldValue.arrayUnion([
      //     {
      //       "userId": uid,
      //       "sessionId": _sessionId,
      //       // "userName": userProvider.getUserModel!.userName,
      //       // "productId": value.productId,
      //       // "productTitle": getCurrProd!.productTitle,
      //       // "price": double.parse(getCurrProd.productPrice) * value.quantity,
      //       "totalPrice": cartProvider.getTotalForPayment(
      //           productsProvider: productProvider),
      //       "totalProducts": cartProvider.getQty(),
      //       // "paymentMethod": "Cash on Delivery",
      //       "paymentMethod": hobby.toString() == "1" ? "Cash" : "Visa",
      //       "orderStatus": "Processing",
      //       "orderDate": Timestamp.now(),
      //     }
      //   ])
      // });

      await cartProvider.clearCartFirebase();
      cartProvider.clearCart();
      Navigator.pushNamed(context, PaymentSuccess.routeName);
    } catch (error) {
      MyAppFunctions.showErrorOrWarningDialog(
          context: context, fct: () {}, subTitle: error.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  //customized function
//   Future<void> placeOrderAdvanced({
//     required UserProvider userProvider,
//     required ProductsProvider productProvider,
//     required CartProvider cartProvider,
//     required int hobby,
//   }) async {
//     final auth = FirebaseAuth.instance;
//     final User? user = auth.currentUser;
//     final ordersDb = FirebaseFirestore.instance.collection("ordersAdvanced");
//     final usersDb = FirebaseFirestore.instance.collection("users");
//
//     if (user == null) {
//       return;
//     }
//     final uid = user.uid;
//     try {
//       setState(() {
//         isLoading = true;
//       });
//       //Original working one
//       // cartProvider.cartItems.forEach((key, value) async {
//       //   final getCurrProd = productProvider.findByProdId(value.productId);
//       //   final orderId = const Uuid().v4();
//       //   // print(orderId);
//       //   await createSession();
//       //   await ordersDb.doc(uid).update({
//       //     // await ordersDb.doc(_sessionId).update({
//       //     "userId": uid,
//       //     "orderDate": Timestamp.now(),
//       //     "sessionId": _sessionId,
//       //     "totalPrice": cartProvider.getTotalForPayment(
//       //         productsProvider: productProvider),
//       //     "orderSummary": FieldValue.arrayUnion([
//       //       {
//       //         "orderId": orderId,
//       //         "userId": uid,
//       //         "sessionId": _sessionId,
//       //         // "userName": userProvider.getUserModel!.userName,
//       //         // "productId": value.productId,
//       //         // "productTitle": getCurrProd!.productTitle,
//       //         // "price": double.parse(getCurrProd.productPrice) * value.quantity,
//       //         "totalPrice": cartProvider.getTotalForPayment(
//       //             productsProvider: productProvider),
//       //         "totalProducts": cartProvider.getQty(),
//       //         "orderDate": Timestamp.now(),
//       //       }
//       //     ]),
//       //     "userOrder": FieldValue.arrayUnion([
//       //       {
//       //         "orderId": orderId,
//       //         "userId": uid,
//       //         "sessionId": _sessionId,
//       //         "userName": userProvider.getUserModel!.userName,
//       //         "productId": value.productId,
//       //         "productTitle": getCurrProd!.productTitle,
//       //         "imageUrl": getCurrProd.productImage,
//       //         "price": double.parse(getCurrProd.productPrice) * value.quantity,
//       //         "totalPrice": cartProvider.getTotalForPayment(
//       //             productsProvider: productProvider),
//       //         "quantity": value.quantity,
//       //         "orderDate": Timestamp.now(),
//       //       }
//       //     ])
//       //   });
//       // });
//
// //customized one
//       cartProvider.cartItems.forEach((key, value) async {
//         final getCurrProd = productProvider.findByProdId(value.productId);
//         final orderId = const Uuid().v4();
//         // print(orderId);
//         await createSession();
//         await ordersDb.doc(uid).update({
//           // await ordersDb.doc(_sessionId).update({
//           "userId": uid,
//           "orderDate": Timestamp.now(),
//           "sessionId": _sessionId,
//           "totalPrice": cartProvider.getTotalForPayment(
//               productsProvider: productProvider),
//           // "totalProducts": cartProvider.getQty(),
//           "userOrder": FieldValue.arrayUnion([
//             {
//               "orderId": orderId,
//               "userId": uid,
//               "sessionId": _sessionId,
//               "userName": userProvider.getUserModel!.userName,
//               "productId": value.productId,
//               "productTitle": getCurrProd!.productTitle,
//               "imageUrl": getCurrProd.productImage,
//               "price": double.parse(getCurrProd.productPrice) * value.quantity,
//               "totalPrice": cartProvider.getTotalForPayment(
//                   productsProvider: productProvider),
//               "quantity": value.quantity,
//               "orderDate": Timestamp.now(),
//             }
//           ])
//         });
//       });
//       await ordersDb.doc(uid).update({
//         "orderSummary": FieldValue.arrayUnion([
//           {
//             "userId": uid,
//             "sessionId": _sessionId,
//             // "userName": userProvider.getUserModel!.userName,
//             // "productId": value.productId,
//             // "productTitle": getCurrProd!.productTitle,
//             // "price": double.parse(getCurrProd.productPrice) * value.quantity,
//             "totalPrice": cartProvider.getTotalForPayment(
//                 productsProvider: productProvider),
//             "totalProducts": cartProvider.getQty(),
//             // "paymentMethod": "Cash on Delivery",
//             "paymentMethod": hobby.toString() == "1" ? "Cash" : "Visa",
//             "orderStatus": "Processing",
//             "orderDate": Timestamp.now(),
//           }
//         ])
//       });
//       //TODO
//       await cartProvider.clearCartFirebase();
//       cartProvider.clearCart();
//       Navigator.pushNamed(context, PaymentSuccess.routeName);
//     } catch (error) {
//       MyAppFunctions.showErrorOrWarningDialog(
//           context: context, fct: () {}, subTitle: error.toString());
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
}
