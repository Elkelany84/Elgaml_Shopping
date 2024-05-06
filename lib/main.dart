import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/providers/categories_provider.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/providers/order_provider.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/providers/user_provider.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/screens/all_users_screen.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/screens/inner_screen/add_category_dashboard.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/screens/inner_screen/orders/order_details.dart';
import 'package:provider/provider.dart';

import 'consts/theme_data.dart';
import 'providers/products_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/categories_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/edit_upload_product_form.dart';
import 'screens/inner_screen/orders/order_screen_completed.dart';
import 'screens/inner_screen/orders/orders_screen_processing.dart';
import 'screens/search_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: FirebaseOptions(
            apiKey: "AIzaSyCUfPySK2s6fR87-DmhzkNTTyEwbHvjK-0",
            appId: "1:493433453225:android:3b221b58cbaa93116207b8",
            messagingSenderId: "493433453225",
            projectId: "hadishopsmarprovideradminpanel",
            storageBucket: "hadishopsmarprovideradminpanel.appspot.com",
          ),
        )
      : await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          return ThemeProvider();
        }),
        ChangeNotifierProvider(create: (_) {
          return ProductsProvider();
        }),
        ChangeNotifierProvider(create: (_) {
          return CategoriesProvider();
        }),
        ChangeNotifierProvider(create: (_) {
          return UserProvider();
        }),
        ChangeNotifierProvider(create: (_) {
          return OrderProvider();
        }),
      ],
      child: Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Elgaml Dashboard',
          theme: Styles.themeData(
              isDarkTheme: themeProvider.getIsDarkTheme, context: context),
          home: const DashboardScreen(),
          routes: {
            OrdersScreenFree.routeName: (context) => const OrdersScreenFree(),
            SearchScreen.routeName: (context) => const SearchScreen(),
            EditOrUploadProductForm.routeName: (context) =>
                const EditOrUploadProductForm(),
            CategoriesScreen.routeName: (context) => const CategoriesScreen(),
            AllUsersScreen.routeName: (context) => const AllUsersScreen(),
            OrderStreamScreen.routeName: (context) => OrderStreamScreen(),
            OrdersScreenCompleted.routeName: (context) =>
                OrdersScreenCompleted(),
            AddCategoryDashboard.routeName: (context) => AddCategoryDashboard(),
            // PersonalProfile.routeName: (context) => const PersonalProfile(),
          },
        );
      }),
    );
  }
}
