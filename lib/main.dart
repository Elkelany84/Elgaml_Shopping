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
            apiKey: "AIzaSyDAVrD1t3YlQhh3xG333nfjInaM5HGeBkQ",
            appId: "1:1035545623294:android:474c46ad7f73ce4a4943af",
            messagingSenderId: "1035545623294",
            projectId: "elgamlstores",
            storageBucket: "elgamlstores.appspot.com",
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
