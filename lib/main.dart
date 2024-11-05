import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/providers/banners_provider.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/providers/categories_provider.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/providers/order_provider.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/providers/user_provider.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/screens/all_users_screen.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/screens/banners_screen.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/screens/inner_screen/categories/add_category_dashboard.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/screens/inner_screen/fees/fees_screen.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/screens/inner_screen/orders/order_details.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/screens/inner_screen/orders/orders_cancelled.dart';
import 'package:provider/provider.dart';

import 'consts/theme_data.dart';
import 'providers/products_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/dashboard_screen.dart';
import 'screens/edit_upload_product_form.dart';
import 'screens/inner_screen/categories/categories_screen.dart';
import 'screens/inner_screen/orders/orders_completed.dart';
import 'screens/inner_screen/orders/orders_processing.dart';
import 'screens/search_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: FirebaseOptions(
            apiKey: "AIzaSyDAVrD1t3YlQhh3xG333nfjInaM5HGeBkQ",
            appId: "1:1035545623294:android:474c46ad7f73ce4a4943af",
            messagingSenderId: "1035545623294",
            projectId: "elgamlstores",
            storageBucket: "elgamlstores.appspot.com",
          ),
        )
      : await Firebase.initializeApp();
  // Create a Firestore instance
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
          return BannersProvider();
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
          title: 'Elgaml Admin Dashboard',
          // localizationsDelegates: [
          //   GlobalMaterialLocalizations.delegate,
          //   GlobalWidgetsLocalizations.delegate,
          // ],
          // supportedLocales: [
          //   const Locale('ar', 'AE'),
          //   const Locale('en'),
          // ],
          // locale: Locale("ar", "AE"),
          theme: Styles.themeData(
              isDarkTheme: themeProvider.getIsDarkTheme, context: context),
          home: const DashboardScreen(),
          routes: {
            OrdersScreenProcessing.routeName: (context) =>
                const OrdersScreenProcessing(),
            SearchScreen.routeName: (context) => const SearchScreen(),
            EditOrUploadProductForm.routeName: (context) =>
                const EditOrUploadProductForm(),
            CategoriesScreen.routeName: (context) => const CategoriesScreen(),
            BannersScreen.routeName: (context) => const BannersScreen(),
            AllUsersScreen.routeName: (context) => const AllUsersScreen(),
            OrderStreamScreen.routeName: (context) => OrderStreamScreen(),
            OrdersScreenCompleted.routeName: (context) =>
                OrdersScreenCompleted(),
            OrdersScreenCancelled.routeName: (context) =>
                OrdersScreenCancelled(),
            FeesScreen.routeName: (context) => const FeesScreen(),
            AddCategoryDashboard.routeName: (context) => AddCategoryDashboard(),
            // PersonalProfile.routeName: (context) => const PersonalProfile(),
          },
        );
      }),
    );
  }
}
