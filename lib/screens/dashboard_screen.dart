import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/models/dashboard_buttons_model.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/providers/banners_provider.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/providers/categories_provider.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/providers/order_provider.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/providers/products_provider.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/providers/user_provider.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/widgets/app_name_text.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/widgets/dashboard_btn.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../services/assets_manager.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/DashboardScreen';
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  bool isLoadingProd = true;

  //very important to fetch products and make stream function to work
  Future<void> fetchFct() async {
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    final categoryProvider =
        Provider.of<CategoriesProvider>(context, listen: false);
    final bannerProvider = Provider.of<BannersProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    try {
      //fetch many future functions
      // Future.wait({productsProvider.fetchProducts()});
      await productsProvider.fetchProducts();
      await categoryProvider.fetchCategories();
      await productsProvider.countProducts();
      await categoryProvider.countCategories();
      await bannerProvider.fetchBanners();
      await bannerProvider.countBanners();
      await userProvider.countUsers();
      await orderProvider.fetchOrders();
      // await categoryProvider.fetchCategories();
    } catch (e) {
      log(e.toString());
    }
  }

  final CollectionReference<Map<String, dynamic>> productList =
      FirebaseFirestore.instance.collection('products');
  int? quer;
  Future<int?> countProducts() async {
    AggregateQuerySnapshot query = await productList.count().get();
    // debugPrint('The number of products: ${query.count}');
    quer = query.count;
    return query.count;
  }

  // void setupPushNotification() async {
  //   final fcm = FirebaseMessaging.instance;
  //   var token = await FirebaseMessaging.instance.getToken();
  //   NotificationSettings settings = await fcm.requestPermission(
  //     alert: true,
  //     announcement: false,
  //     badge: true,
  //     carPlay: false,
  //     criticalAlert: false,
  //     provisional: false,
  //     sound: true,
  //   );
  //   print('User granted permission: ${settings.authorizationStatus}');
  //   await fcm.subscribeToTopic("ordersAdvanced"); // Add this line
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     print('Got a message whilst in the foreground!');
  //     print('Message data: ${message.data}');
  //
  //     if (message.notification != null) {
  //       print('Message also contained a notification: ${message.notification}');
  //     }
  //   });
  //
  //   print(token);
  // }

  @override
  void didChangeDependencies() {
    if (isLoadingProd) {
      fetchFct();
      countProducts();
    }

    super.didChangeDependencies();
  }

  // @override
  // void initState() {
  //   // setupPushNotification();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const AppNameTextWidget(
          label: "لوحة التحكم",
          fontFamily: "ElMessiri",
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.shoppingCart),
        ),
        actions: [
          IconButton(
            onPressed: () {
              themeProvider.setDarkTheme(
                  themeValue: !themeProvider.getIsDarkTheme);
            },
            icon: Icon(themeProvider.getIsDarkTheme
                ? Icons.light_mode
                : Icons.dark_mode),
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: List.generate(
          //we add context because we had to add it to list
          DashboardButtonsModel.dashboardBtnsList(context).length,
          (index) => DashboardButtonsWidget(
            text: DashboardButtonsModel.dashboardBtnsList(context)[index].text,
            imagePath: DashboardButtonsModel.dashboardBtnsList(context)[index]
                .imagePath,
            onPressed: DashboardButtonsModel.dashboardBtnsList(context)[index]
                .onPressed,
          ),
        ),
      ),
    );
  }
}
