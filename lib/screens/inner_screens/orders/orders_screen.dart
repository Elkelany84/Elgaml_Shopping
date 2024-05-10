import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:hadi_ecommerce_firebase_admin/localization/locales.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/order_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/theme_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/user_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/inner_screens/orders/order_details.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/app_name_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/subtitle_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/title_text.dart';
import 'package:provider/provider.dart';

class OrdersScreenFree extends StatefulWidget {
  const OrdersScreenFree({super.key});
  static String routeName = "OrdersScreenFree";

  @override
  State<OrdersScreenFree> createState() => _OrdersScreenFreeState();
}

class _OrdersScreenFreeState extends State<OrdersScreenFree> {
  // bool isEmptyOrders = false;

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Directionality(
      textDirection: themeProvider.currentLocaleProvider == "ar"
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        // change layout to RTL if arabic language is used

        appBar: AppBar(
          title: AppNameTextWidget(
            label: LocaleData.placedOrders.getString(context),
            fontSize: 30,
          ),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("ordersAdvanced")
              .where("userId", isEqualTo: userProvider.uidd)
              .orderBy("orderDate", descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrderStreamScreen(
                                    docName: snapshot.data!.docs[index]
                                        ["sessionId"],
                                    // userId: snapshot.data!.docs[index]["userId"],
                                  )),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        height: 255,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  TitleTextWidget(
                                    label:
                                        LocaleData.orderDate.getString(context),
                                  ),
                                  Expanded(
                                    child: SubtitleTextWidget(
                                        label:
                                            // timeago.format(
                                            //   snapshot.data!.docs[index]["orderDate"]
                                            //       .toDate(),
                                            // ),
                                            snapshot
                                                .data!.docs[index]["orderDate"]
                                                .toDate()
                                                .toString()
                                                .substring(0, 10)),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  TitleTextWidget(
                                    label: LocaleData.orderNumber
                                        .getString(context),
                                  ),
                                  Expanded(
                                    child: SubtitleTextWidget(
                                      label: snapshot.data!.docs[index]
                                          ["sessionId"],
                                      textOverflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  TitleTextWidget(
                                    label: LocaleData.orderStatus
                                        .getString(context),
                                  ),
                                  Expanded(
                                    child: SubtitleTextWidget(
                                      label: snapshot.data!.docs[index]
                                          ["orderStatus"],
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  TitleTextWidget(
                                    label: LocaleData.orderTotalProducts
                                        .getString(context),
                                  ),
                                  Expanded(
                                    child: SubtitleTextWidget(
                                        label: snapshot
                                            .data!.docs[index]["totalProducts"]
                                            .toString(),
                                        color: Colors.blue),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  TitleTextWidget(
                                    label: LocaleData.totalPrice
                                        .getString(context),
                                  ),
                                  Expanded(
                                    child: SubtitleTextWidget(
                                        label:
                                            "\$ ${snapshot.data!.docs[index]["totalPrice"].toString()}",
                                        color: Colors.blue),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  TitleTextWidget(
                                    label: LocaleData.paymentMethod
                                        .getString(context),
                                  ),
                                  Expanded(
                                    child: SubtitleTextWidget(
                                        label: snapshot.data!.docs[index]
                                            ["paymentMethod"],
                                        color: Colors.blue),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              // Row(
                              //   children: [
                              //     const TitleTextWidget(
                              //       label: "Shipping Date: ",
                              //     ),
                              //     Expanded(
                              //       child: SubtitleTextWidget(
                              //         label: snapshot
                              //             .data!.docs[index]["shippingDate"]
                              //             .toDate()
                              //             .toString()
                              //             .substring(0, 10),
                              //         color: Colors.blue,
                              //         textOverflow: TextOverflow.ellipsis,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        //original futurebuilder to get the data from ordersummary arrayfield using fetchorders in orderProvider
        // FutureBuilder(
        //   future: orderProvider.fetchOrders(),
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return const Center(
        //           child: CircularProgressIndicator(
        //         color: Colors.red,
        //       ));
        //     } else if (snapshot.hasError) {
        //       return Center(child: SelectableText(snapshot.error.toString()));
        //     } else if (!snapshot.hasData || orderProvider.getOrders.isEmpty) {
        //       return EmptyBag(
        //         title: "No Orders Have Been Placed Yet",
        //         subtitle: "",
        //         imagePath: AssetsManager.orderBag,
        //         buttonText: "Shop Now",
        //       );
        //     }
        //     return ListView.separated(
        //         itemBuilder: (context, index) {
        //           return Padding(
        //             padding:
        //                 const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
        //             child: OrdersWidgetFree(
        //               orderSummary: orderProvider.getOrders[index],
        //               // ordersModelAdvanced:
        //               //     orderProvider.newOrders.values.toList()[index],
        //             ),
        //           );
        //         },
        //         separatorBuilder: (context, index) {
        //           return const Divider(
        //             thickness: 6,
        //           );
        //         },
        //         itemCount: orderProvider.getOrders.length
        //         // itemCount: snapshot.data!.length
        //         );
        //   },
        // ),
      ),
    );
  }
}
